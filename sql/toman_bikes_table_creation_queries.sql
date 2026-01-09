-- Create the two transational tables.
CREATE TABLE "transitional_bike_share_yr_0"(
    "id" SERIAL PRIMARY KEY,
    "dteday" TEXT,
	"season" TEXT,
	"yr" TEXT,
	"mnth" TEXT,
	"hr" TEXT,
	"holiday" TEXT,
	"weekday" TEXT,
	"workingday" TEXT,
	"weathersit" TEXT,
	"temp" TEXT,
	"atemp" TEXT,
	"hum" TEXT,
	"windspeed" TEXT,
	"rider_type" TEXT,
	"riders" TEXT
);

CREATE TABLE "transitional_bike_share_yr_1"(
    "id" SERIAL PRIMARY KEY,
    "dteday" TEXT,
	"season" TEXT,
	"yr" TEXT,
	"mnth" TEXT,
	"hr" TEXT,
	"holiday" TEXT,
	"weekday" TEXT,
	"workingday" TEXT,
	"weathersit" TEXT,
	"temp" TEXT,
	"atemp" TEXT,
	"hum" TEXT,
	"windspeed" TEXT,
	"rider_type" TEXT,
	"riders" TEXT
);

-- Creat the 'cost_table' table.
CREATE TABLE "cost_table"(
    "id_cost_table" SERIAL PRIMARY KEY,
	"yr" SMALLINT,
	"price" NUMERIC(7, 2),
	"cogs" NUMERIC(5, 2)
	);

-- Check the created tables.
SELECT * FROM "transitional_bike_share_yr_0";
SELECT * FROM "transitional_bike_share_yr_1";
SELECT * FROM "cost_table";
	
-- Create the final bike_share tables.
CREATE TABLE "bike_share_yr_0"(
    "bike_share_yr_0_id" SERIAL PRIMARY KEY,
    "dteday" DATE,
	"season" SMALLINT CHECK("season" BETWEEN 1 AND 4),
	"yr" SMALLINT CHECK("yr" >= 0),
	"mnth" SMALLINT CHECK("mnth" BETWEEN 1 AND 12),
	"hr" SMALLINT CHECK("hr" BETWEEN 0 AND 23),
	"holiday" SMALLINT CHECK("holiday" IN (0,1)),
	"weekday" SMALLINT CHECK("weekday" BETWEEN 0 AND 6),
	"workingday" SMALLINT CHECK("workingday" IN (0,1)),
	"weathersit" SMALLINT CHECK("weathersit" >= 0),
	"temp" NUMERIC(3, 2),
	"atemp" NUMERIC(5, 4),
	"hum" NUMERIC(3, 2),
	"windspeed" NUMERIC(5, 4),
	"rider_type" VARCHAR(10),
	"riders" INTEGER CHECK("riders" >= 0)
);

CREATE TABLE "bike_share_yr_1"(
    "bike_share_yr_1_id" SERIAL PRIMARY KEY,
    "dteday" DATE,
	"season" SMALLINT CHECK("season" BETWEEN 1 AND 4),
	"yr" SMALLINT CHECK("yr" >= 0),
	"mnth" SMALLINT CHECK("mnth" BETWEEN 1 AND 12),
	"hr" SMALLINT CHECK("hr" BETWEEN 0 AND 23),
	"holiday" SMALLINT CHECK("holiday" IN (0,1)),
	"weekday" SMALLINT CHECK("weekday" BETWEEN 0 AND 6),
	"workingday" SMALLINT CHECK("workingday" IN (0,1)),
	"weathersit" SMALLINT CHECK("weathersit" >= 0),
	"temp" NUMERIC(3, 2),
	"atemp" NUMERIC(5, 4),
	"hum" NUMERIC(3, 2),
	"windspeed" NUMERIC(5, 4),
	"rider_type" VARCHAR(10),
	"riders" INTEGER CHECK("riders" >= 0)
);

--Insert the data from the transational tables to the final ones.
INSERT INTO "bike_share_yr_0"(
    "dteday",
	"season",
	"yr",
	"mnth",
	"hr",
	"holiday",
	"weekday",
	"workingday",
	"weathersit",
	"temp",
	"atemp",
	"hum",
	"windspeed",
	"rider_type",
	"riders") 
SELECT
    to_date("dteday", 'DD/MM/YYYY')::date,
	"season"::smallint,
	"yr"::smallint,
	"mnth"::smallint,
	"hr"::smallint,
	"holiday"::smallint,
	"weekday"::smallint,
	"workingday"::smallint,
	"weathersit"::smallint,
	"temp"::numeric(3,2),
	"atemp"::numeric(5,4),
	"hum"::numeric(3,2),
	"windspeed"::numeric(5,4),
	"rider_type",
	"riders"::integer
FROM "transitional_bike_share_yr_0";


INSERT INTO "bike_share_yr_1"(
    "dteday",
	"season",
	"yr",
	"mnth",
	"hr",
	"holiday",
	"weekday",
	"workingday",
	"weathersit",
	"temp",
	"atemp",
	"hum",
	"windspeed",
	"rider_type",
	"riders") 
SELECT
    to_date("dteday", 'DD/MM/YYYY')::date,
	"season"::smallint,
	"yr"::smallint,
	"mnth"::smallint,
	"hr"::smallint,
	"holiday"::smallint,
	"weekday"::smallint,
	"workingday"::smallint,
	"weathersit"::smallint,
	"temp"::numeric(3,2),
	"atemp"::numeric(5,4),
	"hum"::numeric(3,2),
	"windspeed"::numeric(5,4),
	"rider_type",
	"riders"::integer
FROM "transitional_bike_share_yr_1";

-- Delete the transational tables.
DROP TABLE "transitional_bike_share_yr_0";
DROP TABLE "transitional_bike_share_yr_1";

-- Check the final tables.
SELECT * FROM "bike_share_yr_0";
SELECT * FROM "bike_share_yr_1";
SELECT * FROM "cost_table";