# = API Methods
# These are all the exposed commands. 

module Jossh

  # Execute one or more commands via SSH
  #
  # ==== Params:
  #
  # +hostspec+:: 
  #   A hash of SSH host parameters or a symbol pointing to a record in 
  #   +ssh_hosts.yml+. If a hash is provided, it must include at 
  #   least +:host+ and +:user+. It can also include any or the options 
  #   supported by Net::SSH#start.
  #
  # +script+::   
  #   A string or array of commands
  #
  # +callback+:: 
  #   (optional) A method to be called on each block of data received from 
  #   the SSH execution. If none provided, we will simply use `puts`.
  #
  # ==== Examples:
  #
  #   ssh :localhost, ["cd /opt/app", "git pull"]
  #
  #   ssh { host: 'localhost', user: 'vagrant' }, "ls -l"
  #
  #   def my_puts(data)
  #     puts "> #{data}"
  #   end
  #   ssh :localhost, "ls -l", method: my_puts
  #
  def ssh(hostspec, script, callback: nil)
    CommandRunner.new.ssh hostspec, script, callback: callback
  end

  # Same as +ssh+, only this will print a pretty output. 
  #
  # This method accepts only +hostspec+ and +script+ (no +callback+).
  #
  def ssh!(hostspec, script)
    CommandRunner.new.ssh! hostspec, script
  end

  # Same as +ssh+, only load commands from a file.
  #
  # ==== Params:
  #
  # +hostspec+:: 
  #   See +ssh+
  #
  # +script+:: 
  #   A path to the script to run. The script file should be a file with a
  #   list of shell commands.
  #
  # +callback+:: 
  #   (optional) See +ssh+
  #
  # ==== Examples:
  #
  #   ssh_script :localhost, "deploy"
  #
  def ssh_script(hostspec, script, callback: nil)
    CommandRunner.new.ssh_script hostspec, script, callback: callback
  end

  # Same as +ssh_script+, only this will print a pretty output. 
  #
  # This method accepts only +hostspec+ and +script+ (no +callback+).
  #
  def ssh_script!(hostspec, script)
    CommandRunner.new.ssh_script! hostspec, script
  end

end

