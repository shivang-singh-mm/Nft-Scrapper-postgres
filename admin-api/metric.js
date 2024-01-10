const express = require('express')
const client  = require('prom-client')

const app = express();
const register  = new client.Registry();
const responseTimeGraph = new client.Histogram({
  name: 'response_time_duration_seconds',
  help:'RESPONSE API RESPONSE time in seconds',
  labelNames:['method','route','status_code'],
  buckets: [0.1, 5, 15, 50, 100, 500],
})

const transferFunctionHistogram = new client.Histogram({
  name: "async_funtions_response_time_duration_seconds",
  help: "Async functions response time in seconds",
  labelNames: ["operation","blockchain" ,"success"],
});

const http_request_counter = new client.Counter({
  name: 'http_request_count',
  help: 'Count of HTTP requests made to my app',
  labelNames: ['method', 'route', 'statusCode'],
});

register.removeSingleMetric(http_request_counter);
const startMetrics = ()=>{
  const collectDefaultMetrics = client.collectDefaultMetrics;
  collectDefaultMetrics(register);

  app.get('/metrics',async(req,res)=>{
    res.set("Content-Type",client.register.contentType);
    return res.send(await client.register.metrics());
  })

  app.listen(5900,()=>console.log("Metrics started at port 5900"));
}



module.exports={
  startMetrics, responseTimeGraph,transferFunctionHistogram, http_request_counter
}