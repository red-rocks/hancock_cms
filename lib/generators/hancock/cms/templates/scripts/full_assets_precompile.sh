#!/bin/sh

RAILS_ENV=production rails assets:clobber
RAILS_ENV=production rails assets:precompile
