require 'simplecov'
SimpleCov.start

require 'minitest/reporters'
require 'minitest/autorun'
require_relative '../lib/jossh'

Minitest::Reporters.use!(Minitest::Reporters::SpecReporter.new)

# ENV['RUBY_ENV'] = 'test'

module Minitest::Assertions
  def assert_contains(expected, actual)
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

def run_ssh(cmd, host: :localhost)
  capture_stdout { ssh host, cmd }
end

def run_ssh!(cmd, host: :localhost)
  capture_stdout { ssh! host, cmd }
end

def run_ssh_script(script, host: :localhost)
  capture_stdout { ssh_script host, "test/fixtures/#{script}" }
end

def run_ssh_script!(script, host: :localhost)
  capture_stdout { ssh_script! host, "test/fixtures/#{script}" }
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

def create_user_hostfile
  content = File.read 'ssh_hosts.yml'
  content.gsub!(":localhost:", ":fairlylocal:")
  File.write user_hostfile, content  
end

def remove_user_hostfile
  File.exist? user_hostfile and FileUtils.rm user_hostfile
end

def user_hostfile
  "#{Dir.home}/ssh_hosts_test.yml"
end
