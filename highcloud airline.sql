CREATE DATABASE airline;
USE airline;
CREATE TABLE maindata (
`%Airline ID` TEXT,
`%Carrier Group ID` TEXT,
`%Unique Carrier Code` TEXT,
`%Unique Carrier Entity Code` TEXT,
`%Region Code` TEXT,
`%Origin Airport ID` TEXT,
`%Origin Airport Sequence ID` TEXT,
`%Origin Airport Market ID` TEXT,
`%Origin World Area Code` TEXT,
`%Destination Airport ID` TEXT,
`%Destination Airport Sequence ID` TEXT,
`%Destination Airport Market ID` TEXT,
`%Destination World Area Code` TEXT,
`%Aircraft Group ID` TEXT,
`%Aircraft Type ID` TEXT,
`%Aircraft Configuration ID` TEXT,
`%Distance Group ID` TEXT,
`%Service Class ID` TEXT,
`%Datasource ID` TEXT,
`# Departures Scheduled` TEXT,
`# Departures Performed` TEXT,
`# Payload` TEXT,
`Distance` TEXT,
`# Available Seats` TEXT,
`# Transported Passengers` TEXT,
`# Transported Freight` TEXT,
`# Transported Mail` TEXT,
`# Ramp-To-Ramp Time` TEXT,
`# Air Time` TEXT,
`Unique Carrier` TEXT,
`Carrier Code` TEXT,
`Carrier Name` TEXT,
`Origin Airport Code` TEXT,
`Origin City` TEXT,
`Origin State Code` TEXT,
`Origin State FIPS` TEXT,
`Origin State` TEXT,
`Origin Country Code` TEXT,
`Origin Country` TEXT,
`Destination Airport Code` TEXT,
`Destination City` TEXT,
`Destination State Code` TEXT,
`Destination State FIPS` TEXT,
`Destination State` TEXT,
`Destination Country Code` TEXT,
`Destination Country` TEXT,
`Year` TEXT,
`Month` TEXT,
`Day` TEXT,
`From - To Airport Code` TEXT,
`From - To Airport ID` TEXT,
`From - To City` TEXT,
`From - To State Code` TEXT,
`From - To State` TEXT,
`Date` TEXT,
`Month full name` TEXT,
`Year Month` TEXT,
`Financial Month` TEXT,
`Weekday no` TEXT,
`Weekday Name` TEXT,
`Financial Quarter` TEXT,
`Quarter` TEXT
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/highcloud.csv'
INTO TABLE maindata
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

SELECT COUNT(*) AS TotalRows
FROM maindata;

DESCRIBE maindata;

-- Q1. Create Date Field
SELECT
STR_TO_DATE(CONCAT(`Year`, '-', LPAD(`Month`,2,'0'), '-', LPAD(`Day`,2,'0')), '%Y-%m-%d') AS Flight_Date
FROM maindata
LIMIT 10;

-- Q1(A). Year
SELECT DISTINCT `Year`
FROM maindata
ORDER BY CAST(`Year` AS UNSIGNED);

-- Q1(B). Month No
SELECT DISTINCT
CAST(`Month` AS UNSIGNED) AS MonthNo
FROM maindata
ORDER BY MonthNo;

-- Q1(C). Month Full Name
SELECT DISTINCT `Month full name`
FROM maindata;

-- Q1(D). Quarter
SELECT DISTINCT Quarter
FROM maindata;

-- Q1(E). Year Month
SELECT DISTINCT `Year Month`
FROM maindata;

-- F. Weekday Number
SELECT
DAYOFWEEK(
STR_TO_DATE(CONCAT(`Year`, '-', LPAD(`Month`,2,'0'), '-', LPAD(`Day`,2,'0')), '%Y-%m-%d')
) AS WeekdayNo
FROM maindata;

-- G. Weekday Name
SELECT
DAYNAME(
STR_TO_DATE(CONCAT(`Year`, '-', LPAD(`Month`,2,'0'), '-', LPAD(`Day`,2,'0')), '%Y-%m-%d')
) AS WeekdayName
FROM maindata;

-- H. Financial Month
SELECT
CASE
WHEN CAST(`Month` AS UNSIGNED)>=4
THEN CAST(`Month` AS UNSIGNED)-3
ELSE CAST(`Month` AS UNSIGNED)+9
END AS FinancialMonth
FROM maindata;

-- Q2. Load Factor (Yearly)
SELECT
`Year`,
ROUND(
SUM(CAST(`# Transported Passengers` AS DECIMAL(18,2)))
/
SUM(CAST(`# Available Seats` AS DECIMAL(18,2)))
*100,2
) AS LoadFactor
FROM maindata
GROUP BY `Year`;

-- Q3 Carrier Wise Load Factor
SELECT
`Carrier Name`,
ROUND(
SUM(CAST(`# Transported Passengers` AS DECIMAL(18,2)))
/
SUM(CAST(`# Available Seats` AS DECIMAL(18,2)))
*100,2
) AS LoadFactor
FROM maindata
GROUP BY `Carrier Name`
ORDER BY LoadFactor DESC;

-- Q4 Top 10 Carrier
SELECT
`Carrier Name`,
SUM(CAST(`# Transported Passengers` AS UNSIGNED)) AS TotalPassengers
FROM maindata
GROUP BY `Carrier Name`
ORDER BY TotalPassengers DESC
LIMIT 10;

-- Q5 Top Routes
SELECT
`From - To City`,
COUNT(*) AS TotalFlights
FROM maindata
GROUP BY `From - To City`
ORDER BY TotalFlights DESC;

-- Q6 Weekend vs Weekday
SELECT
CASE
WHEN `Weekday Name` IN ('Saturday','Sunday')
THEN 'Weekend'
ELSE 'Weekday'
END AS DayType,

ROUND(
SUM(CAST(`# Transported Passengers` AS DECIMAL(18,2)))
/
SUM(CAST(`# Available Seats` AS DECIMAL(18,2)))
*100,2
) AS LoadFactor

FROM maindata

GROUP BY DayType;

-- Q7 Distance Group
SELECT

`%Distance Group ID`,

COUNT(*) AS Flights

FROM maindata

GROUP BY `%Distance Group ID`

ORDER BY `%Distance Group ID`;

-- KPI queries
-- 1. Total Flights KPI
SELECT COUNT(*) AS Total_Flights
FROM maindata;

-- 2. Total Passengers KPI
SELECT
SUM(CAST(`# Transported Passengers` AS UNSIGNED)) AS Total_Passengers
FROM maindata;

-- 3. Total Available Seats KPI
SELECT
SUM(CAST(`# Available Seats` AS UNSIGNED)) AS Total_Available_Seats
FROM maindata;

-- 4. Overall Load Factor % KPI
SELECT
ROUND(
(
SUM(CAST(`# Transported Passengers` AS DECIMAL(18,2)))
/
SUM(CAST(`# Available Seats` AS DECIMAL(18,2)))
)*100,2) AS Load_Factor_Percentage
FROM maindata;

-- 5. Total Airlines KPI
SELECT
COUNT(DISTINCT `Carrier Name`) AS Total_Airlines
FROM maindata;

-- 6. Total Origin Cities KPI
SELECT
COUNT(DISTINCT `Origin City`) AS Total_Origin_Cities
FROM maindata;