#!/bin/sh

PORT=3000
echo 'server will be started at '$PORT
rails s -b 0.0.0.0 -p $PORT -e development
