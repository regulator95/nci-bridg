shopt -s expand_aliases
alias phpm="php -d memory_limit=-1"
#alias composerm="/usr/bin/composer"

echo "**** composer outdated 'drupal/*'  BEFORE"
phpm /usr/bin/composer outdated "drupal/*"

echo "*** CLEAN UP DATABASE"
echo "*** Remove unnecessary TABLES for DB"
echo
SEARCH_TERM="old_"
echo "SEARCH_TERM = $SEARCH_TERM"
echo "**** EXECUTE THESE COMMANDS AT THE COMMAND LINE"
mysql --user=$username --password=$password --database=$database --host=$host --port=$port -A -e "show tables;" -s |egrep "^$SEARCH_TERM" |xargs -I "@@" echo mysql --user=$username --password=$password --database=$database --host=$host --port=$port -A -e "DROP TABLE @@"
mysql --user=$username --password=$password --database=$database --host=$host --port=$port -A -e "show tables;" -s |egrep "^$SEARCH_TERM" |xargs -I "@@" mysql --user=$username --password=$password --database=$database --host=$host --port=$port -A -e "DROP TABLE @@"

SEARCH_TERM="tmp_"
echo "SEARCH_TERM = $SEARCH_TERM"
echo "**** EXECUTE THESE COMMANDS AT THE COMMAND LINE"
mysql --user=$username --password=$password --database=$database --host=$host --port=$port -A -e "show tables;" -s |egrep "^$SEARCH_TERM" |xargs -I "@@" echo mysql --user=$username --password=$password --database=$database --host=$host --port=$port -A -e "DROP TABLE @@"
mysql --user=$username --password=$password --database=$database --host=$host --port=$port -A -e "show tables;" -s |egrep "^$SEARCH_TERM" |xargs -I "@@" mysql --user=$username --password=$password --database=$database --host=$host --port=$port -A -e "DROP TABLE @@"

SEARCH_TERM="dd"
echo "SEARCH_TERM = $SEARCH_TERM"
echo "**** EXECUTE THESE COMMANDS AT THE COMMAND LINE"
mysql --user=$username --password=$password --database=$database --host=$host --port=$port -A -e "show tables;" -s |egrep "^$SEARCH_TERM" |xargs -I "@@" echo mysql --user=$username --password=$password --database=$database --host=$host --port=$port -A -e "DROP TABLE @@"
mysql --user=$username --password=$password --database=$database --host=$host --port=$port -A -e "show tables;" -s |egrep "^$SEARCH_TERM" |xargs -I "@@" mysql --user=$username --password=$password --database=$database --host=$host --port=$port -A -e "DROP TABLE @@"

SEARCH_TERM="migrate_"
echo "SEARCH_TERM = $SEARCH_TERM"
echo "**** EXECUTE THESE COMMANDS AT THE COMMAND LINE"
mysql --user=$username --password=$password --database=$database --host=$host --port=$port -A -e "show tables;" -s |egrep "^$SEARCH_TERM" |xargs -I "@@" echo mysql --user=$username --password=$password --database=$database --host=$host --port=$port -A -e "DROP TABLE @@"
mysql --user=$username --password=$password --database=$database --host=$host --port=$port -A -e "show tables;" -s |egrep "^$SEARCH_TERM" |xargs -I "@@" mysql --user=$username --password=$password --database=$database --host=$host --port=$port -A -e "DROP TABLE @@"

drush entup -y
drush updatedb -y
drush updatedb-status
drush sql-query "show tables"

echo "*** Reinstall Backup and Migrate"
drush pm-uninstall backup_migrate
drush pm-enable backup_migrate -y

echo "*** Uninstall Migrate Plus"
drush pm-uninstall migrate_plus
#Remove the system.schema for migrate_plus
drush php-eval "\Drupal::keyValue('system.schema')->delete('migrate_plus');"

echo "*** Uninstall Migrate"
drush pm-uninstall migrate

echo "*** Missing Memory Module Fixer"
drush pm-uninstall module_missing_message_fixer

#drush ev "\Drupal::service('config.manager')->uninstall('module', 'migrate_plus');"

echo "*** Reinstall Google Analytics"
drush ev "\Drupal::service('config.manager')->uninstall('module', 'google_analytics');"
drush pm-uninstall google_analytics
drush pm-enable google_analytics -y

echo "*** STEP 1: Add devel_entity_updates"
phpm /usr/bin/composer require drupal/devel_entity_updates
drush pm-enable devel_entity_updates -y

drush entup -y
drush updatedb -y

echo "*** STEP 2: Update to 8.9.x"
phpm /usr/bin/composer require drupal/core:^8.9 webflo/drupal-core-require-dev:^8.9 --update-with-dependencies
drush entup -y
drush updatedb -y


echo "*** STEP 3: Update all modules"
phpm /usr/bin/composer update
drush entup -y
drush updatedb -y
drush cr



echo "*** Get rid of path_alias path_alias issue"
drush ev '$definition_update_manager=\Drupal::entityDefinitionUpdateManager();$definition_update_manager->updateEntityType(\Drupal::entityTypeManager()->getDefinition("path_alias"));'
SEARCH_TERM="tmp_"
echo "SEARCH_TERM = $SEARCH_TERM"
echo "**** EXECUTE THESE COMMANDS AT THE COMMAND LINE"
mysql --user=$username --password=$password --database=$database --host=$host --port=$port -A -e "show tables;" -s |egrep "^$SEARCH_TERM" |xargs -I "@@" echo mysql --user=$username --password=$password --database=$database --host=$host --port=$port -A -e "DROP TABLE @@"
mysql --user=$username --password=$password --database=$database --host=$host --port=$port -A -e "show tables;" -s |egrep "^$SEARCH_TERM" |xargs -I "@@" mysql --user=$username --password=$password --database=$database --host=$host --port=$port -A -e "DROP TABLE @@"
drush entup -y
drush updatedb -y
drush cr

echo "*** Uninstall devel_entity_updates"
drush pm-uninstall devel_entity_updates

echo
echo "*** Upgrade Complete"
echo "*** STATUS"
echo "*** drush pm-security"
drush pm-security
echo "**** composer outdated 'drupal/*'  AFTER"
phpm /usr/bin/composer outdated "drupal/*"

echo "*** drush updatedb-status"

drush updatedb-status

drush status
php -v 
httpd -v 

echo "Upgrade completed:  Check Reports->Available Updates and Reports->Status for info.  Should be all GREEN and no issues on STATUS page."

#phpm /usr/bin/composer remove webflo/drupal-core-require-dev
#drush updatedb -y
#drush ev '$definition_update_manager=\Drupal::entityDefinitionUpdateManager();$definition_update_manager->updateEntityType(\DrupantityTypeManager()->getDefinition("url_alias"));'

