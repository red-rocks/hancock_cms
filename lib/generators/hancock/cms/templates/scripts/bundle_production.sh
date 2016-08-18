#!/bin/sh

rm Gemfile.lock
bundle install --without development test
