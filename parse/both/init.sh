#!/bin/bash

parse-server server-config.json &

parse-dashboard --config dashboard-config.json --allowInsecureHTTP true   