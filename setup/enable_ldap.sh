#!/bin/bash

echo "Peform this after loading database or importing config"
echo ""
echo "* Set server info"
drush cset ldap_servers.server.nci address $ldap_address -y
drush cset ldap_servers.server.nci port $ldap_port -y
echo "* Enable ldap_authentication"
drush pm-enable ldap_authentication -y
