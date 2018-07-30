# Getting started

## To run the application natively:

* `git clone git@github.com:howtohireme/give-me-poc.git`
* `cd give-me-poc`
* `cp config/database.yml.sample config/database.yml`
* Change the password in `config/database.yml` to your password.
* `rake db:create`
* `rake db:schema:load`

## To run the application with Vagrant:

[Check out document](https://github.com/howtohireme/give-me-poc/blob/master/vagrant/README.md)

## Subdomains navigation

When you start app locally, use `lvh.me` domain to access it

e.g. `http://lvh.me:3000/` or `http://bootcamp.lvh.me:3000/`
