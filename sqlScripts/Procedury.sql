-- KOMENDY DODAJACE DANE DO TABLIC

-- Dodaje nowy film
delimiter //
DROP PROCEDURE IF EXISTS DodajFilm//
CREATE PROCEDURE DodajFilm(in _tytul varchar(30), in _rezyser varchar(30), in _rok date, in _gatunek varchar(30), in _dlugosc varchar(30)) 
BEGIN
INSERT INTO Filmy(Tytul, Rezyser, Rok, Gatunek, Dlugosc) VALUES
(_tytul, _rezyser, _rok, _gatunek, _dlugosc);
END
//

-- Dodaje seans i rezerwacje zaleznie od ilosci miejsc na sali
delimiter //
DROP PROCEDURE IF EXISTS DodajSeans//
CREATE PROCEDURE DodajSeans(in _idFilmu int, in _idSali int, in _dataSeansu date, in _godzina time, in _cena float ) 
BEGIN
SET @id=_idSali;
SELECT @miejsca:=Pojemnosc FROM Sale WHERE Id=@id;

INSERT INTO Seanse(IdFilmu,IdSali, DataSeansu, Godzina, Cena, WolneMiejsca) VALUES 
(_idFilmu,@id,_dataSeansu,_godzina,_cena,@miejsca);

SET @idSeansu = LAST_INSERT_ID();
SET @i=1;

WHILE (@i<=@miejsca) DO
		INSERT INTO Rezerwacje(IdMiejsca,IdSeansu, Zajete) VALUES (@i,@idSeansu,'0');		
		SET @i=@i+1;
END WHILE;

END
//


-- Dodaje nowy bilet 
delimiter //
DROP PROCEDURE IF EXISTS KupBilet//
CREATE PROCEDURE KupBilet(in _idKlienta int, in _idRezerwacji int ) 
BEGIN

SELECT @czyWolne:=Zajete FROM Rezerwacje WHERE Rezerwacje.Id=_idRezerwacji;

IF @czyWolne=0 THEN
INSERT INTO Bilety(IdKlienta, IdRezerwacji) VALUES (_idKlienta, _idRezerwacji);
UPDATE Rezerwacje SET Zajete=1 WHERE Rezerwacje.Id=_idRezerwacji;
UPDATE Seanse INNER JOIN Rezerwacje SET WolneMiejsca=WolneMiejsca-1 WHERE Rezerwacje.Id=_idRezerwacji AND Seanse.Id=Rezerwacje.IdSeansu;
END IF;

END
//

-- Dodanie sali i miejsc w tej sali
delimiter //
DROP PROCEDURE IF EXISTS DodajSale//
CREATE PROCEDURE DodajSale(in _nazwa varchar(30), in _iloscMiejscWRzedzie int, in _rzedy int ) 
BEGIN

INSERT INTO Sale(NazwaSali,Pojemnosc) VALUES (_nazwa,_iloscMiejscWRzedzie*_rzedy);

SET @idSali=LAST_INSERT_ID();
SET @i=1;
SET @j=1;
SET @nrMiejsca=1;

WHILE (@i<=_rzedy) DO
	WHILE (@j<=_iloscMiejscWrzedzie) DO
		INSERT INTO Miejsca(IdSali,Rzad, NrMiejsca) VALUES (@idSali,@i,@nrMiejsca);
		SET @nrMiejsca=@nrMiejsca+1;
		SET @j=@j+1;
	END WHILE;
	SET @j=1;
	SET @i=@i+1;
END WHILE;

END
//

-- Dodaje uzytkownika
delimiter //
DROP PROCEDURE IF EXISTS DodajUzytkownika//
CREATE PROCEDURE DodajUzytkownika(in _imie varchar(30), in _nazwisko varchar(30), in _login varchar(30), in _haslo varchar(30)) 
BEGIN
INSERT INTO Uzytkownicy(Imie, Nazwisko, Login, Haslo, Uprawnienia) VALUES
(_imie,_nazwisko,_login,_haslo,'2');
END
//

-- Dodaje admina
delimiter //
DROP PROCEDURE IF EXISTS DodajAdmina//
CREATE PROCEDURE DodajAdmina(in _imie varchar(30), in _nazwisko varchar(30), in _login varchar(30), in _haslo varchar(30)) 
BEGIN
INSERT INTO Uzytkownicy(Imie, Nazwisko, Login, Haslo, Uprawnienia) VALUES
(_imie,_nazwisko,_login,_haslo,'1');
END
//

-- Wyswietla bilety uzytkownika
delimiter //
DROP PROCEDURE IF EXISTS BiletyUsera//
CREATE PROCEDURE BiletyUsera(in _id int) 
BEGIN
SELECT * FROM _Bilety_ WHERE IdKlienta=_id;
END
//

-- Edytuje parametry konkretnego filmu
delimiter //
DROP PROCEDURE IF EXISTS EdytujFilm//
CREATE PROCEDURE EdytujFilm(in _id int, in _tytul varchar(30), in _rezyser varchar(30), in _rok date, in _gatunek varchar(30), in _dlugosc varchar(30)) 
BEGIN
UPDATE Filmy
SET Tytul = _tytul, Rezyser = _rezyser, Rok=_rok, Gatunek=_gatunek, Dlugosc=_dlugosc
WHERE Id=_id;
END
//

-- Edytuje konkretny seans
delimiter //
DROP PROCEDURE IF EXISTS EdytujSeans//
CREATE PROCEDURE EdytujSeans(in _id int, in _dataSeansu date, in _godzina time, in _cena float ) 
BEGIN
UPDATE Seanse
SET DataSeansu=_dataSeansu, Godzina=_godzina, Cena=_cena
WHERE Id=_id;
END
//

-- Zmienia nazwe konkretnej sali
delimiter //
DROP PROCEDURE IF EXISTS EdytujSale//
CREATE PROCEDURE EdytujSale(in _id int, in _nazwaSali varchar(30)) 
BEGIN
UPDATE Sale
SET NazwaSali=_nazwaSali
WHERE Id=_id;
END
//

-- Usuwa konkretną rezerwacje
delimiter //
DROP PROCEDURE IF EXISTS UsunRezerwacje //
CREATE PROCEDURE UsunRezerwacje(in _id int) 
BEGIN
UPDATE Rezerwacje
SET Zajete=0
WHERE Id=_id;

UPDATE Seanse INNER JOIN Rezerwacje SET WolneMiejsca=WolneMiejsca+1 WHERE Rezerwacje.Id=_id AND Seanse.Id=Rezerwacje.IdSeansu;

DELETE FROM Bilety
WHERE IdRezerwacji=_id;

END
//

-- Usuwa konkretny film
delimiter //
DROP PROCEDURE IF EXISTS UsunFilm//
CREATE PROCEDURE UsunFilm(in _id int) 
BEGIN

DELETE FROM Bilety
WHERE IdRezerwacji in (SELECT Rezerwacje.Id FROM Rezerwacje WHERE IdSeansu in (SELECT Seanse.Id FROM Seanse WHERE IdFilmu =_id));

DELETE FROM Rezerwacje
WHERE IdSeansu in (SELECT Seanse.Id FROM Seanse WHERE IdFilmu =_id);

DELETE FROM Seanse
WHERE IdFilmu=_id;

DELETE FROM Filmy
WHERE Id=_id;
END
//

-- Usuwa konkretny seans
delimiter //
DROP PROCEDURE IF EXISTS UsunSeans//
CREATE PROCEDURE UsunSeans(in _id int) 
BEGIN
DELETE FROM Bilety
WHERE IdRezerwacji in (SELECT Rezerwacje.Id FROM Rezerwacje WHERE IdSeansu=_id);

DELETE FROM Rezerwacje
WHERE IdSeansu=_id;

DELETE FROM Seanse
WHERE Id=_id;
END
//

-- Usuwa konkretna sale
delimiter //
DROP PROCEDURE IF EXISTS UsunSale//
CREATE PROCEDURE UsunSale(in _id int) 
BEGIN
DELETE FROM Bilety
WHERE IdRezerwacji in (SELECT Rezerwacje.Id FROM Rezerwacje WHERE IdSeansu in (SELECT Seanse.Id FROM Seanse WHERE IdSali=_id));

DELETE FROM Rezerwacje
WHERE IdSeansu in (SELECT Seanse.Id FROM Seanse WHERE IdSali=_id);

DELETE FROM Seanse
WHERE IdSali=_id;

DELETE FROM Miejsca
WHERE IdSali=_id;

DELETE FROM Sale
WHERE Id=_id;
END
//

-- Wyświetla Bilet o podanym id
delimiter //
DROP PROCEDURE IF EXISTS WyswietlBilet//
CREATE PROCEDURE WyswietlBilet(in _id int) 
BEGIN
SELECT * FROM _Bilety_
WHERE Id=_id;
END
//

-- Wyswietla niezarezerwowane miejsca na konkretny seans
delimiter //
DROP PROCEDURE IF EXISTS WyswietlMiejsca//
CREATE PROCEDURE WyswietlMiejsca(in _idSeansu int) 
BEGIN
SELECT * FROM _Miejsca_
WHERE IdSeansu=_idSeansu AND Zajete=0;
END
//

-- Wyswietla wszystkie seanse dla konkretnego filmu
delimiter //
DROP PROCEDURE IF EXISTS WyswietlSeanse//
CREATE PROCEDURE WyswietlSeanse(in _idFilmu int) 
BEGIN
SELECT * FROM _Seanse_
WHERE IdFilmu=_idFilmu;
END
//

-- Wyswietla dane uzytkownika jesli login i haslo sie zgadzaja
delimiter //
DROP PROCEDURE IF EXISTS SprawdzUzytkownika//
CREATE PROCEDURE SprawdzUzytkownika(in _login varchar(30), in _haslo varchar(30)) 
BEGIN
SELECT * FROM Uzytkownicy
WHERE Login=_login AND Haslo=_haslo;
END
