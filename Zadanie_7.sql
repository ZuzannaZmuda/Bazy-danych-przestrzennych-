CREATE EXTENSION postgis;
CREATE EXTENSION postgis_raster;

--ex 1
-- raster2pgsql.exe -s 27700 -N -32767 -t 100x100 -I -C -M -d "/Users/zuziak/Desktop/AGH/Semestr 5 AGH/Bazy Danych Przestrzennych/*.tif" uk_250k | psql -U postgres -d cw7 -h localhost -p 5432

--ex2
SELECT * FROM rasters.uk_250k;
  
--ex3
CREATE TABLE mozaika AS SELECT ST_Union(rastry.rast)
FROM rasters.uk_250k AS rastry

--ex5

SELECT * FROM national_parks;


--ex6

CREATE TABLE uk_lake_district AS 
SELECT ST_Union(ST_Clip(a.rast, b.geom, true)) AS rast
FROM uk_250k AS a, national_parks AS b
WHERE ST_Intersects(a.rast, b.geom) AND b.id = '1';

SELECT * FROM uk_lake_district;

--ex7

CREATE TABLE tmp_out AS
SELECT lo_from_bytea(0,
ST_AsGDALRaster(ST_Union(rast), 'GTiff', ARRAY['COMPRESS=DEFLATE',
'PREDICTOR=2', 'PZLEVEL=9'])
) AS loid
FROM uk_lake_district;

SELECT lo_export(loid, '/Users/zuziak/Desktop/AGH/Semestr 5 AGH/Bazy Danych Przestrzennych/uk_lake_district.tiff')
FROM tmp_out;


--ex8
-- raster2pgsql -s 32630 -N -32767 -t 128x128 -I -C -M -d "/Users/zuziak/Desktop/AGH/Semestr 5 AGH/Bazy Danych Przestrzennych/*.jp2" sentinel2_B03 | psql -d cwiczenia7 -h localhost -U postgres -p 5432
-- raster2pgsql -s 32630 -N -32767 -t 128x128 -I -C -M -d "/Users/zuziak/Desktop/AGH/Semestr 5 AGH/Bazy Danych Przestrzennych/*.jp2" sentinel2_B08 | psql -d cwiczenia7 -h localhost -U postgres -p 5432

SELECT * FROM SENTINEL_03;
SELECT * FROM SENTINEL_08;


--ex9/10
WITH raster1 AS (
(SELECT ST_Union(ST_Clip(a.rast, ST_Transform(b.geom, 32630), true)) AS rast
FROM SENTINEL_03 AS a, national_parks AS b
WHERE ST_Intersects(a.rast, ST_Transform(b.geom, 32630)) AND b.id = 1))
,
raster2 AS (
(SELECT ST_Union(ST_Clip(a.rast, ST_Transform(b.geom, 32630), true)) AS rast
FROM SENTINEL_08 AS a, national_parks AS b
WHERE ST_Intersects(a.rast, ST_Transform(b.geom, 32630)) AND b.id = 1))

SELECT ST_MapAlgebra(raster2.rast, raster2.rast, '([rast1.val]-[rast2.val])/([rast1.val]+[rast2.val])::float', '32BF') AS rast
INTO lakeNDVI FROM raster2, raster2;

CREATE INDEX idxLakeNDVI ON lakeNDVI
USING gist(ST_ConvexHull(rast));

SELECT AddRasterConstraints('public'::name, 'lakeNDVI'::name, 'rast'::name);

--ex11

CREATE TABLE tmp_out AS
SELECT lo_from_bytea(0,
       ST_AsGDALRaster(ST_Union(rast), 'GTiff',  ARRAY['COMPRESS=DEFLATE', 'PREDICTOR=2', 'PZLEVEL=9'])
        ) AS loid
FROM rasters.sentinelNDVI;

