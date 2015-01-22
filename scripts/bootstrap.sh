#!/usr/bin/env bash

# main package installs
#yum install -y unzip zip wget
yum install -y httpd mysql mysql-server mcrypt
yum install -y php php-cli php-common php-gd php-mbstring php-mcrypt php-xml php-mysql php-pdo
yum install -y npm beanstalkd

# repos for php 5.5

# get remi in the right place
#wget --directory-prefix=/etc/yum.repos.d http://rpms.famillecollet.com/enterprise/remi.repo

#yum install -y --enablerepo=remi php55 php55-php-common php55-php-cli php55-php-gd php55-php-mbstring php55-php-opcache php55-php-xml php55-php-mcrypt

# gotta install composer
npm install -g bower gulp grunt-cli

chkconfig --add mysqld
chkconfig mysqld on
chkconfig --add httpd
chkconfig httpd on
service httpd start
service mysqld start
