#!/bin/bash

echo "*** Setting the website on docker after compose install"
echo ""
echo "*Setting up directory permissions"
echo "chmod -R 775 /local/drupal/site/web/sites/default/files"
chmod -R 775 /local/drupal/site/web/sites/default/files
echo "chmod -R 775 /local/drupal/site/web/sites/default/s*"
chmod -R 664 /local/drupal/site/web/sites/default/s*

echo ""
echo "*Add symbolic link to shared volume"
echo "username = the project name for docker"
echo "ln -s /mnt/s3fs/$username /local/drupal/site/web/sites/default/files/assets/s3fs"
ln -s /mnt/s3fs /local/drupal/site/web/sites/default/files/assets/s3fs
echo "ls -latr"
ls -latr

echo "Import Config or Load Database if config doesn't work"
echo "drush cim -y"
drush cim -y

echo "Adding server info"

./enable_ldap.sh


