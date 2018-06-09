## Running app in Vagrant

* Install [vagrant](https://www.vagrantup.com/) for your platform
* Clone this application and [features](https://github.com/howtohireme/give-me-poc-features) in neighbor directories, e.g. `~/projects/give-me-poc` and `~/projects/give-me-poc-features`
* Run `vagrant up`. It will bring virtual machine with PostgreSQL, Ruby, Redis prepared for development work.

Inside the VM you will have application code and features, shared with your host machine according to `/app` and `/features`.

Feel free to run `vagrant ssh` and navigate to directories, run rails server, and do any kind of development work.

If something from this document does not work for your environment don't hesitate to open [issue](https://github.com/howtohireme/give-me-poc/issues).
