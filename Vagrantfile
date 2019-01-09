#!/usr/bin/env ruby
VAGRANTFILE_API_VERSION = '2'
MEMORY = 2048
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.ssh.forward_agent = true
  config.vm.box = 'ubuntu/xenial64'
  config.vm.provision 'shell' do |s|
    s.path = 'bootstrap.sh'
    s.privileged = false
    s.args = []
  end
  config.vm.provider :virtualbox do |vb|
    vb.customize ['modifyvm', :id, '--memory', MEMORY.to_s]
  end
end
