stage { "pre": before => Stage["main"] }

Exec {
    path => '/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin'
}

class devbox {
    rename { "magento.nefariousdesigns.co.uk": }
    exec { "aptupdate":
        command => "aptitude update --quiet --assume-yes",
        user => "root",
        timeout => 0,
    }
    group { "puppet":
        ensure => present,
    }
    package { "build-essential":
        ensure => latest,
    }
    package { [
            "python-software-properties",
            "tmux",
            "vim",
            "curl",
            "git",
            "git-flow",
            "aptitude",
            "memcached",
        ]:
        ensure => latest,
        require => Exec["aptupdate"]
    }
}

class { "devbox": stage => pre }

if $virtual == 'virtualbox' {
    class { "vagrant-user": stage => pre }
} else {
    class { "user": stage => pre }
}

class { "mysql": root_password => "monkeys" }

include php
include php::composer

class { "magento":
    /* magento version */
    version        => "1.8.0.0",

    /* magento database settings */
    db_username    => "magento",
    db_password    => "magento",

    /* magento admin user */
    admin_username => "admin",
    admin_password => "123123abc",

    /* "yes|no */
    use_rewrites   => "no",
}

include nginx
