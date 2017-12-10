<?php

function postRequest($table, $key, $d){
  $sql = "";

  if($key){
    switch ($table) {
      case 'film': $sql = "CALL EdytujFilm('$key', '$d->Tytul', '$d->Rezyser', '$d->Rok', '$d->Gatunek', '$d->Dlugosc')";  break;
      case 'sala': $sql = "CALL EdytujSale('$key', '$d->Nazwa')";  break;
      case 'seans': $sql = "CALL EdytujSeans('$key', '$d->Data', '$d->Godzina', '$d->Cena')";  break;
      //DELETE
      case 'dseans': $sql = "CALL UsunSeans('$key')"; break;
      case 'dsala': $sql = "CALL UsunSale('$key')"; break;
      case 'dfilm': $sql = "CALL UsunFilm('$key')"; break;
      case 'drezerwacja': $sql = "CALL UsunRezerwacje('$key')"; break;
    }
  }else{
    switch ($table) {
      case 'film': $sql = "CALL DodajFilm('$d->Tytul', '$d->Rezyser', '$d->Rok', '$d->Gatunek', '$d->Dlugosc')";  break;
      case 'admin': $sql = "CALL DodajAdmina('$d->Imie', '$d->Nazwisko', '$d->Login', '$d->Haslo')";  break;
      case 'sala': $sql = "CALL DodajSale('$d->Nazwa', '$d->Miejsca', '$d->Rzedy')";  break;
      case 'seans': $sql = "CALL DodajSeans('$d->IdFilmu', '$d->IdSali', '$d->Data', '$d->Godzina', '$d->Cena')";  break;
      case 'uzytkownik': $sql = "CALL DodajUzytkownika('$d->Imie', '$d->Nazwisko', '$d->Login', '$d->Haslo')";  break;
      case 'bilet': $sql = "CALL KupBilet('$d->Klient', '$d->Rezerwacja')";  break;
      case 'login': $sql = "CALL SprawdzUzytkownika('$d->Login', '$d->Haslo')";  break;

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
