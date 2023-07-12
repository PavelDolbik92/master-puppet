node default {
   service { 'firewalld':
     ensure => stopped,
     enable => false,
   }
}
