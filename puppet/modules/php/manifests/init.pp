class ondrejppa {
    include apt

    apt::pparepo { "ondrej/php5":
        apt_key => "E5267A6C",
        ensure => present
    }
}

class php {
    require ondrejppa

    package { [
            "php5-fpm",
            "php5-cli",
            "php-pear",
        ]:
        ensure => latest,
        require => Class['ondrejppa'],
    }
}

class php::composer {
    exec { "getcomposer":
        command => "curl -sS https://getcomposer.org/installer | php",
        user => "root",
        require => [
            Class['php'],
            Package["curl"]
        ],
    }
    exec { "movecomposer":
        command => "mv composer.phar /usr/local/bin/composer",
        user => "root",
        require => Exec["getcomposer"],
    }
}
