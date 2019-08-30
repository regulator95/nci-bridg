#!/bin/bash

echo "*** Setting the website on docker after compose install"
echo ""
echo "*Setting up directory permissions"
echo "chmod -R 775 /local/drupal/site/web/default"
chmod -R 775 /local/drupal/site/web/default
echo ""
echo "*Add symbolic link to shared volume"
ln -s /mnt/s3fs/
