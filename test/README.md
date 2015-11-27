Running Tests
=============

In order to run tests you need to prepare the `ssh_hosts.yml` file at the
root folder of the repository (this file is .gitignored).

It needs to have a `:localhost` key that defines the host you want to test
against.

Example

```yaml
# ssh_hosts.yml
:localhost:
  :host: 'localhost'
  :user: 'vagrant'
  :password: 'this is safe'
```

Then, from the root of the repository, simply run:

	$ run test
