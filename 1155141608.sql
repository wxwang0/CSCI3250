/*
Student ID: 1155141608
Name: Wang Wei Xiao
*/
/* Query 1 */
/*
Spool result1.lst
SELECT LEAGUES.LID,LEAGUES.LEAGUE_NAME, REGIONS.REGION_NAME, LEAGUES.YEAR
  FROM LEAGUES  
  INNER JOIN REGIONS ON LEAGUES.RID = REGIONS.RID
  WHERE SEASON = 'Spring' OR SEASON = 'Summer' 
  ORDER BY LID ASC;
Spool off
*/
/* Query 2 */
/*
Spool result2.lst
SELECT TEAMS.TID,TEAMS.TEAM_NAME,TEAMS.AVERAGE_AGE 
  FROM TEAMS  
  INNER JOIN LEAGUES ON LEAGUES.CHAMPION_TID = TEAMS.TID
  WHERE LEAGUES.YEAR >= 2015 
GROUP BY TEAMS.TID,TEAMS.TEAM_NAME,TEAMS.AVERAGE_AGE 
HAVING  COUNT(*) > 1
ORDER BY TID ASC;
Spool off
*/

/* Query 3 */
/*
Spool result3.lst
DROP TABLE T1;
CREATE TABLE T1 AS SELECT * FROM (
SELECT TID, TEAM_NAME, AVERAGE_AGE, SEASON,COUNT(SEASON) AS W_NUM FROM(
    SELECT T.TID,T.TEAM_NAME,T.AVERAGE_AGE,L.SEASON 
     FROM TEAMS T
     INNER JOIN LEAGUES L ON L.CHAMPION_TID = T.TID  
  )
  GROUP BY TID, TEAM_NAME, AVERAGE_AGE, SEASON
);

SELECT * FROM T1 
WHERE (W_NUM = (
  SELECT MAX(W_NUM) FROM T1 
  WHERE T1.SEASON= 'Spring'
  ) AND SEASON = 'Spring'
  )
OR (W_NUM = (
  SELECT MAX(W_NUM) FROM T1 
  WHERE T1.SEASON= 'Summer'
  ) AND SEASON = 'Summer'
  )
OR (W_NUM = (
  SELECT MAX(W_NUM) FROM T1 
  WHERE T1.SEASON= 'Autumn'
  ) AND SEASON = 'Autumn'
  )
OR (W_NUM = (
  SELECT MAX(W_NUM) FROM T1 
  WHERE T1.SEASON= 'Winter'
  ) AND SEASON = 'Winter'
  )
ORDER BY TID,SEASON ASC;
Spool off
*/

/* Query 4 */
/*
Spool result4.lst
SELECT * FROM(
  SELECT SID, SPONSOR_NAME,COUNT(LID) AS L_NUM FROM(
    SELECT SPONSORS.SID, SPONSORS.SPONSOR_NAME, SUPPORT.LID FROM SPONSORS 
    INNER JOIN SUPPORT ON SUPPORT.SID=SPONSORS.SID
  )GROUP BY SID, SPONSOR_NAME
)WHERE ROWNUM <= 5
ORDER BY SID ASC;
Spool off
*/

/* Query 5 */
/*
Spool result5.lst
SELECT LID, LEAGUE_NAME FROM(
  SELECT LEAGUES.LID,LEAGUES.LEAGUE_NAME, LEAGUES.SEASON, SPONSORS.MARKET_VALUE, TEAMS.AVERAGE_AGE FROM LEAGUES
  INNER JOIN TEAMS ON LEAGUES.CHAMPION_TID = TEAMS.TID
  INNER JOIN SUPPORT ON SUPPORT.LID = LEAGUES.LID 
  INNER JOIN SPONSORS ON SPONSORS.SID = SUPPORT.SID  
)WHERE SEASON IN ('Winter','Summer') AND MARKET_VALUE>50 AND AVERAGE_AGE <30
ORDER BY LID DESC;
Spool off
*/

/* Query 6 */
/*
Spool result6.lst

DROP TABLE TABLE6;
CREATE TABLE TABLE6 AS SELECT* FROM (
   SELECT SID,TOTAL_SPONSORSHIP/(SQRT(MARKET_VALUE)*LOG(2,SQRT(FOOTBALL_RANKING)+1)) AS HOT FROM(
    SELECT SID,MARKET_VALUE,FOOTBALL_RANKING,SUM(SPONSORSHIP) AS TOTAL_SPONSORSHIP FROM(
      SELECT SPONSORS.SID,SPONSORS.MARKET_VALUE,REGIONS.FOOTBALL_RANKING,SUPPORT.SPONSORSHIP FROM SPONSORS
      INNER JOIN SUPPORT ON SUPPORT.SID=SPONSORS.SID
      INNER JOIN LEAGUES ON LEAGUES.LID=SUPPORT.LID
      INNER JOIN REGIONS ON LEAGUES.RID=REGIONS.RID
      WHERE SPONSORS.MARKET_VALUE>40 AND REGIONS.FOOTBALL_RANKING <10
    )GROUP BY SID,MARKET_VALUE,FOOTBALL_RANKING   
   )  
);

SELECT SID,HOT FROM TABLE6
WHERE HOT = (SELECT MAX(HOT) FROM TABLE6)
ORDER BY SID DESC;
Spool off
*/
/* Query 7 */
/*
Spool result7.lst
DROP TABLE T7;
CREATE TABLE T7 AS SELECT* FROM (
   SELECT RID,SID,TOTAL_SPONSORSHIP/(SQRT(MARKET_VALUE)*LOG(2,SQRT(FOOTBALL_RANKING)+1)) AS HOT FROM(
    SELECT RID,SID,MARKET_VALUE,FOOTBALL_RANKING,SUM(SPONSORSHIP) AS TOTAL_SPONSORSHIP FROM(
      SELECT REGIONS.RID,SPONSORS.SID,SPONSORS.MARKET_VALUE,REGIONS.FOOTBALL_RANKING,SUPPORT.SPONSORSHIP FROM SPONSORS
      INNER JOIN SUPPORT ON SUPPORT.SID=SPONSORS.SID
      INNER JOIN LEAGUES ON LEAGUES.LID=SUPPORT.LID
      INNER JOIN REGIONS ON LEAGUES.RID=REGIONS.RID
      WHERE SPONSORS.SID IN (4,5,6,7)
    )GROUP BY RID,SID,MARKET_VALUE,FOOTBALL_RANKING   
   )  
);
DROP TABLE T7_1;
CREATE TABLE T7_1 AS SELECT * FROM(
SELECT DISTINCT RID, 0 AS HOT_4, 0 AS HOT_5, 0 AS HOT_6, 0 AS HOT_7 FROM T7
);  
DROP TABLE TH4;
CREATE TABLE TH4 AS SELECT RID,HOT FROM T7
WHERE SID =4;

DROP TABLE TH5;
CREATE TABLE TH5 AS SELECT RID,HOT FROM T7
WHERE SID =5;

DROP TABLE TH6;
CREATE TABLE TH6 AS SELECT RID,HOT FROM T7
WHERE SID =6;

DROP TABLE TH7;
CREATE TABLE TH7 AS SELECT RID,HOT FROM T7
WHERE SID =7;

SELECT DISTINCT RID,HOT_4,HOT_5,HOT_6,HOT_7,GREATEST(NVL(HOT_4,0), NVL(HOT_5,0), NVL(HOT_6,0), NVL(HOT_7,0)) AS HOT_HIGH FROM(
  SELECT DISTINCT T7.RID, TH4.HOT AS HOT_4 , TH5.HOT AS HOT_5 , TH6.HOT AS HOT_6 , TH7.HOT AS HOT_7 FROM T7
  LEFT JOIN TH4 ON TH4.RID = T7.RID
  LEFT JOIN TH5 ON TH5.RID = T7.RID
  LEFT JOIN TH6 ON TH6.RID = T7.RID
  LEFT JOIN TH7 ON TH7.RID = T7.RID
)
ORDER BY RID DESC;
Spool off
*/
/* Query 8 */
/*
Spool result8.lsT
DROP TABLE MCT;
CREATE TABLE MCT AS
SELECT CHAMPION_TID 
     FROM (
       SELECT DISTINCT CHAMPION_TID, COUNT(*)AS WIN_NUM 
       FROM LEAGUES
       GROUP BY CHAMPION_TID
     )
     WHERE WIN_NUM = (
       SELECT MAX(WIN_NUM) FROM(
       SELECT DISTINCT CHAMPION_TID, COUNT(*)AS WIN_NUM 
       FROM LEAGUES
       GROUP BY CHAMPION_TID
       )
     );
     
SELECT SID,SPONSOR_NAME FROM (
  SELECT DISTINCT SPONSORS.SID,SPONSORS.SPONSOR_NAME FROM SPONSORS
  INNER JOIN SUPPORT ON SUPPORT.SID = SPONSORS.SID
  INNER JOIN LEAGUES ON LEAGUES.LID = SUPPORT.LID
  INNER JOIN MCT ON LEAGUES.CHAMPION_TID = MCT.CHAMPION_TID
)
ORDER BY SID ASC;
Spool off
*/
