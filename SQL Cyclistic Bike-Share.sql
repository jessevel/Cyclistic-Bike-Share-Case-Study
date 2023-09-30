-- Creating a table named annual_trip_data

DROP TABLE if exists annual_trip_data

CREATE TABLE annual_trip_data
(
ride_id nvarchar(255),
rideable_type nvarchar(50),
started_at datetime,
ended_at datetime,
start_station_name nvarchar(255),
start_station_id nvarchar(255),
end_station_name nvarchar(255),
end_station_id nvarchar (255),
start_lat float,
start_lng float,
end_lat float,
end_lng float,
member_casual nvarchar(50)
)

--merging the 12 table and inserting it into the table named annual_trip_data
INSERT INTO annual_trip_data
SELECT *
FROM
(
SELECT *
FROM PortfolioProject.dbo.[202201-divvy-tripdata]
UNION ALL
SELECT *
FROM PortfolioProject.dbo.[202202-divvy-tripdata]
UNION ALL
SELECT *
FROM PortfolioProject.dbo.[202203-divvy-tripdata]
UNION ALL
SELECT *
FROM PortfolioProject.dbo.[202204-divvy-tripdata]
UNION ALL
SELECT *
FROM PortfolioProject.dbo.[202205-divvy-tripdata]
UNION ALL
SELECT *
FROM PortfolioProject.dbo.[202206-divvy-tripdata]
UNION ALL
SELECT *
FROM PortfolioProject.dbo.[202207-divvy-tripdata]
UNION ALL
SELECT *
FROM PortfolioProject.dbo.[202208-divvy-tripdata]
UNION ALL
SELECT *
FROM PortfolioProject.dbo.[202209-divvy-tripdata]
UNION ALL
SELECT *
FROM PortfolioProject.dbo.[202210-divvy-tripdata]
UNION ALL
SELECT *
FROM PortfolioProject.dbo.[202211-divvy-tripdata]
UNION ALL
SELECT *
FROM PortfolioProject.dbo.[202212-divvy-tripdata]
)annual

--CHECKING THE CONTENTS annual_trip_data TABLE
--checks the column names and its data type
USE PortfolioProject;
SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'annual_trip_data';

--checks the rows on each columns
SELECT TOP 100 *
FROM PortfolioProject.dbo.annual_trip_data
ORDER BY started_at

--counts the no. of rows
SELECT COUNT(*)
FROM PortfolioProject.dbo.annual_trip_data

--------------------------------------------------------------------------------
--PRECLEANING DATA
--Checking if each column has null values
SELECT *
FROM PortfolioProject.dbo.annual_trip_data
WHERE ride_id IS NULL
	AND rideable_type IS NULL
	AND started_at IS NULL
	AND ended_at IS NULL
	AND start_station_name IS NULL
	AND start_station_id IS NULL
	AND end_station_name IS NULL
	AND end_station_id IS NULL
	AND start_lat IS NULL
	AND start_lng IS NULL
	AND end_lat IS NULL
	AND end_lng IS NULL
	AND member_casual IS NULL

--checking if there are duplicate rows by looking at ride_id
SELECT *
FROM PortfolioProject.dbo.annual_trip_data
WHERE ride_id IN (
    SELECT ride_id
    FROM PortfolioProject.dbo.annual_trip_data
    GROUP BY ride_id
    HAVING COUNT(ride_id) > 1
)

--checks all rows that has ride_id less than 16 characters
SELECT *
FROM PortfolioProject.dbo.annual_trip_data
WHERE LEN(ride_id) < 16

--checking if there are started_at greater than ended_at
SELECT *
FROM PortfolioProject.dbo.annual_trip_data
WHERE started_at > ended_at


--removing all the null values and all rows that has started_at > ended_at values
CREATE TABLE precleaned_data
(
	ride_id nvarchar(255),
	rideable_type nvarchar(50),
	started_at datetime,
	ended_at datetime,
	start_station_name nvarchar(255),
	start_station_id nvarchar(255),
	end_station_name nvarchar(255),
	end_station_id nvarchar (255),
	start_lat float,
	start_lng float,
	end_lat float,
	end_lng float,
	member_casual nvarchar(50)
)

INSERT INTO precleaned_data
SELECT *
FROM PortfolioProject.dbo.annual_trip_data
WHERE NOT (
	ride_id IS NULL
	AND rideable_type IS NULL
	AND started_at IS NULL
	AND ended_at IS NULL
	AND start_station_name IS NULL
	AND start_station_id IS NULL
	AND end_station_name IS NULL
	AND end_station_id IS NULL
	AND start_lat IS NULL
	AND start_lng IS NULL
	AND end_lat IS NULL
	AND end_lng IS NULL
	AND member_casual IS NULL
	OR started_at > ended_at
	OR LEN(ride_id) < 16
)

--counts the no. of rows
SELECT COUNT(*)
FROM PortfolioProject.dbo.precleaned_data

--checks the column names and its data type
USE PortfolioProject;
SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'precleaned_data';

-- create new columns for ride_length, day_of_week, month and year
ALTER TABLE precleaned_data
ADD ride_length INT;

UPDATE precleaned_data
SET ride_length = CAST(DATEDIFF(MINUTE,started_at,ended_at) AS INT)

ALTER TABLE precleaned_data
ADD day_of_week INT;

UPDATE precleaned_data
SET day_of_week = DATEPART(DW, started_at)

ALTER TABLE PortfolioProject.dbo.precleaned_data
ADD started_date DATE;

UPDATE precleaned_data
SET started_date = CAST(started_at AS DATE)

USE PortfolioProject;
SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'precleaned_data'

SELECT TOP 100 *
FROM precleaned_data


----------------------------------------------------------------------------------------
--CLEANING THE DATA
--checks the data that has ride_length less than 1 minute
--ride_length that has less than 1 minute results from redocking to bikes
--making sure they're properly docked
SELECT *
FROM PortfolioProject.dbo.precleaned_data
WHERE ride_length < 1

--checking how many ride_length that is greater than 1,440 minutes (24 hrs)
--ride_length having more than 24 hrs is considered as lost bike or not properly docked.
SELECT *
FROM PortfolioProject.dbo.precleaned_data
WHERE ride_length > 1440

--checking if there are word 'TEST' at start_station_name or at end_station_name
SELECT *
FROM PortfolioProject.dbo.precleaned_data
WHERE start_station_name LIKE '%TEST%' OR end_station_name LIKE '%TEST%'

--checking the null values on each column on precleaned_data table
SELECT COUNT(*)
FROM PortfolioProject.dbo.precleaned_data
WHERE start_station_name IS NULL

SELECT COUNT(*)
FROM PortfolioProject.dbo.precleaned_data
WHERE start_station_id IS NULL

SELECT COUNT(*)
FROM PortfolioProject.dbo.precleaned_data
WHERE start_station_name IS NULL
	AND start_station_id IS NULL

--checking what's common in both start_station_name and start_station_id null data
SELECT *
FROM PortfolioProject.dbo.precleaned_data
WHERE start_station_name IS NULL
	AND start_station_id IS NULL

SELECT COUNT(*) AS all_nulldata,
	COUNT(rideable_type) AS all_rideable_type
FROM PortfolioProject.dbo.precleaned_data
WHERE start_station_name IS NULL
	AND start_station_id IS NULL
	AND rideable_type = 'electric_bike'
--There is an equal count of both count column, therefore, all data who has null data in
--both start_station_name and start_station_id are electric bikes

--examines the null values of both end_station_name and end_station_id
SELECT *
FROM PortfolioProject.dbo.precleaned_data
WHERE (end_station_name IS NULL
	AND end_station_id IS NULL)

--examine rows that has null values in both end_station_name and end_station_id
--and both start_station_name and start_station_id
SELECT *
FROM PortfolioProject.dbo.precleaned_data
WHERE (end_station_name IS NULL
	AND end_station_id IS NULL)
	OR (start_station_name IS NULL
	AND start_station_id IS NULL)

-- check the null values on start_station_id column
SELECT *
FROM PortfolioProject.dbo.precleaned_data
where start_station_id IS NULL

--check the null data on end_station_id
SELECT *
FROM PortfolioProject.dbo.precleaned_data
where end_station_id IS NULL

--the null values on start_station_id and end_station_id will not be included on cleaning the data
--the start_station_name and end_station_name should be prioritized that there should be no
--null values

--counting the number of rows to be removed
SELECT COUNT(*)
FROM PortfolioProject.dbo.precleaned_data
WHERE ((ride_length < 1
OR ride_length > 1440)
OR (start_station_name LIKE '%TEST%' OR end_station_name LIKE '%TEST%')
OR (start_station_name IS NULL AND start_station_id IS NULL)
OR (end_station_name IS NULL AND end_station_id IS NULL))

--removing the rows that has null values on the following
--creating a new table named clean_data
DROP TABLE if exists clean_data
CREATE TABLE clean_data
(
	ride_id nvarchar(255),
	rideable_type nvarchar(50),
	started_at datetime,
	ended_at datetime,
	start_station_name nvarchar(255),
	start_station_id nvarchar(255),
	end_station_name nvarchar(255),
	end_station_id nvarchar (255),
	start_lat float,
	start_lng float,
	end_lat float,
	end_lng float,
	member_casual nvarchar(50),
	ride_length int,
	day_of_week int,
	started_date date
)

--inserting the filtered out data into the clean_data table
INSERT INTO clean_data
SELECT *
FROM PortfolioProject.dbo.precleaned_data
WHERE (ride_length >= 1 AND ride_length <= 1440)
	AND NOT start_station_name LIKE '%TEST%'
	AND NOT (start_station_name IS NULL AND start_station_id IS NULL)
	AND NOT (end_station_name IS NULL AND end_station_id IS NULL)

--checking the column and data type of clean_data table
USE PortfolioProject;
SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'clean_data';

--------------------------------------------------------------------------
--checking if the clean_data table has been successfully cleaned
SELECT COUNT(*)
FROM PortfolioProject.dbo.clean_data

SELECT COUNT(*)
FROM PortfolioProject.dbo.clean_data
WHERE ride_length < 1

SELECT COUNT(*)
FROM PortfolioProject.dbo.clean_data
WHERE ride_length > 1440

SELECT COUNT(*)
FROM PortfolioProject.dbo.clean_data
WHERE start_station_name IS NULL AND start_station_id IS NULL

SELECT COUNT(*)
FROM PortfolioProject.dbo.clean_data
WHERE end_station_name IS NULL AND end_station_id IS NULL
-----------------------------------------------------
---------------------ANALYZE-------------------------
----------------Descriptive Analysis-----------------
SELECT COUNT(*)
FROM PortfolioProject.dbo.clean_data

SELECT
	MIN(ride_length) as min_ride_length
FROM PortfolioProject.dbo.clean_data

SELECT COUNT(*) AS count_min_ride_length
FROM PortfolioProject.dbo.clean_data
WHERE ride_length = 1

SELECT
	MAX(ride_length) as min_ride_length
FROM PortfolioProject.dbo.clean_data

SELECT COUNT(*) AS count_max_ride_length
FROM PortfolioProject.dbo.clean_data
WHERE ride_length = 1440

SELECT
	AVG(ride_length) as min_ride_length
FROM PortfolioProject.dbo.clean_data

SELECT COUNT(*) AS count_avg_ride_length
FROM PortfolioProject.dbo.clean_data
WHERE ride_length = 17

SELECT
	STDEV(ride_length)
FROM PortfolioProject.dbo.clean_data


----------------------EDA-------------------------

--count the total rides, number of casual rides and member rides
SELECT
	COUNT(*) AS total_rides,
	SUM(CASE WHEN member_casual = 'casual' THEN 1 ELSE 0 END) AS num_casual_rides,
	SUM(CASE WHEN member_casual = 'member' THEN 1 ELSE 0 END) AS num_member_rides
FROM PortfolioProject.dbo.clean_data

--analyze the number of rides per rideable_type by member_casual
SELECT
	rideable_type,
	member_casual,
	COUNT(rideable_type) AS num_rideable_type
FROM PortfolioProject.dbo.clean_data
GROUP BY rideable_type, member_casual
ORDER BY COUNT(rideable_type) DESC

--examine the number of rides by member type and day of the week
SELECT 
	member_casual,
	day_of_week,
	COUNT(ride_id) AS num_rides
FROM PortfolioProject.dbo.clean_data
GROUP BY member_casual, day_of_week
ORDER BY member_casual, day_of_week

--examine the number of rides per month
SELECT
	DATEPART(MONTH, started_date) AS month,
	SUM(CASE WHEN member_casual = 'casual' THEN 1 ELSE 0 END) AS num_casual_rides,
	SUM(CASE WHEN member_casual = 'member' THEN 1 ELSE 0 END) AS num_member_rides
FROM PortfolioProject.dbo.clean_data
GROUP BY DATEPART(MONTH, started_date)
ORDER BY DATEPART(MONTH, started_date)

--get the avg ride length by member type and day of the week
SELECT member_casual, day_of_week, ROUND(AVG(CAST(ride_length AS FLOAT)),2) AS avg_ride_length
FROM clean_data
GROUP BY member_casual, day_of_week
ORDER BY member_casual, day_of_week;

--get the avg ride length by member type and month
SELECT member_casual, DATEPART(MONTH, started_date) AS month, ROUND(AVG(CAST(ride_length AS FLOAT)),2) AS avg_ride_length
FROM PortfolioProject.dbo.clean_data
GROUP BY member_casual, DATEPART(MONTH, started_date)
ORDER BY member_casual, DATEPART(MONTH, started_date)

-- get the top 10 most popular start

SELECT top 10
  start_station_name,
  SUM(num_casual_rides) AS total_casual_rides,
  SUM(num_member_rides) AS total_member_rides
FROM (
SELECT
    start_station_name,
    COUNT(*) AS num_rides,
    SUM(CASE WHEN member_casual = 'casual' THEN 1 ELSE 0 END) AS num_casual_rides,
    SUM(CASE WHEN member_casual = 'member' THEN 1 ELSE 0 END) AS num_member_rides
  FROM PortfolioProject.dbo.clean_data
  GROUP BY start_station_name
) AS rides
GROUP BY start_station_name
ORDER BY SUM(num_rides) DESC;

--exporting clean_data as CSV file for analysis
--and creation of data visualization and dashboard
SELECT
	started_date,
	rideable_type,
	member_casual,
	ride_length,
	day_of_week
FROM PortfolioProject.dbo.clean_data