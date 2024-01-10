const express = require('express');
const cors = require('cors')
require('dotenv').config();
const router = express.Router();
const {transferFunctionHistogram} = require('./metric')
const opentelemetry = require('@opentelemetry/api')
const { createLogger, format, transports } = require('winston')
const { combine, timestamp, label, printf } = format


require('./db_metric')
const meter = opentelemetry.metrics.getMeter('express-server')

const client = require('./db.config')

router.get('/',(_,res)=>{console.log(_),res.json("good")});



//logging part
const myFormat = printf(({ level, message, label, timestamp }) => {
  return `${timestamp} [${level}]: ${message}`;
});

const logger = createLogger({
  level: 'debug',
  format: combine(
      label({ label: 'right meow!' }),
      timestamp(),
      myFormat
  ),
  transports: [
      new transports.Console(),
  ]
})



//open telemetry 
const activeConnectionCounter = meter.createObservableGauge('temperature.gauge')

const dbErrorQuary= meter.createCounter('sql_Error_Query')

const dbResponseTime = meter.createHistogram('sql_Response_duration')

const dbRequestCounter =  meter.createUpDownCounter('postgres_requests_total', {
  description: 'Total number of requests hitting PostgreSQL',
});



//get all blockchains
router.get('/blockchains',async(req,res)=>{
  try{
    const blockchain = client.find((blockchain)=>blockchain.database==="postgres");
    const body = await blockchain.query('SELECT * FROM "public"."blockchainlist"')
    res.status(200).json(body.rows);
  }
  catch(err){
    console.log(err);
    res.status(404).message("Error fetching data from database");
  }
})

//get all collections
router.get('/collections/list/:database/:offset/:limit', (req, res) => {
  // Fetch data from the PostgreSQL database
  const data = {
    offset:req.params.offset,
    limit:req.params.limit,
    database: req.params.database
  }
  const metricLables = {operation: 'collectionList'};
  const startTime = new Date().getTime();
  const timer = transferFunctionHistogram.startTimer();
  logger.debug('Making a requets to Fetch collections')
  const blockchain = client.find((blockchain)=>blockchain.database===data.database)
  blockchain.query(`SELECT * FROM "public"."collections" 
                INNER JOIN "public"."collectionStatus" ON 
                "public"."collectionStatus"."collection_uuid"="public"."collections"."uuid"
                ORDER BY "public"."collections"."uuid"
                OFFSET ${data.offset} ROWS FETCH NEXT ${data.limit} ROWS ONLY`, (err, result) => {
    if (err) {
      logger.error(`Error Fetching collections: ${err}`)

      dbErrorQuary.add(1, {
        'query': 'SELECT * FROM "public"."collections" INNER JOIN "public"."collectionStatus" ON "public"."collectionStatus"."collection_uuid"="public"."collections"."uuid" ORDER BY "public"."collections"."uuid" OFFSET ${data.offset} ROWS FETCH NEXT 10 ROWS ONLY'
      })
      console.error('Error in getting all collections', err);
      timer({...metricLables,"blockchain":req.params.database ,success:false})
      res.status(500).send('Error fetching data from database');
    } else {
      dbRequestCounter.add(1, {
        'query': 'SELECT * FROM "public"."collections" INNER JOIN "public"."collectionStatus" ON "public"."collectionStatus"."collection_uuid"="public"."collections"."uuid" ORDER BY "public"."collections"."uuid" OFFSET ${data.offset} ROWS FETCH NEXT 10 ROWS ONLY'
      })
      // Return the fetched data as the API response
      timer({...metricLables,"blockchain":req.params.database ,success:true});
      const endTime = new Date().getTime();

      const executionTime = endTime - startTime;
      dbResponseTime.record(executionTime, {
        'query': 'SELECT * FROM "public"."collections" INNER JOIN "public"."collectionStatus" ON "public"."collectionStatus"."collection_uuid"="public"."collections"."uuid" ORDER BY "public"."collections"."uuid" OFFSET ${data.offset} ROWS FETCH NEXT 10 ROWS ONLY'
      })

      logger.debug("Sucessfully Fetched Collections!")
      res.json({rows:result.rows,continuation:Number(data.offset)+result.rows.length});
    }
  });
});


//get collection details by id
router.get('/collections/details/:database/:collection_id', async (req, res) => {
  logger.info('getting collection details by id')
  const metricLables = {operation: 'collectionDetails'};
  const timer = transferFunctionHistogram.startTimer();
  const collectionId = req.params.collection_id;
  const dbName = req.params.database
    try {
      logger.debug("makeing a request to get collection details by id ")
      const startTime = new Date().getTime();
      const query = `SELECT * FROM collections
                     INNER JOIN "public"."collectionStatus" ON 
                     "public"."collectionStatus"."collection_uuid"="public"."collections"."uuid"
                     WHERE "public"."collections"."collection_id" = $1;`;
      const values = [collectionId];
      const blockchain = client.find((blockchain)=>blockchain.database===dbName);
      const { rows } = await blockchain.query(query, values);

      
      const endTime = new Date().getTime();
      const executionTime = endTime - startTime;
      dbResponseTime.record(executionTime, {
       'query': query
      })
  
      if (rows.length === 0) {
        // timer({...metricLables,"blockchain":req.params.database ,success:false});
        logger.error("Collection not found")
        res.status(404).json({ error: 'Collection not found' });
      } else {
        logger.debug("Sucessfully get collection details by id")

        dbRequestCounter.add(1, {
          'query': query
        })
        timer({...metricLables,"blockchain":req.params.database ,success:true});
        res.json(rows);
      }
    } catch (error) {
      logger.error(`Erron in getting collection details by id :${error}`)
      dbErrorQuary.add(1, {
        'query': 'SELECT * FROM collections INNER JOIN "public"."collectionStatus" ON "public"."collectionStatus"."collection_uuid"="public"."collections"."uuid" WHERE "public"."collections"."collection_id" = $1;'
      })
      console.error('Error fetching collection:', error);
      timer({...metricLables,"blockchain":req.params.database ,success:false});
      res.status(500).json({ error: 'Internal server error' });
    }
});


//search a collection by name or id or trait key
router.get('/search/collections/:database', async (req, res) => {
  logger.info("searching a collection by name or id or trait key")
  const metricLables = {operation: 'searchCollections'};
  const timer = transferFunctionHistogram.startTimer();
  const { queryParam } = req.query;
  const dbName = req.params.database

  try {
    const blockchain = client.find((blockchain)=>blockchain.database===dbName)
    logger.debug("makeing a request to  search a collection by name or id or trait key")
    const startTime = new Date().getTime();
    const result = await blockchain.query(
      'SELECT * FROM collections WHERE collection_id ILIKE $1 OR name ILIKE $2 OR uuid IN (SELECT collection_uuid FROM assets WHERE uuid IN(SELECT asset_uuid FROM traits WHERE key ILIKE $3))',
      [`%${queryParam}%`, `%${queryParam}%`, `%${queryParam}%`]
    );

    const endTime = new Date().getTime();
    const executionTime = endTime - startTime;
    dbResponseTime.record(executionTime, {
      'query': 'SELECT * FROM collections WHERE collection_id ILIKE $1 OR name ILIKE $2 OR uuid IN (SELECT collection_uuid FROM assets WHERE uuid IN(SELECT asset_uuid FROM traits WHERE key ILIKE $3))',
    })

    if (result.rowCount === 0) {
      logger.error("Asset not found.")
      // timer({...metricLables,"blockchain":req.params.database ,success:false});
      return res.status(404).json({ error: 'Asset not found.' });
    }

    dbRequestCounter.add(1, {
      'query': 'SELECT * FROM collections WHERE collection_id ILIKE $1 OR name ILIKE $2 OR uuid IN (SELECT collection_uuid FROM assets WHERE uuid IN(SELECT asset_uuid FROM traits WHERE key ILIKE $3))'
    })

    logger.debug("Sucessfully searched a collection by name or id or trait key")
    timer({...metricLables,"blockchain":req.params.database ,success:true});
    res.json(result.rows);
  } catch (err) {
    logger.error(`Erron in searching a collection by name or id or trait key :${err}`)
    dbErrorQuary.add(1, {
      'query': 'SELECT * FROM collections WHERE collection_id ILIKE $1 OR name ILIKE $2 OR uuid IN (SELECT collection_uuid FROM assets WHERE uuid IN(SELECT asset_uuid FROM traits WHERE key ILIKE $3))',
    })
    console.error('Error executing query:', err);
    timer({...metricLables,"blockchain":req.params.database ,success:false});
    res.status(500).json({ error: 'Internal server error.' });
  }
});

//get all assets by collection id
router.get('/assets/list/:database/:collection_uuid/:offset/:limit', async (req, res) => {
  logger.info("getting all assets by collection id")
  const metricLables = {operation: 'searchCollections'};
  const timer = transferFunctionHistogram.startTimer();
  const collectionId = req.params.collection_uuid;
  const offset = req.params.offset
  const limit = req.params.limit
  const dbName = req.params.database

  try {
    logger.debug("makeing a request to  get all assets by collection id")
    const startTime = new Date().getTime();
    const blockchain = client.find((blockchain)=>blockchain.database===dbName)
    const query = `SELECT * FROM assets
                   INNER JOIN "public"."assetStatus" ON 
                   "public"."assetStatus"."asset_uuid"="public"."assets"."uuid"
                   WHERE "public"."assets"."collection_uuid"=$1
                   OFFSET ${offset} ROWS FETCH NEXT ${limit} ROWS ONLY;`;
    const values = [collectionId];

    const { rows } = await blockchain.query(query, values);

    const endTime = new Date().getTime();
    const executionTime = endTime - startTime;
    dbResponseTime.record(executionTime, {
      'query': query
    })

    if (rows.length === 0) {
      logger.error("Asset not found")
      timer({...metricLables,"blockchain":req.params.database ,success:false});
      res.status(404).json({ error: 'Asset not found' });
    } else {
      logger.debug("Sucessfully get all assets by collection id")
      dbRequestCounter.add(1, {
        'query': query
      })
      timer({...metricLables,"blockchain":req.params.database ,success:true});
      res.json(rows);
    }
  } catch (error) {
    logger.error(`Erron in getting all assets by collection id :${error}`)
    dbErrorQuary.add(1, {
      'query': 'SELECT * FROM assets INNER JOIN "public"."assetStatus" ON "public"."assetStatus"."asset_uuid"="public"."assets"."uuid" WHERE "public"."assets"."collection_uuid"=$1;'
    })
    console.error('Error fetching asset:', error);
    timer({...metricLables,"blockchain":req.params.database ,success:false});
    res.status(500).json({ error: 'Internal server error' });
  }
});

//get asset details by assetid
router.get('/assets/details/:database/:asset_id', async (req, res) => {
  logger.info("getting asset details by assetid")
  const metricLables = {operation: 'searchCollections'};
  const timer = transferFunctionHistogram.startTimer();
  const collectionId = req.params.asset_id;
  const dbName = req.params.database

    try {
      logger.debug("makeing a request to  get asset details by assetid")
      const startTime = new Date().getTime();
      const blockchain = client.find((blockchain)=>blockchain.database===dbName)
      const query = 'SELECT * FROM assets WHERE asset_id = $1';
      const values = [collectionId];
  
      const { rows } = await blockchain.query(query, values);
  
      const endTime = new Date().getTime();
      const executionTime = endTime - startTime;
      dbResponseTime.record(executionTime, {
       'query': query
      })

      if (rows.length === 0) {
        logger.error("Asset not found")
        timer({...metricLables,"blockchain":req.params.database ,success:false});
        res.status(404).json({ error: 'Asset not found' });
      } else {
        logger.debug("Sucessfully get asset details by assetid")
        dbRequestCounter.add(1, {
          'query': query
        })
        timer({...metricLables,"blockchain":req.params.database ,success:true});
        res.json(rows);
      }
    } catch (error) {
      logger.error(`Erron in getting asset details by assetid :${error}`)
      dbErrorQuary.add(1, {
        'query': 'SELECT * FROM assets WHERE asset_id = $1'
      })
      console.error('Error fetching assets:', error);
      timer({...metricLables,"blockchain":req.params.database ,success:false});
      res.status(500).json({ error: 'Internal server error' });
    }
});

//search assets by asset id, name and trait uuid 
router.get('/search/assets/:database/:offset/:limit', async (req, res) => {
  logger.info("searchinng assets by asset id, name and trait uuid")
  const metricLables = {operation: 'searchCollections'};
  const timer = transferFunctionHistogram.startTimer();
  const { queryParam } = req.query;
  const offset = req.params.offset
  const limit = req.params.limit
  const dbName = req.params.database
  try {
    logger.debug("makeing a request to  search assets by asset id, name and trait uuid")
    const startTime = new Date().getTime();
    const blockchain = client.find((blockchain)=>blockchain.database===dbName)
    const result = await blockchain.query(
      `SELECT * FROM assets WHERE collection_uuid = $1 OR name ILIKE $2 OR uuid IN (SELECT asset_uuid FROM traits WHERE key ILIKE $3)
      ORDER BY "public"."assets"."uuid"
      OFFSET ${offset} ROWS FETCH NEXT ${limit} ROWS ONLY`,
      [queryParam, `%${queryParam}%`, `%${queryParam}%`]
    );

    const endTime = new Date().getTime();
    const executionTime = endTime - startTime;
    dbResponseTime.record(executionTime, {
      'query': 'SELECT * FROM assets WHERE collection_uuid = $1 OR name ILIKE $2 OR uuid IN (SELECT asset_uuid FROM traits WHERE key ILIKE $3) ORDER BY "public"."assets"."uuid" OFFSET ${offset} ROWS FETCH NEXT 10 ROWS ONLY'
    })

    if (result.rowCount === 0) {
      logger.error("Asset not found")
      timer({...metricLables,"blockchain":req.params.database ,success:false});
      return res.status(404).json({ error: 'Asset not found.' });
    }
    logger.debug("Sucessfully searched assets by asset id, name and trait uuid ")
    dbRequestCounter.add(1, {
      'query': 'SELECT * FROM assets WHERE collection_uuid = $1 OR name ILIKE $2 OR uuid IN (SELECT asset_uuid FROM traits WHERE key ILIKE $3) ORDER BY "public"."assets"."uuid" OFFSET ${offset} ROWS FETCH NEXT 10 ROWS ONLY'
    })
    timer({...metricLables,"blockchain":req.params.database ,success:true});
    res.json({rows:result.rows,continutaion:Number(offset)+result.rows.length});
  } catch (err) {
    logger.error(`Error in searchinng assets by asset id, name and trait uuid :${err}`)
    dbErrorQuary.add(1, {
      'query': 'SELECT * FROM assets WHERE collection_uuid = $1 OR name ILIKE $2 OR uuid IN (SELECT asset_uuid FROM traits WHERE key ILIKE $3) ORDER BY "public"."assets"."uuid" OFFSET ${offset} ROWS FETCH NEXT 10 ROWS ONLY'
    })
    console.error('Error executing query:', err);
    timer({...metricLables,"blockchain":req.params.database ,success:false});
    res.status(500).json({ error: 'Internal server error.' });
  }
});

//search asset of a particular collection
router.get('/collection/asset/:database/:uuid/:assetId', async (req, res) => {
  logger.info("searching asset of a particular collection")
  const metricLables = {operation: 'searchCollections'};
  const timer = transferFunctionHistogram.startTimer();
  const { uuid, assetId } = req.params;
  const dbName = req.params.database

  try {
    logger.debug("makeing a request to  search asset of a particular collection")
    const startTime = new Date().getTime();
    const blockchain = client.find((blockchain)=>blockchain.database===dbName)
    // Check if the collection exists
    const collectionQuery = await blockchain.query('SELECT uuid FROM collections WHERE uuid = $1', [uuid]);

    const endTime = new Date().getTime();
    const executionTime = endTime - startTime;
    dbResponseTime.record(executionTime, {
      'query': 'SELECT uuid FROM collections WHERE uuid = $1'
    })

    if (collectionQuery.rows.length === 0) {
      logger.error("Collection not found")
      return res.status(404).json({ error: 'Collection not found' });
    }

    logger.debug("Sucessfully search asset of a particular collection")
    const startTimes = new Date().getTime();
    // Fetch the asset from the assets table based on collectionId and assetId
    const assetQuery = await blockchain.query(`SELECT * FROM assets
                                           INNER JOIN "public"."assetStatus" ON 
                                           "public"."assetStatus"."asset_uuid"="public"."assets"."uuid"
                                           WHERE "public"."assets"."collection_uuid"=$1 AND "public"."assets"."asset_id"=$2`, [uuid, assetId]);

    const endTimes = new Date().getTime();
    const executionTimes = endTimes - startTimes;
    dbResponseTime.record(executionTimes, {
    'query': 'SELECT * FROM assets INNER JOIN "public"."assetStatus" ON "public"."assetStatus"."asset_uuid"="public"."assets"."uuid" WHERE "public"."assets"."collection_uuid"=$1 AND "public"."assets"."asset_id"=$2'
    })
    if (assetQuery.rows.length === 0) {
      logger.error("Collection not found")
      timer({...metricLables,"blockchain":req.params.database ,success:false});
      return res.status(404).json({ error: 'Asset not found in the collection' });
    }
    dbRequestCounter.add(1, {
      'query': 'SELECT * FROM assets INNER JOIN "public"."assetStatus" ON "public"."assetStatus"."asset_uuid"="public"."assets"."uuid" WHERE "public"."assets"."collection_uuid"=$1 AND "public"."assets"."asset_id"=$2'
    })
    // Return the asset details
    timer({...metricLables,"blockchain":req.params.database ,success:true});
    res.json(assetQuery.rows);
  } catch (error) {
    logger.error(`Erron in searching asset of a particular collection: ${error}`)
    dbErrorQuary.add(1, {
      'query': 'SELECT * FROM assets INNER JOIN "public"."assetStatus" ON "public"."assetStatus"."asset_uuid"="public"."assets"."uuid" WHERE "public"."assets"."collection_uuid"=$1 AND "public"."assets"."asset_id"=$2'
    })
    console.error('Error while fetching asset:', error);
    timer({...metricLables,"blockchain":req.params.database ,success:false});
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

//enable collection by collection uuid
router.post('/collections/enable/:database', async (req, res) => {
  logger.info("enableing collection by collection uuid")
  const metricLables = {operation: 'searchCollections'};
  const timer = transferFunctionHistogram.startTimer();
  const { collectionUuids } = req.body;
  const dbName = req.params.database

  if (!collectionUuids || !Array.isArray(collectionUuids)) {
    logger.error("Invalid request body: collectionUuids must be an array")
    timer({...metricLables,"blockchain":req.params.database ,success:false});
    return res.status(400).json({ status: 'error', message: 'Invalid request body: collectionUuids must be an array' });
  }

  try {
    logger.debug("makeing a request to  enable collection by collection uuid")
    const startTime = new Date().getTime();
    const blockchain = client.find((blockchain)=>blockchain.database===dbName)
    const queryString = `SELECT uuid FROM collections WHERE uuid = ANY($1::text[])`;
    const result = await blockchain.query(queryString, [collectionUuids]);


    const endTime = new Date().getTime();
    const executionTime = endTime - startTime;
    dbResponseTime.record(executionTime, {
      'query': queryString
    })


    

    // If the query returned some results, it means the collection IDs exist
    const existingIds = result.rows.map(row => row.uuid);
    const notFoundIds = collectionUuids.filter(id => !existingIds.includes(id));

    dbRequestCounter.add(1, {
      'query': queryString
    })

    logger.debug("Sucessfully enable collection by collection uuid")

    if (notFoundIds.length === 0) {
      const startTimes = new Date().getTime();
      const placeholders = existingIds.map((item) => `'${item}'`).join(', ');
      const upsertQuery = `UPDATE "public"."collectionStatus" SET status = 'true'
                           WHERE collection_uuid IN (${placeholders})`;

      await blockchain.query(upsertQuery);

      const endTime = new Date().getTime();
      const executionTime = endTime - startTimes;
      dbResponseTime.record(executionTime, {
       'query': upsertQuery
      })

      dbRequestCounter.add(1, {
        'query': upsertQuery
      })

      timer({...metricLables,"blockchain":req.params.database ,success:true});
      res.json({ status: 'success', foundIds: existingIds });
    } else {
      logger.error(`Collection IDs not found: ${notFoundIds.join(', ')}`)
      dbErrorQuary.add(1, {
        'query' : 'UPDATE "public"."collectionStatus" SET status = "true" WHERE collection_uuid IN (${placeholders})'
      })
      timer({...metricLables,"blockchain":req.params.database ,success:false});
      res.status(404).json({ status: 'error', message: `Collection IDs not found: ${notFoundIds.join(', ')}` });
    }
  } catch (error) {
    logger.error(`Erron in enableing collection by collection uuid :${error}`)
    dbErrorQuary.add(1, {
      'query': 'UPDATE "public"."collectionStatus" SET status = "true" WHERE collection_uuid IN (${placeholders})'
    })
    console.error('Error querying the database:', error);
    timer({...metricLables,"blockchain":req.params.database ,success:false});
    res.status(500).json({ status: 'error', message: 'Internal server error' });
  }
});

//disable collection by collection uuid
router.post('/collections/disable/:database', async (req, res) => {
  logger.info("disableing collection by collection uuid")
  const metricLables = {operation: 'searchCollections'};
  const timer = transferFunctionHistogram.startTimer();
  const { collectionUuids } = req.body;
  const dbName = req.params.database

  if (!collectionUuids || !Array.isArray(collectionUuids)) {
    logger.error('Invalid request body: collectionUuids must be an array' )
    timer({...metricLables,"blockchain":req.params.database ,success:false});
    return res.status(400).json({ status: 'error', message: 'Invalid request body: collectionUuids must be an array' });
  }

  try {
    logger.debug("makeing a request to  disable collection by collection uuid")
    const startTime = new Date().getTime();
    const blockchain = client.find((blockchain)=>blockchain.database===dbName)
    const queryString = `SELECT uuid FROM collections WHERE uuid = ANY($1::text[])`;
    const result = await blockchain.query(queryString, [collectionUuids]);


    const endTime = new Date().getTime();
    const executionTime = endTime - startTime;
    dbResponseTime.record(executionTime, {
      'query': queryString
    })



   

    // If the query returned some results, it means the collection IDs exist
    const existingIds = result.rows.map(row => row.uuid);
    const notFoundIds = collectionUuids.filter(id => !existingIds.includes(id));

    dbRequestCounter.add(1, {
      'query': queryString
    })

    logger.debug("Sucessfully disabled collection by collection uuid")

    if (notFoundIds.length === 0) {
      const startTimes = new Date().getTime();
      const placeholders = existingIds.map((item) => `'${item}'`).join(', ');
      const upsertQuery = `UPDATE "public"."collectionStatus" SET status = 'false'
                           WHERE collection_uuid IN (${placeholders})`;

      await blockchain.query(upsertQuery);

      const endTime = new Date().getTime();
      const executionTime = endTime - startTimes;
      dbResponseTime.record(executionTime, {
       'query': upsertQuery
      })

      dbRequestCounter.add(1, {
        'query': upsertQuery
      })

      timer({...metricLables,"blockchain":req.params.database ,success:true});
      res.json({ status: 'success', foundIds: existingIds });
    } else {
      logger.error(`Collection IDs not found: ${notFoundIds.join(', ')}`)
      dbErrorQuary.add(1, {
        'query': 'UPDATE "public"."collectionStatus" SET status = "false" WHERE collection_uuid IN (${placeholders})'
      })

      timer({...metricLables,"blockchain":req.params.database ,success:false});
      res.status(404).json({ status: 'error', message: `Collection IDs not found: ${notFoundIds.join(', ')}` });
    }
  } catch (error) {
    logger.error(`Erron in disableing collection by collection uuid  :${error}`)
    dbErrorQuary.add(1, {
      'query': 'SELECT uuid FROM collections WHERE uuid = ANY($1::text[])'
    })

    console.error('Error querying the database:', error);
    timer({...metricLables,"blockchain":req.params.database ,success:false});
    res.status(500).json({ status: 'error', message: 'Internal server error' });
  }
});

//enable assets by asset uuid
router.post('/assets/enable/:database', async (req, res) => {
  logger.info("enabling assets by asset uuid")
  const metricLables = {operation: 'searchCollections'};
  const timer = transferFunctionHistogram.startTimer();
  const { assetUuids } = req.body;
  const dbName = req.params.database

  if (!assetUuids || !Array.isArray(assetUuids)) {
    logger.error('Invalid request body: assetUuids must be an array')
    timer({...metricLables,"blockchain":req.params.database ,success:false});
    return res.status(400).json({ status: 'error', message: 'Invalid request body: assetUuids must be an array' });
  }

  try {
    logger.debug("makeing a request to  enable assets by asset uuid")
    const startTime = new Date().getTime();
    const blockchain = client.find((blockchain)=>blockchain.database===dbName)
    const queryString = `SELECT uuid FROM assets WHERE uuid = ANY($1::text[])`;
    const result = await blockchain.query(queryString, [assetUuids]);

    const endTime = new Date().getTime();
    const executionTime = endTime - startTime;
    dbResponseTime.record(executionTime, {
      'query': queryString
    })

    // If the query returned some results, it means the collection IDs exist
    const existingIds = result.rows.map(row => row.uuid);
    const notFoundIds = assetUuids.filter(id => !existingIds.includes(id));

    dbRequestCounter.add(1, {
      'query': queryString
    })

    logger.debug("Sucessfully enabled assets by asset uuid")


    if (notFoundIds.length === 0) {
      const startTimes = new Date().getTime();
      const placeholders = existingIds.map((item) => `'${item}'`).join(', ');
      const upsertQuery = `UPDATE "public"."assetStatus" SET status = 'true'
                           WHERE asset_uuid IN (${placeholders})`;

      await blockchain.query(upsertQuery);

      const endTime = new Date().getTime();
      const executionTime = endTime - startTimes;
      dbResponseTime.record(executionTime, {
       'query': upsertQuery
      })

      dbRequestCounter.add(1, {
        'query': upsertQuery
      })

      timer({...metricLables,"blockchain":req.params.database ,success:true});
      res.json({ status: 'success', foundIds: existingIds });
    } else {
      logger.error(`Asset UuiDs not found: ${notFoundIds.join(', ')}`)
      dbErrorQuary.add(1, {
        'query': 'UPDATE "public"."assetStatus" SET status = "true" WHERE asset_uuid IN (${placeholders})'
      })

      timer({...metricLables,"blockchain":req.params.database ,success:false});
      res.status(404).json({ status: 'error', message: `Asset UuiDs not found: ${notFoundIds.join(', ')}` });
    }
  } catch (error) {
    logger.error(`Erron in enabling assets by asset uuid :${error}`)
    dbErrorQuary.add(1, {
      'query': 'SELECT uuid FROM assets WHERE uuid = ANY($1::text[])'
    })
    console.error('Error querying the database:', error);
    timer({...metricLables,"blockchain":req.params.database ,success:false});
    res.status(500).json({ status: 'error', message: 'Internal server error' });
  }
});

//disable assets by asset uuid
router.post('/assets/disable/:database', async (req, res) => {
  logger.info("disabling assets by asset uuid")
  const metricLables = {operation: 'searchCollections'};
  const timer = transferFunctionHistogram.startTimer();
  const { assetUuids } = req.body;
  const dbName = req.params.database

  if (!assetUuids || !Array.isArray(assetUuids)) {
    logger.error('Invalid request body: assetUuids must be an array')
    timer({...metricLables,"blockchain":req.params.database ,success:false});
    return res.status(400).json({ status: 'error', message: 'Invalid request body: assetUuids must be an array' });
  }

  try {
    logger.debug("makeing a request to  disable assets by asset uuid")
    const startTime = new Date().getTime();
    const blockchain = client.find((blockchain)=>blockchain.database===dbName)
    const queryString = `SELECT uuid FROM assets WHERE uuid = ANY($1::text[])`;
    const result = await blockchain.query(queryString, [assetUuids]);

    const endTime = new Date().getTime();
    const executionTime = endTime - startTime;
    dbResponseTime.record(executionTime, {
      'query': queryString
    })

    // If the query returned some results, it means the collection IDs exist
    const existingIds = result.rows.map(row => row.uuid);
    const notFoundIds = assetUuids.filter(id => !existingIds.includes(id));

    dbRequestCounter.add(1, {
      'query': queryString
    })

    logger.debug("Sucessfully disabled assets by asset uuid")
    
    if (notFoundIds.length === 0) {
      const startTimes = new Date().getTime();
      const placeholders = existingIds.map((item) => `'${item}'`).join(', ');
      const upsertQuery = `UPDATE "public"."assetStatus" SET status = 'false'
                           WHERE asset_uuid IN (${placeholders})`;

      await blockchain.query(upsertQuery);

      const endTime = new Date().getTime();
      const executionTime = endTime - startTimes;
      dbResponseTime.record(executionTime, {
       'query': upsertQuery
      })

      dbRequestCounter.add(1, {
        'query': upsertQuery
      })
      timer({...metricLables,"blockchain":req.params.database ,success:true});
      res.json({ status: 'success', foundIds: existingIds });
    } else {
      logger.error(`Asset UuiDs not found: ${notFoundIds.join(', ')}`)
      dbErrorQuary.add(1, {
        'query' : 'UPDATE "public"."assetStatus" SET status = "false" WHERE asset_uuid IN (${placeholders})'
      })

      timer({...metricLables,"blockchain":req.params.database ,success:false});
      res.status(404).json({ status: 'error', message: `Asset UuiDs not found: ${notFoundIds.join(', ')}` });
    }
  } catch (error) {
    logger.error(`Erron in disabling assets by asset uuid  :${error}`)
    console.error('Error querying the database:', error);
    timer({...metricLables,"blockchain":req.params.database ,success:false});
    res.status(500).json({ status: 'error', message: 'Internal server error' });
  }
});

router.get('/conn', async (req, res) => {
  try {
    throw new Error("This is a fake error message!");
  } catch (error) {
    dbErrorQuary.add(1,{
      'query' : 'This is a fake error message!'
    })
    res.send(Error.message)
    // You can display the error message wherever you want in your code or in the console.
  }
})


const TrackActiveConnection = async () => {
  try {
    const query = 'SELECT COUNT(*) FROM pg_stat_activity WHERE state = \'active\'';

    const result = await client.query(query);
    const numberOfConnections = parseInt(result.rows[0].count);

    activeConnectionCounter.addCallback((result) => {
      result.observe(numberOfConnections)
    })
  } catch (error) {
    console.error('Error retrieving active connections:', error);
  }
}

setInterval(TrackActiveConnection, 5000)

router.get('/conn', async (req, res) => {
  try {
    throw new Error("This is a fake error message!");
  } catch (error) {
    dbErrorQuary.add(1,{
      'query' : 'This is a fake error message!'
    })
    res.send(Error.message)
    // You can display the error message wherever you want in your code or in the console.
  }
})

setInterval(TrackActiveConnection, 5000)

module.exports = router