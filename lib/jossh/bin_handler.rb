require 'etc'
require 'docopt'
require 'colsole'
require 'fileutils'

module Jossh

  class BinHandler

    include Colsole

    def handle(args)
      begin
        execute Docopt::docopt(doc, argv: args)
      rescue Docopt::Exit => e
        puts e.message
      end
    end

    private

    def execute(args)
      return show_version if args['--version']
      return make_hostfile if args['--make-hostfile']
      return list_hosts if args['--list']
      handle_script args['<host>'].dup, args['<script>']
    end

    def handle_script(host, script)
      host = standardize_host host

      begin
        if File.exist? script
          ssh_script! host, script
        else
          ssh host, script
        end
      # :nocov:
      rescue => e
        abort e.message
      end
      # :nocov:
    end

    def standardize_host(str)
      if str[0] == ':' 
        str[0] = ''
        return str.to_sym
      end

      # :nocov:
      # We DO have a test for these two cases, requires manual password type
      if str =~ /^(.+)@(.+)$/
        return { user: $1, host: $2 }
      end

      return { user: Etc.getlogin, host: str }
      # :nocov:
    end

    def make_hostfile
      abort "ssh_hosts.yml already exists" if File.exist?('ssh_hosts.yml')
      FileUtils.copy template('ssh_hosts.yml'), './ssh_hosts.yml'
      File.exist? './ssh_hosts.yml' or abort "Unable to create ssh_hosts.yml"
      say "!txtgrn!Created ssh_hosts.yml" 
    end

    def list_hosts
      runner = CommandRunner.new
      if runner.active_hostfile
        say "!txtgrn!Using: #{runner.active_hostfile}\n"
        runner.ssh_hosts.each do |key, spec|
          say "  :#{key.to_s.ljust(14)} = !txtblu!#{spec[:user]}!txtrst!@!txtylw!#{spec[:host]}"
        end
      else
        say "!txtred!Cannot find ssh_hosts.yml or ~/ssh_hosts.yml"
      end
    end

    def show_version
      puts VERSION
    end

    def doc
      return @doc if @doc 
      @doc = File.read template 'docopt.txt'
    end

    def template(file)
      File.expand_path("../templates/#{file}", __FILE__)
    end
  end
end
