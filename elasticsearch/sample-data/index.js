/* This is a script to index photos into elasticsearch. 
This part of a post on searching through photos using Elasticsearch 
Read more at http://blog.sandeepchivukula.com */

// Extended from https://github.com/jettro/nodejs-photo-indexer//
// If  you're running this on a VM an you run out of memory create a swapfile 
// using the instructions here:
// http://stackoverflow.com/questions/26193654/node-js-catch-enomem-error-thrown-after-spawn

"use strict";

var walk    = require('walk')
, fs      = require('fs')
, path    = require('path')
, exif = require('exif2')
,readline = require('readline')
,elasticsearch = require('elasticsearch');



/* Do you love hard coded constants ??*/
var suffix = ".jpg" // Types of images to index
, startdir = process.argv[2] || './photos' // The Folder with images to index
, queue = 100 // How many items to queue before sending to ES
, hostandport = '192.168.99.100:9200' //ES Server and Port 
, indexname='photos' //ES Index Name 
, doctype ='photo' // ES Document Type
, items = []; 


/* First create the Indices */ 
var client = new elasticsearch.Client({host: hostandport});

client.indices.create({
    index: indexname,
    body: {},
    //This lets us ignore the error when the index already exists. 
    ignore:[400]
}).then(
function(body) {
    console.log("create index!");
    /* If we were being clever we could read this from a seperate file */ 
    client.indices.putMapping({
        index: indexname,
        type:doctype,
        body: {
            "photo": {
                "_all": {
                    "enabled": true
                },
                "properties": {
                    "file_name":{
                        "type": "string",
                        "index": "not_analyzed"
                    },  
                    "name": {
                      "type": "string",
                      "index": "not_analyzed"
                  },
                  "camera": {
                      "type": "string",
                      "analyzer":"english",
                      "fields":{
                       "raw":{
                        "type":"string",
                        "index": "not_analyzed"     
                    }
                }

            },
            "lens": {
              "type": "string",
              "index": "not_analyzed"
          },
          "create_Date": {
              "type": "date",
              "format": "yyyy:MM:dd HH:mm:ss||yyyy:MM:dd HH:mm:ss.SS||yyyy:MM:dd HH:mm||yyyy:MM:dd HH:mm:ss.SSS"
          },
          "iso": {
              "type": "integer"
          },
          "focalLength": {
              "type": "string",
              "analyzer":"english",
              "fields":{
               "raw":{
                "type":"string",
                "index": "not_analyzed"     
            }
        }

    },
    "location":{
      "type":"geo_point"
  }

}
}
}
}).then (function(body){console.log("Put mapping !");}, function(err){console.log(err);});


}, function(err) {
    console.log(err)
}
); 

/* Go through each directory and extract data */
var walker  = walk.walk(startdir);

walker.on('file', function(root, stat, next) {
    console.log("Walk " + stat.name);
    // Add this file to the list of files
    if (strEndsWith(stat.name.toLowerCase(),suffix)) {
        extractData(root + '/' + stat.name, next);
    }
    next();
});

/* Add a user input so that we wait for the extraction processes to finish 
   before flushing into the index
   */
walker.on('end', function() {
    /* we do this little hokey pokey in case things are still in flight */
    var rl = readline.createInterface({
        input: process.stdin,
        output: process.stdout
    });

    rl.question("What do you think of node.js? ", function(answer) {
        console.log("Thank you for your valuable feedback:", answer);
        rl.close();
        flushItems(items);
        console.log("We are done!");
    });
    
});


/* This is the core work horse that calls the 
functions to get the data from the images an add 
it to a search object */ 
function extractData(file) {

   
    exif(file, function(err, obj){
        if(err) {
            console.log(err);

        } else 
        {
            //console.log("Creating the object");
            var searchObj = {};
            searchObj.id = file;
            //We want something guranteed to be unqiue here like a primary key but this works. 
            searchObj.orientation=obj["orientation"];
            searchObj.flash=obj["flash"];
            searchObj.lens=obj["lens"];
            searchObj.aperture=obj["aperture"];
            searchObj.megapixels=obj["megapixels"];
            searchObj.file_name=obj["file name"];
            searchObj.directory=obj["directory"];
            searchObj.file_size=obj["file size"];
            searchObj.make=obj["make"];
            searchObj.camera_model_name=obj["camera model name"];
            searchObj.x_resolution=obj["x resolution"];
            searchObj.y_resolution=obj["y resolution"];
            searchObj.resolution_unit=obj["resolution unit"];
            searchObj.create_Date=obj["create date"];
            searchObj.focal_length=obj["focal length"];
            searchObj.focus_position=obj["focus position"];
            searchObj.focus_distance=obj["focus distance"];
            searchObj.lens_f_stops=obj["lens f stops"];
            searchObj.shutter_speed=obj["shutter speed"];
            searchObj.depth_of_field=obj["depth of field"];
            searchObj.GPS_Altitude=obj["gps altitude"];
            searchObj.GPS_Date_Time=obj["gps date/time"];
            searchObj.GPS_Latitude=obj["gps latitude"];
            searchObj.GPS_Longitude=obj["gps longitude"];
            searchObj.gps_altitude=obj["gps altitude"];
            obj["gps position"] >"" ? searchObj.location= gpstodd(obj["gps position"]): 1;
            sendToElasticsearch(searchObj);

        }
    });
    
    getPalette(file, function(colors){
        var searchObj = {}
        searchObj.id = file;
        searchObj.colors=[]
        colors.forEach(function(color)
        {
            searchObj.colors.push({"h":color[0],"s":color[1],"v":color[2]})

        });
        sendToElasticsearch(searchObj);
    });

};



/* Some Utility functions */
function strEndsWith(str, suffix) {
    return str.match(suffix+"$")==suffix;
}

/* Convert from GPS Degrees in EXIF to Degree Decimal so the ES understands the GPS */
function gpstodd (input)
{
	input = input.replace(/\'/g," min").replace(/\"/g,' sec').replace(/\,/g,"").split(" ")

	var lat= (parseFloat(input[0])+parseFloat(input[2]/60)+parseFloat(input[4]/(60*60)) )* (input[6] =="S" ? -1 : 1);
	var lng=(parseFloat(input[7])+parseFloat(input[9]/60)+parseFloat(input[11]/(60*60)) ) *  (input[13] =="W" ? -1 : 1); 
        //console.log(searchObj)
        return {"lat": lat, "lon":lng}
}

/* Get Color information from the photos */ 
var getPalette = function(file, callback){
    //from https://github.com/tj/palette
    var convert = require('color-convert')
    ,palette= require('palette')
    ,Canvas = require('canvas');

    var img = new Canvas.Image;
    img.src = file;
    var canvas = new Canvas(img.width, img.height);
    var ctx = canvas.getContext('2d');
    ctx.drawImage(img, 0, 0, img.width/4, img.height/4);

    var colors  = palette(canvas);
    var output =[]

    colors.forEach(function(color){
        output.push(convert.rgb.hsv(color)) 
    })

    callback(output);
};



/*Collect and Flsuh using the Bulk Index */ 
function sendToElasticsearch(searchObj) {
	console.log("Sending to elastic");

    //We'll do an upsert here b/c we don't which feature will return first
    items.push({"update":{"_id":searchObj.id}},{"doc": searchObj, "doc_as_upsert":true});
    //console.log(items);
    if (items.length >= 100) {
        var new_items = items
        flushItems(new_items);
        new_items = [];
        items=[];
    }
}

function flushItems(new_items) {
    console.log("Flushing items");
    client.bulk({
        index: indexname,
        type: doctype,
        body: new_items
    }, function(err,response) {
        if (err) {
            console.log(JSON.stringify(err));
        }
        console.log(JSON.stringify(response));
        
    });
}
