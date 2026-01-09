-- Output the data stored in 'cost_table' .
SELECT
    *
FROM "cost_table";

-- Using UNION ALL (to show duplicates) we output
-- the combined data of the two bike_share tables. 
SELECT
    *
FROM "bike_share_yr_0"
UNION ALL
SELECT
    *
FROM "bike_share_yr_1";

-- Create a cte with the same output.
WITH "cte_bike_shares" AS(
    SELECT
        *
    FROM "bike_share_yr_0"
    UNION ALL
    SELECT
        *
    FROM "bike_share_yr_1")

SELECT
    *
FROM "cte_bike_shares";

-- Using the above cte, we join
-- the three tables of the database
-- and the query for the columns we will use.

-- We also use the data of the table to calculate
-- revenue and profits for the two years of the company's operation.
-- Also we output two new columns, 'iso_weekday' and 'season_calendar'
-- that fix the weekday and season issues of the data discussed in the project's README file.
WITH "cte_bike_shares" AS(
    SELECT
        *
    FROM "bike_share_yr_0"
    UNION ALL
    SELECT
        *
    FROM "bike_share_yr_1")

SELECT
    "cte_bike_shares"."dteday",
	"cte_bike_shares"."season",
	"cte_bike_shares"."yr",
	"cte_bike_shares"."weekday",
	"cte_bike_shares"."hr",
	"cte_bike_shares"."rider_type",
	"cte_bike_shares"."riders",
	"cost_table"."price",
	"cost_table"."cogs",
	"cte_bike_shares"."riders" * "cost_table"."price" AS "revenue",
	"cte_bike_shares"."riders" * ("cost_table"."price" - "cost_table"."cogs") AS "profit",
	DATE_PART('isodow', cte_bike_shares.dteday)::int AS "iso_weekday",
	CASE
	    WHEN EXTRACT(MONTH FROM "cte_bike_shares"."dteday")::int IN (12, 1, 2) THEN '1'
		WHEN EXTRACT(MONTH FROM "cte_bike_shares"."dteday")::int IN (3, 4, 5) THEN '2'
		WHEN EXTRACT(MONTH FROM "cte_bike_shares"."dteday")::int IN (6, 7, 8) THEN '3'
		WHEN EXTRACT(MONTH FROM "cte_bike_shares"."dteday")::int IN (9, 10, 11) THEN '4'
	END AS "season_calendar"
FROM "cte_bike_shares"
LEFT JOIN "cost_table"
    ON "cte_bike_shares"."yr" = "cost_table"."yr";