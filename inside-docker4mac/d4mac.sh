#!/bin/bash

docker run -it --privileged --pid=host debian nsenter -t -1 -m -u -n -i sh