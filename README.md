# Give me proof-of-concept

[![Build Status](https://travis-ci.org/howtohireme/give-me-poc.svg?branch=master)](https://travis-ci.org/howtohireme/give-me-poc)
[![Maintainability](https://api.codeclimate.com/v1/badges/90170690cc5aab0e5168/maintainability)](https://codeclimate.com/github/howtohireme/give-me-poc/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/90170690cc5aab0e5168/test_coverage)](https://codeclimate.com/github/howtohireme/give-me-poc/test_coverage)
[![Inline docs](http://inch-ci.org/github/howtohireme/give-me-poc.svg?branch=master)](http://inch-ci.org/github/howtohireme/give-me-poc)

The goal of this project is to allow everyone to propose an idea of an opensource, non-profit project and to find a team of developers.

## To run the application natively:

* `git clone git@github.com:howtohireme/give-me-poc.git`
* `cp config/database.yml.sample config/database.yml`
* Change the password in `config/database.yml` to your password.
* `rake db:schema:load`

## To run the application with Vagrant:

[Check out document](https://github.com/howtohireme/give-me-poc/blob/master/vagrant/README.md)

## Subdomains navigation

When you start app locally, use `lvh.me` domain to access it

e.g. `http://lvh.me:3000/` or `http://bootcamp.lvh.me:3000/`

## Contributing

TBD
