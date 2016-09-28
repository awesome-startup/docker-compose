#!/bin/bash

docker run -d -p 1401:1401 -p 2775:2775 -p 8990:8990 -v /mnt/smpp:/var/log/jasmin --name jasmin_01 jookies/jasmin:latest
