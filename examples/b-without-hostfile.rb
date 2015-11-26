#!/usr/bin/env ruby

# This example avoids using any external file for defining the host.
# See the previous example for comparison.

require 'jossh'

localhost = {
  host:     'localhost',
  user:     'vagrant',
  # password: 'SECRET',     # if needed
  # passphrase: 'SECRET',   # if needed
  # forward_agent: true,    # if needed
}

ssh! localhost, ["echo '-> Showing files'", "ls"]



