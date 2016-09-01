#!/bin/sh

PORT=3000
echo 'server will by started at '$PORT
rails s -b 0.0.0.0 -p $PORT -e development
