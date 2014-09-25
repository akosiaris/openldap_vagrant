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
    'm1': { $server_id = 1 $master = 'm2.example.org' }
    'm2': { $server_id = 2 $master = 'm1.example.org' }
    's1': { $server_id = 1 $master = 'm1.example.org' }
}

class { '::openldap':
    server_id => $server_id,
    suffix => 'dc=corp,dc=wikimedia,dc=org',
    datadir => '/var/lib/ldap/corp',
    master => $master,
    sync_pass => '123',
}
