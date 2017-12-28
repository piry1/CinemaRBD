<?php

function getRequest($table, $key){

  $sql = "";

  switch ($table) {
    case 'bilety': $sql ="select * from _Bilety_".($key?" WHERE id=$key":''); break;
    case 'filmy': $sql ="select * from Filmy".($key?" WHERE id=$key":''); break;
    case 'miejsca': $sql ="select * from Miejsca".($key?" WHERE id=$key":''); break;
    case 'rezerwacje': $sql ="select * from Rezerwacje".($key?" WHERE id=$key":''); break;
    case 'sale': $sql ="select * from Sale".($key?" WHERE id=$key":''); break;
    case 'seanse': $sql ="select * from _Seanse_".($key?" WHERE id=$key":''); break;
    case 'bilet': $sql ="CALL WyswietlBilet('$key')"; break;
    case 'seansefilmu': $sql ="CALL WyswietlSeanse('$key')"; break;
    case 'wolnemiejsca': $sql ="CALL WyswietlMiejsca('$key')"; break;
    case 'biletyusera': $sql ="CALL BiletyUsera('$key')"; break;
  }

  if($sql == ""){
    http_response_code(403);
    die("no method found");
  }
  //  echo $sql;
  return $sql;
}

?>
