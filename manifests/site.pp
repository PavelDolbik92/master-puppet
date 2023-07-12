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
  package { 'httpd':
    ensure => 'installed',
  }

  package { 'php':
    ensure => 'installed',
  }

  service {
     ensure => running,
     enable => true,
   }
}
