<?php
return array (
  'backend' =>
  array (
    'frontName' => 'MAGENTO_ADMINURL',
  ),
  'crypt' =>
  array (
    'key' => '9bff632bcd8057bb6d7af76a54115018',
  ),
  'session' =>
  array (
    'save' => 'files',
  ),
  'db' =>
  array (
    'table_prefix' => '',
    'connection' =>
    array (
      'default' =>
      array (
        'host' => 'MYSQL_HOST',
        'dbname' => 'MYSQL_DATABASE',
        'username' => 'MYSQL_USER',
        'password' => 'MYSQL_PASSWORD',
        'model' => 'mysql4',
        'engine' => 'innodb',
        'initStatements' => 'SET NAMES utf8;',
        'active' => '1',
      ),
    ),
  ),
  'resource' =>
  array (
    'default_setup' =>
    array (
      'connection' => 'default',
    ),
  ),
  'x-frame-options' => 'SAMEORIGIN',
  'MAGE_MODE' => 'default',
  'cache_types' =>
  array (
    'config' => 0,
    'layout' => 0,
    'block_html' => 0,
    'collections' => 0,
    'reflection' => 0,
    'db_ddl' => 0,
    'eav' => 0,
    'customer_notification' => 0,
    'full_page' => 0,
    'config_integration' => 0,
    'config_integration_api' => 0,
    'translate' => 0,
    'config_webservice' => 0,
    'compiled_config' => 1,
  ),
  'install' =>
  array (
    'date' => 'Sun, 03 Sep 2017 13:35:25 +0000',
  ),
);
