# -*- mode: ruby -*-
# vi: set ft=ruby :

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

  config.vm.define 'instance1' do |v|
    v.vm.box = 'puppetlabs/centos-7.2-64-puppet'
    v.vm.host_name = 'centos-7-instance1'

    v.vm.provider 'virtualbox' do |virtualbox|
      virtualbox.name = 'centos-7-instance1'
      virtualbox.memory = 1024
    end

    v.vm.network 'private_network', ip: '172.28.128.20'

    v.vm.provision :puppet do |puppet|
      puppet.environment_path = 'environments'
      puppet.environment = 'production'
      puppet.options = '--verbose --debug --trace --profile'
    end
  end

  config.vm.define 'instance2' do |v|
    v.vm.box = 'puppetlabs/centos-7.2-64-puppet'
    v.vm.host_name = 'centos-7-instance2'

    v.vm.provider 'virtualbox' do |virtualbox|
      virtualbox.name = 'centos-7-instance2'
      virtualbox.memory = 1024
    end

    v.vm.network 'private_network', ip: '172.28.128.30'

    v.vm.provision :puppet do |puppet|
      puppet.environment_path = 'environments'
      puppet.environment = 'production'
      puppet.options = '--verbose --debug --trace --profile'
    end
  end

  config.vm.define 'gossiprouter' do |c|
    c.vm.provider 'docker' do |d|
      d.build_dir = '.'
      d.ports = ['12001:12001']
    end
  end
end
