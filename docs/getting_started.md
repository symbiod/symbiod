# Getting started

## Before starting application

To get access to the secret variables, such as Github credentials, Slack and others you need to decrypt a file located at `secrets/envrc.gpg`

To to that we need to have your public GPG key in the repo.

* generate GPG key with `gpg --gen-key`
* export public key to the file `gpg --export --armor youremail@example.com > last_name.asc`
* put the public key to the `secrets/pubkeys/last_name.asc`
* commit changes, push and create a PR
* when your PR is merged you'll be able to run `secrets/decrypt` to get the list of environment variables, required for project run

For more information about GPG encryption read this [article](http://blog.ghostinthemachines.com/2015/03/01/how-to-use-gpg-command-line/).

## To run the application natively:

* The [postgresql][postgresql] database must be installed
* `git clone https://github.com/howtohireme/give-me-poc.git`
* `cd give-me-poc`
* `cp config/database.yml.sample config/database.yml`
* Change the password in `config/database.yml` to your password.
* `rails db:create`
* `rails db:schema:load`

## To run the application with Vagrant:

[Check out document](https://github.com/howtohireme/give-me-poc/blob/master/vagrant/README.md)

## Subdomains navigation

When you start app locally, use `lvh.me` domain to access it

e.g. `http://lvh.me:3000/` or `http://bootcamp.lvh.me:3000/`

[postgresql]: https://www.postgresql.org/
