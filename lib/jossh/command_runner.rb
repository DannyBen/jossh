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
      callback ||= method :simple_puts
      script   = script.join "\n" if script.is_a? Array
      hostspec = load_spec(hostspec) if hostspec.is_a? Symbol
      host     = hostspec.delete :host
      user     = hostspec.delete :user

      Net::SSH.start( host, user, hostspec ) do |ssh| 
        ssh.exec! script do |_ch, stream, data|
          callback.call data, stream
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

      # force reload in case we were called after some ssh call was
      # initiated (e.g. in tests...)
      @ssh_hosts = nil 
    end

    private

    def simple_puts(data, stream)
      if stream == :stderr
        STDERR.puts data
      else
        puts data
      end
    end

    def load_spec(key)
      ssh_hosts[key] or raise "Cannot find :#{key} in #{hostfile}"
    end

    def ssh_hosts
      @ssh_hosts ||= load_ssh_hosts
    end

    def load_ssh_hosts
      File.exist? hostfile or raise "Cannot find #{hostfile}"
      YAML.load_file hostfile
    end

    def hostfile
      @hostfile ||= 'ssh_hosts.yml'
    end

    def load_script(script)
      File.read script
    end

  end

end

