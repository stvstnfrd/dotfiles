# -*- mode: ruby -*-
# vi: set ft=ruby :
VAGRANTFILE_API_VERSION = '2'
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.ssh.forward_agent = true
  config.vm.box = 'ubuntu/xenial64'
  # config.vm.provision "shell", inline: 'sudo apt-get update'
  config.vm.provision "shell" do |s|
    s.path = 'Makefile'
    s.args = [
        'system',
        'vagrant',
    ]
  end
  config.vm.synced_folder './', '/home/vagrant/.config/dotfiles',
    owner: 'vagrant', group: 'vagrant'
end
