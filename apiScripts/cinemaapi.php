<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");
header("Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With");
header("Access-Control-Allow-Methods: GET, OPTIONS, DELETE");

// Master IP localhost:3307 root master
// Slave1 IP localhost:3308 root slave1
// Slave2 IP localhost:3309 root slave2		delayed
// Slave3 IP localhost:3310 root slave3
// Slave4 IP localhost:3311 root slave4

require_once("./CinemaApi/get.php");
require_once("./CinemaApi/delete.php");
require_once("./CinemaApi/put.php");
require_once("./CinemaApi/post.php");

// get the HTTP method, path and body of the request
$method = $_SERVER['REQUEST_METHOD'];
$request = explode('/', trim($_SERVER['PATH_INFO'],'/'));
$input = json_decode(file_get_contents('php://input'));

// in case of SQL injection
function clear($data){
  return  preg_replace('/[^a-z0-9_]+/i','',$data);
}

// retrieve the table and key from the path
$table = clear(array_shift($request));
$key = clear(array_shift($request)+0);

if($table == ""){
  header("Content-Type: text/html; charset=utf-8");
  readfile('./CinemaApi/api.html' );
  die();
}

// connect to the mysql database
if($method == 'GET'){
  $link = mysqli_connect('localhost:3307', 'root', 'master', 'Cinema')
  or die('Error connecting to MySQL server.');
} else{
  $link = mysqli_connect('localhost:3308', 'root', 'slave1', 'Cinema')
  or die('Error connectiong to MySQL server');
}
mysqli_set_charset($link,'utf8');

// create SQL based on HTTP method
switch ($method) {
  case 'GET':
  $sql = getRequest($table, $key); break;
  case 'DELETE':
  $sql = deleteRequest($table, $key); break;
  case 'PUT':
  $sql = putRequest($table, $input); break;
  case 'POST':
  $sql = postRequest($table, $key, $input); break;
}

$result = mysqli_query($link,$sql);

// die if SQL statement failed
if (!$result) {
  http_response_code(404);
  die(mysqli_error());
}

// print results, insert id or affected row count
if ($method == 'GET' || $table == 'login') {
  if (mysqli_num_rows($result) > 1) echo '[';
  for ($i=0;$i<mysqli_num_rows($result);$i++) {
    echo ($i>0?',':'').json_encode(mysqli_fetch_object($result));
  }
  if (mysqli_num_rows($result) > 1) echo ']';
} elseif ($method == 'POST') {
  echo mysqli_insert_id($link);
} else {
  echo mysqli_affected_rows($link);
}


// close mysql connection
mysqli_close($link);
?>
