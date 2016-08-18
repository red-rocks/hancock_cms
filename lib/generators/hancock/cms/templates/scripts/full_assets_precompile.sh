#!/bin/sh

RAILS_ENV=production rake assets:clobber
RAILS_ENV=production rake assets:precompile
