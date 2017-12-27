-- phpMyAdmin SQL Dump
-- version 4.7.6
-- https://www.phpmyadmin.net/
--
-- Host: db
-- Generation Time: Dec 27, 2017 at 05:36 PM
-- Server version: 5.7.20-log
-- PHP Version: 7.1.9

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `Cinema`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`%` PROCEDURE `BiletyUsera` (IN `_id` INT)  BEGIN
SELECT * FROM Bilety WHERE IdKlienta=_id;
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `DodajAdmina` (IN `_imie` VARCHAR(30), IN `_nazwisko` VARCHAR(30), IN `_login` VARCHAR(30), IN `_haslo` VARCHAR(30))  BEGIN
INSERT INTO Uzytkownicy(Imie, Nazwisko, Login, Haslo, Uprawnienia) VALUES
(_imie,_nazwisko,_login,_haslo,'1');
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `DodajFilm` (IN `_tytul` VARCHAR(30), IN `_rezyser` VARCHAR(30), IN `_rok` DATE, IN `_gatunek` VARCHAR(30), IN `_dlugosc` VARCHAR(30))  BEGIN
INSERT INTO Filmy(Tytul, Rezyser, Rok, Gatunek, Dlugosc) VALUES
(_tytul, _rezyser, _rok, _gatunek, _dlugosc);
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `DodajSale` (IN `_nazwa` VARCHAR(30), IN `_iloscMiejscWRzedzie` INT, IN `_rzedy` INT)  BEGIN

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

END$$

CREATE DEFINER=`root`@`%` PROCEDURE `DodajSeans` (IN `_idFilmu` INT, IN `_idSali` INT, IN `_dataSeansu` DATE, IN `_godzina` TIME, IN `_cena` FLOAT)  BEGIN
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

END$$

CREATE DEFINER=`root`@`%` PROCEDURE `DodajUzytkownika` (IN `_imie` VARCHAR(30), IN `_nazwisko` VARCHAR(30), IN `_login` VARCHAR(30), IN `_haslo` VARCHAR(30))  BEGIN
INSERT INTO Uzytkownicy(Imie, Nazwisko, Login, Haslo, Uprawnienia) VALUES
(_imie,_nazwisko,_login,_haslo,'2');
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `EdytujFilm` (IN `_id` INT, IN `_tytul` VARCHAR(30), IN `_rezyser` VARCHAR(30), IN `_rok` DATE, IN `_gatunek` VARCHAR(30), IN `_dlugosc` VARCHAR(30))  BEGIN
UPDATE Filmy
SET Tytul = _tytul, Rezyser = _rezyser, Rok=_rok, Gatunek=_gatunek, Dlugosc=_dlugosc
WHERE Id=_id;
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `EdytujSale` (IN `_id` INT, IN `_nazwaSali` VARCHAR(30))  BEGIN
UPDATE Sale
SET NazwaSali=_nazwaSali
WHERE Id=_id;
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `EdytujSeans` (IN `_id` INT, IN `_dataSeansu` DATE, IN `_godzina` TIME, IN `_cena` FLOAT)  BEGIN
UPDATE Seanse
SET DataSeansu=_dataSeansu, Godzina=_godzina, Cena=_cena
WHERE Id=_id;
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `KupBilet` (IN `_idKlienta` INT, IN `_idRezerwacji` INT)  BEGIN

SELECT @czyWolne:=Zajete FROM Rezerwacje WHERE Rezerwacje.Id=_idRezerwacji;

IF @czyWolne=0 THEN
INSERT INTO Bilety(IdKlienta, IdRezerwacji) VALUES (_idKlienta, _idRezerwacji);
UPDATE Rezerwacje SET Zajete=1 WHERE Rezerwacje.Id=_idRezerwacji;
UPDATE Seanse INNER JOIN Rezerwacje SET WolneMiejsca=WolneMiejsca-1 WHERE Rezerwacje.Id=_idRezerwacji AND Seanse.Id=Rezerwacje.IdSeansu;
END IF;

END$$

CREATE DEFINER=`root`@`%` PROCEDURE `SprawdzUzytkownika` (IN `_login` VARCHAR(30), IN `_haslo` VARCHAR(30))  BEGIN
SELECT * FROM Uzytkownicy
WHERE Login=_login AND Haslo=_haslo;
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `UsunFilm` (IN `_id` INT)  BEGIN

DELETE FROM Bilety
WHERE IdRezerwacji in (SELECT Rezerwacje.Id FROM Rezerwacje WHERE IdSeansu in (SELECT Seanse.Id FROM Seanse WHERE IdFilmu =_id));

DELETE FROM Rezerwacje
WHERE IdSeansu in (SELECT Seanse.Id FROM Seanse WHERE IdFilmu =_id);

DELETE FROM Seanse
WHERE IdFilmu=_id;

DELETE FROM Filmy
WHERE Id=_id;
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `UsunRezerwacje` (IN `_id` INT)  BEGIN
UPDATE Rezerwacje
SET Zajete=0
WHERE Id=_id;

UPDATE Seanse INNER JOIN Rezerwacje SET WolneMiejsca=WolneMiejsca+1 WHERE Rezerwacje.Id=_id AND Seanse.Id=Rezerwacje.IdSeansu;

DELETE FROM Bilety
WHERE IdRezerwacji=_id;

END$$

CREATE DEFINER=`root`@`%` PROCEDURE `UsunSale` (IN `_id` INT)  BEGIN
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
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `UsunSeans` (IN `_id` INT)  BEGIN
DELETE FROM Bilety
WHERE IdRezerwacji in (SELECT Rezerwacje.Id FROM Rezerwacje WHERE IdSeansu=_id);

DELETE FROM Rezerwacje
WHERE IdSeansu=_id;

DELETE FROM Seanse
WHERE Id=_id;
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `WyswietlBilet` (IN `_id` INT)  BEGIN
SELECT * FROM Bilety
WHERE Id=_id;
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `WyswietlMiejsca` (IN `_idSeansu` INT)  BEGIN
SELECT * FROM _Miejsca_
WHERE IdSeansu=_idSeansu AND Zajete=0;
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `WyswietlSeanse` (IN `_idFilmu` INT)  BEGIN
SELECT * FROM _Seanse_
WHERE IdFilmu=_idFilmu;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `Bilety`
--

CREATE TABLE `Bilety` (
  `Id` int(11) NOT NULL,
  `IdKlienta` int(11) NOT NULL,
  `IdRezerwacji` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci;

--
-- Dumping data for table `Bilety`
--

INSERT INTO `Bilety` (`Id`, `IdKlienta`, `IdRezerwacji`) VALUES
(2, 1, 885),
(3, 2, 886),
(4, 2, 887),
(5, 2, 888);

-- --------------------------------------------------------

--
-- Table structure for table `Filmy`
--

CREATE TABLE `Filmy` (
  `Id` int(11) NOT NULL,
  `Tytul` varchar(30) COLLATE utf8_polish_ci NOT NULL,
  `Rezyser` varchar(30) COLLATE utf8_polish_ci NOT NULL,
  `Rok` date NOT NULL,
  `Gatunek` varchar(30) COLLATE utf8_polish_ci NOT NULL,
  `Dlugosc` varchar(30) COLLATE utf8_polish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci;

--
-- Dumping data for table `Filmy`
--

INSERT INTO `Filmy` (`Id`, `Tytul`, `Rezyser`, `Rok`, `Gatunek`, `Dlugosc`) VALUES
(1, 'Listy do M. 3', 'Tomasz Konecki', '2017-11-10', 'komedia romantyczna', '121'),
(2, 'Najlepszy', 'Łukasz Palkowski', '2017-11-17', 'dramat', '112'),
(14, 'Vikings', 'Ciaran Donnelly', '2013-10-12', 'dramat historyczny', '45'),
(20, 'Avatar', 'James Cammeron', '2009-09-25', 'fantasy', '130'),
(21, 'Gwiezdne wojny: Ostatni Jedi', 'Rian Johnson', '2017-12-14', 'fantasy', '112');

-- --------------------------------------------------------

--
-- Table structure for table `Miejsca`
--

CREATE TABLE `Miejsca` (
  `Id` int(11) NOT NULL,
  `IdSali` int(11) NOT NULL,
  `Rzad` int(11) NOT NULL,
  `NrMiejsca` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci;

--
-- Dumping data for table `Miejsca`
--

INSERT INTO `Miejsca` (`Id`, `IdSali`, `Rzad`, `NrMiejsca`) VALUES
(1, 1, 1, 1),
(2, 1, 1, 2),
(3, 1, 1, 3),
(4, 1, 1, 4),
(5, 1, 1, 5),
(6, 1, 1, 6),
(7, 1, 1, 7),
(8, 1, 1, 8),
(9, 1, 1, 9),
(10, 1, 1, 10),
(11, 1, 1, 11),
(12, 1, 1, 12),
(13, 1, 1, 13),
(14, 1, 1, 14),
(15, 1, 1, 15),
(16, 1, 2, 16),
(17, 1, 2, 17),
(18, 1, 2, 18),
(19, 1, 2, 19),
(20, 1, 2, 20),
(21, 1, 2, 21),
(22, 1, 2, 22),
(23, 1, 2, 23),
(24, 1, 2, 24),
(25, 1, 2, 25),
(26, 1, 2, 26),
(27, 1, 2, 27),
(28, 1, 2, 28),
(29, 1, 2, 29),
(30, 1, 2, 30),
(31, 1, 3, 31),
(32, 1, 3, 32),
(33, 1, 3, 33),
(34, 1, 3, 34),
(35, 1, 3, 35),
(36, 1, 3, 36),
(37, 1, 3, 37),
(38, 1, 3, 38),
(39, 1, 3, 39),
(40, 1, 3, 40),
(41, 1, 3, 41),
(42, 1, 3, 42),
(43, 1, 3, 43),
(44, 1, 3, 44),
(45, 1, 3, 45),
(46, 1, 4, 46),
(47, 1, 4, 47),
(48, 1, 4, 48),
(49, 1, 4, 49),
(50, 1, 4, 50),
(51, 1, 4, 51),
(52, 1, 4, 52),
(53, 1, 4, 53),
(54, 1, 4, 54),
(55, 1, 4, 55),
(56, 1, 4, 56),
(57, 1, 4, 57),
(58, 1, 4, 58),
(59, 1, 4, 59),
(60, 1, 4, 60),
(61, 1, 5, 61),
(62, 1, 5, 62),
(63, 1, 5, 63),
(64, 1, 5, 64),
(65, 1, 5, 65),
(66, 1, 5, 66),
(67, 1, 5, 67),
(68, 1, 5, 68),
(69, 1, 5, 69),
(70, 1, 5, 70),
(71, 1, 5, 71),
(72, 1, 5, 72),
(73, 1, 5, 73),
(74, 1, 5, 74),
(75, 1, 5, 75),
(76, 1, 6, 76),
(77, 1, 6, 77),
(78, 1, 6, 78),
(79, 1, 6, 79),
(80, 1, 6, 80),
(81, 1, 6, 81),
(82, 1, 6, 82),
(83, 1, 6, 83),
(84, 1, 6, 84),
(85, 1, 6, 85),
(86, 1, 6, 86),
(87, 1, 6, 87),
(88, 1, 6, 88),
(89, 1, 6, 89),
(90, 1, 6, 90),
(91, 1, 7, 91),
(92, 1, 7, 92),
(93, 1, 7, 93),
(94, 1, 7, 94),
(95, 1, 7, 95),
(96, 1, 7, 96),
(97, 1, 7, 97),
(98, 1, 7, 98),
(99, 1, 7, 99),
(100, 1, 7, 100),
(101, 1, 7, 101),
(102, 1, 7, 102),
(103, 1, 7, 103),
(104, 1, 7, 104),
(105, 1, 7, 105),
(106, 1, 8, 106),
(107, 1, 8, 107),
(108, 1, 8, 108),
(109, 1, 8, 109),
(110, 1, 8, 110),
(111, 1, 8, 111),
(112, 1, 8, 112),
(113, 1, 8, 113),
(114, 1, 8, 114),
(115, 1, 8, 115),
(116, 1, 8, 116),
(117, 1, 8, 117),
(118, 1, 8, 118),
(119, 1, 8, 119),
(120, 1, 8, 120),
(121, 1, 9, 121),
(122, 1, 9, 122),
(123, 1, 9, 123),
(124, 1, 9, 124),
(125, 1, 9, 125),
(126, 1, 9, 126),
(127, 1, 9, 127),
(128, 1, 9, 128),
(129, 1, 9, 129),
(130, 1, 9, 130),
(131, 1, 9, 131),
(132, 1, 9, 132),
(133, 1, 9, 133),
(134, 1, 9, 134),
(135, 1, 9, 135),
(136, 1, 10, 136),
(137, 1, 10, 137),
(138, 1, 10, 138),
(139, 1, 10, 139),
(140, 1, 10, 140),
(141, 1, 10, 141),
(142, 1, 10, 142),
(143, 1, 10, 143),
(144, 1, 10, 144),
(145, 1, 10, 145),
(146, 1, 10, 146),
(147, 1, 10, 147),
(148, 1, 10, 148),
(149, 1, 10, 149),
(150, 1, 10, 150),
(151, 2, 1, 1),
(152, 2, 1, 2),
(153, 2, 1, 3),
(154, 2, 1, 4),
(155, 2, 1, 5),
(156, 2, 1, 6),
(157, 2, 1, 7),
(158, 2, 1, 8),
(159, 2, 1, 9),
(160, 2, 1, 10),
(161, 2, 1, 11),
(162, 2, 1, 12),
(163, 2, 1, 13),
(164, 2, 1, 14),
(165, 2, 1, 15),
(166, 2, 1, 16),
(167, 2, 1, 17),
(168, 2, 1, 18),
(169, 2, 2, 19),
(170, 2, 2, 20),
(171, 2, 2, 21),
(172, 2, 2, 22),
(173, 2, 2, 23),
(174, 2, 2, 24),
(175, 2, 2, 25),
(176, 2, 2, 26),
(177, 2, 2, 27),
(178, 2, 2, 28),
(179, 2, 2, 29),
(180, 2, 2, 30),
(181, 2, 2, 31),
(182, 2, 2, 32),
(183, 2, 2, 33),
(184, 2, 2, 34),
(185, 2, 2, 35),
(186, 2, 2, 36),
(187, 2, 3, 37),
(188, 2, 3, 38),
(189, 2, 3, 39),
(190, 2, 3, 40),
(191, 2, 3, 41),
(192, 2, 3, 42),
(193, 2, 3, 43),
(194, 2, 3, 44),
(195, 2, 3, 45),
(196, 2, 3, 46),
(197, 2, 3, 47),
(198, 2, 3, 48),
(199, 2, 3, 49),
(200, 2, 3, 50),
(201, 2, 3, 51),
(202, 2, 3, 52),
(203, 2, 3, 53),
(204, 2, 3, 54),
(205, 2, 4, 55),
(206, 2, 4, 56),
(207, 2, 4, 57),
(208, 2, 4, 58),
(209, 2, 4, 59),
(210, 2, 4, 60),
(211, 2, 4, 61),
(212, 2, 4, 62),
(213, 2, 4, 63),
(214, 2, 4, 64),
(215, 2, 4, 65),
(216, 2, 4, 66),
(217, 2, 4, 67),
(218, 2, 4, 68),
(219, 2, 4, 69),
(220, 2, 4, 70),
(221, 2, 4, 71),
(222, 2, 4, 72),
(223, 2, 5, 73),
(224, 2, 5, 74),
(225, 2, 5, 75),
(226, 2, 5, 76),
(227, 2, 5, 77),
(228, 2, 5, 78),
(229, 2, 5, 79),
(230, 2, 5, 80),
(231, 2, 5, 81),
(232, 2, 5, 82),
(233, 2, 5, 83),
(234, 2, 5, 84),
(235, 2, 5, 85),
(236, 2, 5, 86),
(237, 2, 5, 87),
(238, 2, 5, 88),
(239, 2, 5, 89),
(240, 2, 5, 90),
(241, 2, 6, 91),
(242, 2, 6, 92),
(243, 2, 6, 93),
(244, 2, 6, 94),
(245, 2, 6, 95),
(246, 2, 6, 96),
(247, 2, 6, 97),
(248, 2, 6, 98),
(249, 2, 6, 99),
(250, 2, 6, 100),
(251, 2, 6, 101),
(252, 2, 6, 102),
(253, 2, 6, 103),
(254, 2, 6, 104),
(255, 2, 6, 105),
(256, 2, 6, 106),
(257, 2, 6, 107),
(258, 2, 6, 108),
(259, 2, 7, 109),
(260, 2, 7, 110),
(261, 2, 7, 111),
(262, 2, 7, 112),
(263, 2, 7, 113),
(264, 2, 7, 114),
(265, 2, 7, 115),
(266, 2, 7, 116),
(267, 2, 7, 117),
(268, 2, 7, 118),
(269, 2, 7, 119),
(270, 2, 7, 120),
(271, 2, 7, 121),
(272, 2, 7, 122),
(273, 2, 7, 123),
(274, 2, 7, 124),
(275, 2, 7, 125),
(276, 2, 7, 126),
(277, 2, 8, 127),
(278, 2, 8, 128),
(279, 2, 8, 129),
(280, 2, 8, 130),
(281, 2, 8, 131),
(282, 2, 8, 132),
(283, 2, 8, 133),
(284, 2, 8, 134),
(285, 2, 8, 135),
(286, 2, 8, 136),
(287, 2, 8, 137),
(288, 2, 8, 138),
(289, 2, 8, 139),
(290, 2, 8, 140),
(291, 2, 8, 141),
(292, 2, 8, 142),
(293, 2, 8, 143),
(294, 2, 8, 144),
(295, 2, 9, 145),
(296, 2, 9, 146),
(297, 2, 9, 147),
(298, 2, 9, 148),
(299, 2, 9, 149),
(300, 2, 9, 150),
(301, 2, 9, 151),
(302, 2, 9, 152),
(303, 2, 9, 153),
(304, 2, 9, 154),
(305, 2, 9, 155),
(306, 2, 9, 156),
(307, 2, 9, 157),
(308, 2, 9, 158),
(309, 2, 9, 159),
(310, 2, 9, 160),
(311, 2, 9, 161),
(312, 2, 9, 162),
(313, 2, 10, 163),
(314, 2, 10, 164),
(315, 2, 10, 165),
(316, 2, 10, 166),
(317, 2, 10, 167),
(318, 2, 10, 168),
(319, 2, 10, 169),
(320, 2, 10, 170),
(321, 2, 10, 171),
(322, 2, 10, 172),
(323, 2, 10, 173),
(324, 2, 10, 174),
(325, 2, 10, 175),
(326, 2, 10, 176),
(327, 2, 10, 177),
(328, 2, 10, 178),
(329, 2, 10, 179),
(330, 2, 10, 180),
(331, 2, 11, 181),
(332, 2, 11, 182),
(333, 2, 11, 183),
(334, 2, 11, 184),
(335, 2, 11, 185),
(336, 2, 11, 186),
(337, 2, 11, 187),
(338, 2, 11, 188),
(339, 2, 11, 189),
(340, 2, 11, 190),
(341, 2, 11, 191),
(342, 2, 11, 192),
(343, 2, 11, 193),
(344, 2, 11, 194),
(345, 2, 11, 195),
(346, 2, 11, 196),
(347, 2, 11, 197),
(348, 2, 11, 198),
(349, 2, 12, 199),
(350, 2, 12, 200),
(351, 2, 12, 201),
(352, 2, 12, 202),
(353, 2, 12, 203),
(354, 2, 12, 204),
(355, 2, 12, 205),
(356, 2, 12, 206),
(357, 2, 12, 207),
(358, 2, 12, 208),
(359, 2, 12, 209),
(360, 2, 12, 210),
(361, 2, 12, 211),
(362, 2, 12, 212),
(363, 2, 12, 213),
(364, 2, 12, 214),
(365, 2, 12, 215),
(366, 2, 12, 216),
(382, 4, 1, 1),
(383, 4, 1, 2),
(384, 4, 1, 3),
(385, 4, 1, 4),
(386, 4, 1, 5),
(387, 4, 1, 6),
(388, 4, 1, 7),
(389, 4, 1, 8),
(390, 4, 2, 9),
(391, 4, 2, 10),
(392, 4, 2, 11),
(393, 4, 2, 12),
(394, 4, 2, 13),
(395, 4, 2, 14),
(396, 4, 2, 15),
(397, 4, 2, 16),
(398, 4, 3, 17),
(399, 4, 3, 18),
(400, 4, 3, 19),
(401, 4, 3, 20),
(402, 4, 3, 21),
(403, 4, 3, 22),
(404, 4, 3, 23),
(405, 4, 3, 24),
(406, 4, 4, 25),
(407, 4, 4, 26),
(408, 4, 4, 27),
(409, 4, 4, 28),
(410, 4, 4, 29),
(411, 4, 4, 30),
(412, 4, 4, 31),
(413, 4, 4, 32),
(414, 4, 5, 33),
(415, 4, 5, 34),
(416, 4, 5, 35),
(417, 4, 5, 36),
(418, 4, 5, 37),
(419, 4, 5, 38),
(420, 4, 5, 39),
(421, 4, 5, 40),
(422, 4, 6, 41),
(423, 4, 6, 42),
(424, 4, 6, 43),
(425, 4, 6, 44),
(426, 4, 6, 45),
(427, 4, 6, 46),
(428, 4, 6, 47),
(429, 4, 6, 48),
(430, 4, 7, 49),
(431, 4, 7, 50),
(432, 4, 7, 51),
(433, 4, 7, 52),
(434, 4, 7, 53),
(435, 4, 7, 54),
(436, 4, 7, 55),
(437, 4, 7, 56),
(438, 4, 8, 57),
(439, 4, 8, 58),
(440, 4, 8, 59),
(441, 4, 8, 60),
(442, 4, 8, 61),
(443, 4, 8, 62),
(444, 4, 8, 63),
(445, 4, 8, 64);

-- --------------------------------------------------------

--
-- Table structure for table `Rezerwacje`
--

CREATE TABLE `Rezerwacje` (
  `Id` int(11) NOT NULL,
  `IdMiejsca` int(11) NOT NULL,
  `IdSeansu` int(11) NOT NULL,
  `Zajete` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci;

--
-- Dumping data for table `Rezerwacje`
--

INSERT INTO `Rezerwacje` (`Id`, `IdMiejsca`, `IdSeansu`, `Zajete`) VALUES
(885, 1, 7, 1),
(886, 2, 7, 1),
(887, 3, 7, 1),
(888, 4, 7, 1),
(889, 5, 7, 0),
(890, 6, 7, 0),
(891, 7, 7, 0),
(892, 8, 7, 0),
(893, 9, 7, 0),
(894, 10, 7, 0),
(895, 11, 7, 0),
(896, 12, 7, 0),
(897, 13, 7, 0),
(898, 14, 7, 0),
(899, 15, 7, 0),
(900, 16, 7, 0),
(901, 17, 7, 0),
(902, 18, 7, 0),
(903, 19, 7, 0),
(904, 20, 7, 0),
(905, 21, 7, 0),
(906, 22, 7, 0),
(907, 23, 7, 0),
(908, 24, 7, 0),
(909, 25, 7, 0),
(910, 26, 7, 0),
(911, 27, 7, 0),
(912, 28, 7, 0),
(913, 29, 7, 0),
(914, 30, 7, 0),
(915, 31, 7, 0),
(916, 32, 7, 0),
(917, 33, 7, 0),
(918, 34, 7, 0),
(919, 35, 7, 0),
(920, 36, 7, 0),
(921, 37, 7, 0),
(922, 38, 7, 0),
(923, 39, 7, 0),
(924, 40, 7, 0),
(925, 41, 7, 0),
(926, 42, 7, 0),
(927, 43, 7, 0),
(928, 44, 7, 0),
(929, 45, 7, 0),
(930, 46, 7, 0),
(931, 47, 7, 0),
(932, 48, 7, 0),
(933, 49, 7, 0),
(934, 50, 7, 0),
(935, 51, 7, 0),
(936, 52, 7, 0),
(937, 53, 7, 0),
(938, 54, 7, 0),
(939, 55, 7, 0),
(940, 56, 7, 0),
(941, 57, 7, 0),
(942, 58, 7, 0),
(943, 59, 7, 0),
(944, 60, 7, 0),
(945, 61, 7, 0),
(946, 62, 7, 0),
(947, 63, 7, 0),
(948, 64, 7, 0),
(949, 65, 7, 0),
(950, 66, 7, 0),
(951, 67, 7, 0),
(952, 68, 7, 0),
(953, 69, 7, 0),
(954, 70, 7, 0),
(955, 71, 7, 0),
(956, 72, 7, 0),
(957, 73, 7, 0),
(958, 74, 7, 0),
(959, 75, 7, 0),
(960, 76, 7, 0),
(961, 77, 7, 0),
(962, 78, 7, 0),
(963, 79, 7, 0),
(964, 80, 7, 0),
(965, 81, 7, 0),
(966, 82, 7, 0),
(967, 83, 7, 0),
(968, 84, 7, 0),
(969, 85, 7, 0),
(970, 86, 7, 0),
(971, 87, 7, 0),
(972, 88, 7, 0),
(973, 89, 7, 0),
(974, 90, 7, 0),
(975, 91, 7, 0),
(976, 92, 7, 0),
(977, 93, 7, 0),
(978, 94, 7, 0),
(979, 95, 7, 0),
(980, 96, 7, 0),
(981, 97, 7, 0),
(982, 98, 7, 0),
(983, 99, 7, 0),
(984, 100, 7, 0),
(985, 101, 7, 0),
(986, 102, 7, 0),
(987, 103, 7, 0),
(988, 104, 7, 0),
(989, 105, 7, 0),
(990, 106, 7, 0),
(991, 107, 7, 0),
(992, 108, 7, 0),
(993, 109, 7, 0),
(994, 110, 7, 0),
(995, 111, 7, 0),
(996, 112, 7, 0),
(997, 113, 7, 0),
(998, 114, 7, 0),
(999, 115, 7, 0),
(1000, 116, 7, 0),
(1001, 117, 7, 0),
(1002, 118, 7, 0),
(1003, 119, 7, 0),
(1004, 120, 7, 0),
(1005, 121, 7, 0),
(1006, 122, 7, 0),
(1007, 123, 7, 0),
(1008, 124, 7, 0),
(1009, 125, 7, 0),
(1010, 126, 7, 0),
(1011, 127, 7, 0),
(1012, 128, 7, 0),
(1013, 129, 7, 0),
(1014, 130, 7, 0),
(1015, 131, 7, 0),
(1016, 132, 7, 0),
(1017, 133, 7, 0),
(1018, 134, 7, 0),
(1019, 135, 7, 0),
(1020, 136, 7, 0),
(1021, 137, 7, 0),
(1022, 138, 7, 0),
(1023, 139, 7, 0),
(1024, 140, 7, 0),
(1025, 141, 7, 0),
(1026, 142, 7, 0),
(1027, 143, 7, 0),
(1028, 144, 7, 0),
(1029, 145, 7, 0),
(1030, 146, 7, 0),
(1031, 147, 7, 0),
(1032, 148, 7, 0),
(1033, 149, 7, 0),
(1034, 150, 7, 0),
(1035, 1, 8, 0),
(1036, 2, 8, 0),
(1037, 3, 8, 0),
(1038, 4, 8, 0),
(1039, 5, 8, 0),
(1040, 6, 8, 0),
(1041, 7, 8, 0),
(1042, 8, 8, 0),
(1043, 9, 8, 0),
(1044, 10, 8, 0),
(1045, 11, 8, 0),
(1046, 12, 8, 0),
(1047, 13, 8, 0),
(1048, 14, 8, 0),
(1049, 15, 8, 0),
(1050, 16, 8, 0),
(1051, 17, 8, 0),
(1052, 18, 8, 0),
(1053, 19, 8, 0),
(1054, 20, 8, 0),
(1055, 21, 8, 0),
(1056, 22, 8, 0),
(1057, 23, 8, 0),
(1058, 24, 8, 0),
(1059, 25, 8, 0),
(1060, 26, 8, 0),
(1061, 27, 8, 0),
(1062, 28, 8, 0),
(1063, 29, 8, 0),
(1064, 30, 8, 0),
(1065, 31, 8, 0),
(1066, 32, 8, 0),
(1067, 33, 8, 0),
(1068, 34, 8, 0),
(1069, 35, 8, 0),
(1070, 36, 8, 0),
(1071, 37, 8, 0),
(1072, 38, 8, 0),
(1073, 39, 8, 0),
(1074, 40, 8, 0),
(1075, 41, 8, 0),
(1076, 42, 8, 0),
(1077, 43, 8, 0),
(1078, 44, 8, 0),
(1079, 45, 8, 0),
(1080, 46, 8, 0),
(1081, 47, 8, 0),
(1082, 48, 8, 0),
(1083, 49, 8, 0),
(1084, 50, 8, 0),
(1085, 51, 8, 0),
(1086, 52, 8, 0),
(1087, 53, 8, 0),
(1088, 54, 8, 0),
(1089, 55, 8, 0),
(1090, 56, 8, 0),
(1091, 57, 8, 0),
(1092, 58, 8, 0),
(1093, 59, 8, 0),
(1094, 60, 8, 0),
(1095, 61, 8, 0),
(1096, 62, 8, 0),
(1097, 63, 8, 0),
(1098, 64, 8, 0),
(1099, 65, 8, 0),
(1100, 66, 8, 0),
(1101, 67, 8, 0),
(1102, 68, 8, 0),
(1103, 69, 8, 0),
(1104, 70, 8, 0),
(1105, 71, 8, 0),
(1106, 72, 8, 0),
(1107, 73, 8, 0),
(1108, 74, 8, 0),
(1109, 75, 8, 0),
(1110, 76, 8, 0),
(1111, 77, 8, 0),
(1112, 78, 8, 0),
(1113, 79, 8, 0),
(1114, 80, 8, 0),
(1115, 81, 8, 0),
(1116, 82, 8, 0),
(1117, 83, 8, 0),
(1118, 84, 8, 0),
(1119, 85, 8, 0),
(1120, 86, 8, 0),
(1121, 87, 8, 0),
(1122, 88, 8, 0),
(1123, 89, 8, 0),
(1124, 90, 8, 0),
(1125, 91, 8, 0),
(1126, 92, 8, 0),
(1127, 93, 8, 0),
(1128, 94, 8, 0),
(1129, 95, 8, 0),
(1130, 96, 8, 0),
(1131, 97, 8, 0),
(1132, 98, 8, 0),
(1133, 99, 8, 0),
(1134, 100, 8, 0),
(1135, 101, 8, 0),
(1136, 102, 8, 0),
(1137, 103, 8, 0),
(1138, 104, 8, 0),
(1139, 105, 8, 0),
(1140, 106, 8, 0),
(1141, 107, 8, 0),
(1142, 108, 8, 0),
(1143, 109, 8, 0),
(1144, 110, 8, 0),
(1145, 111, 8, 0),
(1146, 112, 8, 0),
(1147, 113, 8, 0),
(1148, 114, 8, 0),
(1149, 115, 8, 0),
(1150, 116, 8, 0),
(1151, 117, 8, 0),
(1152, 118, 8, 0),
(1153, 119, 8, 0),
(1154, 120, 8, 0),
(1155, 121, 8, 0),
(1156, 122, 8, 0),
(1157, 123, 8, 0),
(1158, 124, 8, 0),
(1159, 125, 8, 0),
(1160, 126, 8, 0),
(1161, 127, 8, 0),
(1162, 128, 8, 0),
(1163, 129, 8, 0),
(1164, 130, 8, 0),
(1165, 131, 8, 0),
(1166, 132, 8, 0),
(1167, 133, 8, 0),
(1168, 134, 8, 0),
(1169, 135, 8, 0),
(1170, 136, 8, 0),
(1171, 137, 8, 0),
(1172, 138, 8, 0),
(1173, 139, 8, 0),
(1174, 140, 8, 0),
(1175, 141, 8, 0),
(1176, 142, 8, 0),
(1177, 143, 8, 0),
(1178, 144, 8, 0),
(1179, 145, 8, 0),
(1180, 146, 8, 0),
(1181, 147, 8, 0),
(1182, 148, 8, 0),
(1183, 149, 8, 0),
(1184, 150, 8, 0),
(1401, 1, 10, 0),
(1402, 2, 10, 0),
(1403, 3, 10, 0),
(1404, 4, 10, 0),
(1405, 5, 10, 0),
(1406, 6, 10, 0),
(1407, 7, 10, 0),
(1408, 8, 10, 0),
(1409, 9, 10, 0),
(1410, 10, 10, 0),
(1411, 11, 10, 0),
(1412, 12, 10, 0),
(1413, 13, 10, 0),
(1414, 14, 10, 0),
(1415, 15, 10, 0),
(1416, 16, 10, 0),
(1417, 17, 10, 0),
(1418, 18, 10, 0),
(1419, 19, 10, 0),
(1420, 20, 10, 0),
(1421, 21, 10, 0),
(1422, 22, 10, 0),
(1423, 23, 10, 0),
(1424, 24, 10, 0),
(1425, 25, 10, 0),
(1426, 26, 10, 0),
(1427, 27, 10, 0),
(1428, 28, 10, 0),
(1429, 29, 10, 0),
(1430, 30, 10, 0),
(1431, 31, 10, 0),
(1432, 32, 10, 0),
(1433, 33, 10, 0),
(1434, 34, 10, 0),
(1435, 35, 10, 0),
(1436, 36, 10, 0),
(1437, 37, 10, 0),
(1438, 38, 10, 0),
(1439, 39, 10, 0),
(1440, 40, 10, 0),
(1441, 41, 10, 0),
(1442, 42, 10, 0),
(1443, 43, 10, 0),
(1444, 44, 10, 0),
(1445, 45, 10, 0),
(1446, 46, 10, 0),
(1447, 47, 10, 0),
(1448, 48, 10, 0),
(1449, 49, 10, 0),
(1450, 50, 10, 0),
(1451, 51, 10, 0),
(1452, 52, 10, 0),
(1453, 53, 10, 0),
(1454, 54, 10, 0),
(1455, 55, 10, 0),
(1456, 56, 10, 0),
(1457, 57, 10, 0),
(1458, 58, 10, 0),
(1459, 59, 10, 0),
(1460, 60, 10, 0),
(1461, 61, 10, 0),
(1462, 62, 10, 0),
(1463, 63, 10, 0),
(1464, 64, 10, 0),
(1465, 65, 10, 0),
(1466, 66, 10, 0),
(1467, 67, 10, 0),
(1468, 68, 10, 0),
(1469, 69, 10, 0),
(1470, 70, 10, 0),
(1471, 71, 10, 0),
(1472, 72, 10, 0),
(1473, 73, 10, 0),
(1474, 74, 10, 0),
(1475, 75, 10, 0),
(1476, 76, 10, 0),
(1477, 77, 10, 0),
(1478, 78, 10, 0),
(1479, 79, 10, 0),
(1480, 80, 10, 0),
(1481, 81, 10, 0),
(1482, 82, 10, 0),
(1483, 83, 10, 0),
(1484, 84, 10, 0),
(1485, 85, 10, 0),
(1486, 86, 10, 0),
(1487, 87, 10, 0),
(1488, 88, 10, 0),
(1489, 89, 10, 0),
(1490, 90, 10, 0),
(1491, 91, 10, 0),
(1492, 92, 10, 0),
(1493, 93, 10, 0),
(1494, 94, 10, 0),
(1495, 95, 10, 0),
(1496, 96, 10, 0),
(1497, 97, 10, 0),
(1498, 98, 10, 0),
(1499, 99, 10, 0),
(1500, 100, 10, 0),
(1501, 101, 10, 0),
(1502, 102, 10, 0),
(1503, 103, 10, 0),
(1504, 104, 10, 0),
(1505, 105, 10, 0),
(1506, 106, 10, 0),
(1507, 107, 10, 0),
(1508, 108, 10, 0),
(1509, 109, 10, 0),
(1510, 110, 10, 0),
(1511, 111, 10, 0),
(1512, 112, 10, 0),
(1513, 113, 10, 0),
(1514, 114, 10, 0),
(1515, 115, 10, 0),
(1516, 116, 10, 0),
(1517, 117, 10, 0),
(1518, 118, 10, 0),
(1519, 119, 10, 0),
(1520, 120, 10, 0),
(1521, 121, 10, 0),
(1522, 122, 10, 0),
(1523, 123, 10, 0),
(1524, 124, 10, 0),
(1525, 125, 10, 0),
(1526, 126, 10, 0),
(1527, 127, 10, 0),
(1528, 128, 10, 0),
(1529, 129, 10, 0),
(1530, 130, 10, 0),
(1531, 131, 10, 0),
(1532, 132, 10, 0),
(1533, 133, 10, 0),
(1534, 134, 10, 0),
(1535, 135, 10, 0),
(1536, 136, 10, 0),
(1537, 137, 10, 0),
(1538, 138, 10, 0),
(1539, 139, 10, 0),
(1540, 140, 10, 0),
(1541, 141, 10, 0),
(1542, 142, 10, 0),
(1543, 143, 10, 0),
(1544, 144, 10, 0),
(1545, 145, 10, 0),
(1546, 146, 10, 0),
(1547, 147, 10, 0),
(1548, 148, 10, 0),
(1549, 149, 10, 0),
(1550, 150, 10, 0),
(1551, 151, 10, 0),
(1552, 152, 10, 0),
(1553, 153, 10, 0),
(1554, 154, 10, 0),
(1555, 155, 10, 0),
(1556, 156, 10, 0),
(1557, 157, 10, 0),
(1558, 158, 10, 0),
(1559, 159, 10, 0),
(1560, 160, 10, 0),
(1561, 161, 10, 0),
(1562, 162, 10, 0),
(1563, 163, 10, 0),
(1564, 164, 10, 0),
(1565, 165, 10, 0),
(1566, 166, 10, 0),
(1567, 167, 10, 0),
(1568, 168, 10, 0),
(1569, 169, 10, 0),
(1570, 170, 10, 0),
(1571, 171, 10, 0),
(1572, 172, 10, 0),
(1573, 173, 10, 0),
(1574, 174, 10, 0),
(1575, 175, 10, 0),
(1576, 176, 10, 0),
(1577, 177, 10, 0),
(1578, 178, 10, 0),
(1579, 179, 10, 0),
(1580, 180, 10, 0),
(1581, 181, 10, 0),
(1582, 182, 10, 0),
(1583, 183, 10, 0),
(1584, 184, 10, 0),
(1585, 185, 10, 0),
(1586, 186, 10, 0),
(1587, 187, 10, 0),
(1588, 188, 10, 0),
(1589, 189, 10, 0),
(1590, 190, 10, 0),
(1591, 191, 10, 0),
(1592, 192, 10, 0),
(1593, 193, 10, 0),
(1594, 194, 10, 0),
(1595, 195, 10, 0),
(1596, 196, 10, 0),
(1597, 197, 10, 0),
(1598, 198, 10, 0),
(1599, 199, 10, 0),
(1600, 200, 10, 0),
(1601, 201, 10, 0),
(1602, 202, 10, 0),
(1603, 203, 10, 0),
(1604, 204, 10, 0),
(1605, 205, 10, 0),
(1606, 206, 10, 0),
(1607, 207, 10, 0),
(1608, 208, 10, 0),
(1609, 209, 10, 0),
(1610, 210, 10, 0),
(1611, 211, 10, 0),
(1612, 212, 10, 0),
(1613, 213, 10, 0),
(1614, 214, 10, 0),
(1615, 215, 10, 0),
(1616, 216, 10, 0);

-- --------------------------------------------------------

--
-- Table structure for table `Sale`
--

CREATE TABLE `Sale` (
  `Id` int(11) NOT NULL,
  `NazwaSali` varchar(30) COLLATE utf8_polish_ci NOT NULL,
  `Pojemnosc` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci;

--
-- Dumping data for table `Sale`
--

INSERT INTO `Sale` (`Id`, `NazwaSali`, `Pojemnosc`) VALUES
(1, 'A1', 150),
(2, 'A2', 216),
(4, 'VIP', 64);

-- --------------------------------------------------------

--
-- Table structure for table `Seanse`
--

CREATE TABLE `Seanse` (
  `Id` int(11) NOT NULL,
  `IdFilmu` int(11) NOT NULL,
  `IdSali` int(11) NOT NULL,
  `DataSeansu` date NOT NULL,
  `Godzina` time NOT NULL,
  `Cena` float NOT NULL,
  `WolneMiejsca` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci;

--
-- Dumping data for table `Seanse`
--

INSERT INTO `Seanse` (`Id`, `IdFilmu`, `IdSali`, `DataSeansu`, `Godzina`, `Cena`, `WolneMiejsca`) VALUES
(7, 1, 1, '2018-01-05', '18:30:00', 22, 146),
(8, 1, 1, '2018-01-06', '20:30:00', 25, 150),
(10, 14, 2, '2017-12-09', '18:30:00', 20, 216);

-- --------------------------------------------------------

--
-- Table structure for table `Uprawnienia`
--

CREATE TABLE `Uprawnienia` (
  `Id` int(11) NOT NULL,
  `Nazwa` varchar(30) COLLATE utf8_polish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci;

--
-- Dumping data for table `Uprawnienia`
--

INSERT INTO `Uprawnienia` (`Id`, `Nazwa`) VALUES
(1, 'Administrator'),
(2, 'Uzytkownik');

-- --------------------------------------------------------

--
-- Table structure for table `Uzytkownicy`
--

CREATE TABLE `Uzytkownicy` (
  `Id` int(11) NOT NULL,
  `Imie` varchar(30) COLLATE utf8_polish_ci NOT NULL,
  `Nazwisko` varchar(30) COLLATE utf8_polish_ci NOT NULL,
  `Login` varchar(30) COLLATE utf8_polish_ci NOT NULL,
  `Haslo` varchar(30) COLLATE utf8_polish_ci NOT NULL,
  `Uprawnienia` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci;

--
-- Dumping data for table `Uzytkownicy`
--

INSERT INTO `Uzytkownicy` (`Id`, `Imie`, `Nazwisko`, `Login`, `Haslo`, `Uprawnienia`) VALUES
(1, 'Radosław', 'Taborski', 'rado', '1111', 2),
(2, 'Piotr', 'Konieczny', 'piru', '2222', 2),
(3, 'Gal', 'Anonim', 'Anoymous', 'zaszyfrowane', 2),
(4, 'Radosław', 'Taborski', 'admin1', '123456', 1),
(5, 'Piru', 'Konieczny', 'piruBoss', 'boss', 2),
(6, 'Anna', 'Kowalska', 'akowalska', '222', 2),
(7, 'Kamil', 'Włodarczyk', 'wlodar', '444', 2),
(8, 'Krzysztof', 'Taborski', 'belmondo', '333', 2);

-- --------------------------------------------------------

--
-- Stand-in structure for view `_Miejsca_`
-- (See below for the actual view)
--
CREATE TABLE `_Miejsca_` (
`Id` int(11)
,`Tytul` varchar(30)
,`DataSeansu` date
,`Godzina` time
,`Cena` float
,`NazwaSali` varchar(30)
,`Rzad` int(11)
,`NrMiejsca` int(11)
,`Zajete` tinyint(1)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `_Seanse_`
-- (See below for the actual view)
--
CREATE TABLE `_Seanse_` (
`Id` int(11)
,`IdFilmu` int(11)
,`Tytul` varchar(30)
,`Rezyser` varchar(30)
,`Rok` date
,`Gatunek` varchar(30)
,`Dlugosc` varchar(30)
,`IdSali` int(11)
,`NazwaSali` varchar(30)
,`DataSeansu` date
,`Godzina` time
,`Cena` float
,`WolneMiejsca` int(11)
);

-- --------------------------------------------------------

--
-- Structure for view `_Miejsca_`
--
DROP TABLE IF EXISTS `_Miejsca_`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `_Miejsca_`  AS  select `Rezerwacje`.`Id` AS `Id`,`Filmy`.`Tytul` AS `Tytul`,`Seanse`.`DataSeansu` AS `DataSeansu`,`Seanse`.`Godzina` AS `Godzina`,`Seanse`.`Cena` AS `Cena`,`Sale`.`NazwaSali` AS `NazwaSali`,`Miejsca`.`Rzad` AS `Rzad`,`Miejsca`.`NrMiejsca` AS `NrMiejsca`,`Rezerwacje`.`Zajete` AS `Zajete` from ((((`Rezerwacje` left join `Miejsca` on((`Miejsca`.`Id` = `Rezerwacje`.`IdMiejsca`))) left join `Sale` on((`Sale`.`Id` = `Miejsca`.`IdSali`))) left join `Seanse` on((`Seanse`.`Id` = `Rezerwacje`.`IdSeansu`))) left join `Filmy` on((`Filmy`.`Id` = `Seanse`.`IdFilmu`))) ;

-- --------------------------------------------------------

--
-- Structure for view `_Seanse_`
--
DROP TABLE IF EXISTS `_Seanse_`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `_Seanse_`  AS  select `Seanse`.`Id` AS `Id`,`Filmy`.`Id` AS `IdFilmu`,`Filmy`.`Tytul` AS `Tytul`,`Filmy`.`Rezyser` AS `Rezyser`,`Filmy`.`Rok` AS `Rok`,`Filmy`.`Gatunek` AS `Gatunek`,`Filmy`.`Dlugosc` AS `Dlugosc`,`Sale`.`Id` AS `IdSali`,`Sale`.`NazwaSali` AS `NazwaSali`,`Seanse`.`DataSeansu` AS `DataSeansu`,`Seanse`.`Godzina` AS `Godzina`,`Seanse`.`Cena` AS `Cena`,`Seanse`.`WolneMiejsca` AS `WolneMiejsca` from ((`Seanse` left join `Filmy` on((`Filmy`.`Id` = `Seanse`.`IdFilmu`))) left join `Sale` on((`Sale`.`Id` = `Seanse`.`IdSali`))) ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `Bilety`
--
ALTER TABLE `Bilety`
  ADD PRIMARY KEY (`Id`),
  ADD KEY `IdKlienta` (`IdKlienta`),
  ADD KEY `IdRezerwacji` (`IdRezerwacji`);

--
-- Indexes for table `Filmy`
--
ALTER TABLE `Filmy`
  ADD PRIMARY KEY (`Id`);

--
-- Indexes for table `Miejsca`
--
ALTER TABLE `Miejsca`
  ADD PRIMARY KEY (`Id`),
  ADD KEY `IdSali` (`IdSali`);

--
-- Indexes for table `Rezerwacje`
--
ALTER TABLE `Rezerwacje`
  ADD PRIMARY KEY (`Id`),
  ADD KEY `IdMiejsca` (`IdMiejsca`),
  ADD KEY `IdSeansu` (`IdSeansu`);

--
-- Indexes for table `Sale`
--
ALTER TABLE `Sale`
  ADD PRIMARY KEY (`Id`),
  ADD UNIQUE KEY `NazwaSali` (`NazwaSali`);

--
-- Indexes for table `Seanse`
--
ALTER TABLE `Seanse`
  ADD PRIMARY KEY (`Id`),
  ADD KEY `IdFilmu` (`IdFilmu`),
  ADD KEY `IdSali` (`IdSali`);

--
-- Indexes for table `Uprawnienia`
--
ALTER TABLE `Uprawnienia`
  ADD PRIMARY KEY (`Id`),
  ADD UNIQUE KEY `Nazwa` (`Nazwa`);

--
-- Indexes for table `Uzytkownicy`
--
ALTER TABLE `Uzytkownicy`
  ADD PRIMARY KEY (`Id`),
  ADD UNIQUE KEY `Login` (`Login`),
  ADD KEY `Uprawnienia` (`Uprawnienia`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `Bilety`
--
ALTER TABLE `Bilety`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `Filmy`
--
ALTER TABLE `Filmy`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `Miejsca`
--
ALTER TABLE `Miejsca`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=446;

--
-- AUTO_INCREMENT for table `Rezerwacje`
--
ALTER TABLE `Rezerwacje`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1632;

--
-- AUTO_INCREMENT for table `Sale`
--
ALTER TABLE `Sale`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `Seanse`
--
ALTER TABLE `Seanse`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `Uprawnienia`
--
ALTER TABLE `Uprawnienia`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `Uzytkownicy`
--
ALTER TABLE `Uzytkownicy`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `Bilety`
--
ALTER TABLE `Bilety`
  ADD CONSTRAINT `Bilety_ibfk_1` FOREIGN KEY (`IdKlienta`) REFERENCES `Uzytkownicy` (`Id`),
  ADD CONSTRAINT `Bilety_ibfk_2` FOREIGN KEY (`IdRezerwacji`) REFERENCES `Rezerwacje` (`Id`);

--
-- Constraints for table `Miejsca`
--
ALTER TABLE `Miejsca`
  ADD CONSTRAINT `Miejsca_ibfk_1` FOREIGN KEY (`IdSali`) REFERENCES `Sale` (`Id`);

--
-- Constraints for table `Rezerwacje`
--
ALTER TABLE `Rezerwacje`
  ADD CONSTRAINT `Rezerwacje_ibfk_1` FOREIGN KEY (`IdMiejsca`) REFERENCES `Miejsca` (`Id`),
  ADD CONSTRAINT `Rezerwacje_ibfk_2` FOREIGN KEY (`IdSeansu`) REFERENCES `Seanse` (`Id`);

--
-- Constraints for table `Seanse`
--
ALTER TABLE `Seanse`
  ADD CONSTRAINT `Seanse_ibfk_1` FOREIGN KEY (`IdFilmu`) REFERENCES `Filmy` (`Id`),
  ADD CONSTRAINT `Seanse_ibfk_2` FOREIGN KEY (`IdSali`) REFERENCES `Sale` (`Id`);

--
-- Constraints for table `Uzytkownicy`
--
ALTER TABLE `Uzytkownicy`
  ADD CONSTRAINT `Uzytkownicy_ibfk_1` FOREIGN KEY (`Uprawnienia`) REFERENCES `Uprawnienia` (`Id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
