#!/bin/bash
# User specific aliases and functions
source /usr/local/share/chruby/chruby.sh
source /usr/local/share/chruby/auto.sh

cd ~/pdx_crime
ruby import_rss.rb
