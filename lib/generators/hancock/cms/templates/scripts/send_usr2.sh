#!/bin/sh

kill -USR2 $(cat ./tmp/pids/unicorn.pid)
