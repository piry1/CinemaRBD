<?php

function postRequest($table, $key, $d){
  $sql = "";

  if($key){
    switch ($table) {
      case 'film': $sql = "CALL EdytujFilm('$key', '$d->tytul', '$d->rezyser', '$d->rok', '$d->gatunek', '$d->dlugosc')";  break;
      case 'sala': $sql = "CALL EdytujSale('$key', '$d->nazwa')";  break;
      case 'seans': $sql = "CALL EdytujSeans('$key', '$d->data', '$d->godzina', '$d->cena')";  break;
      //DELETE
      case 'dseans': $sql = "CALL UsunSeans('$key')"; break;
      case 'dsala': $sql = "CALL UsunSale('$key')"; break;
      case 'dfilm': $sql = "CALL UsunFilm('$key')"; break;
      case 'drezerwacja': $sql = "CALL UsunRezerwacje('$key')"; break;
    }
  }else{
    switch ($table) {
      case 'film': $sql = "CALL DodajFilm('$d->tytul', '$d->rezyser', '$d->rok', '$d->gatunek', '$d->dlugosc')";  break;
      case 'admin': $sql = "CALL DodajAdmina('$d->imie', '$d->nazwisko', '$d->login', '$d->haslo')";  break;
      case 'sala': $sql = "CALL DodajSale('$d->nazwa', '$d->miejsca', '$d->rzedy')";  break;
      case 'seans': $sql = "CALL DodajSeans('$d->idfilmu', '$d->idsali', '$d->data', '$d->godzina', '$d->cena')";  break;
      case 'uzytkownik': $sql = "CALL DodajUzytkownika('$d->imie', '$d->nazwisko', '$d->login', '$d->haslo')";  break;
      case 'bilet': $sql = "CALL KupBilet('$d->klient', '$d->rezerwacja')";  break;
    }
  }

  if($sql == ""){
    http_response_code(404);
    die("no method found");
  }
  //  echo $sql;
  return $sql;
}

?>
