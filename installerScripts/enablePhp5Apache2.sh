#!/bin/sh
# when calling sed in a script, no need for '' quotes around command

sudo sed -ie s/^#LoadModule php5_module/LoadModule php5_module/ /etc/apache2/httpd.conf

