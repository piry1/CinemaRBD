<?php

function putRequest($table, $d){
  $sql = "";

  switch ($table) {
    case 'film': $sql = "CALL DodajFilm('$d->tytul', '$d->rezyser', '$d->rok', '$d->gatunek', '$d->dlugosc')";  break;
    case 'admin': $sql = "CALL DodajAdmina('$d->imie', '$d->nazwisko', '$d->login', '$d->haslo')";  break;
    case 'sala': $sql = "CALL DodajSale('$d->nazwa', '$d->miejsca', '$d->rzedy')";  break;
    case 'seans': $sql = "CALL DodajSeans('$d->idfilmu', '$d->idsali', '$d->data', '$d->godzina', '$d->cena')";  break;
    case 'uzytkownik': $sql = "CALL DodajUzytkownika('$d->imie', '$d->nazwisko', '$d->login', '$d->haslo')";  break;
    case 'bilet': $sql = "CALL KupBilet('$d->klient', '$d->rezerwacja')";  break;
  }

  if($sql == ""){
    http_response_code(405);
    die("no method found");
  }
  //  echo $sql;
  return $sql;
}

?>
