CREATE SCHEMA Ksiegowosc; 

	CREATE TABLE Ksiegowosc.Pracownicy
	(
		id_pracownika INT PRIMARY KEY,
		imie VARCHAR(80) NOT NULL,
		nazwisko VARCHAR(80) NOT NULL,
		adres VARCHAR(80) NOT NULL,
		telefon VARCHAR(15) NULL
	);
	
	CREATE TABLE Ksiegowosc.Godziny
	(
		id_godziny INT PRIMARY KEY,
		data DATE NOT NULL,
		liczba_godzin INT NOT NULL,
		id_pracownika INT NOT NULL
	);
	
	CREATE TABLE Ksiegowosc.Pensja
	(
		id_pensji INT PRIMARY KEY,
		stanowisko VARCHAR(80) NOT NULL,
		kwota MONEY NOT NULL
	);
	
	CREATE TABLE Ksiegowosc.Premia
	(
		id_premii INT PRIMARY KEY,
		rodzaj VARCHAR(80) NOT NULL,
		kwota MONEY NOT NULL
	);
	
	CREATE TABLE Ksiegowosc.Wynagrodzenie
	(
		id_wynagrodzenia INT PRIMARY KEY,
		data DATE NOT NULL,
		id_pracownika INT NOT NULL,
		id_godziny INT NOT NULL,
		id_pensji INT NOT NULL,
		id_premii INT
	);
	
	ALTER TABLE Ksiegowosc.Godziny
	ADD FOREIGN KEY (id_pracownika) 
	REFERENCES Ksiegowosc.Pracownicy(id_pracownika);
	
	ALTER TABLE Ksiegowosc.Wynagrodzenie
	ADD FOREIGN KEY (id_pracownika) 
	REFERENCES Ksiegowosc.Pracownicy(id_pracownika);
	
	ALTER TABLE Ksiegowosc.Wynagrodzenie
	ADD FOREIGN KEY (id_godziny) 
	REFERENCES Ksiegowosc.Godziny(id_godziny);
	
	ALTER TABLE Ksiegowosc.Wynagrodzenie
	ADD FOREIGN KEY (id_pensji) 
	REFERENCES Ksiegowosc.Pensja(id_pensji);
	
	ALTER TABLE Ksiegowosc.Wynagrodzenie
	ADD FOREIGN KEY (id_premii) 
	REFERENCES Ksiegowosc.Premia(id_premii);
	
	INSERT INTO Ksiegowosc.Pracownicy VALUES
	(1, 'Aleksandra', 'Nowak', 'ul.Kwiatowa 2, 32-043, Krakow', '721 543 621'),
	(2, 'Piotr', 'Kowalski', 'ul.Basztowa 14, 31-026, Krakow', '711 513 611'),
	(3, 'Magdalena', 'Bury', 'ul.Oliwkowa 1, 32-013, Krakow', NULL),
	(4, 'Weronika', 'Kowal', 'ul.Jagodowa 54, 31-021, Krakow', '631 543 644'),
	(5, 'Tomasz', 'Kamiński', 'ul.Włoska 16, 30-043, Krakow', '766 123 111'),
	(6, 'Paweł', 'Wiśniewski', 'ul.Laurowa 16, 30-023, Krakow', NULL),
	(7, 'Anna', 'Lewandowska', 'ul.Akacjowa 5, 35-143, Krakow', '722 113 142'),
	(8, 'Karolina', 'Kowalczyk', 'ul.Warszawska 11, 31-021, Krakow', '546 133 311'),
	(9, 'Michał', 'Brzoza', 'ul.Wierzbowa 23, 33-123, Krakow', '726 323 431'),
	(10, 'Iwona', 'Szymańska', 'ul.Włoska 16, 30-043, Krakow', '656 423 5421')
	;
	
	INSERT INTO Ksiegowosc.Godziny VALUES
	(1, '2022-03-12', '100', 1),
	(2, '2022-03-12', '180', 3),
	(3, '2022-03-13', '140', 10),
	(4, '2022-03-13', '80', 8),
	(5, '2022-03-14', '300', 5),
	(6, '2022-03-14', '220', 6),
	(7, '2022-03-14', '170', 9),
	(8, '2022-03-15', '161', 7),
	(9, '2022-03-15', '160', 4),
	(10, '2022-03-16', '130', 2)
	;
	
	INSERT INTO Ksiegowosc.Premia VALUES
	(1, 'Zadaniowa', '500'),
	(2, 'Motywacyjna', '100'),
	(3, 'Zadaniowa', '500'),
	(4, 'Uznaniowa', '200'),
	(5, 'Motywacyjna', '100'),
	(6, 'Wynikowa', '1000'),
	(7, 'Zadaniowa', '500'),
	(8, 'Wynikowa', '1500'),
	(9, 'Wynikowa', '1000'),
	(10, 'Uznaniowa', '200')
	;
	
	INSERT INTO Ksiegowosc.Pensja VALUES
	(1, 'Project Manager', '14000'),
	(2, 'Software Engineer', '10000'),
	(3, 'UX Designer', '8000'),
	(4, 'Senior DevOps Engineer', '30000'),
	(5, 'Scrum Master', '9500'),
	(6, 'Product Owner', '17000'),
	(7, 'Project Manager', '25000'),
	(8, 'Data Analyst', '17000'),
	(9, 'Data Analyst', '15000'),
	(10, 'UX Designer Intern', '3500')
	;
	 
	 INSERT INTO Ksiegowosc.Wynagrodzenie VALUES
	(1, '2022-04-16', 1, 1, 3, NULL),
	(2, '2022-04-16', 2, 10, 4, 1),
	(3, '2022-04-16', 3, 2, 1, NULL),
	(4, '2022-04-16', 4, 9, 2, NULL),
	(5, '2022-04-16', 5, 5, 5, 2),
	(6, '2022-04-16', 6, 6, 7, NULL),
	(7, '2022-04-16', 7, 8, 9, 10),
	(8, '2022-04-17', 8, 4, 8, NULL),
	(9, '2022-04-17', 9, 7, 10, 7),
	(10, '2022-04-17', 10, 3, 6, NULL)
	;
	
	--a)
	SELECT id_pracownika, nazwisko
	FROM Ksiegowosc.Pracownicy
	
	--b)
	SELECT Pracownicy.id_pracownika
	FROM Ksiegowosc.Pracownicy
	INNER JOIN Ksiegowosc.Wynagrodzenie on Pracownicy.id_pracownika = Wynagrodzenie.id_pracownika
	INNER JOIN Ksiegowosc.Pensja on Wynagrodzenie.id_pensji = Pensja.id_pensji
	WHERE Pensja.Kwota > cast(29000 AS MONEY)
	
	--c)
	SELECT Pracownicy.id_pracownika
	FROM Ksiegowosc.Pracownicy
	INNER JOIN Ksiegowosc.Wynagrodzenie on Pracownicy.id_pracownika = Wynagrodzenie.id_pracownika
	INNER JOIN Ksiegowosc.Pensja on Wynagrodzenie.id_pensji = Pensja.id_pensji
	INNER JOIN Ksiegowosc.Premia on Wynagrodzenie.id_premii = Premia.id_premii 
	WHERE Pensja.Kwota > cast(2000 AS MONEY) AND Premia.Kwota IS NULL
	
	--d)
	SELECT  imie
	FROM Ksiegowosc.Pracownicy 
	WHERE imie LIKE 'J%'
	
	--e)
	SELECT  id_pracownika, imie, nazwisko
	FROM Ksiegowosc.Pracownicy 
	WHERE nazwisko LIKE '%n%' AND nazwisko LIKE '%a'
	
	--f) 
	ALTER TABLE ksiegowosc.godziny ADD liczba_nadgodzin INT;
	UPDATE ksiegowosc.godziny SET liczba_nadgodzin = liczba_godzin-160
	WHERE ksiegowosc.godziny.liczba_godzin > 160;
	
	SELECT Pracownicy.imie, Pracownicy.nazwisko, Godziny.liczba_nadgodzin 
	FROM Ksiegowosc.Pracownicy
	INNER JOIN Ksiegowosc.Wynagrodzenie on Pracownicy.id_pracownika = Wynagrodzenie.id_pracownika
	INNER JOIN Ksiegowosc.Godziny on Wynagrodzenie.id_godziny = Godziny.id_godziny
	
	--g)
	SELECT Pracownicy.imie, Pracownicy.nazwisko, Pensja.kwota
	FROM Ksiegowosc.Pracownicy
	INNER JOIN Ksiegowosc.Wynagrodzenie on Pracownicy.id_pracownika = Wynagrodzenie.id_pracownika
	INNER JOIN Ksiegowosc.Pensja on Wynagrodzenie.id_pensji = Pensja.id_pensji
	WHERE Pensja.Kwota BETWEEN cast(18000 AS MONEY) AND cast(30000 AS MONEY) 
	
	--h) NIESKONCZONE
	ALTER TABLE ksiegowosc.godziny ADD liczba_nadgodzin INT;
	UPDATE ksiegowosc.godziny SET liczba_nadgodzin = liczba_godzin-160
	WHERE ksiegowosc.godziny.liczba_godzin > 160;
	
	SELECT Pracownicy.imie, Pracownicy.nazwisko, Godziny.liczba_nadgodzin 
	FROM Ksiegowosc.Pracownicy
	INNER JOIN Ksiegowosc.Wynagrodzenie on Pracownicy.id_pracownika = Wynagrodzenie.id_pracownika
	INNER JOIN Ksiegowosc.Godziny on Wynagrodzenie.id_godziny = Godziny.id_godziny
	INNER JOIN Ksiegowosc.Premia on Wynagrodzenie.id_premii = Premia.id_premii 
	WHERE (Godziny.liczba_nadgodzin IS NOT NULL) AND Premia.Kwota IS NULL
	
	
	--i)
	SELECT Pracownicy.imie, Pracownicy.nazwisko, Pensja.kwota
	FROM Ksiegowosc.Pracownicy
	INNER JOIN Ksiegowosc.Wynagrodzenie on Pracownicy.id_pracownika = Wynagrodzenie.id_pracownika
	INNER JOIN Ksiegowosc.Pensja on Wynagrodzenie.id_pensji = Pensja.id_pensji
	ORDER BY Pensja.Kwota
	
	--j)
	SELECT Pracownicy.imie, Pracownicy.nazwisko, Pensja.kwota, Premia.kwota
	FROM Ksiegowosc.Pracownicy
	INNER JOIN Ksiegowosc.Wynagrodzenie on Pracownicy.id_pracownika = Wynagrodzenie.id_pracownika
	INNER JOIN Ksiegowosc.Pensja on Wynagrodzenie.id_pensji = Pensja.id_pensji
	INNER JOIN Ksiegowosc.Premia on Wynagrodzenie.id_premii = Premia.id_premii 
	ORDER BY Pensja.Kwota, Premia.Kwota DESC
	
	--k)
	SELECT Pensja.Stanowisko, COUNT(Pensja.stanowisko)
	FROM Ksiegowosc.Pracownicy
	INNER JOIN Ksiegowosc.Wynagrodzenie on Pracownicy.id_pracownika = Wynagrodzenie.id_pracownika
	INNER JOIN Ksiegowosc.Pensja on Wynagrodzenie.id_pensji = Pensja.id_pensji
	GROUP BY Pensja.stanowisko
	
	--l) 
	SELECT Pensja.Stanowisko, MIN(Pensja.kwota) AS placa_minimalna, MAX(Pensja.kwota) AS placa_maksymalna, AVG(Pensja.kwota::numeric) AS srednia_placa
	FROM Ksiegowosc.Pracownicy
	INNER JOIN Ksiegowosc.Wynagrodzenie on Pracownicy.id_pracownika = Wynagrodzenie.id_pracownika
	INNER JOIN Ksiegowosc.Pensja on Wynagrodzenie.id_pensji = Pensja.id_pensji
	GROUP BY Pensja.Stanowisko
	
	--m)
	SELECT SUM(Pensja.kwota) AS Suma_wszystkich_wynagrodzen
	FROM Ksiegowosc.Pracownicy
	INNER JOIN Ksiegowosc.Wynagrodzenie on Pracownicy.id_pracownika = Wynagrodzenie.id_pracownika
	INNER JOIN Ksiegowosc.Pensja on Wynagrodzenie.id_pensji = Pensja.id_pensji
																											   
	--n)																										   
	SELECT Pensja.Stanowisko, SUM(Pensja.kwota) AS Suma_wszystkich_wynagrodzen
	FROM Ksiegowosc.Pracownicy 
	INNER JOIN Ksiegowosc.Wynagrodzenie on Pracownicy.id_pracownika = Wynagrodzenie.id_pracownika
	INNER JOIN Ksiegowosc.Pensja on Wynagrodzenie.id_pensji = Pensja.id_pensji
	GROUP BY Pensja.Stanowisko
																											   
	--o)
	SELECT Pensja.Stanowisko, SUM(Pensja.kwota) AS Suma_wszystkich_wynagrodzen, COUNT(Premia.id_premii) AS liczba_premii_danego_stanowiska
	FROM Ksiegowosc.Pracownicy 
	INNER JOIN Ksiegowosc.Wynagrodzenie on Pracownicy.id_pracownika = Wynagrodzenie.id_pracownika
	INNER JOIN Ksiegowosc.Pensja on Wynagrodzenie.id_pensji = Pensja.id_pensji
	INNER JOIN Ksiegowosc.Premia on Wynagrodzenie.id_premii = Premia.id_premii															
	GROUP BY Pensja.Stanowisko
																											   
	--p)
	DELETE 
	FROM Ksiegowosc.Pracownicy 
	USING Ksiegowosc.Wynagrodzenie, Ksiegowosc.Pensja
	WHERE Wynagrodzenie.id_pracownika = Pracownicy.id_pracownika AND Wynagrodzenie.id_pensji = Pensja.id_pensji AND kwota < cast(1200 AS money);																										   
																											   

																											   
