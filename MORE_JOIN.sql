-- 1.
SELECT id, title
FROM movie
WHERE yr=1962

-- 2.
SELECT yr FROM movie WHERE title = 'Citizen Kane'

-- 3.
SELECT id,title,yr FROM movie WHERE title LIKE '%Star Trek%' 
ORDER BY yr

-- 4.
SELECT id 
FROM actor
WHERE name= 'Glenn Close'

-- 5.
SELECT id FROM movie WHERE title = 'Casablanca'

-- 6.
SELECT name FROM actor JOIN casting ON actor.id = casting.actorid WHERE movieid = 11768

-- 7.
SELECT name FROM actor 
INNER JOIN casting ON actor.id = casting.actorid 
INNER JOIN movie ON casting.movieid = movie.id 
WHERE movie.title = 'Alien'

-- 8.
SELECT title 
FROM movie 
INNER JOIN casting ON movie.id = casting.movieid 
INNER JOIN actor ON casting.actorid = actor.id 
WHERE name ='Harrison Ford'

-- 9.
SELECT title
FROM movie 
INNER JOIN casting ON movie.id = casting.movieid 
INNER JOIN actor ON casting.actorid = actor.id  
WHERE ord!=1 AND name = 'Harrison Ford'

-- 10.
SELECT title,name
FROM movie 
INNER JOIN casting ON movie.id = casting.movieid 
INNER JOIN actor ON casting.actorid = actor.id  
WHERE yr = 1962 AND ord = 1

-- 11.
SELECT yr,COUNT(title) FROM
  movie JOIN casting ON movie.id=movieid
         JOIN actor   ON actorid=actor.id
where name='John Travolta'
GROUP BY yr
HAVING COUNT(title)=(SELECT MAX(c) FROM
(SELECT yr,COUNT(title) AS c FROM
   movie JOIN casting ON movie.id=movieid
         JOIN actor   ON actorid=actor.id
 where name='John Travolta'
 GROUP BY yr) AS t
)

-- 12.
SELECT title,name FROM movie
INNER JOIN casting ON movie.id = casting.movieid AND ord = 1
INNER JOIN actor ON casting.actorid = actor.id  
WHERE movie.id IN (
  SELECT movieid FROM casting
    WHERE actorid IN (
      SELECT id FROM actor
        WHERE name='Julie Andrews' ))

-- 13.
SELECT name 
FROM movie
INNER JOIN casting ON movie.id = casting.movieid AND ord = 1
INNER JOIN actor ON casting.actorid = actor.id 
GROUP BY name 
HAVING COUNT(name)>=30

-- 14.
SELECT title ,COUNT(actorid)
FROM movie
INNER JOIN casting ON movie.id = casting.movieid 
WHERE yr =1978
GROUP BY title
ORDER BY COUNT(actorid) DESC,title

-- 15.
SELECT name 
FROM actor
JOIN casting ON actor.id = casting.actorid 
WHERE movieid IN (SELECT movieid FROM actor
                     INNER JOIN casting ON actor.id = casting.actorid                 
                        WHERE  name = 'Art Garfunkel')
AND name != 'Art Garfunkel'