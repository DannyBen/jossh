Jossh - Your SSH Buddy
======================

[![Gem Version](https://badge.fury.io/rb/jossh.svg)](https://badge.fury.io/rb/jossh)
[![Maintainability](https://api.codeclimate.com/v1/badges/deea8bfb0490e6be3cf6/maintainability)](https://codeclimate.com/github/DannyBen/jossh/maintainability)


**Jossh** is

- a command line utility for running local scripts and commands over SSH.
- a ruby library for easier and prettier SSH deployment and automation.

## Install

Add to your Gemfile

	gem 'jossh'

Or install manually

	gem install jossh


## Features

1. Allows running one or more commands over SSH.
2. Allows running local scripts remotely
3. Allows running a script on multiple hosts.
4. Has four commands: `ssh`, `ssh!`, `ssh_script` and `ssh_script!`. The 'bang' versions generate pretty and indented output.
5. Uses a single SSH connection.
6. Uses a simple hash for defining hosts.
7. Allows storing host specifications in a YAML file.
8. Supports all options available in `Net::SSH#start`.
9. Prints output Heroku-style.
10. Has a command line interface - `jossh <host> <script>` 

## Command Line Usage

After installing, you can call `jossh` from the command line to run arbitrary
commands or a local script over SSH.

    $ jossh -h

    Jossh
    
    Usage:
      jossh <host> <script> [-- <arguments>...]
      jossh -m | --make-hostfile
      jossh -e | --edit-hostfile
      jossh -l | --list
      jossh -h | --help 
      jossh -v | --version
    
    Arguments:
      <host>
        can be:
        - :symbol    : in this case we will look in ./ssh_hosts.yml or ~/ssh_hosts.yml
        - host       : in this case we will use the current logged in user
        - user@host
    
      <script> 
        can be:
        - a file in the current directory
        - a file in ~/jossh directory
        - one or more direct command
    
      <arguments>...
        When specifying a filename as the <script>, you may also pass additional
        arguments to it. 
        Use $1 - $9 in your script file to work with these arguments.
        Use $@ (or $*) to use the entire arguments string
    
    Options:
      -m --make-hostfile     Generate a template ssh_hosts.yml 
      -e --edit-hostfile     Open the currently used ssh_hosts.yml file for editing
      -l --list              Show hosts in ./ssh_hosts.yml or ~/ssh_hosts.yml
      -h --help              Show this screen
      -v --version           Show version
    
    Examples: 
      jossh :production "git status"
      jossh jack@server.com "cd ~ && ls -l"
      jossh server.com deploy
      jossh server.com rake -- db:migrate

---

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

## Host Specification File

When using a :symbol as the host name, Jossh will look for a YAML 
configuration file named `ssh_hosts.yml`. The file is expected to be either
in the current directory or the user's home directory.

If you wish to use a different filename or location, use the `ssh_hostfile` 
method. If you specify only a filename or a relative path, Jossh will still 
look for this file in both the current directory and user's home directory.

```ruby
# Specify exact location
ssh_hostfile "/etc/my_hosts.yml"
ssh! :myhost, 'ls'

# Look for ./configs/hosts.yml or ~/configs/hosts.yml
ssh_hostfile "configs/hosts.yml"
ssh! :myhost, 'ls'
```

You can ask Jossh to create a sample file for you by running:

    $ jossh --make-hostfile

## Working with Multiple Hosts

Define multiple hosts in the `ssh_hosts.yml` file by simply providing an array
of other keys:

```yaml
:web01:
  :host: web01.server.com
  :user: admin

:web02:
  :host: web02.server.com
  :user: admin

:production: 
  - :web01
  - :web02
```

See [ssh_hosts.example.yml](https://github.com/DannyBen/jossh/blob/master/ssh_hosts.example.yml) as an example.

## Writing Scripts

The scripts you execute with Jossh are simple shell scripts. These variables 
are available to you inside the script:

### `$1 - $9 and $@ or $*`

When running through the command line and using the 
`jossh <host> <script> -- <arguments>` syntax, these variables hold the 
arguments.

`$@` and `$*` hold the entire arguments string.

Example: 
```bash
# myscript
echo "-> Running requested rake task"
rake $@
```

And call it with:
`$ jossh :host myscript -- db:migrate`



### `%{key}`
When this syntax appears in your script, it will be replaced with any key
from the host configuration. 

Example: 
```bash
echo "-> Migrating database on %{host}"
rake db:migrate
```
