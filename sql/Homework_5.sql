CREATE EXTENSION postgis; 
CREATE EXTENSION postgis_topology;

select updateGeometrySRID('pgcensustract','geom', 26985);
select st_srid(geom) from pgcensustract;

select updateGeometrySRID('publicschools','geom', 26985);
select st_srid(geom) from publicschools;

select updateGeometrySRID('pgroads','geom', 26985);
select st_srid(geom) from pgroads; 

SELECT * 
FROM publicschools;

--Q1
SELECT COUNT(school_nam) 
FROM publicschools;

--Q2
SELECT school_nam, city, category 
FROM publicschools
WHERE city = 'Laurel'
Order by school_nam ASC;

--Q3
SELECT school_nam, street, city, zip 
FROM publicschools
WHERE street like '% Oxon Hill Road';

--Q4
SELECT city, count(city) AS school_count
FROM publicschools
GROUP by city;

--Q5
SELECT *
FROM publicschools
WHERE category = 'public elementary sch' and zip != '20744'

SELECT *
FROM publicschools
WHERE CITY = 'Laurel'

--Q6: road that includes 11407 Queen Anne Ave (Note: Address does not exist in pgroads table)
SELECT *
FROM pgroads
WHERE fename ='Queen Anne' and fetype = 'Ave' and
(TOADDL = '11407' or  FRADDL = '11407' or FRADDR = '11407' or TOADDR = '11407');

SELECT *
FROM pgroads
WHERE fename ='Queen Anne' and 
(TOADDL = '11407' or  FRADDL = '11407' or FRADDR = '11407' or TOADDR = '11407');


(TOADDL = '11407' or FRADDL = '11407')
(FRADDR = '11407' or TOADDR = '11407')
(TOADDL = '11407' or FRADDL = '11407');

--Q7: road(s) that intersect with Prairie Ct
SELECT * 
from pgroads
where FNODE = ANY(
   SELECT FNODE
   FROM pgroads
   WHERE fename = 'Prairie' and fetype = 'Ct');
   
 --Q8: Select longest road
SELECT * 
from pgroads
where length = (
   SELECT MAX (length)
   FROM pgroads); 
   
 --Q9: Select shortest road
SELECT * 
from pgroads
where length = (
   SELECT MIN (length)
   FROM pgroads); 
   
 --Q10: Select roads that intersect with the shortest road
SELECT * 
from pgroads
where FNODE = ANY(
	SELECT FNODE 
	from pgroads
	where length = (
	   SELECT MIN (length)
	   FROM pgroads))
	   OR
TNODE = ANY(
	SELECT TNODE 
	from pgroads
	where length = (
	   SELECT MIN (length)
	   FROM pgroads)); 

--Q11: Total length of Local, neighborhood, rural road, and city streets
SELECT SUM (length) AS total_ln
FROM pgroads
where cfcc = 'A41' OR cfcc = 'A45';

SELECT *
FROM pgcensustract;

--Q12: Population of Laurel HS
SELECT population
FROM publicschools as pgs
INNER JOIN pgcensustract AS pgc
ON pgc.geodesc = pgs.geodesc
WHERE city = 'Laurel' and category = 'public high school'

--Q13:Todal Population by zipcode
SELECT sum(population)
FROM publicschools as pgs
INNER JOIN pgcensustract AS pgc
ON pgc.geodesc = pgs.geodesc
WHERE zip = '20737' 

--Q14: total road length of each CFCC category
SELECT pgroads.cfcc, sum(pgroads.length) AS group_len
from pgroads
GROUP BY cfcc
ORDER BY group_len DESC;

--Q15: Removing public schools table from DB
DELETE FROM publicschools

--Q16: Removing roads that are not A41
DELETE FROM pgroads 
WHERE cfcc != 'A41';

DELETE FROM geometries;

CREATE table geometries (name varchar, geom geometry);
INSERT INTO geometries vALUES
('Point', 'POINT(0 0)'),
('Linestring', 'LINESTRING (0 0, 1 1, 2 1, 2 2)'),
('PolygonWithHole', 'POLYGON((0 0, 10 0, 10 10, 0 10, 0 0),(1 1, 1 2, 2 2, 2 1, 1 1))'),
('Collection', 'GEOMETRYCOLLECTION(POINT(2 0),POLYGON((0 0, 1 0, 1 1, 0 1, 0 0)))');
 
SELECT st_srid(geom) FROM geometries;
SELECT updateGeometrySRID('geometries','geom',4326);

-- Defining geometry of linestring as text
SELECT ST_AsText(ST_GeometryFromText('LINESTRING(0 0 0,1 0 0,1 1 2)', 4326));


--Q1
CREATE table geom (name varchar, geom geometry);
INSERT INTO geom vALUES
('Point', 'POINT(10 8)'),
('Linestring', 'LINESTRING (0 0, 5 5, 7 7, 2 2)'),
('Polygon', 'POLYGON((1 1, 1 5, 1 8, 2 2, 1 1))');

SELECT ST_AsText(geom) 
FROM geom

SELECT name, ST_AsText(geom) FROM geometries;
SELECT name, ST_GeometryType(geom), ST_NDims(geom), ST_SRID(geom) FROM geometries;

--Q2: PG Roads
SELECT ST_GeometryType(geom), ST_NDims(geom), ST_SRID(geom)
FROM pgroads;

-- PG Census Tract
SELECT ST_GeometryType(geom), ST_NDims(geom), ST_SRID(geom)
FROM pgcensustract;

--PUBLIC SCHOOLS
SELECT school_nam, ST_GeometryType(geom), ST_NDims(geom), ST_SRID(geom)
FROM publicschools;

SELECT ST_AsText(geom) FROM geometries WHERE name = 'Point';
SELECT ST_X(geom), ST_Y(geom) FROM geometries WHERE name = 'Point';

--Q3: School (X, Y)
SELECT school_nam, ST_X(geom), ST_Y(geom)
FROM publicschools

SELECT *
FROM pgroads

--Q4: Road length by name
SELECT fename, ST_Length(geom)
FROM pgroads
WHERE fename = 'Fenno'

SELECT *
FROM publicschools

--Q5:Census Tract Vertex (Text)
SELECT ST_NPoints(geom), ST_AsText(geom)
FROM pgcensustract


--Q6: PG Census Tract(Area, Geometry) 
SELECT GEODESC, ST_Perimeter(geom), ST_Area(geom)
FROM pgcensustract
WHERE GEODESC = '8004.02';

--Q7: Identifying collection type and reporting number of parts
--Collecion Type: Multipoint
SELECT ST_GeometryType(geom), ST_NumGeometries(geom)
FROM pgcensustract;

--Collecion Type: MultiLineString
SELECT ST_GeometryType(geom), ST_NumGeometries(geom)
FROM pgroads;

FROM geometries WHERE name = 'Point';
