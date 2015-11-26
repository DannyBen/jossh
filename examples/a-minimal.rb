#!/usr/bin/env ruby

# This example runs a two commands on localhost.
# The host specifications for `localhost` are defined in `./ssh_hosts.yml`.
#
# Use `ssh!` for pretty print, or `ssh!` for unformated output
#
# The second argument can be either an array or a string


require 'jossh'

ssh! :localhost, ["echo '-> Showing files'", "ls"]

