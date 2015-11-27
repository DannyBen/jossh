require 'simplecov'
SimpleCov.start

require 'minitest/reporters'
require 'minitest/autorun'
require_relative '../lib/jossh'

Minitest::Reporters.use!(Minitest::Reporters::SpecReporter.new)

module Minitest::Assertions
  def assert_contains(expected, actual)
    # p actual; p "---"; p expected;exit
    assert actual.include?(expected), "String '#{actual}' does not contain '#{expected}'"
  end
end

def capture_stdout
  begin
    old_stdout = $stdout
    $stdout = StringIO.new
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
  capture_stdout { ssh_script :localhost, "test/fixtures/#{script}" }
end

def run_ssh_script!(script)
  capture_stdout { ssh_script! :localhost, "test/fixtures/#{script}" }
end

def run_bin(args=[])
  # `jossh :localhost test/fixtures/#{script}`
  capture_stdout do
    BinHandler.new.handle args
  end
end

def run_external_bin(args='')
  `jossh #{args}`
end

