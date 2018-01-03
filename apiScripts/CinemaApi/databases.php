<?php

class database{
    public $adress;
    public $password;
    public $login;
}

function createDb($adress, $password, $login){
    $db = new database;
    $db->adress = $adress;
    $db->password = $password;
    $db->login = $login;
    return $db;
}

$databases = array();

$databases[] = createDb('localhost:3308', 'slave1', 'root');
$databases[] = createDb('localhost:3310', 'slave3', 'root');
$databases[] = createDb('localhost:3311', 'slave4', 'root');

?>
