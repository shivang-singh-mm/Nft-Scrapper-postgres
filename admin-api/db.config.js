require('dotenv').config();
const fs = require('fs')

const dbHost = process.env.DB_HOST;
const dbPort = process.env.DB_PORT;
const dbUser = process.env.DB_USER;
const dbPassword = process.env.DB_PASSWORD;
const rawConfig = JSON.parse(fs.readFileSync('db-config.json'))
const dbNames = rawConfig.dbnames


const {Client} = require('pg');

var client = [];

for(var i=0;i<dbNames.length;i++){
  var blockchain = dbNames[i];
  blockchain =  new Client({
    host:dbHost,
    user:dbUser,
    port:dbPort,
    password: dbPassword,
    database:blockchain
  });
  client.push(blockchain);
  const dbConnect = blockchain.database
  blockchain.connect().then((data)=>console.log("Connected to " + dbConnect));
}


module.exports = client