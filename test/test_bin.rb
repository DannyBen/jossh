require_relative 'helpers'
require_relative '../lib/jossh'
include Jossh

class TestBin < MiniTest::Test
  def setup
  end

  def test_usage
    actual = run_bin
    assert_contains "Usage", actual
    assert_contains "jossh <host> <script>", actual
  end

  def test_script
    expected = "\e[0;32m----->\e[0m Status example\n       \e[0;35m$ command example\n\e[0m  \e[0;33m!\e[0m    \e[0;31mERROR example\n\e[0m       regular output\n         indentation\n           is\n             kept\n               tabs are converted to 8 spaces\n"
    assert_contains expected, run_bin([":localhost", "test/fixtures/script1"])
  end

  def test_command
    assert_contains 'roger rabbit', run_bin([":localhost", "echo 'roger rabbit'"])
  end

  def test_version
    assert_contains VERSION, run_bin(["-v"])
  end

  # def test_explicit_host
  #   user = Etc.getlogin
  #   assert_contains 'hello', run_bin(["localhost", "echo 'hello'"])
  # end

  # def test_explicit_user_and_host
  #   user = Etc.getlogin
  #   assert_contains 'hello', run_bin(["#{user}@localhost", "echo 'hello'"])
  # end

  def test_make_hostfile
    Dir.chdir('/tmp') do
      FileUtils.rm 'ssh_hosts.yml' if File.exist? 'ssh_hosts.yml'
      assert_contains 'Created ssh_hosts.yml', run_bin(["-m"])      
    end
  end

end