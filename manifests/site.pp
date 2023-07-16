node mineserver.puppet {
  package { 'java':
    name => 'java-latest-openjdk.x86_64',
    ensure => 'installed',
    provider => 'dnf'
  }
  -> file { '/opt/minecraft':
      ensure => directory,
  }
  -> file { 'eula.txt':
      path => "/opt/minecraft/eula.txt",
      ensure => present,
      source => "/vagrant/eula.txt",
  }
  -> file { 'minecraft':
      path => "/opt/minecraft/server.jar",
      source => "https://piston-data.mojang.com/v1/objects/84194a2f286ef7c14ed7ce0090dba59902951553/server.jar",
      mode => "755",
  }
  -> file { 'minecraft_service':
      path => "/etc/systemd/system/minecraft.service",
      ensure => present,
      source => "/vagrant/minecraft.service",
  }
  ~> service { 'minecraft':
      ensure => running,
  }
}

node master.puppet {
  class{'nginx': }

  nginx::resource::location{ '/blog':
    proxy => 'http://192.168.99.1/',
    server => 'www.myhost.com',
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
