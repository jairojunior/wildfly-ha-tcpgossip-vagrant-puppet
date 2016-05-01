# -*- mode: ruby -*-
# vi: set ft=ruby :

WILDFLY_INSTANCES = (1..2)
INITIAL_IP = 20

Vagrant.configure(2) do |config|
  if Vagrant.has_plugin?('vagrant-cachier')
    config.cache.scope = :box

    config.cache.enable :yum
    config.cache.enable :generic, 'wget' => { cache_dir: '/var/cache/wget' }
  end

  config.vm.define 'load-balancer' do |v|
    v.vm.box = 'puppetlabs/centos-7.2-64-puppet'
    v.vm.host_name = 'centos-7-load-balancer'

    v.vm.provider 'virtualbox' do |virtualbox|
      virtualbox.name = 'centos-7-load-balancer'
      virtualbox.memory = 512
    end

    v.vm.network 'private_network', ip: '172.28.128.10'

    v.vm.provision :puppet do |puppet|
      puppet.environment_path = 'environments'
      puppet.environment = 'production'
      puppet.options = '--verbose --debug --trace --profile'
    end
  end

  WILDFLY_INSTANCES.each do |instance_number|
    config.vm.define "instance#{instance_number}" do |v|
      v.vm.box = 'puppetlabs/centos-7.2-64-puppet'
      v.vm.host_name = "centos-7-instance#{instance_number}"

      v.vm.provider 'virtualbox' do |virtualbox|
        virtualbox.name = "centos-7-instance#{instance_number}"
        virtualbox.memory = 1024
      end

      v.vm.network 'private_network', ip: "172.28.128.#{INITIAL_IP + instance_number}"

      v.vm.provision :puppet do |puppet|
        puppet.environment_path = 'environments'
        puppet.environment = 'production'
        puppet.options = '--verbose --debug --trace --profile'
      end
    end
  end

  config.vm.define 'gossiprouter' do |c|
    c.vm.provider 'docker' do |d|
      d.build_dir = '.'
      d.ports = ['12001:12001']
    end
  end
end
