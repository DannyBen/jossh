#!/usr/bin/env ruby

# This example runs two commands on localhost.
# The host specifications for `localhost` are defined in `./ssh_hosts.yml`.
#
# Use `ssh!` for pretty print, or `ssh!` for unformatted output
#
# The second argument can be either an array or a string


require 'jossh'

ssh! :localhost, ["echo '-> Showing files'", "ls"]

