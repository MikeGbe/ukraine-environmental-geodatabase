CREATE TABLE categories (category_code varchar PRIMARY KEY, category varchar);

CREATE TABLE businesses (id integer PRIMARY KEY, business varchar, year_founded integer, category_code varchar, country_code char(3));

CREATE TABLE countries (country_code varchar PRIMARY KEY, country varchar,
continent varchar);

/*Select the oldest and newest founding years from the businesses table */
SELECT MIN(year_founded), MAX(year_founded) FROM businesses;

/*Get the count of rows in businesses where the founding year was before 1000*/
SELECT COUNT(*)
FROM businesses
WHERE year_founded < 1000;


/*Select rows in businesses where the founding year was before 1000*/
SELECT *
FROM businesses
WHERE year_founded < 1000
ORDER BY year_founded;

-- Exploring catagories table
SELECT *
FROM categories;

-- Exploring countries table
SELECT *
FROM countries;

/*  
-- Select business name, founding year, and country code from businesses; and category from categories
-- where the founding year was before 1000, arranged from oldest to newest */
SELECT bus.business, bus.year_founded, bus.country_code, cat.category
FROM businesses AS bus
INNER JOIN categories AS cat
ON bus.category_code = cat.category_code
WHERE year_founded < 1000
ORDER BY year_founded;


SELECT *
FROM businesses;

-- Select the category and count of category (as "n")
SELECT bus.category_code, COUNT(bus.category_code) AS n
FROM businesses AS bus
GROUP BY bus.category_code ORDER BY n DESC LIMIT 10;


-- Select the category and count of category (as "n")
-- arranged by descending count, limited to 10 most common categories
SELECT cat.category, COUNT(cat.category) AS n
FROM businesses AS bus
INNER JOIN categories AS cat
ON bus.category_code = cat.category_code
GROUP BY cat.category ORDER BY n DESC LIMIT 10;

-- Select the oldest founding year (as "oldest") from businesses,
-- and continent from countries
-- for each continent, ordered from oldest to newest
SELECT MIN(bus.year_founded) as oldest, cnt.continent
FROM businesses AS bus
INNER JOIN countries as cnt
ON bus.country_code = cnt.country_code
GROUP BY continent
ORDER BY oldest;

SELECT MIN(year_founded) 
FROM businesses;

SELECT *
FROM businesses
--WHERE year_founded = MIN(year_founded);
WHERE year_founded = 578;


--Q7: multi-table join of Country and Catagories on Businesses  
SELECT *
FROM businesses AS bus
INNER JOIN categories AS cat
ON bus.category_code = cat.category_code
INNER JOIN countries as cnt
ON bus.country_code = cnt.country_code


-- Q8: Gropuing catagories by continent 

SELECT cat.category, cnt.continent, COUNT(cat.category) AS n
FROM businesses AS bus
INNER JOIN categories AS cat
ON bus.category_code = cat.category_code
INNER JOIN countries as cnt
ON bus.country_code = cnt.country_code
GROUP BY continent, cat.category
ORDER BY n DESC;

--Q9: Selecting Catagory/Continent pair by count
SELECT cat.category, cnt.continent, COUNT(cat.category) AS nt 
FROM businesses AS bus
INNER JOIN categories AS cat
ON bus.category_code = cat.category_code
INNER JOIN countries as cnt
ON bus.country_code = cnt.country_code
GROUP BY continent, cat.category

/*  */