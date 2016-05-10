var express = require('express');
var ParseDashboard = require('parse-dashboard');
var ParseServer = require('parse-server').ParseServer;

var app = express();

var api = new ParseServer({
    databaseURI: 'mongodb://@mongo:27017/' + process.env.MONGO_DB_NAME, // Connection string for your MongoDB database
    cloud: '/parse/cloud/main.js', // Absolute path to your Cloud Code
    appId: process.env.APP_ID,
    masterKey: process.env.MASTER_KEY, // Keep this key secret!
    serverURL: 'http://localhost:' + process.env.PARSE_SERVER_PORT + '/parse' // Don't forget to change to https if needed
});

// Serve the Parse API on the /parse URL prefix
app.use('/parse', api);
// var allowInsecureHTTP =true;
var dashboard = new ParseDashboard({
    "apps": [
        {
            "serverURL": "http://" + process.env.PARSE_PUBLIC_ADDR + ":" + process.env.PARSE_PUBLIC_PORT + "/parse",
            "appId": process.env.APP_ID,
            "masterKey": process.env.MASTER_KEY, // Keep this key secret!
            "appName": "demo"
        }
    ],
    "users": [
        {
            "user": process.env.ADMIN_USER,
            "pass": process.env.ADMIN_PASS
        }
    ]
}, process.env.PARSE_DASHBOARD_ALLOW_INSECURE_HTTP);

// make the Parse Dashboard available at /dashboard
app.use('/dashboard', dashboard);

var httpServer = require('http').createServer(app);
httpServer.listen(4040);

app.listen(process.env.PARSE_SERVER_PORT, function () {
    console.log('parse-server-example running on port 1337.');
});
