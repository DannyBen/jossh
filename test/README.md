Running Tests
=============

In order to run tests you need to prepare host configuration files at the root 
directory or the repository:

	`ssh_hosts.yml` 
	`custom_hosts.yml`

Both these files need to be identical and are .gitignored.

The reason we need two files, is that one of the tests is testing the 
feature that allows using a custom hosts filename.

The tests look for a `:localhost` key that defines the host you want to test
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
