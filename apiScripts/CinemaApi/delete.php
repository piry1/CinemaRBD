<?php

function deleteRequest($table, $key){

  $sql = "";

  switch ($table) {
    case 'seans': $sql = "CALL UsunSeans('$key')"; break;
    case 'sala': $sql = "CALL UsunSale('$key')"; break;
    case 'film': $sql = "CALL UsunFilm('$key')"; break;
    case 'rezerwacja': $sql = "CALL UsunRezerwacje('$key')"; break;
  }

  if($sql == ""){
    http_response_code(404);
    die("no method found");
  }

  return $sql;
}

?>
