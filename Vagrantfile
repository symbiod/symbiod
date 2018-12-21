# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.box_check_update = false

  config.vm.network "forwarded_port", guest: 3000, host: 3000

  config.vm.synced_folder "./", "/app"
  config.vm.synced_folder '../symbiod-features', '/features'

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "1024"
  end

  config.ssh.forward_env = environment_variable_names

  config.vm.provision "shell", path: 'vagrant/env.sh', privileged: true
  config.vm.provision "shell", path: 'vagrant/ruby.sh', privileged: false
  config.vm.provision "shell", path: 'vagrant/redis.sh', privileged: true
  config.vm.provision "shell", path: 'vagrant/postgres.sh', privileged: true
  config.vm.provision "shell", path: 'vagrant/nodejs.sh', privileged: true
  config.vm.provision "shell", path: 'vagrant/chromedriver.sh', privileged: true
  config.vm.provision "shell", path: 'vagrant/app.sh', privileged: false
end

def environment_variable_names
  File.readlines('.envrc').map do |l|
    l.strip.match(/export\s([A-Z_]+)=\w+/)&.captures
  end.compact.flatten
end
