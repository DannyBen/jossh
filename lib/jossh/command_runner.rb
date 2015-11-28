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
      file = 'ssh_hosts.yml' if file == :default
      @hostfile = file

      # force reload in case we were called after some ssh call was
      # initiated (e.g. in tests...)
      @ssh_hosts = nil 
    end

    def ssh_hosts
      @ssh_hosts ||= load_ssh_hosts
    end

    def active_hostfile
      if File.exist? hostfile 
        hostfile
      elsif hostfile[0] != '/' and File.exist? user_hostfile
        user_hostfile
      else
        false
      end
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
      ssh_hosts[key] or raise "Cannot find :#{key}"
    end

    def load_ssh_hosts
      if active_hostfile
        YAML.load_file active_hostfile
      else
        raise "Cannot find #{hostfile} or #{user_hostfile}"
      end
    end

    def hostfile
      @hostfile ||= 'ssh_hosts.yml'
    end

    def user_hostfile
      "#{Dir.home}/#{hostfile}"
    end

    def load_script(script)
      File.read script
    end

  end

end

