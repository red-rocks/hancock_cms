#!/bin/sh

PORT=4000
echo 'server will by started at '$PORT
rails s -b 0.0.0.0 -p $PORT -e development
