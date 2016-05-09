var express = require('express');
var ParseDashboard = require('parse-dashboard');

var dashboard = new ParseDashboard({
    "apps": [
        {
            "serverURL": "http://server:8080/parse",
            appId: process.env.APP_ID || '',
            masterKey: process.env.MASTER_KEY || '',
            "appName": "ParseDashboard"
        }
    ],
    "users": [
        {
            "user": "llitfkitfk@gmail.com",
            "pass": "MNHAkX42PmnaYj"
        }
    ]
});

var app = express();

// make the Parse Dashboard available at /dashboard
app.use('/dashboard', dashboard);

var httpServer = require('http').createServer(app);
httpServer.listen(4040);