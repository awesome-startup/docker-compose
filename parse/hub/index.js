var express = require('express');
var ParseDashboard = require('parse-dashboard');
var ParseServer = require('parse-server').ParseServer;

var app = express();

var api = new ParseServer({
    databaseURI: 'mongodb://@mongo:27017/' + process.env.DB_NAME, // Connection string for your MongoDB database
    cloud: '/parse/cloud/main.js', // Absolute path to your Cloud Code
    appId: 'X4jwAIMI2sCuH99ueEI4c8LdTbgnkrR4u5kSqsc8',
    masterKey: '43p7s64k54z9uOKgztcC23CXx0cAM6RbdXObWfVt', // Keep this key secret!
    serverURL: 'http://localhost:1337/parse' // Don't forget to change to https if needed
});

// Serve the Parse API on the /parse URL prefix
app.use('/parse', api);
// var allowInsecureHTTP =true;
var dashboard = new ParseDashboard({
    "apps": [
        {
            "serverURL": "http://192.168.30.73:1337/parse",
            "appId": "X4jwAIMI2sCuH99ueEI4c8LdTbgnkrR4u5kSqsc8",
            "masterKey": "43p7s64k54z9uOKgztcC23CXx0cAM6RbdXObWfVt",
            "appName": "test",
            "production": true
        }
    ],
    "users": [
        {
            "user": "user",
            "pass": "pass"
        }
    ]
}, true);

// make the Parse Dashboard available at /dashboard
app.use('/dashboard', dashboard);

var httpServer = require('http').createServer(app);
httpServer.listen(4040);

app.listen(1337, function () {
    console.log('parse-server-example running on port 1337.');
});
