node mineserver.puppet {
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

  file { '/opt/minecraft/minecraft.service':
    ensure => present,
    source => "/vagrant/minecraft.service",
  }

  java::download { 'jdk19' :
    ensure  => 'present',
    java_se => 'jdk',
    url     => 'https://download.java.net/java/GA/jdk19.0.2/fdb695a9d9064ad6b064dc6df578380c/7/GPL/openjdk-19.0.2_linux-aarch64_bin.tar.gz',
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
