# Case Study: How does a bike-share navigate speedy success
## A Google Data Analytics Professional Certificate Capstone Project
<p align="center">
  <img src="https://github.com/jessevel/Cyclistic-Bike-Share-Case-Study/blob/main/images/Cyclistic%20Bike-Share%20logo.JPG">
</p>

## Scenario
I am a junior data analyst working in the marketing analyst team at Cyclistic, a bike-share company in Chicago. The director of marketing believes the company’s future success depends on maximizing the number of annual memberships. Therefore, my team wants to understand how casual riders and annual members use Cyclistic bikes differently. From these insights, my team will design a new marketing strategy to convert casual riders into annual members.

## About the company
In 2016, Cyclistic launched a successful bike-share offering. Since then, the program has grown to a fleet of 5,824 bicycles that are geotracked and locked into a network of 692 stations across Chicago. The bikes can be unlocked from one station and returned to any other station in the system anytime.
Until now, Cyclistic’s marketing strategy relied on building general awareness and appealing to broad consumer segments. One approach that helped make these things possible was the flexibility of its pricing plans: single-ride passes, full-day passes, and annual memberships. Customers who purchase single-ride or full-day passes are referred to as casual riders. Customers who purchase annual memberships are Cyclistic members.

Cyclistic’s finance analysts have concluded that annual members are much more profitable than casual riders. Although the pricing flexibility helps Cyclistic attract more customers, Moreno believes that maximizing the number of annual members will be key to future growth. Rather than creating a marketing campaign that targets all-new customers, Moreno believes there is a very good chance to convert casual riders into members. She notes that casual riders are already aware of the Cyclistic program and have chosen Cyclistic for their mobility needs.

Moreno has set a clear goal: Design marketing strategies aimed at converting casual riders into annual members. In order to do that, however, the marketing analyst team needs to better understand how annual members and casual riders differ, why casual riders would buy a membership, and how digital media could affect

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
* Visualization for each Analysis: MS Excel
* Dashboard: Tableau

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
I used MS SQL for data cleaning because it is free to use and it has the capability to handle huge datasets. The merged dataset has 5,667,719 rows. Here's the [sql](https://github.com/jessevel/Cyclistic-Bike-Share-Case-Study/blob/main/SQL%20Cyclistic%20Bike-Share.sql) that has sequel queries from Data Cleaning to Analyze Phase.

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
After the Process phase, I now have a data table named clean_data. In this stage, I am still using MS SQL. For the data visualization on each of my analysis, I will use MS Excel. After this phase, I will use Tableau to create a dashboard.

#### Descriptive Analysis
* Total number of rows: 4,323,836
* The minimum ride length is 1 minute which has 61, 305 count
* The maximum ride length is 1440 minute (24 hours) which has 2 counts
* The average ride length is 17 minutes which has 99,310 counts.
* The standard deviation of ride length is 30.92 minutes

The standard deviation indicates that there is a fair amount of variability in the ride lengths. The fact that there are 2 rides with a ride length of 1440 minutes (24 hours) indicates that some customer are using the bikes for their full 24-hour rental period. Cyclistic Bike-Share offers usage of their bike up to 24 hours and my analysis shows that during the year 2022, there are 2 rides that has 24 hours ride length.

#### Exploratory Data Analysis
To start our Exploratory Data Analysis, let's take a look at the total number of rides and the number of rides on each casual and member riders.
```sql
SELECT
	COUNT(*) AS total_rides,
	SUM(CASE WHEN member_casual = 'casual' THEN 1 ELSE 0 END) AS num_casual_rides,
	SUM(CASE WHEN member_casual = 'member' THEN 1 ELSE 0 END) AS num_member_rides
FROM PortfolioProject.dbo.clean_data
```
<img src="https://github.com/jessevel/Cyclistic-Bike-Share-Case-Study/blob/main/images/EDA%201.JPG">
Based on the result, the number of members are greater compared to the number of casual rides during the entire year of 2022. It shows that the company have a strong user base for annual membership.

<hr>
<b>Number of Rides by Rideable Type</b>

```sql
SELECT
	rideable_type,
	member_casual,
	COUNT(rideable_type) AS num_rideable_type
FROM PortfolioProject.dbo.clean_data
GROUP BY rideable_type, member_casual
ORDER BY COUNT(rideable_type) DESC
```
<img src="https://github.com/jessevel/Cyclistic-Bike-Share-Case-Study/blob/main/images/EDA%203.JPG">
<img src="https://github.com/jessevel/Cyclistic-Bike-Share-Case-Study/blob/main/images/Number%20of%20Rides%20per%20Rideable%20Type.png">
According to the bar chart above, Classic Bikes were the most popular rideable type among both casual and member riders, with 1,692,369 member rides and 881,361 rides. On the other hand, Docked bikes is the least popular with only casual riders which has 173,831 rides. This information can help in optimizing the distribution of rideable types to cater to user preferences.

<hr>
<b>Number of Rides per Week</b>

```sql
SELECT 
	member_casual,
	day_of_week,
	COUNT(ride_id) AS num_rides
FROM PortfolioProject.dbo.clean_data
GROUP BY member_casual, day_of_week
ORDER BY member_casual, day_of_week
```
<img src="https://github.com/jessevel/Cyclistic-Bike-Share-Case-Study/blob/main/images/EDA%204.jpg">
<img src="https://github.com/jessevel/Cyclistic-Bike-Share-Case-Study/blob/main/images/Number%20of%20Rides%20per%20Day.png">

Throughout the week, Casual riders showed relatively consistent low usage during weekdays, with the highest usage on weekends, specifically on Saturdays (363,961 rides) and Sundays (298,536 rides) and has the lowest number of rides Tuesdays. On the other hand, member riders have consistent high usage during weekdays, with the highest on Thursdays (411,286 rides) and has the lowest during Sundays. The data suggests that casual riders are most active during weekends while member riders are most active during weekdays.

<hr>
<b>Number of Rides per Month</b>

```sql
SELECT
	DATEPART(MONTH, started_date) AS month,
	SUM(CASE WHEN member_casual = 'casual' THEN 1 ELSE 0 END) AS num_casual_rides,
	SUM(CASE WHEN member_casual = 'member' THEN 1 ELSE 0 END) AS num_member_rides
FROM PortfolioProject.dbo.clean_data
GROUP BY DATEPART(MONTH, started_date)
ORDER BY DATEPART(MONTH, started_date)
```
<img src="https://github.com/jessevel/Cyclistic-Bike-Share-Case-Study/blob/main/images/EDA%202.JPG">
<img src="https://github.com/jessevel/Cyclistic-Bike-Share-Case-Study/blob/main/images/Number%20of%20Rides%20per%20Month.png">

Both casual and member rides show a seasonal trend because of the data shows higher usage during the warmer months. May, June, July and August have the highest number of rides for both rider types. January followed y December has the lowest number of rides for both riders, likely due to weather conditions. The company can use this information to plan marketing and promotions during peak seasons to attract more members.

<hr>
<b>Average Ride Length per Week</b>

```sql
SELECT member_casual, day_of_week, ROUND(AVG(CAST(ride_length AS FLOAT)),2) AS avg_ride_length
FROM clean_data
GROUP BY member_casual, day_of_week
ORDER BY member_casual, day_of_week;
```
<img src="https://github.com/jessevel/Cyclistic-Bike-Share-Case-Study/blob/main/images/EDA%206.JPG">
<img src="https://github.com/jessevel/Cyclistic-Bike-Share-Case-Study/blob/main/images/Average%20Ride%20Length%20per%20Day.png">

Casual riders have longer average ride lengths compared to members across all days of the week. Fridays, Saturdays and Sundays have the highest average ride length for both riders. For casual riders, the highest ride length is Saturday(27.22 minutes) while for member rider, Friday is the highest (14.15 minutes).

<hr>
<b>Average Ride Length per Month</b>

```sql
SELECT member_casual, DATEPART(MONTH, started_date) AS month, ROUND(AVG(CAST(ride_length AS FLOAT)),2) AS avg_ride_length
FROM PortfolioProject.dbo.clean_data
GROUP BY member_casual, DATEPART(MONTH, started_date)
ORDER BY member_casual, DATEPART(MONTH, started_date)
```
<img src="https://github.com/jessevel/Cyclistic-Bike-Share-Case-Study/blob/main/images/EDA%207.JPG">
<img src="https://github.com/jessevel/Cyclistic-Bike-Share-Case-Study/blob/main/images/Average%20Ride%20Length%20per%20Month.png">

Looking at the monthly data, casual riders tend to have longer average ride lengths compared to members too. May has the highest average ride length for casual riders with 27.81 minutes while June has the highest with 13.84 minutes. Both riders has the lowest ride length on December. Just like the previous analysis on the average ride length weekly, both analysis shows that casual riders may be using the bikes for leisurely rides while casual riders may be using them for shorter rides.

<hr>
<b>Top 10 Start Station Name</b>

```sql
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
ORDER BY SUM(num_rides) DESC
```
<img src="https://github.com/jessevel/Cyclistic-Bike-Share-Case-Study/blob/main/images/eda%208.JPG">
<img src="https://github.com/jessevel/Cyclistic-Bike-Share-Case-Study/blob/main/images/Top%2010.png">

The top 10 start station name based on the number of rides for the entire year 2022 is shown above. The Top 1 is Streeter Dr & Grand Ave that has also highest casual rides with 54,560 count. On the other hand the Top 8, Kingsbury St & Kinzie St has the highest member rides with 23,291 count. This indicates different station preferences for casual and member riders, which can give insights about station placement and marketing efforts.

<hr>

## SHARE
To share my data visualization to stakeholders effectively, I created an interactive dashboard using Tableau. Check out my Tableau Dashboard [here](https://public.tableau.com/views/GoogleCaseStudyCyclisticBike-ShareDashboard/Dashboard3?:language=en-US&publish=yes&:display_count=n&:origin=viz_share_link).

## ACT
### Key Findings
The analysis of Cyclistic Bike-Share data for the year 2022 has revealed several key findings:
* Classic Bikes are the most popular rideable type among both casual and member riders followed by Electric Bikes, while Docked bikes are the least popular, primarily used by casual riders.
* Casual riders are most active during weekends, while member riders are most active during weekdays.
* Both casual and member rides show a seasonal trend, with higher usage during the warmer months.
* Casual riders tend to have longer average ride lengths compared to members, indicating different usage patterns.

### Actions to Take
The following are my top three recommendations:
1. Membership Promotion
   Launch targeted marketing campaigns, promotions, and incentives to encourage casual riders to become annual members.
   * Weekend Marketing
     * Tailor marketing efforts to target casual riders on weekends
   * Seasonal Promotion
     * Plan marketing and promotional campaigns with special offers and events during warmer months, such as May, June, July and August to attract casual riders to join annual membership.
3. Optimize Rideable Type
   * Allocate resources and marketing effort toward Classic Bikes, as they are the most popular rideable type.
5. Optimize Station Placement
   * Evaluate station locations and potentially relocate or expand stations to better serve the needs of different rider types and potentially attract more users.

### Additional Data to Expand Findings
The following are the additional data needed to expand findings and gain more insights:
* Demographic Data
* User Feedback
* Weather Data

The demographic data and user feedback will help understand more the user behavior and gain more insights on the users' perspective. In addition, weather data will be useful for further analysis such as predictive analysis for the company and for users.


