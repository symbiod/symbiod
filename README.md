# Give me proof-of-concept

[![Build Status](https://travis-ci.org/howtohireme/give-me-poc.svg?branch=master)](https://travis-ci.org/howtohireme/give-me-poc)
[![Maintainability](https://api.codeclimate.com/v1/badges/90170690cc5aab0e5168/maintainability)](https://codeclimate.com/github/howtohireme/give-me-poc/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/90170690cc5aab0e5168/test_coverage)](https://codeclimate.com/github/howtohireme/give-me-poc/test_coverage)
[![Inline docs](http://inch-ci.org/github/howtohireme/give-me-poc.svg?branch=master)](http://inch-ci.org/github/howtohireme/give-me-poc)

We want to build a place, where anyone can take part in development of opensource projects, that will help non-profits to bring value to the people.

The approach is that we connect individuals, that have an idea of some useful non-profit project(or event profitable, but tolerant to having the code open to everyone) and developers who wants to participate in those projects.

As a result the author gets the MVP of his project, and developers get experience in real projects(which is very important for beginners).
Experienced developers will be able to practice in leading teams, managing the project or event hiring our members for their companies.

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

We have an enormous amount of work and appreciate *any* kind of help, that can be offered.

If you want to take part in the project as developer then [this document](https://github.com/howtohireme/give-me-poc/blob/master/CONTRIBUTING.md) is for you!

If you want to take part as designer of manager don't hesitate to drop us an [email](mailto:opensource@howtohireme.ru).

And don't forget to sign up at [givemepoc.org](http://givemepoc.org) ;)

## Other documentation

Feel free to explore [our docs](https://github.com/howtohireme/give-me-poc/blob/master/docs)
