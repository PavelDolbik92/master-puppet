node mineserver.puppet {
  include minecraft
}

node master.puppet {
  class { selinux:
    mode => 'disabled',
  }
  -> class{'nginx': }
  -> nginx::resource::server { 'proxy1':
      server_name => ['localhost'],
      listen_port => 8080,
      proxy       => 'http://192.168.50.3:80/',
  }
  -> nginx::resource::server { 'proxy2':
      server_name => ['localhost'],
      listen_port => 8080,
      proxy       => 'http://192.168.50.4:80/',
  }
}

node slave1.puppet {
  package { 'httpd':
    ensure => 'installed',
  }

  file { '/var/www/html/index.html':
          ensure => present,
          source => "/vagrant/index.html",
  }
   
  service { 'httpd':
     ensure => running,
     enable => true,
   }

   service { 'firewalld':
     ensure => stopped,
     enable => false,
   }
}

node slave2.puppet {
  package { 'httpd':
    ensure => 'installed',
  }

  package { 'php':
    ensure => 'installed',
  }

  file { '/var/www/html/index.php':
          ensure => present,
          source => "/vagrant/index.php",
  }
  
  service { 'httpd':
     ensure => running,
     enable => true,
   }

   service { 'firewalld':
     ensure => stopped,
     enable => false,
   }
}
