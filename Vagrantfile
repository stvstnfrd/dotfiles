# -*- mode: ruby -*-
# vi: set ft=ruby :
VAGRANTFILE_API_VERSION = '2'
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.ssh.forward_agent = true
  config.vm.box = 'ubuntu/trusty64'
  config.vm.provision "shell" do |s|
    s.path = 'Makefile'
    s.args = [
        'SUDO=',
        'DOTFILES=/home/vagrant/.config/dotfiles',
        'system',
        'vagrant',
    ]
  end
  config.vm.synced_folder './', '/home/vagrant/.config/dotfiles',
    owner: 'vagrant', group: 'vagrant'
end
