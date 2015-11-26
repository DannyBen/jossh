module Jossh

  def ssh!(hostspec, script)
    CommandRunner.new.ssh! hostspec, script
  end

  def ssh(hostspec, script, callback: nil)
    CommandRunner.new.ssh hostspec, script, callback: callback
  end

  def ssh_script!(hostspec, script)
    CommandRunner.new.ssh_script! hostspec, script
  end

  def ssh_script(hostspec, script, callback: nil)
    CommandRunner.new.ssh_script hostspec, script, callback: callback
  end

end

