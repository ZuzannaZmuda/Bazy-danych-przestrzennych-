--notes
--POINT(x y)
--LINESTRING(x1 y1, x2 y2)
--POLYGON((x1 y1, x2 y2, x3 y3, x4 y4, x1 y1))

CREATE EXTENSION postgis;
CREATE TABLE roads(id INT, name VARCHAR(50), geom GEOMETRY);
CREATE TABLE points(id INT, name VARCHAR(50), geom GEOMETRY);
CREATE TABLE buildings(id INT, name VARCHAR(50), geom GEOMETRY);
CREATE TABLE bufor(id INT, name VARCHAR(50), geom GEOMETRY);




INSERT INTO points VALUES
  (1,'PointG', ST_GeomFromText('POINT(1 3.5)', 0)),
  (2,'PointH', ST_GeomFromText('POINT(5.5 1.5)', 0)),
  (3,'PointI', ST_GeomFromText('POINT(9.5 6)', 0)),
  (4,'PointJ', ST_GeomFromText('POINT(6.5 6)', 0)),
  (5,'PointK', ST_GeomFromText('POINT(6 9.5)', 0));
  
INSERT INTO roads VALUES
  (1, 'RoadX', ST_GeomFromText('LINESTRING(0 4.5, 12 4.5)', 0)),
  (2, 'RoadY', ST_GeomFromText('LINESTRING(7.5 10.5, 7.5 0)', 0));
  
INSERT INTO buildings VALUES
  (1, 'BuildingA', ST_GeomFromText('POLYGON((8 4, 10.5 4, 10.5 1.5, 8 1.5, 8 4))', 0)),
  (2, 'BuildingB', ST_GeomFromText('POLYGON((4 7 , 6 7, 6 5, 4 5, 4 7))', 0)),
  (3, 'BuildingC', ST_GeomFromText('POLYGON((3 8 , 5 8, 5 6, 3 6, 3 8))', 0)),
  (4, 'BuildingD', ST_GeomFromText('POLYGON((9 9 , 10 9, 10 8, 9 8, 9 9))', 0)),
  (5, 'BuildingF', ST_GeomFromText('POLYGON((1 2 , 2 2, 2 1, 1 1, 1 2))', 0));
  
--1
--SELECT * FROM roads;
SELECT *, ST_AsText(roads.geom) AS WKT FROM roads;
SELECT SUM(ST_Length(geom)) AS totalLength FROM roads;

--2
SELECT ST_Area(buildings.geom) AS Area, ST_PERIMETER(buildings.geom) AS Perimeter 
FROM buildings
WHERE name='BuildingA';

--3
SELECT name AS Nazwy, ST_Area(buildings.geom) AS Area 
FROM buildings
ORDER BY Nazwy;

--4
SELECT name AS Nazwy, ST_PERIMETER(buildings.geom) AS Perimeter
FROM buildings
ORDER BY Perimeter desc
LIMIT 2;

--5

SELECT ST_Distance(
		ST_GeomFromText('POINT(1 3.5)', 0),
		ST_GeomFromText('POLYGON((3 8 , 5 8, 5 6, 3 6, 3 8))', 0)
	);

--6

SELECT ST_Area(ST_DIFFERENCE('POLYGON((3 8 , 5 8, 5 6, 3 6, 3 8))', ST_Buffer('POLYGON((4 7 , 6 7, 6 5, 4 5, 4 7))', 0.5)))


--7


SELECT name
FROM buildings 
WHERE ST_Y(ST_Centroid(buildings.geom)) > ST_Y(ST_Centroid('LINESTRING(0 4.5, 12 4.5)'))
ORDER BY buildings.name ASC;



--8
CREATE TABLE buforr AS SELECT geom FROM buildings WHERE name='BuildingC';
SELECT ST_Area(ST_Difference(geom, ST_GeomFromText('POLYGON((4 7, 6 7, 6 8, 4 8, 4 7))', 0))) AS wynik FROM buforr;