#!/usr/bin/env ruby
VAGRANTFILE_API_VERSION = '2'
MEMORY = 1024
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.ssh.forward_agent = true
  config.vm.box = 'boxcutter/ubuntu1604'
  config.vm.provision 'shell' do |s|
    s.path = 'Makefile'
    s.args = [
        'DOTFILES=/home/vagrant/.dotfiles',
        'vagrant',
    ]
  end
  config.vm.synced_folder './', '/home/vagrant/.dotfiles',
    owner: 'vagrant', group: 'vagrant'
  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", MEMORY.to_s]
  end
end
