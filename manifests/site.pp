node slave1.puppet {
  package { 'httpd':
    ensure => 'installed',
  }
}

node slave2.puppet {
  &packages = [ 'httpd', 'php' ]
  package { &packages:
    ensure => 'installed',
  }
}
