node slave2.puppet {
  package { 'httpd':
    ensure => 'present',
  }
}

node slave1.puppet {
  package { 'php':
    ensure => 'present',
  }
}
