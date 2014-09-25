#

host { 'm1.example.org':
    ensure => 'present',
    ip => '192.168.10.2',
}

host { 'm2.example.org':
    ensure => 'present',
    ip => '192.168.10.3',
}

host { 's1.example.org':
    ensure => 'present',
    ip => '192.168.10.4',
}

case $::hostname {
    'm1': { $server_id = 1 $master = 'm2.example.org' $mirrormode=true }
    'm2': { $server_id = 2 $master = 'm1.example.org' $mirrormode=true }
    's1': { $server_id = 1 $master = 'm1.example.org' $mirrormode=false }
}

exec { 'copy_ca':
    command => '/bin/cp /vagrant/ca/cacert.crt /usr/local/share/ca-certificates/'
}

exec { 'update_cas':
    command => '/usr/sbin/update-ca-certificates'
}

exec { 'copy_cert':
    command => "/bin/cp /vagrant/ca/${::hostname}.example.org.crt /etc/ssl/certs/"
}

exec { 'copy_key':
    command => "/bin/cp /vagrant/ca/${::hostname}.example.org.key /etc/ssl/private"
}

file { '/etc/ssl/private':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0701',
}

class { '::openldap':
    server_id => $server_id,
    suffix => 'dc=corp,dc=wikimedia,dc=org',
    datadir => '/var/lib/ldap/corp',
    master => $master,
    sync_pass => '123',
    ca => '/etc/ssl/certs/ca-certificates.crt',
    certificate => "/etc/ssl/certs/${::hostname}.example.org.crt",
    key => "/etc/ssl/private/${::hostname}.example.org.key",
}

Exec['copy_ca'] -> Exec['update_cas']
Exec['update_cas'] -> Class['::openldap']
Exec['copy_cert'] -> Class['::openldap']
Exec['copy_key'] -> Class['::openldap']
File['/etc/ssl/private'] -> Class['::openldap']
