
#Remove these
drush php-eval "\Drupal::keyValue('system.schema')->delete('google_analytics');"
drush php-eval "\Drupal::keyValue('system.schema')->delete('migrate_plus');"

#Install devel_entity_updates
php -d memory_limit=-1 /usr/bin/composer require drupal/devel_entity_updates:^3.0 drupal/pathauto:^1.10
drush pm-enable devel_entity_updates -y

drush devel-entity-updates -y


drush ev '$definition_update_manager=\Drupal::entityDefinitionUpdateManager();$definition_update_manager->updateEntityType(\Drupal::entityTypeManager()->getDefinition("path_alias"));'
drush devel-entity-updates -y
drush updatedb -y
drush updatedb-status

php -d memory_limit=-1 /usr/bin/composer require drupal/core:8.9.20 webflo/drupal-core-require-dev:8.9.20 --update-with-dependencies

drush updatedb -y

php -d memory_limit=-1 /usr/bin/composer update
drush updatedb -y
drush cr


php -d memory_limit=-1 /usr/bin/composer require  drupal/backup_migrate:^5.0 drupal/devel:^4.1
drush updatedb -y
drush cr
drush pmu module_missing_message_fixer -y
drush cr
php -d memory_limit=-1 /usr/bin/composer remove drupal/module_missing_message_fixer

drush pmu ldap_help -y
drush cr

drush pmu ldap_query -y
drush cr

#Now update ldap to 4.3

php -d memory_limit=-1 /usr/bin/composer require drupal/ldap:^4.3 drupal/ldap_servers:^4.3
drush updatedb -y
drush cr

php -d memory_limit=-1 /usr/bin/composer remove webflo/drupal-core-require-dev

php -d memory_limit=-1 /usr/bin/composer require drupal/core:i^9.3 --no-update
exit
vi composer.json and change webflo/drupal-core-require-dev to 9.3.15
drush updatedb -y
drush cr
