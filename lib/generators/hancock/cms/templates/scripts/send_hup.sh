#!/bin/sh

kill -HUP $(cat ./tmp/pids/unicorn.pid)
