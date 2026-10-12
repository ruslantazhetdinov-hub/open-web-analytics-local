<?php

define('OWA_DB_TYPE', 'mysql');
define('OWA_DB_NAME', getenv('OWA_DB_NAME') ?: 'owa');
define('OWA_DB_HOST', getenv('OWA_DB_HOST') ?: 'db');
define('OWA_DB_USER', getenv('OWA_DB_USER') ?: 'owa');
define('OWA_DB_PORT', '3306');
define('OWA_DB_PASSWORD', getenv('OWA_DB_PASSWORD'));

define('OWA_NONCE_KEY', hash('sha256', 'nonce-key:' . getenv('OWA_DB_PASSWORD')));
define('OWA_NONCE_SALT', hash('sha256', 'nonce-salt:' . getenv('OWA_DB_PASSWORD')));
define('OWA_AUTH_KEY', hash('sha256', 'auth-key:' . getenv('OWA_DB_PASSWORD')));
define('OWA_AUTH_SALT', hash('sha256', 'auth-salt:' . getenv('OWA_DB_PASSWORD')));

define('OWA_PUBLIC_URL', getenv('OWA_PUBLIC_URL') ?: 'http://localhost:8080/');
define('OWA_TIMEZONE', getenv('OWA_TIMEZONE') ?: 'Europe/Moscow');
define('OWA_CACHE_OBJECTS', true);

// Keep 24 months in the local lab. Change or remove this limit before client deployment.
define('OWA_SCHEDULED_JOBS', array(
    'rotate-partitions' => array('params' => array('keep' => 24)),
));

