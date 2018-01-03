<?php

class database{
    public $adress;
    public $password;
    public $login;
}

$db1 = new database;
$db2 = new database;
$db3 = new database;
$databases = array();

$db1->adress = 'localhost:3308';
$db1->password = 'slave1';
$db1->login = 'root';

$databases[] = $db1;

$db2->adress = 'localhost:3310';
$db2->password = 'slave3';
$db2->login = 'root';

$databases[] = $db2;

$db3->adress = 'localhost:3311';
$db3->password = 'slave4';
$db3->login = 'root';

$databases[] = $db3;

//echo  var_dump($databases);
?>
