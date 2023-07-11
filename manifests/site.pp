node slave2.puppet {
  package { 'apatch2':
    ensure => 'present',
  }
}
