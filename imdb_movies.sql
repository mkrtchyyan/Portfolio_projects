-- CHECKING OUR DATA

SELECT * FROM movies..movies_info
SELECT * FROM movies..movies_budget


-- DELETING UNUSEFULL FIELDS

USE movies
ALTER TABLE movies_info
DROP COLUMN orig_lang;

USE movies
ALTER TABLE movies_info
DROP COLUMN orig_title;


-- ADDING CONTRY COLUMN TO MOVIES_BUDGET 

USE movies
ALTER TABLE movies_budget
ADD country NVARCHAR(MAX);


-- AND COPYING THE VALUES OF COUNTRY COLUMN OF MOVIES_INFO TABLE TO NEW CREATED COLUMN

USE movies
UPDATE movies_budget
SET country = ( 
SELECT country
FROM movies..movies_info
WHERE movies..movies_budget.movie_id = movies..movies_info.movie_id)



-- FINDING ROWS WITH NULL VALUES AND DELETING THEM

DELETE FROM movies..movies_info
WHERE names IS NULL 
OR release_date IS NULL
OR overview IS NULL
OR crew IS NULL
OR country IS NULL -- movie_id is the PRIMARY KEY, it can't be NULL so we don't check it


-- FINDING ROWS WITH NULL VALUES AND DELETING THEM FOR THE OTHER TABLE TOO

DELETE FROM movies..movies_budget
WHERE budget_x IS NULL 
OR revenue IS NULL
OR genre IS NULL
OR status IS NULL
OR score IS NULL
OR country IS NULL --and one more time movie_id is the PRIMARY KEY, it can't be NULL so we don't check it


-- JOINING TABLES

SELECT mi.movie_id,mi.names,mi.release_date,mb.budget_x,mb.revenue,mb.genre,mb.status,mb.score,mb.country
FROM movies..movies_info mi
JOIN movies..movies_budget mb
ON mb.movie_id = mi.movie_id
ORDER BY 3


-- FINDING THE AVG SCORE & AVG BUDGET OF THE MOVIES RELEASED IN 2023

SELECT mi.names,mi.release_date,AVG(mb.score) AS AVG_Score,AVG(mb.budget_x) AS AVG_Budget
FROM movies..movies_info mi 
JOIN movies..movies_budget mb 
ON mi.movie_id=mb.movie_id 
WHERE LOWER(mb.status) = 'released' -- using LOWER() string function to not mess with uppercases/lowercases
AND mb.score <> 0
GROUP BY mi.release_date, mi.names
HAVING mi.release_date >= '2023-01-01'
ORDER BY 2


-- FINDING TOP 3 MOVIES WITH THE HIGHEST BUDGET(WITH RELEASE DATE)

SELECT top(3) mi.names,mb.budget_x,mi.release_date
FROM movies..movies_info mi 
JOIN movies..movies_budget mb
ON mi.movie_id=mb.movie_id
ORDER BY 2 DESC


-- AVG SCORES & BUDGET FOR EACH COUTRY, EXCLUDING THE SCORE WHICH ARE 0

SELECT  mb.country, AVG(CAST(mb.score AS bigint)) AS AVG_score, AVG(CAST(mb.budget_x AS bigint)) as AVG_budget
FROM movies..movies_budget mb 
WHERE mb.score <> 0
GROUP BY mb.country
ORDER BY 2 


-- HOW MANY RELEASED ROMCOMS ARE THERE WITH A SCORE HIGHER THAN 80

SELECT COUNT(DISTINCT mi.movie_id) as RomComs
FROM movies..movies_info mi 
JOIN movies..movies_budget mb
ON mi.movie_id = mb.movie_id
WHERE LOWER(mb.genre) LIKE ('%comedy%') 
AND LOWER(mb.genre) LIKE ('%romance%') 
AND mb.score >= 80 
AND LOWER(mb.status) = 'released'


-- JUST A CTE WHICH WILL COUNT HOW MANY MOVIES EACH GENRE HAS IN EACH COUNTRY
--  FOR EXAMPLE I'LL USE 'ACTION' GENRE

WITH genre_name_CTE
AS ( 
SELECT mb.country, COUNT(mb.genre) AS genre_name_count
FROM movies..movies_budget mb
WHERE LOWER(mb.genre) LIKE ('%action%') -- ('%genre_name%'): WE CAN CHANGE AND FIND THE ONE WE WANT 
GROUP BY mb.country
)
SELECT  * FROM genre_name_CTE
ORDER BY genre_name_count DESC


-- GROUPING MOVIES BY SEASONS

SELECT mi.names,mb.genre,mb.country,
CASE WHEN MONTH(mi.release_date) IN (3,4,5) THEN 'SPRING'
	WHEN MONTH(mi.release_date) IN (6,7,8) THEN 'SUMMER'
	WHEN MONTH(mi.release_date) IN (9,10,11) THEN 'AUTUMN'
	WHEN MONTH(mi.release_date) IN (12,1,2) THEN 'WINTER'
	ELSE 'UNKNOW' END AS release_season
FROM movies..movies_info mi
JOIN movies..movies_budget mb 
ON mi.movie_id=mb.movie_id;


-- FIND MOVIES WHICH STATUSES ARE POST/IN PRODUCTION 
SELECT mi.names, mb.status
FROM movies..movies_info mi JOIN movies..movies_budget mb ON mi.movie_id=mb.movie_id
WHERE LOWER(mb.status) IN ('post production','in production') 
ORDER BY mi.names ASC