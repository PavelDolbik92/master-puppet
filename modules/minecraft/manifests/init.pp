class minecraft {
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
    source => "puppet:///modules/minecraft/eula.txt",
  }
  -> file { 'minecraft':
    path => "/opt/minecraft/server.jar",
    source => "https://piston-data.mojang.com/v1/objects/84194a2f286ef7c14ed7ce0090dba59902951553/server.jar",
    mode => "755",
  }
  -> file { 'minecraft_service':
    path => "/etc/systemd/system/minecraft.service",
    ensure => present,
    source => "puppet:///modules/minecraft/minecraft.service",
  }
  ~> service { 'minecraft':
    ensure => running,
  }
}