#!/bin/sh
# modify /etc/apache2/httpd.conf to enable loading of php5_module
sed -i 's/^#LoadModule php5_module/LoadModule php5_module/' /etc/apache2/httpd.conf"