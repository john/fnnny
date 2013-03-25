group { "puppet":
  ensure => "present",
}

exec { "apt-update":
  command => "/usr/bin/apt-get update",
  require => Group[puppet]
}

Exec["apt-update"] -> Package <| |>

file { "/etc/environment":
    owner => 'root',
    group => 'root',
    mode => '644',
    content => template("common/environment"),
    require => Exec["apt-update"],
}

file { "/etc/update-motd.d/51-cloudguest":
  ensure => absent,
}

# create deploybot user; use the 'user' type.
# See http://reductivelabs.com/trac/puppet/wiki/TypeReference#id229
user { "deploybot":
  name => 'deploybot',
  password => '149645421780291',
  comment => 'This user was created by Puppet',
  ensure => 'present',
  home => '/home/deploybot',
}

file { "/home/deploybot":
    ensure => 'directory',
    owner => 'deploybot',
    require => User["deploybot"],
}

# The managed_home above creates the home dir, but we also need
# the .ssh dir, use the file type
# see http://reductivelabs.com/trac/puppet/wiki/TypeReference#file
file { "/home/deploybot/.ssh":
    path    => "/home/deploybot/.ssh",
    ensure => 'directory',
    owner => 'deploybot',
    group => 'deploybot',
    mode => '700',
    require => File["/home/deploybot"],
}

file { "/home/deploybot/.ssh/authorized_keys":
    path    => "/home/deploybot/.ssh/authorized_keys",
    owner => 'deploybot',
    group => 'deploybot',
    mode => '600',
    require => File["/home/deploybot/.ssh"],
}

ssh_authorized_key { "deploybot-rsa-key":
   ensure => 'present',
   key => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQClugerYn0P8JnSYFTOy4ukWlgRwy2gMUo93xQmyxGP7s6zzBV1dss5gEuGjKGRUiITjZJV06dUmU9BoxGNuj0qzkX/sSME/XTpnuLD6npNYS0uoQRISLpZzto3B1HX+GRdXGxLjMZ8yUaSSWM4BFyiak6jpRyinKj1oYIMGnFeT45ioz4bB5ODeIehXPi7WHupGe2A5mQOlIuokEG8g0UsM29gtxQjwJX1DuWO9bsJ+fVrBPKEnExO3gVmyNDy077fob0BhMItdhkeP32ttMOdN8MwGR4hXzHpnO0VdrAENRyPNFzbOrFqrS5yDSuMS/H7tn8ynmKdG8T1TRpHRA7z',
   type => 'rsa',
   user => 'deploybot',
   require => File["/home/deploybot/.ssh/authorized_keys"],
}

ssh_authorized_key { "ubuntu-rsa-key":
   ensure => 'present',
   key => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDacMQpb7bjLP1yk70NbrsLoJwsbd4Di41ltjrqWyk6F/l5ZxBonqkNkdi7fZjyAImMMPOEWsHi0BT+0WfTy0mpkthwX63FyAaWDbqtXRcIqPCZ3AwBbmNWGaOq5MYgNku9ei4U3k2AXqL1cjg2FBXXuTHEb/K+d4BNH//maCcd45j0JPiTPebDRkvArRKv/+p9Fcg65WJBxJKkOD0G8lgsVcvC5euDFiGiVRGWhuaR76eD79aBP/nyl8crV0qGffRfCDiJuPz9R7ClAxZ1X05ICiWzRiQs9AwfUwxCNZjY1zLgBYLJLu/nZKmhWzyS0knQIyPtBaEQ4IDAsuKZjBwV',
   type => 'rsa',
   user => 'ubuntu',
   require => File["/home/deploybot/.ssh/authorized_keys"],
}
include build_essential
include git
include gcc
include jruby
include libcurl4_openssl_dev
include libxml2_dev
include libxslt1_dev
include nginx
include openjdk_7_jdk
include trinidad