require 'colsole'

# Print functions inspired by Heroku and based on code from Mina
# https://github.com/mina-deploy/mina/blob/master/lib/mina/output_helpers.rb

module Jossh

  class OutputHandler

    include Colsole

    def pretty_puts(lines)
      lines = lines.split("\n") if lines.is_a? String
      lines.each do |line|
        if line =~ /^\-+> (.*?)$/
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
      say "       #{msg}"
    end

  end

end

