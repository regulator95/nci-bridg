#!/bin/bash
drushcmd = '/local/drupal/site/vendor/drush/drush/drush'

echo "Peform this after loading database or importing config"
echo ""
echo "* Set server info"
$drushcmd cset ldap_servers.server.nci address $ldap_address -y
$drushcmd cset ldap_servers.server.nci port $ldap_port -y
echo "* Enable ldap_authentication"
$drushcmd pm-enable ldap_authentication -y
