CREATE TABLE IF NOT EXISTS Filmy 
( 
Id int AUTO_INCREMENT primary key,
Tytul varchar(30) not null,
Rezyser varchar(30) not null,
Rok date not null,
Gatunek varchar(30) not null,
Dlugosc varchar(30) not null
) ; 

CREATE TABLE IF NOT EXISTS Sale
(
Id int AUTO_INCREMENT primary key,
NazwaSali varchar(30) unique not null,
Pojemnosc int not null
CHECK (pojemnosc BETWEEN 20 AND 450)
);

CREATE TABLE IF NOT EXISTS Seanse
(
Id int AUTO_INCREMENT primary key,
IdFilmu int not null,
IdSali int  not null,
DataSeansu date not null,
Godzina time not null,
Cena float not null,
WolneMiejsca int not null,
foreign key (IdFilmu) references Filmy(Id),
foreign key (IdSali)  references Sale(Id)
);

CREATE TABLE IF NOT EXISTS Uprawnienia
(
Id int AUTO_INCREMENT primary key,
Nazwa varchar(30) unique not null
);

INSERT IGNORE INTO Uprawnienia(Id, Nazwa) VALUES
('1','Administrator'),
('2','Uzytkownik');

CREATE TABLE IF NOT EXISTS Uzytkownicy
(
Id int AUTO_INCREMENT primary key,
Imie varchar(30) not null,
Nazwisko varchar(30) not null,
Login varchar(30) unique not null,
Haslo varchar(30) not null,
Uprawnienia int  not null,
foreign key (Uprawnienia) references Uprawnienia(Id)
);

CREATE TABLE IF NOT EXISTS Miejsca 
(
Id int AUTO_INCREMENT primary key,
IdSali int  not null,
Rzad int not null,
NrMiejsca int not null,
foreign key (IdSali) references Sale(Id)
);

CREATE TABLE IF NOT EXISTS Rezerwacje
(
Id int AUTO_INCREMENT primary key,
IdMiejsca int not null,
IdSeansu int not null,
Zajete boolean not null,
foreign key (IdMiejsca) references Miejsca(Id),
foreign key (IdSeansu) references Seanse(Id)
);

CREATE TABLE IF NOT EXISTS Bilety
(
Id int AUTO_INCREMENT primary key,
IdKlienta int not null,
IdRezerwacji int not null,
foreign key (IdKlienta) references Uzytkownicy(Id),
foreign key (IdRezerwacji) references Rezerwacje(Id)
);

CREATE OR REPLACE VIEW _Seanse_ AS
SELECT Seanse.Id, Filmy.Id AS IdFilmu, Filmy.Tytul, 
Filmy.Rezyser, Filmy.Rok, Filmy.Gatunek, Filmy.Dlugosc,
Sale.Id As IdSali, Sale.NazwaSali, Seanse.DataSeansu, 
Seanse.Godzina, Seanse.Cena, Seanse.WolneMiejsca 
FROM Seanse
LEFT JOIN Filmy ON Filmy.Id=IdFilmu
LEFT JOIN Sale ON Sale.Id=IdSali;

CREATE OR REPLACE VIEW _Miejsca_ AS
SELECT Rezerwacje.Id, Filmy.Tytul, Seanse.DataSeansu, Seanse.Godzina, Seanse.Cena,
Sale.NazwaSali, Miejsca.Rzad, Miejsca.NrMiejsca, 
Rezerwacje.Zajete FROM Rezerwacje
LEFT JOIN Miejsca ON Miejsca.Id=Rezerwacje.IdMiejsca
LEFT JOIN Sale ON Sale.Id=IdSali
LEFT JOIN Seanse ON Seanse.Id=Rezerwacje.IdSeansu
LEFT JOIN Filmy ON Filmy.Id=Seanse.IdFilmu;
