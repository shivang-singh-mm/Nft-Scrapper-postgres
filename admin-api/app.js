require('dotenv').config();
const express = require('express');
const app  = express();
const getAuthRouter  = require('./server');
const {startMetrics, responseTimeGraph, http_request_counter} = require('./metric');
const responseTime = require('response-time');
const client = require('prom-client');
const cors = require('cors')
// app.use(cors());
app.use(express.json());
app.use(express.urlencoded({extended:false}));


app.use(responseTime((req,res,time)=>{
    if(req?.route?.path)
    {
        responseTimeGraph.observe({
            method: req.method,
            route: req.route.path,
            status_code: res.statusCode
        },time/1000)
    }
}))
app.use('/',getAuthRouter);
app.get('/health',(_,res)=>res.json("good"));

startMetrics();

app.listen(6983,()=>console.log(`Server started at port ${process.env.PORT}`))