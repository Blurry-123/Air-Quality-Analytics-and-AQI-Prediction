SELECT *
FROM aqi_data
LIMIT 5;
--What is the overall air quality across all monitored cities?
SELECT
COUNT(*) AS total_records,
COUNT(DISTINCT "City") AS total_cities,
ROUND(AVG(aqi)::NUMERIC, 2) AS average_aqi,
MAX(aqi) AS highest_aqi,
MIN(aqi) AS lowest_aqi
FROM aqi_data;
--Which cities have the highest average AQI
SELECT
"City",
ROUND(AVG(aqi)::NUMERIC,2) AS average_aqi
FROM aqi_data
GROUP BY "City"
ORDER BY average_aqi DESC;
--Which are the Top 10 most polluted cities?
SELECT
"City",
ROUND(AVG(aqi)::NUMERIC,2) AS average_aqi
FROM aqi_data
GROUP BY "City"
ORDER BY average_aqi DESC
LIMIT 10;
--Which are the Top 10 cleanest cities?
SELECT
"City",
ROUND(AVG(aqi)::NUMERIC,2) AS average_aqi
FROM aqi_data
GROUP BY "City"
ORDER BY average_aqi
LIMIT 10;
--Which city recorded the highest AQI ever?
SELECT
"City",
"Date",
aqi
FROM aqi_data
ORDER BY aqi DESC
LIMIT 1;
--Which cities experienced the highest number of hazardous days (AQI > 300)?
SELECT
"City",
COUNT(*) AS hazardous_days
FROM aqi_data
WHERE aqi > 300
GROUP BY "City"
ORDER BY hazardous_days DESC;
--Which pollutant has the highest average concentration across all cities?
SELECT

ROUND(AVG(pm25)::NUMERIC,2) AS avg_pm25,

ROUND(AVG(pm10)::NUMERIC,2) AS avg_pm10,

ROUND(AVG(no2)::NUMERIC,2) AS avg_no2,

ROUND(AVG(so2)::NUMERIC,2) AS avg_so2,

ROUND(AVG(co)::NUMERIC,2) AS avg_co,

ROUND(AVG(o3)::NUMERIC,2) AS avg_o3

FROM aqi_data;
--Which season experiences the worst air quality?
SELECT

"Season",

ROUND(AVG(aqi)::NUMERIC,2) AS average_aqi

FROM aqi_data

GROUP BY "Season"

ORDER BY average_aqi DESC;
--Which months have the highest average AQI?
SELECT
"Month",
"Month_Name",
ROUND(AVG(aqi)::NUMERIC,2) AS average_aqi
FROM aqi_data
GROUP BY "Month","Month_Name"
ORDER BY "Month";
--What is the distribution of AQI categories?
SELECT
aqi_bucket,
COUNT(*) AS total_days,
ROUND(
COUNT(*)*100.0/
SUM(COUNT(*)) OVER()
,2) AS percentage
FROM aqi_data
GROUP BY aqi_bucket
ORDER BY total_days DESC;
--Which cities rank highest in terms of average AQI?
SELECT
    "City",
    ROUND(AVG(aqi)::NUMERIC,2) AS average_aqi,
    RANK() OVER(
        ORDER BY AVG(aqi) DESC
    ) AS city_rank
FROM aqi_data
GROUP BY "City"
ORDER BY city_rank;
--What is the dense ranking of cities based on average AQI?
SELECT
    "City",
    ROUND(AVG(aqi)::NUMERIC,2) AS average_aqi,
    DENSE_RANK() OVER(
        ORDER BY AVG(aqi) DESC
    ) AS dense_rank
FROM aqi_data
GROUP BY "City"
ORDER BY dense_rank;
--Which cities show the greatest variation in AQI?
SELECT
    "City",
    ROUND(STDDEV(aqi)::NUMERIC,2) AS pollution_variability
FROM aqi_data
GROUP BY "City"
ORDER BY pollution_variability DESC;
--Which cities experienced the most severe pollution days (AQI > 400)?
SELECT
    "City",
    COUNT(*) AS severe_days
FROM aqi_data
WHERE aqi > 400
GROUP BY "City"
ORDER BY severe_days DESC;
--How has the average AQI changed over the years?
SELECT
    "Year",
    ROUND(AVG(aqi)::NUMERIC,2) AS average_aqi
FROM aqi_data
GROUP BY "Year"
ORDER BY "Year";
--Which weekday records the highest average AQI?
SELECT
    "Weekday",
    ROUND(AVG(aqi)::NUMERIC,2) AS average_aqi
FROM aqi_data
GROUP BY "Weekday"
ORDER BY average_aqi DESC;
--Which cities have the highest average levels of major pollutants?
SELECT
    "City",
    ROUND(AVG(pm25)::NUMERIC,2) AS avg_pm25,
    ROUND(AVG(pm10)::NUMERIC,2) AS avg_pm10,
    ROUND(AVG(no2)::NUMERIC,2) AS avg_no2,
    ROUND(AVG(so2)::NUMERIC,2) AS avg_so2,
    ROUND(AVG(co)::NUMERIC,2) AS avg_co,
    ROUND(AVG(o3)::NUMERIC,2) AS avg_o3
FROM aqi_data
GROUP BY "City"
ORDER BY avg_pm25 DESC;
--Which cities have the highest Pollution Index?
SELECT
    "City",
    ROUND(AVG("Pollution_Index")::NUMERIC,2) AS avg_pollution_index
FROM aqi_data
GROUP BY "City"
ORDER BY avg_pollution_index DESC;
--Which AQI levels occur most frequently?
SELECT
    "AQI_Level",
    COUNT(*) AS total_days,
    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER(),
        2
    ) AS percentage
FROM aqi_data
GROUP BY "AQI_Level"
ORDER BY total_days DESC;
--How has the average AQI changed year-over-year for each city?
WITH yearly_aqi AS
(
    SELECT
        "City",
        "Year",
        AVG(aqi) AS average_aqi
    FROM aqi_data
    GROUP BY "City","Year"
)

SELECT
    "City",
    "Year",
    ROUND(average_aqi::NUMERIC,2) AS average_aqi,
    ROUND(
        LAG(average_aqi) OVER(
            PARTITION BY "City"
            ORDER BY "Year"
        )::NUMERIC,
        2
    ) AS previous_year_aqi,
    ROUND(
        (
            average_aqi -
            LAG(average_aqi) OVER(
                PARTITION BY "City"
                ORDER BY "Year"
            )
        )::NUMERIC,
        2
    ) AS yearly_change
FROM yearly_aqi
ORDER BY "City","Year";
--Which cities have the highest average PM2.5 concentration?
SELECT
    "City",
    ROUND(AVG(pm25)::NUMERIC,2) AS average_pm25
FROM aqi_data
GROUP BY "City"
ORDER BY average_pm25 DESC;
--Which cities have the highest average PM10 concentration?
SELECT
    "City",
    ROUND(AVG(pm10)::NUMERIC,2) AS average_pm10
FROM aqi_data
GROUP BY "City"
ORDER BY average_pm10 DESC;
--Which cities have the highest average NO₂ concentration?
SELECT
    "City",
    ROUND(AVG(no2)::NUMERIC,2) AS average_no2
FROM aqi_data
GROUP BY "City"
ORDER BY average_no2 DESC;
--Which cities have the highest average SO₂ concentration?
SELECT
    "City",
    ROUND(AVG(so2)::NUMERIC,2) AS average_so2
FROM aqi_data
GROUP BY "City"
ORDER BY average_so2 DESC;
--Which cities have the highest average CO concentration?
SELECT
    "City",
    ROUND(AVG(co)::NUMERIC,2) AS average_co
FROM aqi_data
GROUP BY "City"
ORDER BY average_co DESC;
--Which city recorded the highest Pollution Index?
SELECT
    "City",
    ROUND(MAX("Pollution_Index")::NUMERIC,2) AS highest_pollution_index
FROM aqi_data
GROUP BY "City"
ORDER BY highest_pollution_index DESC;
--Which cities experienced the greatest improvement in AQI over the years?
WITH yearly_avg AS (
    SELECT
        "City",
        "Year",
        AVG(aqi) AS avg_aqi
    FROM aqi_data
    GROUP BY "City","Year"
)

SELECT
    "City",
    ROUND(
        (MAX(avg_aqi) - MIN(avg_aqi))::NUMERIC,
        2
    ) AS aqi_difference
FROM yearly_avg
GROUP BY "City"
ORDER BY aqi_difference ASC;
--What is the 7-day rolling average AQI for each city?
SELECT
    "City",
    "Date",
    aqi,
    ROUND(
        AVG(aqi) OVER (
            PARTITION BY "City"
            ORDER BY "Date"
            ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
        )::NUMERIC,
        2
    ) AS rolling_7day_aqi
FROM aqi_data
ORDER BY "City","Date";
