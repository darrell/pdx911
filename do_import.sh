#!/bin/bash
# User specific aliases and functions
#source /usr/local/share/chruby/chruby.sh
#source /usr/local/share/chruby/auto.sh
#source /opt/rh/rh-ruby27/enable

#export PATH=/usr/pgsql-13/bin/:$PATH

#echo "hi"

cd ~/pdx_crime
ruby import_rss.rb
