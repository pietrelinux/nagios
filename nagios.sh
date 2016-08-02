#!/bin/bash
apt-get install apache2 libapache2-mod-php5 build-essential bgd2-xpm-dev apache2-utils mailx postfix
/usr/sbin/useradd -m -s /bin/bash nagios
passwd nagios
/usr/sbin/groupadd nagios
/usr/sbin/usermod -G nagios nagios
/usr/sbin/groupadd nagcmd
/usr/sbin/usermod -a -G nagcmd www-data	
wget http://prdownloads.sourceforge.net/sourceforge/nagios/nagios-3.2.3.tar.gz
wget http://prdownloads.sourceforge.net/sourceforge/nagiosplug/nagios-plugins-1.4.11.tar.gz
cd nagios-3.2.3
./configure --with-command-group=nagcmd
make all && make install-init && make install-init && make install-config && make install-commandmode
make install-webconf
htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin
/etc/init.d/apache2 reload
cd ..
tar xzf nagios-plugins-1.4.11.tar.gz
cd nagios-plugins-1.4.11
./configure --with-nagios-user=nagios --with-nagios-group=nagios
make && make install
ln -s /etc/init.d/nagios /etc/rcS.d/S99nagios
/usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg
/etc/init.d/nagios restart

