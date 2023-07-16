node mineserver.puppet {
  package { 'java-latest-openjdk.x86_64':
  ensure => 'installed',
    provider => 'dnf'
  }

  file { '/opt/minecraft':
    ensure => directory,
    before => File['minecraft'],
  }

  file { 'minecraft':
    path => "/opt/minecraft/server.jar",
    source => "https://piston-data.mojang.com/v1/objects/84194a2f286ef7c14ed7ce0090dba59902951553/server.jar",
    mode => "755",
    require => File['/opt/minecraft'],
  }

  file { 'minecraft_service':
    path => "/etc/systemd/system/minecraft.service",
    ensure => present,
    source => "/vagrant/minecraft.service",
    notify => Service["minecraft"]
  }

  service { 'minecraft':
    ensure => running,
    require => File["minecraft_service"]

  }
}

node master.puppet {
  package { 'nginx':
    ensure => 'installed',
  }

  package { 'php-fpm':
    ensure => 'installed',
  }

  exec {"disable silinux":
    command => 'sudo setenforce 0',
    provider => shell,
  }

  service { 'firewalld':
    ensure => stopped,
    enable => false,
  }

  file { '/etc/nginx/nginx.conf':
    ensure => present,
    source => "/vagrant/nginx.conf",
  }

  service { 'nginx':
    ensure => running,
    enable => true,
  }

  service { 'php-fpm':
    ensure => running,
    enable => true,
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
