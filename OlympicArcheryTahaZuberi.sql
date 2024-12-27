USE olympicarchery;

-- 1

SELECT P.FName, P.LName, P.Country
FROM PARTICIPANT P
JOIN ATHLETE A ON P.OlympicID = A.OlympicID;

-- 2

SELECT P.FName, P.LName, P.Country
FROM COACH C
JOIN PARTICIPANT P ON C.OlympicID = P.OlympicID
WHERE C.Orientation = 'Pending';

-- 3

SELECT P.Country, COUNT(*) AS AthleteCount
FROM PARTICIPANT P
GROUP BY P.Country;

-- 4

SELECT P.OlympicID, 
       IFNULL(A.BirthYear, 'null') AS BirthYear
FROM PARTICIPANT P
LEFT JOIN ATHLETE A ON P.OlympicID = A.OlympicID
ORDER BY A.BirthYear ASC;

-- 5

SELECT P.Country
FROM PARTICIPANT P
GROUP BY P.Country
HAVING COUNT(P.OlympicID) > 1;


-- 6

SELECT DISTINCT P.FName, P.LName
FROM PARTICIPANT P
JOIN INDIVIDUAL_RESULTS IR ON P.OlympicID = IR.Olympian
UNION
SELECT DISTINCT P.FName, P.LName
FROM PARTICIPANT P
JOIN TEAM_RESULTS TR ON P.OlympicID IN (TR.Team)
WHERE TR.Medal IS NOT NULL;

-- 7

SELECT C.CName
FROM COUNTRY C
JOIN PARTICIPANT P ON C.CName = P.Country
JOIN INDIVIDUAL_RESULTS IR ON P.OlympicID = IR.Olympian
GROUP BY C.CName
HAVING COUNT(IR.Medal) >= 5;


-- 8

SELECT P.Country, COUNT(IR.Medal) AS MedalCount
FROM PARTICIPANT P
JOIN INDIVIDUAL_RESULTS IR ON P.OlympicID = IR.Olympian
GROUP BY P.Country;


-- 9

SELECT P.FName, P.LName
FROM PARTICIPANT P
JOIN ATHLETE A ON P.OlympicID = A.OlympicID
WHERE A.FirstGames = 'Tokyo 2020';

-- 10

SELECT P.FName, P.LName
FROM PARTICIPANT P
JOIN ATHLETE A ON P.OlympicID = A.OlympicID
WHERE A.BirthYear = (SELECT MIN(BirthYear) FROM ATHLETE)
   OR A.BirthYear = (SELECT MAX(BirthYear) FROM ATHLETE);


-- 11

CREATE VIEW TEAM_ATHLETES AS
SELECT P.FName, P.LName, A.BirthYear
FROM PARTICIPANT P
JOIN ATHLETE A ON P.OlympicID = A.OlympicID
WHERE P.OlympicID IN (SELECT Member1 FROM TEAM
                       UNION
                       SELECT Member2 FROM TEAM
                       UNION
                       SELECT Member3 FROM TEAM
                       UNION
                       SELECT Member4 FROM TEAM
                       UNION
                       SELECT Member5 FROM TEAM
                       UNION
                       SELECT Member6 FROM TEAM);

SELECT * FROM TEAM_ATHLETES
ORDER BY BirthYear DESC;


SELECT * FROM TEAM_ATHLETES;

-- 12

CREATE TABLE INDIVID_W AS
SELECT ES.EventDate, ES.Location, P.LName, P.Country
FROM PARTICIPANT P
JOIN INDIVIDUAL_RESULTS IR ON P.OlympicID = IR.Olympian
JOIN EVENT_SCHEDULE ES ON IR.EventID = ES.EventID
WHERE ES.EventDate = 'July 30';
SELECT * FROM INDIVID_W;


-- 13

-- This will fail because the 'OlympicID' is not a primary key in the 'COACH' table
-- Adding a new entry requires ensuring unique values and satisfying all constraints

-- 14

-- The deletion will remove the record for the athlete with OlympicID = 'T2020_001' from the PARTICIPANT table
-- Though, deleting this would require removing all dependent rows first and it may also cause a foreign key violation in other tables

-- 15

-- A possible constraint for the TEAM table is ensuring that all team members exist in the ATHLETE table
-- This can be enforced with foreign key constraints linking the Mmeber columns to the OlympicID in the ATHLETE table
-- This would ensure that only valid athletes are part of the teams