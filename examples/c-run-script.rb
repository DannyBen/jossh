#!/usr/bin/env ruby

# This example runs an external shell script.
# The script does not need to be executable.

require 'jossh'

ssh_script! :localhost, 'sample_script'



