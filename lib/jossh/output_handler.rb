require 'colsole'

module Jossh

  # OutputHandler is responsible for generating the pretty output created by
  # +ssh!+ and +ssh_script!+ commands.
  #
  class OutputHandler

    include Colsole

    # Print indented output while giving special treatment to strings that 
    # start with certain markers.
    #
    # This method is used as the callback function by +ssh!+ and +ssh_script!+
    #
    # ==== Params:
    # +lines+::
    #   A newline delimited string or array to pretty-print
    #
    #
    # ==== Credits:
    # This function was inspired by Heroku and based on code from Mina[https://github.com/mina-deploy/mina/blob/master/lib/mina/output_helpers.rb]
    #
    def pretty_puts(lines, stream=nil)
      lines = lines.split("\n") if lines.is_a? String
      lines.each do |line|
        line = line.rstrip.gsub(/\t/, "        ")
        if stream == :stderr
          puts_stderr line
        elsif line =~ /^\-+> (.*?)$/
          puts_status $1
        elsif line =~ /^! (.*?)$/
          puts_error $1
        elsif line =~ /^\$ (.*?)$/
          puts_command $1
        else
          puts_stdout line
        end
      end
    end

    private

    def puts_status(msg)
      say "!txtgrn!----->!txtrst! #{msg}"
    end

    def puts_error(msg)
      say "  !txtylw!!!txtrst!    !txtred!#{msg}"
    end

    def puts_stderr(msg)
      say "       !txtred!#{msg}"
    end

    def puts_command(msg)
      say "       !txtpur!$ #{msg}"
    end

    def puts_stdout(msg)
      puts "       #{msg}"
    end

  end

end

