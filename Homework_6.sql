--Testing the spatial equality of two geometries
select name 
FROM geometries
WHERE ST_Equals(geom,
				ST_GeometryFromText('POINT(0 0)', 4326)
)

-- True if two shapes have space in common 
SELECT *
FROM pgcensustract 
WHERE ST_Intersects(geom, 
ST_GeomFromText('POLYGON((406286 124178, 406286 125000, 416286 125000, 
416286 124178, 406286 124178))', 26985)) 

--
SELECT school_nam, ST_X(geom), ST_Y(geom), ST_SRID(geom)
FROM publicschools

--Q1: Name of school at a point 
SELECT school_nam
FROM publicschools
Where ST_Intersects(geom, 
		ST_GeomFromText(
		'POINT(413733.7123517269 145711.8991284715)',
		26985));
		
--Q2: Schools within 1km of given point 
SELECT distinct(school_nam)
FROM publicschools
Where ST_DWithin(geom, 
		ST_GeomFromText(
		'POINT(413733.7123517269 145711.8991284715)',
		26985),1000);
		
--Q3: Selecting tract from  PG Census Tract spatially including point
SELECT gid, geodesc 
FROM pgcensustract
Where ST_Contains(geom, 
		ST_GeomFromText(
		'POINT(417108 129547)',
		26985));
		
--Q4: Road segments within 5km of point 
SELECT *
FROM pgroads
Where ST_DWithin(geom, 
		ST_GeomFromText(
		'POINT(406286 124178)',
		26985),5000);
		
--Q5: Roads within 1000 meters to the school Baden 
SELECT R.fename, R.fetype
FROM pgroads as R
WHERE ST_DWithin(R.geom,
				 (select s.geom
				 FROM publicschools AS S
                 WHERE s.school_nam = 'Baden'),
1000);

--Q6: total number of schools in each census tract
SELECT C.geodesc, count(S.geodesc)
FROM pgcensustract AS C
JOIN publicschools as S
ON ST_Contains(
C.geom, S.geom)
GROUP by C.geodesc
ORDER by count DESC


--Q7:Roads, Census Tract, and School
SELECT *
FROM pgroads as R
Where ST_DWithin(R.geom,
				 
				(SELECT S.geom
				FROM publicschools as S
				INNER JOIN pgcensustract AS C
				ON ST_Contains(
				C.geom, S.geom)
				WHERE C.population > 
								(SELECT population
								FROM pgcensustract
								WHERE  ST_Contains(geom, 
										ST_GeomFromText(
										'POINT(415370.7 135801.7)',
										26985))) and S.category = 'public high school' LIMIT 1) , 100)


				 
ST_DWithin()
SELECT 
FROM pgroads as R
where fetype = 'Hwy'

 
