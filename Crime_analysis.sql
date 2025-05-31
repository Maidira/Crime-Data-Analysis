-------------------------------------------------
-- CASE STUDY: Exploring Crime Data--
-------------------------------------------------

-- Tool used: MySQL Workbench

-------------------------------------------------
-- CASE STUDY QUESTIONS AND ANSWERS--
-------------------------------------------------

-- Database Setup
CREATE DATABASE Crime_Dataset;
USE Crime_Dataset;



-- Top 5 most common crimes
SELECT 
`Crm Cd Desc` AS Crime_Type,
COUNT(*) AS Total_Incidents
FROM crime_data
GROUP BY `Crm Cd Desc`
ORDER BY Total_Incidents DESC
LIMIT 5;




SELECT 
    COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'crime_data' AND COLUMN_NAME = 'DATE OCC';


-- Crimes trend over time
SELECT 
    YEAR(STR_TO_DATE(`DATE OCC`, '%m/%d/%Y %r')) AS Year,
    MONTH(STR_TO_DATE(`DATE OCC`, '%m/%d/%Y %r')) AS Month,
    COUNT(*) AS Total_Crimes
FROM crime_data
WHERE STR_TO_DATE(`DATE OCC`, '%m/%d/%Y %r') IS NOT NULL
GROUP BY 
    YEAR(STR_TO_DATE(`DATE OCC`, '%m/%d/%Y %r')),
    MONTH(STR_TO_DATE(`DATE OCC`, '%m/%d/%Y %r'))
ORDER BY 
    Year, Month
LIMIT 0, 50000;



-- Arrest Rate by Crime Type
SELECT 
    `Crm Cd Desc`,
    COUNT(*) AS Total_Cases,
    SUM(CASE WHEN `Status Desc` LIKE '%Arrest%' THEN 1 ELSE 0 END) AS Arrests,
    ROUND(100.0 * SUM(CASE WHEN `Status Desc` LIKE '%Arrest%' THEN 1 ELSE 0 END) / COUNT(*), 2) AS Arrest_Rate
FROM crime_data
GROUP BY `Crm Cd Desc`
ORDER BY Arrest_Rate DESC;


-- Day of Week Analysis
SELECT 
    DAYNAME(STR_TO_DATE(`DATE OCC`, '%m/%d/%Y %h:%i:%s %p')) AS Day_of_Week,
    COUNT(*) AS Total_Crimes,
    ROUND(AVG(COUNT(*)) OVER (), 0) AS Avg_Daily_Crimes,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS Percentage_of_Total
FROM crime_data
WHERE STR_TO_DATE(`DATE OCC`, '%m/%d/%Y %h:%i:%s %p') IS NOT NULL
GROUP BY 
    DAYNAME(STR_TO_DATE(`DATE OCC`, '%m/%d/%Y %h:%i:%s %p')),
    DAYOFWEEK(STR_TO_DATE(`DATE OCC`, '%m/%d/%Y %h:%i:%s %p'))
ORDER BY 
    DAYOFWEEK(STR_TO_DATE(`DATE OCC`, '%m/%d/%Y %h:%i:%s %p'));


-- Crime Hotspots by Area
SELECT 
   `AREA NAME`,
    COUNT(*) AS Total_Crimes,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS Percentage,
    RANK() OVER (ORDER BY COUNT(*) DESC) AS Area_Rank
FROM crime_data
GROUP BY `AREA NAME`
ORDER BY Total_Crimes DESC;
