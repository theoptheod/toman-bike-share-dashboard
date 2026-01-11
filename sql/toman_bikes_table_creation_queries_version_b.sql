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

-- Create the 'cost_table' table.
CREATE TABLE "cost_table"(
    "cost_table_id" SERIAL PRIMARY KEY,
	"yr" SMALLINT,
	"price" NUMERIC(7, 2),
	"cogs" NUMERIC(5, 2)
);

SELECT * FROM "transitional_bike_share_yr_0";
SELECT * FROM "transitional_bike_share_yr_1";
SELECT * FROM "cost_table";

-- Create the final bike_share tables.
CREATE TABLE "bike_share_yr_0"(
    "bike_share_yr_0_id" SERIAL PRIMARY KEY,
    "cost_table_id" INT NOT NULL,
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
	"riders" INTEGER CHECK("riders" >= 0),
	FOREIGN KEY ("cost_table_id") REFERENCES "cost_table"("cost_table_id")
);

CREATE TABLE "bike_share_yr_1"(
    "bike_share_yr_1_id" SERIAL PRIMARY KEY,
    "cost_table_id" INT NOT NULL,
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
	"riders" INTEGER CHECK("riders" >= 0),
	FOREIGN KEY ("cost_table_id") REFERENCES "cost_table"("cost_table_id")
);

--Insert the data from the transational tables to the final ones.
INSERT INTO "bike_share_yr_0"(
    "cost_table_id",
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
    "c"."cost_table_id",
    to_date("t"."dteday", 'DD/MM/YYYY')::date,
	"t"."season"::smallint,
	"t"."yr"::smallint,
	"t"."mnth"::smallint,
	"t"."hr"::smallint,
	"t"."holiday"::smallint,
	"t"."weekday"::smallint,
	"t"."workingday"::smallint,
	"t"."weathersit"::smallint,
	"t"."temp"::numeric(3,2),
	"t"."atemp"::numeric(5,4),
	"t"."hum"::numeric(3,2),
	"t"."windspeed"::numeric(5,4),
	"t"."rider_type",
	"t"."riders"::integer
FROM "transitional_bike_share_yr_0" AS "t"
JOIN "cost_table" AS "c"
    ON "c"."yr" = "t"."yr"::smallint;;

INSERT INTO "bike_share_yr_1"(
    "cost_table_id",
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
    "c"."cost_table_id",
    to_date("t"."dteday", 'DD/MM/YYYY')::date,
	"t"."season"::smallint,
	"t"."yr"::smallint,
	"t"."mnth"::smallint,
	"t"."hr"::smallint,
	"t"."holiday"::smallint,
	"t"."weekday"::smallint,
	"t"."workingday"::smallint,
	"t"."weathersit"::smallint,
	"t"."temp"::numeric(3,2),
	"t"."atemp"::numeric(5,4),
	"t"."hum"::numeric(3,2),
	"t"."windspeed"::numeric(5,4),
	"t"."rider_type",
	"t"."riders"::integer
FROM "transitional_bike_share_yr_1" AS "t"
JOIN "cost_table" AS "c"
    ON "c"."yr" = "t"."yr"::smallint;;

-- Check the final tables.
SELECT * FROM "bike_share_yr_0";
SELECT * FROM "bike_share_yr_1";
SELECT * FROM "cost_table";

-- Delete the transational tables.
DROP TABLE "transitional_bike_share_yr_0";
DROP TABLE "transitional_bike_share_yr_1";