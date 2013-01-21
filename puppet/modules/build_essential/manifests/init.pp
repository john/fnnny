class build_essential {
  package { 'build-essential':
    ensure => present,
  }
}