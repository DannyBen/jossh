Jossh - Your SSH Buddy
======================

Ruby SSH functions for easier and prettier remote deployment and automation.

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

## Usage

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

See also: The examples folder