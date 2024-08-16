CREATE DATABASE project_rainfall_india;  /* Creating new Database */

USE project_rainfall_india;  /* To make the Database Default */

ALTER TABLE rainfall_india 
RENAME COLUMN DEC TO DECEMBER;  /* Renaming the Column */

ALTER TABLE temperatures
RENAME COLUMN DEC TO DECEMBER; /* Renaming the Column */

-- --------------------------------------- Finding 1 -------------------------------------

-- 1A. Subdivisions wise Five Regions with Highest Average Annual Rainfall from 1901 to 2017
SELECT SUBDIVISIONS, ROUND(AVG(ANNUAL),2) AS Avg_Annual_Rainfall
FROM rainfall_india
GROUP BY SUBDIVISIONS
ORDER BY 2 DESC
LIMIT 5;

-- 1B. Subdivisions wise Five Regions with Least Average Annual Rainfall from 1901 to 2017
SELECT SUBDIVISIONS, ROUND(AVG(ANNUAL),2) AS Avg_Annual_Rainfall
FROM rainfall_india
GROUP BY SUBDIVISIONS
ORDER BY 2 ASC
LIMIT 5;

-- --------------------------------------- Finding 2 -------------------------------------
-- Year wise Total Annual Rainfall Trend of 20th Century in India 
SELECT YEAR, ROUND(SUM(ANNUAL),2) AS Total_Rainfall_in_India
FROM rainfall_india
WHERE YEAR LIKE "19%"
GROUP BY YEAR
ORDER BY 1 ASC;

-- To Check the Forecasting Values from Chart
SELECT YEAR, ROUND(SUM(ANNUAL),2) AS Total_Rainfall_in_India
FROM rainfall_india
WHERE YEAR BETWEEN 2000 AND 2005
GROUP BY YEAR
ORDER BY 1 ASC;

-- --------------------------------------- Finding 3 -------------------------------------
-- Year wise Average Annual Rainfall and Average Annual Temperature Trend in India
SELECT YEAR, ROUND(AVG(RI.ANNUAL),2) AS Avg_Annual_Rainfall , T.ANNUAL AS Avg_Annual_Temperature
FROM rainfall_india AS RI INNER JOIN temperatures AS T USING (YEAR)
GROUP BY RI.YEAR, T.ANNUAL
ORDER BY 1 ASC;

-- --------------------------------------- Finding 4 -------------------------------------

/* Top 5 Subdivisions where India sees most Rainfall in Monsoon (June to September) 
	   also show the Rainfall in Summer (March to May) and Winter (December to February) in those Regions  */
SELECT SUBDIVISIONS, ROUND(SUM(MAR+APR+MAY),2) AS Summer_Rainfall,
	   ROUND(SUM(JUN+JUL+AUG+SEP),2) AS Monsoon_Rainfall,
	   ROUND(SUM(DECEMBER+JAN+FEB),2) AS Winter_Rainfall
FROM rainfall_india
GROUP BY SUBDIVISIONS
ORDER BY 3 DESC
LIMIT 5;

-- --------------------------------------- Finding 5 -------------------------------------
-- Percentage of Total Rainfall in Monsoon over Total Annual Rainfall from 2000 to 2017
WITH Rainfall_Precentage AS
	(SELECT  YEAR, SUM(JUN+JUL+AUG+SEP) AS Rainfall_in_Monsoon, SUM(ANNUAL) AS Annual_Rainfall,
			 ROUND(SUM(JUN+JUL+AUG+SEP)/SUM(ANNUAL),2) AS Rainfall_Precentage_in_Monsoon
	FROM rainfall_india
	WHERE YEAR LIKE "20%"
	GROUP BY YEAR)
SELECT YEAR, RP.Rainfall_Precentage_in_Monsoon, ROUND(SUM(T.JUN+T.JUL+T.AUG+T.SEP)/4,2) AS Avg_Temp_in_Monsoon
FROM Rainfall_Precentage AS RP INNER JOIN temperatures AS T USING (YEAR)
GROUP BY YEAR
ORDER BY 1 ASC;

-- --------------------------------------- Finding 6  -----------------------------------------
-- Annual Rainfall Trend in Gangetic West Bengal (Southern Half of West Bengal) from 1901 to 2017
SELECT SUBDIVISIONS, YEAR, ANNUAL AS Annual_Rainfall
FROM rainfall_india
WHERE SUBDIVISIONS LIKE "%Gangetic West Bengal%" AND ANNUAL IS NOT NULL
ORDER BY YEAR ASC;

-- --------------------------------------- Finding 7  -----------------------------------------
-- 7. Annual Rainfall and Temperature Trend in Gangetic West Bengal (Southern Half of West Bengal) from 1901 to 2017
SELECT YEAR, SUBDIVISIONS, RI.ANNUAL AS Annual_Rainffall, T.ANNUAL AS Annual_Avg_Temperature
FROM rainfall_india AS RI INNER JOIN temperatures AS T USING (YEAR)
WHERE RI.SUBDIVISIONS LIKE "%Gangetic West Bengal%" AND
	  RI.ANNUAL IS NOT NULL AND T.ANNUAL IS NOT NULL
ORDER BY 1 ASC;

-- --------------------------------------- Finding 8  -----------------------------------------
-- 8. Trend of Average Temperature and Total Rainfall in SUMMER (March to May) in Gangetic West Bengal Region from 2000 to 2017
WITH Temp_Rainfall_Table AS
	(SELECT RI.SUBDIVISIONS, RI.YEAR,
			ROUND(((T.MAR+T.APR+T.MAY)/3),2) AS Avg_Temp_in_Summer,
			ROUND(((RI.MAR+RI.APR+RI.MAY)),2) AS Total_Rainfall_in_Summer
	FROM rainfall_india AS RI INNER JOIN temperatures AS T USING (YEAR) )
SELECT SUBDIVISIONS, YEAR, Avg_Temp_in_Summer, Total_Rainfall_in_Summer
FROM Temp_Rainfall_Table
WHERE YEAR LIKE "20%" AND
	  SUBDIVISIONS LIKE "%Gangetic West Bengal%" ;
      
-- --------------------------------------- Finding 9  -----------------------------------------
-- 9. Seasonal Rainfall Comparison between 1917 and 2017 
SELECT  YEAR,
		ROUND(SUM(MAR+APR+MAY)/SUM(ANNUAL),2) AS Rainfall_Precentage_in_Summer,
		ROUND(SUM(JUN+JUL+AUG+SEP)/SUM(ANNUAL),2) AS Rainfall_Precentage_in_Monsoon,
		ROUND(SUM(OCT+NOV)/SUM(ANNUAL),2) AS Rainfall_Precentage_in_Autumn,
		ROUND(SUM(DECEMBER+JAN+FEB)/SUM(ANNUAL),2) AS Rainfall_Precentage_in_Winter
FROM rainfall_india
WHERE YEAR IN (1917,2017)
GROUP BY YEAR;

-- --------------------------------------- Finding 10  -----------------------------------------
-- 10. Month wise Rainfall Comparison between Uttarakhand and Kerala in 2017
SELECT SUBDIVISIONS,
	   JAN, FEB, MAR, APR, MAY, JUN, JUL, AUG, SEP, OCT, NOV, DECEMBER
FROM rainfall_india
WHERE YEAR = 2017 AND SUBDIVISIONS IN ("Uttarakhand","Kerala") ;

-- --------------------------------------- Finding 11  -----------------------------------------
-- 11. Subdivisions wise Average Annual Rainfall
SELECT SUBDIVISIONS, ROUND(AVG(ANNUAL),2) AS Avg_Annual_Rainfall
FROM rainfall_india
GROUP BY SUBDIVISIONS;
