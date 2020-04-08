#!/usr/bin/env php
<?php declare(strict_types=1);
/**
 * Sets the password of key accounts to match those provided by environment variables.
*/

// Command line only!
if (isset($_SERVER['REMOTE_ADDR'])) {
    die("This is a command line tool only.");
}

require('/opt/domjudge/domserver/etc/domserver-static.php');
require(ETCDIR . '/domserver-config.php');
require(LIBDIR . '/init.php');
setup_database_connection();

// Do the updates.
$admin_pw = getenv('DJ_ADMIN_PASSWORD');
if ($admin_pw != NULL) {
    print_r("Setting admin password to {$admin_pw}\n");
    $DB->q("UPDATE user SET password = %s WHERE username = 'admin'", dj_password_hash($admin_pw));
}
$judge_pw = getenv('JUDGEDAEMON_PASSWORD');
if ($judge_pw != NULL) {
    print_r("Setting judgehost password to {$judge_pw}\n");
    $DB->q("UPDATE user SET password = %s WHERE username = 'judgehost'", dj_password_hash($judge_pw));
}

?>
