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

-- ADDING COUNTRY COLUMN TO MOVIES_BUDGET
USE movies
ALTER TABLE movies_budget
ADD country NVARCHAR(MAX);

-- CREATE A TRIGGER TO VALIDATE DATA BEFORE INSERTIONS INTO movies_budget
CREATE TRIGGER trg_validate_movie_budget
BEFORE INSERT ON movies_budget
FOR EACH ROW
BEGIN
    IF NEW.budget_x < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Budget cannot be negative.';
    END IF;

    IF NEW.score < 0 OR NEW.score > 100 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Score must be between 0 and 100.';
    END IF;
END;

-- UPDATING COUNTRY COLUMN IN MOVIES_BUDGET WITH VALUES FROM MOVIES_INFO
UPDATE mb
SET mb.country = mi.country
FROM movies_budget mb
JOIN movies_info mi ON mb.movie_id = mi.movie_id;

-- ENSURE THAT CERTAIN COLUMNS IN  movies_info CANNOT BE NULL
ALTER TABLE movies_info
ALTER COLUMN movie_id INT NOT NULL,
ALTER COLUMN names NVARCHAR(MAX) NOT NULL,
ALTER COLUMN release_date DATE NOT NULL;

--ENSURE THAT CERTAIN COLUMNS IN  movies_info CANNOT BE NULL
ALTER TABLE movies_budget
ALTER COLUMN movie_id INT NOT NULL,
ALTER COLUMN budget_x DECIMAL(18, 2) NOT NULL,
ALTER COLUMN score DECIMAL(5, 2) NOT NULL;


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
	WHEN MONTH(mi.release_date) = 12
	OR MONTH(mi.release_date) IN (1, 2) THEN 'WINTER'
	ELSE 'UNKNOW' 
	END AS release_season
FROM movies..movies_info mi
JOIN movies..movies_budget mb 
ON mi.movie_id=mb.movie_id;


-- FIND MOVIES WHICH STATUSES ARE POST/IN PRODUCTION 
SELECT mi.names, mb.status
FROM movies..movies_info mi JOIN movies..movies_budget mb ON mi.movie_id=mb.movie_id
WHERE LOWER(mb.status) IN ('post production','in production') 
ORDER BY mi.names ASC
