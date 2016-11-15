#!/usr/bin/bash
bundle update
git add --all .
git commit -am "${*:1}"
git push -u origin master
rake release
cd mongoid
bundle update && rake release
cd ..
cd activerecord
bundle update && rake release
cd ..
