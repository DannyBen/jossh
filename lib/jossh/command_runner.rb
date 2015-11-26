require "net/ssh"
require "yaml"

module Jossh

  # CommandRunner is the primary class in the Jossh module. It is responsible
  # for providing the backend for all api methods.
  #
  class CommandRunner

    def self.instance
      @@instance ||= self.new
    end

    def ssh!(hostspec, script)
      ssh hostspec, script, callback: OutputHandler.new.method(:pretty_puts)
    end

    def ssh(hostspec, script, callback: nil)
      callback ||= method :puts
      script   = script.join "\n" if script.is_a? Array
      hostspec = load_spec(hostspec) if hostspec.is_a? Symbol
      host     = hostspec.delete :host
      user     = hostspec.delete :user

      Net::SSH.start( host, user, hostspec ) do |ssh| 
        ssh.exec! script do |_ch, _stream, data|
          callback.call data
        end
      end
    end

    def ssh_script!(hostspec, script)
      ssh! hostspec, load_script(script)
    end

    def ssh_script(hostspec, script, callback: nil)
      ssh hostspec, load_script(script), callback: callback
    end

    def ssh_hostfile(file)
      @hostfile = file
    end

    private

    def load_spec(key)
      ssh_hosts[key] or abort "Cannot find :#{key} in #{hostfile}"
    end

    def ssh_hosts
      @ssh_hosts ||= load_ssh_hosts
    end

    def load_ssh_hosts
      File.exist? hostfile or abort "Cannot find #{hostfile}"
      YAML.load_file hostfile
    end

    def hostfile
      @hostfile ||= 'ssh_hosts.yml'
    end

    def hostfile=(file)
      @hostfile = file
    end

    def load_script(script)
      File.read script
    end

  end

end

