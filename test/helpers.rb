require 'minitest/reporters'
require 'minitest/autorun'
require_relative '../lib/jossh'

Minitest::Reporters.use!(Minitest::Reporters::SpecReporter.new)

def capture_stdout
  begin
    old_stdout = $stdout
    $stdout = StringIO.new('','w')
    yield
    $stdout.string
  ensure
    $stdout = old_stdout
  end
end

def run_ssh(cmd)
  capture_stdout { ssh :localhost, cmd }
end

def run_ssh!(cmd)
  capture_stdout { ssh! :localhost, cmd }
end

def run_ssh_script(script)
  capture_stdout { ssh_script! :localhost, "test/fixtures/#{script}" }
end

def run_bin(script)
  `jossh :localhost test/fixtures/#{script}`
end
