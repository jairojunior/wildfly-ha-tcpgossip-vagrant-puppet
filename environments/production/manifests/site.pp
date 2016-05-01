node 'centos-7-load-balancer' {

  include profile::httpd::cluster

}

node /^centos-7-instance\d+$/ {

  include profile::wildfly

}

class profile::wildfly {

  include java
  include firewalld_appserver

  class { 'wildfly':
    java_home   => '/etc/alternatives/java_sdk',
    config      => 'standalone-full-ha.xml',
    public_bind => $::ipaddress_enp0s8
  }

  wildfly::deployment { 'cluster-demo.war':
    source   => 'file:///vagrant/cluster-demo.war',
  }

  wildfly::jgroups::tcpgossip { 'TCPGOSSIP':
    initial_hosts       => '172.28.128.1[12001]',
    num_initial_members => 2
  }

  wildfly::util::resource { '/socket-binding-group=standard-sockets/remote-destination-outbound-socket-binding=proxy1':
    content => {
      'host' => '172.28.128.10',
      'port' => '6666'
    }
  }
  ->
  wildfly::modcluster::config { 'Modcluster mybalancer':
    balancer             => 'mycluster',
    load_balancing_group => 'demolb',
    proxy_url            => '/',
    proxies              => ['proxy1']
  }
  ~>
  wildfly::util::reload { 'for modcluster': }

  Class['java'] ->
    Class['wildfly'] ->
      Class['firewalld_appserver']

}

class profile::httpd::cluster {
  $modules_dir = '/etc/httpd/modules'

  class { '::apache':
    default_vhost => true,
  }


  archive { '/tmp/mod_cluster-1.3.1.Final-linux2-x64.tar.gz':
    ensure       => present,
    extract      => true,
    extract_path => $modules_dir,
    source       => 'http://downloads.jboss.org/mod_cluster//1.3.1.Final/linux-x86_64/mod_cluster-1.3.1.Final-linux2-x64-so.tar.gz',
    creates      => ["${modules_dir}/mod_advertise.so",
                      "${modules_dir}/mod_cluster_slotmem.so",
                        "${modules_dir}/mod_manager.so",
                          "${modules_dir}/mod_proxy_cluster.so"],
    cleanup      => true,
  }
  ->
  class { '::apache::mod::cluster':
    ip                      => '172.28.128.10',
    allowed_network         => '172.28.128.',
    manager_allowed_network => '172.28.128.',
    balancer_name           => 'mycluster',
    version                 => '1.3.1'
  }
  ->
  firewalld::custom_service { 'httpd with mod_cluster':
      short       => 'httpd',
      description => 'httpd with mod_cluster',
      port        => [
        {
            'port'     => '6666',
            'protocol' => 'tcp',
        },
        {
            'port'     => '80',
            'protocol' => 'tcp',
        },
      ],
      destination => {
        'ipv4' => '172.28.128.0/24',
      }
  }
  ->
  firewalld_service { 'Allow httpd from external zone':
    ensure  => 'present',
    service => 'httpd',
    zone    => 'public',
  }
}

class firewalld_appserver {

  firewalld::custom_service { 'Wildfly Application Server':
      short       => 'wildfly',
      description => 'Wildfly is an Application Server for Java Applications',
      port        => [
        {
            'port'     => '9990',
            'protocol' => 'tcp',
        },
        {
            'port'     => '9999',
            'protocol' => 'tcp',
        },
        {
            'port'     => '8080',
            'protocol' => 'tcp',
        },
        {
            'port'     => '8009',
            'protocol' => 'tcp',
        }
      ],
      destination => {
        'ipv4' => '172.28.128.0/24',
      }
  }
  ->
  firewalld_service { 'Allow Wildfly from external zone':
    ensure  => 'present',
    service => 'wildfly',
    zone    => 'public',
  }
}
