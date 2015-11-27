Jossh - Your SSH Buddy
======================

[![Gem Version](https://badge.fury.io/rb/jossh.svg)](http://badge.fury.io/rb/jossh)
[![Code Climate](https://codeclimate.com/github/DannyBen/jossh/badges/gpa.svg)](https://codeclimate.com/github/DannyBen/jossh)
[![Dependency Status](https://gemnasium.com/DannyBen/jossh.svg)](https://gemnasium.com/DannyBen/jossh)


**Jossh** is

- a command line utility for running local scripts and comments over SSH.
- a ruby library for easier and prettier SSH deployment and automation.

## Install

Add to your Gemfile

	gem 'jossh'

Or install manually

	gem install jossh


## Features

1. Allows running one or more commands over SSH.
2. Allows running external local scripts remotely
3. Has four commands: `ssh`, `ssh!`, `ssh_script` and `ssh_script!`. The 'bang' versions generate pretty and indented output.
4. Uses a single SSH connection.
5. Uses a simple hash for defining hosts.
6. Allows storing host specifications in a YAML file.
7. Supports all options available in `Net::SSH#start`.
8. Prints output Heroku-style.
9. Provides a command line interface - `jossh <host> <script>` 

## Command Line Usage

After installing, you can call `jossh` from the command line to run arbitrary
commands or a local script over SSH.

```
$ jossh -h

Jossh

Usage:
  jossh <host> <script>
  jossh -m | --make-hostfile
  jossh -h | --help
  jossh -v | --version

Arguments:
  <host>
    can be:
    - :symbol    : in this case we will look in ./ssh_hosts.yml
    - host       : in this case we will use the current logged in user
    - user@host

  <script>
    can be:
    - a filename
    - one or more direct command

Options:
  -m --make-hostfile     Generate a template ssh_hosts.yml
  -h --help              Show this screen
  -v --version           Show version

Examples:
  jossh :production "git status"
  jossh jack@server.com "cd ~ && ls -l"
  jossh server.com deploy


```

## Library Usage

### Example 1: Host specifications in a YAML file

```ruby
# example.rb
require 'jossh'

ssh! :localhost, ["cd /opt/app", "git pull"]
```

```yaml
# ssh_hosts.yml
:localhost:
  :host: 'localhost'
  :user: 'vagrant'
```

### Example 2: Host specifications directly in the code

```ruby
# example.rb
require 'jossh'

localhost = {
  host: 'localhost',
  user: 'vagrant',
  forward_agent: true,
}

ssh! localhost, ["cd /opt/app", "git pull"]
```


### Example 3: Run an external local script remotely

```ruby
# example.rb
require 'jossh'

ssh_script! :production, deploy
```

```bash
# deploy
cd /opt/app
echo "-> Pulling source from origin"
git pull
echo "-> Restarting server"
touch 'tmp/restart.txt'
echo "-> Done"
```

See also: The [examples folder](https://github.com/DannyBen/jossh/tree/master/examples)

## Host specification file

Host specifications should be configured in `ssh_hosts.yml` by default.

If you wish to use a different location, use the `ssh_hostfile` method:

```ruby
ssh_hostfile "my_hosts.yml"
ssh! :myhost, 'ls'
```

You can ask Jossh to create a sample file for you by running:

    $ jossh --make-hostfile

See [ssh_hosts.example.yml](https://github.com/DannyBen/jossh/blob/master/ssh_hosts.example.yml) as an example.
