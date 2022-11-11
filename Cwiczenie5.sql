CREATE EXTENSION Postgis;
CREATE TABLE obiekty(idObiektu SERIAL, nazwa VARCHAR(20), geom geometry);

--exercise 1
INSERT INTO obiekty (nazwa, geom)
VALUES ('obiekt1', ST_Collect(ARRAY['LINESTRING(0 1, 1 1)', 'CIRCULARSTRING(1 1, 2 0, 3 1)',
                   'CIRCULARSTRING(3 1, 4 2, 5 1)', 'LINESTRING(5 1, 6 1)']));

--Display ex1
SELECT * FROM obiekty 
WHERE nazwa = 'obiekt1' 

--exercise 2
INSERT INTO obiekty (nazwa, geom)
VALUES ('obiekt2', ST_Collect(ARRAY['LINESTRING(10 6, 14 6)', 'CIRCULARSTRING(14 6, 16 4, 14 2)',
                   'CIRCULARSTRING(14 2, 12 0, 10 2)', 'LINESTRING(10 2, 10 6)',
                   ST_Buffer(ST_MakePoint(12, 2), 1)]));

--Display ex2
SELECT * FROM obiekty 
WHERE nazwa = 'obiekt2' 
				   
--exercise 3				   
INSERT INTO obiekty (nazwa, geom)
VALUES ('obiekt3', 'POLYGON((10 17, 12 13, 7 15, 10 17))');

--Display ex3
SELECT * FROM obiekty 
WHERE nazwa = 'obiekt3' 


--Exercise 4
INSERT INTO obiekty (nazwa, geom)
VALUES ('obiekt4', 'LINESTRING(20 20, 25 25, 27 24, 25 22, 26 21, 22 19, 20.5 19.5)');

--Display ex 4
SELECT * FROM obiekty 
WHERE nazwa = 'obiekt4' 

--Exercise 5
INSERT INTO obiekty (nazwa, geom)
VALUES ('obiekt5', 'MULTIPOINT(30 30 59, 38 32 234)');

--Display ex5
SELECT * FROM obiekty 
WHERE nazwa = 'obiekt5' 

--Exercise 6
INSERT INTO obiekty (nazwa, geom)
VALUES ('obiekt6', ST_Collect('LINESTRING(1 1, 3 2)', 'POINT(4 2)'));

--Display ex6
SELECT * FROM obiekty 
WHERE nazwa = 'obiekt6' 


--EX1
SELECT ST_Area(ST_buffer(ST_ShortestLine(a.geom,b.geom),5))
FROM obiekty a, obiekty b
WHERE a.nazwa='obiekt3' and b.nazwa='obiekt4';

--EX2

UPDATE obiekty SET geom = ST_MakePolygon(ST_AddPoint(geom, 'POINT(20 20)')) WHERE nazwa = 'obiekt4';

--EX3
INSERT INTO obiekty (nazwa, geom)
VALUES ('obiekt7', ST_Collect((SELECT geom FROM obiekty WHERE nazwa='obiekt3'), (SELECT geom FROM obiekty WHERE nazwa='obiekt4')));

--EX4
SELECT SUM(ST_Area(ST_Buffer(geom, 5))) FROM obiekty WHERE ST_HasArc(geom) = FALSE;