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