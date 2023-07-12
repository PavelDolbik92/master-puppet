node default {
   service {
     ensure => stopped,
     enable => false,
   }
}

node slave1.puppet {
  package { 'httpd':
    ensure => 'installed',
  }

  service {
     ensure => running,
     enable => true,
   }
}

node slave2.puppet {
  $packages = [ 'httpd', 'php' ]
  package { $packages:
    ensure => 'installed',
  }

  service {
     ensure => running,
     enable => true,
   }
}
