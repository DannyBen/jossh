#!/usr/bin/env ruby

# This example uses a custom hostfile config, instead of the default 
# `ssh_hosts.yml`

require 'jossh'

ssh_hostfile "my_hosts.yml"

ssh! :myhost, 'ls'



