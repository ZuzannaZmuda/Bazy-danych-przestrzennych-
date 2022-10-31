--EXERCISE 1
SELECT Y2019.polygon_id
FROM t2018_kar_buildings Y2018, t2019_kar_buildings Y2019
WHERE Y2018.polygon_id = Y2019.polygon_id 
AND ST_Equals(Y2018.geom, Y2019.geom) = false

--EXERCISE 2

--V1
SELECT COUNT(*), POI.type 
FROM t2018_kar_buildings Y2018, t2019_kar_buildings Y2019, t2019_kar_poi_table POI
WHERE Y2018.polygon_id = Y2019.polygon_id 
AND ST_Equals(Y2018.geom, Y2019.geom) = false 
AND ST_DWITHIN(GEOGRAPHY(Y2019.geom), GEOGRAPHY(ST_SETSRID(POI.geom,4326)), 500)
GROUP BY POI.type;

--V2
SELECT COUNT(*), POI.type 
FROM t2018_kar_buildings Y2018, t2019_kar_buildings Y2019, t2019_kar_poi_table POI
WHERE Y2018.polygon_id = Y2019.polygon_id 
AND ST_Equals(Y2018.geom, Y2019.geom) = false 
AND ST_DISTANCESPHERE(Y2019.geom, POI.geom) <= 500
GROUP BY POI.type;

--EXERCISE 3

--UPDATE t2019_kar_streets
--SET geom = st_setsrid(geom, 4326)
--CREATE TABLE street_reprojected AS SELECT * FROM t2019_kar_streets
--UPDATE street_reprojected
--SET geom = st_setsrid(geom, 4326)
--UPDATE street_reprojected
--SET geom = st_transform(geom, 3068)

--SELECT * FROM streets_reprojected


CREATE TABLE streets_reprojected (
	gid serial4,
	link_id float,
	st_name varchar(254),
	ref_in_id float,
	nref_in_id float,
	func_class varchar(1),
	speed_cat varchar(1),
	fr_speed_l float,
	to_speed_l float,
	dir_travel varchar(1),
	geom geometry 

);


INSERT INTO streets_reprojected 
SELECT gid, link_id, st_name, ref_in_id, nref_in_id, func_class, speed_cat, fr_speed_l, to_speed_l, dir_travel, st_transform(st_setsrid(geom, 4326), 3068) 
FROM t2019_kar_streets

SELECT * FROM streets_reprojected

--EXERCISE 4
CREATE TABLE input_points(id INT, geom GEOMETRY);
INSERT INTO input_points VALUES
  (1, ST_GeomFromText('POINT(8.36093 49.03174)', 4326)),
  (2, ST_GeomFromText('POINT(8.39876 49.00644)', 4326));

--EXERCISE 5
UPDATE input_points
SET geom = ST_TRANSFORM(ST_SETSRID(geom, 4326), 3068);

SELECT ST_AsText(geom) FROM input_points

--EXERCISE 6
SELECT * FROM T2019_KAR_STREET_NODE

CREATE TABLE t2019_kar_street_node2 (
	gid serial4,
	node_id float,
	link_id float,
	point_num int,
	z_level int,
	"intersect" varchar(1),
	lat decimal,
	lon decimal,
	geom geometry 

);


INSERT INTO t2019_kar_street_node2 
SELECT gid, node_id, link_id, point_num, z_level, "intersect", lat, lon, geom
FROM T2019_KAR_STREET_NODE

SELECT * FROM T2019_KAR_STREET_NODE
SELECT * FROM t2019_kar_street_node2 

UPDATE t2019_kar_street_node2 
SET geom = st_transform(st_setsrid(geom, 4326), 3068);

CREATE TABLE Lines AS 
SELECT ST_MAKELINE(point1.geom, point2.geom)
FROM input_points point1, input_points point2
WHERE point1.id = 1 
AND point2.id = 2
	
SELECT * FROM Lines

SELECT gid, st_makeline 
FROM t2019_kar_street_node2, lines 
WHERE ST_DISTANCE(t2019_kar_street_node2.geom, lines.st_makeline) <= 200;


--EXERCISE 7 
--checking name of parks in this database
SELECT t2019_kar_land_use_a.type, 
COUNT(*) FROM t2019_kar_land_use_a  
GROUP BY t2019_kar_land_use_a.type

SELECT * FROM t2019_kar_poi_table poi
SELECT COUNT (DISTINCT poi.gid) 
FROM t2019_kar_land_use_a park, t2019_kar_poi_table poi
WHERE park.type = 'Park (City/County)' 
AND poi.type = 'Sporting Goods Store' 
AND st_distance(park.geom, poi.geom) <= 300
   

--EXERCISE 8
CREATE TABLE T2019_KAR_BRIDGES(gid serial4, geom geometry);
UPDATE T2019_KAR_BRIDGES
SET geom = ST_SETSRID(geom, 4326)

UPDATE t2019_kar_water_lines
SET geom = ST_SETSRID(geom, 4326)
UPDATE t2019_kar_railways
SET geom = ST_SETSRID(geom, 4326)

INSERT INTO T2019_KAR_BRIDGES(geom)
SELECT ST_INTERSECTION(waterLines.geom, Railways.geom) 
FROM t2019_kar_water_lines waterLines, t2019_kar_railways Railways
WHERE ST_INTERSECTS(waterLines.geom, Railways.geom) = true;

SELECT * FROM T2019_KAR_BRIDGES