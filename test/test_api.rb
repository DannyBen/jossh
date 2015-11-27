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

  def test_script
    expected = "\e[0;32m----->\e[0m Status example\n       \e[0;35m$ command example\n\e[0m  \e[0;33m!\e[0m    \e[0;31mERROR example\n\e[0m       regular output\n         indentation\n           is\n             kept\n               tabs are converted to 8 spaces\n\e[0;32m----->\e[0m Done\n       \e[0;31mstderr output\n\e[0m"
    assert_match expected, run_ssh_script!('script1')
  end

  def test_unformatted_script
    expected = "-> Status example\n$ command example\n! ERROR example\nregular output\n  indentation\n    is\n      kept\n\ttabs are converted to 8 spaces\n-> Done\n"
    assert_match expected, run_ssh_script('script1')
  end

  def test_custom_hostfile
    ssh_hostfile "custom_hosts.yml"
    assert_match /^hello$/, run_ssh("echo 'hello'")
  end

  def test_invalid_hostfile
    ssh_hostfile "no_such_file.yml"
    assert_raises(RuntimeError) { run_ssh("echo 'hello'") }
    ssh_hostfile "ssh_hosts.yml"
  end

  def test_binary
    expected = "-----> Status example\n       $ command example\n  !    ERROR example\n       regular output\n         indentation\n           is\n             kept\n               tabs are converted to 8 spaces\n-----> Done\n       stderr output\n"
    assert_match expected, run_bin('script1')
  end

end