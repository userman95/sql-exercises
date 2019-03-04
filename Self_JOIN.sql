-- 1. How many stops are in the database.

SELECT COUNT(*)
  FROM stops;

-- 2. Find the id value for the stop 'Craiglockhart'

SELECT id
  FROM stops
  WHERE name = 'Craiglockhart';

-- 3. Give the id and the name for the stops on the '4' 'LRT' service.

SELECT id, name
  FROM stops
  WHERE id IN
    (SELECT stop
      FROM route
      WHERE num = '4' AND company = 'LRT');

-- 4. The query shown gives the number of routes that visit either London Road (149) 
-- or Craiglockhart (53). Run the query and notice the two services that link these 
-- stops have a count of 2. Add a HAVING clause to restrict the output to these two routes.

SELECT company, num, COUNT(*)
  FROM route 
  WHERE stop=149 OR stop=53
  GROUP BY company, num
  HAVING COUNT(*) = 2;

-- 5. Shows the services from Craiglockhart to London Road.

SELECT a.company, a.num, a.stop, b.stop
  FROM route a 
  JOIN route b ON (a.company=b.company AND a.num=b.num AND b.stop = 
    (SELECT id FROM stops WHERE name = 'London Road'))
  WHERE a.stop=53;

  -- 6. The query shown is similar to the previous one, however by joining two copies of 
  -- the stops table we can refer to stops by name rather than by number. Change the query 
  -- so that the services between 'Craiglockhart' and 'London Road' are shown. If you are 
  -- tired of these places try 'Fairmilehead' against 'Tollcross'

SELECT a.company, a.num, stopa.name, stopb.name
  FROM route a 
  JOIN route b ON (a.company=b.company AND a.num=b.num)
  JOIN stops stopa ON (a.stop=stopa.id)
  JOIN stops stopb ON (b.stop=stopb.id AND stopb.name = 'London Road')
  WHERE stopa.name='Craiglockhart';

-- 7. Give a list of all the services which connect stops 115 and 137 ('Haymarket' and 'Leith')

SELECT r1.company, r1.num
  FROM route r1
  INNER JOIN route r2 ON r1.num = r2.num AND r1.stop = 115 AND r2.stop = 137
  GROUP BY r1.company, r1.num;

-- 8. Give a list of the services which connect the stops 'Craiglockhart' and 'Tollcross'

SELECT r1.company, r1.num
  FROM route r1
  INNER JOIN route r2 ON r1.num = r2.num
  INNER JOIN stops sn1 ON r1.stop = sn1.id AND sn1.name =  'Craiglockhart'
  INNER JOIN stops sn2 ON r2.stop = sn2.id AND sn2.name = 'Tollcross';

-- 9. Give a distinct list of the stops which may be reached from 'Craiglockhart' by taking 
-- one bus, including 'Craiglockhart' itself, offered by the LRT company. Include the company 
-- and bus no. of the relevant services.

SELECT DISTINCT(sn2.name), r2.company, r2.num
  FROM route r1
  INNER JOIN route r2 ON r1.num = r2.num
  INNER JOIN stops sn1 ON r1.stop = sn1.id AND sn1.name =  'Craiglockhart'
  INNER JOIN stops sn2 ON r2.stop = sn2.id AND sn2.name IN  (SELECT name FROM stops)
  WHERE r2.company = 'LRT';

-- 10. Find the routes involving two buses that can go from Craiglockhart to Lochend.
-- Show the bus no. and company for the first bus, the name of the stop for the transfer,
-- and the bus no. and company for the second bus.

SELECT a.num,a.company,stops.name, b.num,b.company
  FROM route a
  JOIN route b ON(a.stop=b.stop)
  JOIN stops ON (stops.id=a.stop)
  WHERE a.num != b.num
  AND  a.company IN 
    (SELECT DISTINCT x.company 
      FROM route x 
      JOIN stops sx ON
      ( x.stop = 
        (SELECT id 
          FROM stops sx 
          WHERE name = 'Craiglockhart'))
      WHERE x.num = a.num) AND b.company IN
        (SELECT DISTINCT(y.company)
          FROM route y JOIN stops sy
          ON (y.stop = 
            (SELECT id 
              FROM stops sy 
              WHERE name = 'Lochend'))
          WHERE b.num = y.num)