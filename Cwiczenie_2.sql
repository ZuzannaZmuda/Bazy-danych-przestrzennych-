--extension
CREATE EXTENSION postgis;
--test
SELECT * FROM airports;

--1
--data preview
SELECT * FROM popp;
SELECT * FROM majrivers;

--exercise1
CREATE TABLE TableB AS
SELECT COUNT (DISTINCT popp.gid) AS numberOfBuildings
FROM popp, majrivers 
WHERE popp.f_codedesc = 'Building' AND ST_Intersects(ST_Buffer(majrivers.geom, 1000), popp.geom);
SELECT * FROM TableB

--or v2
CREATE TABLE TableB2 AS
SELECT COUNT(DISTINCT popp.gid) AS nbofBuildings
FROM majrivers, popp 
WHERE (popp.f_codedesc = 'Building') AND (ST_Distance(majrivers.geom, popp.geom) < 1000);

SELECT * FROM TableB2;

--exercise2
--data preview
SELECT * FROM airports;

CREATE TABLE airportsNew AS
SELECT name, geom, elev 
FROM airports;

SELECT * FROM airportsNew

SELECT name AS West, ST_Y(geom) AS  coords
FROM airportsNew
ORDER BY coords ASC 
LIMIT 1;

SELECT name AS East, ST_Y(geom) AS coords  
FROM airportsNew ORDER BY coords DESC 
LIMIT 1;

INSERT INTO airportsNew VALUES ('airportB', (SELECT ST_Centroid
											 (ST_ShortestLine(
												 (SELECT geom 
												  FROM airportsNew 
												  WHERE name = 'NIKOLSKI AS'),
												 (SELECT geom 
												  FROM airportsNew 
												  WHERE name = 'NOATAK')))), 880);

SELECT name, ST_AsText(geom), elev from airportsNew
ORDER BY name ASC
LIMIT 1;

--exercise 3
--data preview
SELECT * FROM lakes;
SELECT * FROM airports;

SELECT ST_Area(
		ST_Buffer(
			ST_ShortestLine(
				(SELECT geom FROM lakes WHERE names = 'Iliamna Lake'),
				(SELECT geom FROM airports WHERE name = 'AMBLER')),1000)) 
					AS area;
--exercise 4
--data preview
SELECT * FROM tundra;
SELECT * FROM swamp;
SELECT * FROM trees;

SELECT (SUM(tundra.area_km2)+SUM(swamp.areakm2)) AS area ,trees.vegdesc trees_species 
FROM  tundra, trees, swamp 
WHERE tundra.area_km2 IN (SELECT tundra.area_km2 
FROM tundra, trees 
WHERE ST_Contains(trees.geom,tundra.geom) = 'true') AND swamp.areakm2  IN (SELECT swamp.areakm2 
FROM swamp, trees 
WHERE ST_Contains(trees.geom,swamp.geom) = 'true') 
GROUP BY trees.vegdesc

