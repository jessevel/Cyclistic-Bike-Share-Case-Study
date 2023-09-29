# Case Study: How does a bike-share navigate speedy success
## A Google Data Analytics Professional Certificate Capstone Project

## Scenario
You are a junior data analyst working in the marketing analyst team at Cyclistic, a bike-share company in Chicago. The director of
marketing believes the company’s future success depends on maximizing the number of annual memberships. Therefore, your
team wants to understand how casual riders and annual members use Cyclistic bikes differently. From these insights, your team will
design a new marketing strategy to convert casual riders into annual members. But first, Cyclistic executives must

## About the company
In 2016, Cyclistic launched a successful bike-share offering. Since then, the program has grown to a fleet of 5,824 bicycles that are
geotracked and locked into a network of 692 stations across Chicago. The bikes can be unlocked from one station and returned to
any other station in the system anytime.
Until now, Cyclistic’s marketing strategy relied on building general awareness and appealing to broad consumer segments. One approach that helped make these things possible was the flexibility of its pricing plans: single-ride passes, full-day passes, and
annual memberships. Customers who purchase single-ride or full-day passes are referred to as casual riders. Customers who
purchase annual memberships are Cyclistic members.

Cyclistic’s finance analysts have concluded that annual members are much more profitable than casual riders. Although the pricing
flexibility helps Cyclistic attract more customers, Moreno believes that maximizing the number of annual members will be key to
future growth. Rather than creating a marketing campaign that targets all-new customers, Moreno believes there is a very good
chance to convert casual riders into members. She notes that casual riders are already aware of the Cyclistic program and have
chosen Cyclistic for their mobility needs.

Moreno has set a clear goal: Design marketing strategies aimed at converting casual riders into annual members. In order to do
that, however, the marketing analyst team needs to better understand how annual members and casual riders differ, why casual
riders would buy a membership, and how digital media could affect

## ASK
### Business Task
Identify the difference between the usage of Cyclistic bikes by annual and casual rider members

### Key Stakeholders
* **Lily Moreno:** The director of marketing and my manager. She is responsible for the development of campaigns and initiatives to promote the bike-share program.
* **Cyclistic Marketing Analytics Team:** A team of data analysts who are responsible for collecting, analyzing, and reporting data that helps guide Cyclistic marketing strategy.
* **Cyclistic Executive Team:** The notoriously detail-oriented executive team that will decide whether to approve the recommended marketing program

## PREPARE
### Data Location
The data used in this case study is 12-month data for the year 2022 downloaded from this [site](https://divvy-tripdata.s3.amazonaws.com/index.html).

### Data Organization
The data is well-structured. It is in CSV file format. Each file has 14 columns. There are 12 files downloaded as zip files and extracted into a folder. The downloaded data are from the year 2022 and organized by months. Each file has 14 columns named:  _ride_id, rideable_type, started_at, ended_at, start_station_name, start_station_id, end_station_name, end_station_id, start_lat, start_lng, end_lat, end_lng, and member_casual_.

### Credibility of data
The data has been made available by Motivate international Inc.and under the license of [Divvybikes](https://divvybikes.com/data-license-agreement). There is no issue with bias and credibility of data because it is Reliable, Original, Comprehensive, Current, and Cited (ROCCC).

## PROCESS
### Tools
Here's the summary of all the tools I used for the entire case study.
* Initial Cleaning and Checking: MS Excel
* Data Cleaning: MS SQL
* Analyze: MS SQL
* Dashboard Creation: Tableau

### Initial Cleaning and Checking: MS Excel
First, I opened each CSV Files and saved it as Excel Workbook. Here's the summary of what I did.
#### Initial Formatting
* Formatted the columns named started_at and ended_at as yyyy/mm/dd hh:mm:ss
* Checked if there are duplicate values and there are not.
* Applied Conditional Formatting that highlight cells that has blank or null data to easily know if there are blank data

#### Initial Checking for data errors
These are the findings of my initial checking for errors:
* With the use of filters, each categorical column was checked to ensure there are no misspellings.
* There are null data found on the ff columns:
  * Both start_station_name and start_station_id
  * Both end_station_name, end_station_id, end_lat, and end_lng
* Using the filter in rows, it was found out that the rideable_type are all electric bike that has null data in start_station_name and start_station_id 
* Not all data that are null in both start_station_name and start_station_id column that has also null data in end_station_name, end_station_id, end_lat, and end_lng columns
* All data that has null data in end_station_name, has also null data on end_station_id, end_lat, and end_lng

### Data Cleaning: MS SQL
I used MS SQL for data cleaning because it is free to use and it has the capability to handle huge datasets. The merged dataset has 5,667,719 rows.

#### Merging of 12 data table
* I imported the 12 XLS Files on MS SQL
* I created a table named annual_trip_data and inserted all the merged data using UNION ALL into the table.

#### Pre-cleaning
* Each column was checked if it has null values and there were 2 rows.
* Duplicate rows were examined by looking at the ride_id having more than 1 count
  * The result of the query shows ride_id with less than 16 characters and are in scientific notation number. This is unusual as most of the ride ids has 16 characters are in the combination of numbers and characters.
* Rows with started_at greater than ended_at were also queried. This will result with negative ride_length if not removed.
* A table named precleaned_data is created to placed all the data that is precleaned
* A query which filters out the 2 rows that has all null values, duplicate rows, ride_id with less than 16 characters, and started_at that is greater than the ended_at were inserted into the precleaned_data table.

#### Data Cleaning
##### Adding new columns
The following are the new columns added as part of the instruction. I also added started_date column for my convenience for future analysis and dashboard creation.
* **ride_length:** The difference of ended_at and started_at in minutes in INT format
* **day_of_week:** Day of week extracted from started_at column where Sunday is 1 and Saturday is 7
* **started_date:** a date data type casted from the started_at column which is in datetime format.

##### Data Cleaning
The following are the filtered out rows from the pre-cleaned_data and was inserted into a new table named cleaned_data
* _ride_length_ with less than 1 minute and greater than 1440 (24 hours)
* _start_station_name_ and _start_station_name_ with 'TEST' character
* _start_station_name_ and _start_station_id_ that are both null
* _end_station_name_ and _end_station_id_ that are both null

According to the FAQ of Divvy Bikes website (which the dataset licensed and came from), the _ride_length_ with less than 1 minute are those who redocked the bikes to make sure it was properly docked and those with more than 1440 (24 hours) are considered lost bikes. Divvy Bikes offer usage of their bikes for up to 24 hours.

The two columns: _start_station_id_ and _end_station_id_ that has null values each were not filtered out. During analysis, we will use _start_station_name_ and _end_station_name_.

### ANALYZE
After the Process phase, I now have a data table named clean_data. The following are the summary of my analysis:
* Total number of rows: 4,323,836
* The minimum ride length is 1 minute which has 61, 305 count
* The maximum ride length is 1440 minute (24 hours) which has 2 counts
* The average ride length is 17 minutes which has 99,310 counts.



