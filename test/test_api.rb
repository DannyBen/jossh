require_relative 'helpers'
require_relative '../lib/jossh'
include Jossh

class TestApi < MiniTest::Test
  def setup
  end

  def test_execute_string
    assert_match /^hello$/, run_ssh("echo 'hello'")
  end

  def test_execute_array
    output = run_ssh ["echo 'hello'", "echo 'world'"]
    assert_match /^hello$/, output
    assert_match /^world$/, output
  end

  def test_pretty_execution
    commands = [
      "echo '-> status'",
      "echo '! error'",
      "echo '$ command'",
      "echo 'regular'"
    ]
    expected = "\e[0;32m----->\e[0m status\n  \e[0;33m!\e[0m    \e[0;31merror\n\e[0m       \e[0;35m$ command\n\e[0m       regular\n"
    assert_match expected, run_ssh!(commands)
  end

  def run_ssh(cmd)
    capture_stdout { ssh :localhost, cmd }
  end

  def run_ssh!(cmd)
    capture_stdout { ssh! :localhost, cmd }
  end

end