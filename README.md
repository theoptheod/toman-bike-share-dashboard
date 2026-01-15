# Project Overview

## Project Title
Toman Bike Share – Power BI Dashboard

## Project Author
Theofilos P. Theodoridis

## Project Description
This project presents an interactive Power BI dashboard built for Toman Bike Share.  
The dashboard highlights key insights into the company’s financial performance, seasonal demand patterns, and customer membership behavior.  
It also includes an exploratory price elasticity analysis that evaluates the feasibility of a price increase and proposes a data‑driven adjustment strategy.

## Project Status
Completed – Version 1.0

## Objectives
The analysis was guided by a project brief sent by the Toman Bike Share company, outlining the key business questions to be addressed.

![Company's Email](images/screenshots/thoman_bike_email_requests.png)

Based on that brief, the main objectives of the project were to:
- Analyze hourly and daily revenue patterns
- Track profit and revenue trends over time
- Identify seasonal changes in demand and revenue
- Compare rider behavior between registered and casual users
- Explore price elasticity to assess the impact of potential price changes

## Tools & Technologies
A combination of database, analytics, and visualization tools was used to build this project:  
- PostgreSQL + pgAdmin — database design, schema management, and data processing
- SQL — data cleaning, transformation, and metric creation
- Power BI Desktop — dashboard development and interactive visualizations
- Power Query — data shaping and model preparation inside Power BI
- DAX — calculated measures and analytical expressions used in the dashboard

## Repository Structure
The diagram below highlights the repository layout, making it easier to understand and navigate the project.

```
├── data/                # All CSV files used in the project
│   ├── original/        # Raw source files provided by the tutorial
│   └── processed/       # Cleaned and enriched files exported from PostgreSQL
├── sql/                 # SQL scripts
├── images/              # Schema diagrams and dashboard screenshots for the README
├── powerbi/             # Power BI project files
├── LICENSE
├── .gitignore
└── README.md
```

## Data Sources
The original CSV files were provided by the tutorial instructor as part of the learning material.

Location in this repository:
data/original/

Original external source:
[Raw CSVs (source files)](https://github.com/Gaelim/YT_bike_share)

## Original Data Dictionary and Samples
The following tables outline the raw structure of the original dataset.
Sample values are also included for quick reference.

cost_table.csv
```
| name  | raw format | description                                          | example raw value | notes                                |
| :---- | :--------- | :--------------------------------------------------- | :---------------- | :----------------------------------- |
| yr    | TEXT       | Business year code (0 = first year, 1 = second year) | 0                 | Cast to SMALLINT in final schema     |
| price | TEXT       | Retail price of the goods sold                       | 3.99              | Cast to NUMERIC(7,2) in final schema |
| COGS  | TEXT       | Cost of goods sold (COGS)                            | 1.24              | Cast to NUMERIC(5,2) in final schema |
```

Sample rows:
```
yr,price,COGS
0,3.99,1.24
1,4.99,1.56
```

bike_share_yr_0.csv
```
| name       | raw format | description                                                | example raw value | notes                                |
| :--------- | :--------- | :--------------------------------------------------------- | :---------------- | :----------------------------------- |
| dteday     | TEXT       | Date string                                                | 1/1/2021          | Cast to DATE in final schema         | 
| season     | TEXT       | Season code (1 = Winter, 2 = Spring, ...)                  | 1                 | Cast to SMALLINT in final schema     |
| yr         | TEXT       | Business year code (0 or 1)                                | 0                 | Cast to SMALLINT in final schema     |
| mnth       | TEXT       | Month code (1 = January, 2 = February, ...)                | 1                 | Cast to SMALLINT in final schema     |
| hr         | TEXT       | Hour of the day (0-23)                                     | 0                 | Cast to SMALLINT in final schema     |
| holiday    | TEXT       | Holiday flag (0 = False, 1 = True)                         | 0                 | Cast to SMALLINT in final schema     |
| weekday    | TEXT       | Weekday code starting from Friday (0) through Thursday (6) | 6                 | Cast to SMALLINT in final schema     |
| workingday | TEXT       | Workday flag (0 = False, 1 = True)                         | 0                 | Cast to SMALLINT in final schema     |
| weathersit | TEXT       | Weather situation code                                     | 1                 | Cast to SMALLINT in final schema     |
| temp       | TEXT       | Normalized actual temperature                              | 0.25              | Cast to NUMERIC(3,2) in final schema |
| atemp      | TEXT       | Normalized “feels‑like” temperature                        | 0.2576            | Cast to NUMERIC(5,4) in final schema |
| hum        | TEXT       | Normalized humidity level                                  | 0.88              | Cast to NUMERIC(3,2) in final schema |
| windspeed  | TEXT       | Normalized wind speed                                      | 0.2537            | Cast to NUMERIC(5,4) in final schema |
| rider_type | TEXT       | Rider category (casual or registered)                      | casual            | Cast to VARCHAR(10) in final schema  |
| riders     | TEXT       | Number of riders in the transaction                        | 2                 | Cast to INT in final schema          |
```

Sample rows:
```
dteday,season,yr,mnth,hr,holiday,weekday,workingday,weathersit,temp,atemp,hum,windspeed,rider_type,riders
1/1/2021,1,0,1,0,0,6,0,1,0.24,0.2879,0.81,0,casual,3
1/1/2021,1,0,1,1,0,6,0,1,0.22,0.2727,0.8,0,casual,8
```

bike_share_yr_1.csv  
This file has the same structure and column definitions as bike_share_yr_0.csv.

Sample rows:
```
dteday,season,yr,mnth,hr,holiday,weekday,workingday,weathersit,temp,atemp,hum,windspeed,rider_type,riders
1/1/2022,1,1,1,0,0,0,0,1,0.36,0.3788,0.66,0,casual,5
1/1/2022,1,1,1,1,0,0,0,1,0.36,0.3485,0.66,0.1343,casual,15
```

##  Database
A PostgreSQL database was created, and transactional tables were populated using the raw CSV files described above.

### Primary key design and import workflow  
The final schema created, uses surrogate primary keys for clarity and maintainability:  
- `bike_share_yr_0_id` was created for the `bike_share_yr_0` table
- `bike_share_yr_1_id` was created for the `bike_share_yr_1` table
- `cost_table_id` was created for the `cost_table` table
 
To ensure safe and consistent data import:

1. Raw CSVs are first loaded into transitional tables, where all columns are stored as TEXT.
This allows controlled casting, validation, and error handling.

2. Final tables are then populated from these transitional tables, applying the appropriate data types and transformations.

### Data Quality Issues & Cleaning Decisions
During data exploration, several inconsistencies were identified in the original dataset.
Before applying corrective transformations, general data quality checks were performed:
- Verified no duplicates or missing values
- Ensured consistent formatting and correct data types during import
- Confirmed completeness and alignment between transactional and cost data

Two key issues required additional corrective transformations:

**1. Non‑standard day‑of‑week encoding**  
The original dataset encoded weekdays in an unusual order:
- 0 = Saturday
- 6 = Friday

To align with common analytical standards, the field `iso_weekday` was created using the ISO convention:
- 1 = Monday
- 7 = Sunday

This ensures compatibility with time‑series analysis and standard BI tools.

**2. Astronomical season boundaries**    
The original `season` column was based on astronomical definitions:
- Spring begins around 20 March
- Summer begins around 21 June
- Fall begins around 22 September
- Winter begins around 21 December

While technically correct, these boundaries do not align with typical business or meteorological seasons and produced inconsistent seasonal groupings.
The `season_calendar` field was created using meteorological seasons:
- Winter: December–February
- Spring: March–May
- Summer: June–August
- Fall: September–November

This provides a more intuitive seasonal segmentation.

#### Derived Metrics
Two fields were generated directly in SQL to enrich the final dataset before export.  
These derived metrics (`revenue` and `profit`) combine rider counts with pricing information from the `cost_table` table ,
allowing key financial insights to be presented through the Power BI analysis and dashboard.

Full scripts are available in the /sql folder.
```
-- Snippet for revenue.
...
"cte_bike_shares"."riders" * "cost_table"."price" AS "revenue"
...
-- Snippet for profit.
...
"cte_bike_shares"."riders" * ("cost_table"."price" - "cost_table"."cogs") AS "profit"
...
```

#### SQL Transformations
The following SQL scripts were used to correct weekday encoding and generate the new meteorological season field.

Full scripts are available in the /sql folder.
```
-- Snippet for day-of-week fix.
...
DATE_PART('isodow', cte_bike_shares.dteday)::int AS "iso_weekday"
...

-- Snippet for season fix.
...
CASE
	WHEN EXTRACT(MONTH FROM "cte_bike_shares"."dteday")::int IN (12, 1, 2) THEN '1'
	WHEN EXTRACT(MONTH FROM "cte_bike_shares"."dteday")::int IN (3, 4, 5) THEN '2'
	WHEN EXTRACT(MONTH FROM "cte_bike_shares"."dteday")::int IN (6, 7, 8) THEN '3'
	WHEN EXTRACT(MONTH FROM "cte_bike_shares"."dteday")::int IN (9, 10, 11) THEN '4'
END AS "season_calendar"
...
```

### Database Schema
The following diagram illustrates the final relational schema used in PostgreSQL after cleaning, casting, and applying surrogate keys.
This schema served as the source for the exported dataset used in Power BI.

![Database Schema](images/screenshots/database_diagram_version_b.png)

## Exported Data Structure
The final analytical dataset was exported from PostgreSQL after all cleaning, transformations, and derived metric calculations were applied.
This exported CSV contains:
- combined records from both bike‑share tables
- pricing and cost information from cost_table
- derived financial metrics (`revenue`, `profit`)
- cleaned fields (`iso_weekday`, `season_calendar`)

This dataset serves as the single source used in the Power BI dashboard.

## Processed Files
This is the CSV file exported from the PostgreSQL database after cleaning and transformation.

Location in this repository:
data/processed/

## Key Features & Insights
This section summarizes the primary analytical findings derived from the dashboard,  
highlighting the patterns, behaviors, and business implications revealed through the data.  
Each insight corresponds to a dedicated section within the dashboard.

### 1. Hourly Revenue Trends
Dashboard Element: Daily Revenue Table
- Displays revenue for each working hour across all days of the week.
- Identifies consistent peak and off‑peak periods, supporting decisions related to staffing, bike allocation, and operational efficiency.
- Reveals demand concentration during specific hours, facilitating targeted service adjustments.

### 2. Profit & Revenue Analysis
Dashboard Elements: Riders Over Time (Vertical Bar Chart) and Average of Profit and Revenue Over Time (Line Chart)
- Provide month‑over‑month and year‑over‑year comparisons of rider volume, revenue, and profit.
- Highlight long‑term growth patterns, including seasonal surges and year‑to‑year improvements.
- Show that revenue and profit increase steadily during warmer months, with a pronounced peak in summer 2022—indicating strong seasonal effects.

### 3. Seasonal Revenue Patterns
Dashboard Element: Sum of Revenue by Season (Horizontal Bar Chart)
- Aggregates total revenue by season, clearly identifying high‑demand periods.
- Confirms that summer generates the highest revenue, reinforcing the importance of seasonal marketing and resource planning.
- Supports strategic decisions related to pricing, promotions, and inventory allocation during peak seasons.

### 4. Membership Status
Dashboard Element: Membership Status (Donut Chart)
- Breaks down the customer base into registered and casual riders, showing both percentages and absolute counts.
- Highlights customer segmentation patterns that can inform targeted promotions, loyalty programs, and differentiated pricing strategies.
- Helps assess the effectiveness of membership initiatives and opportunities for customer conversion.

### 5. Price Elasticity Analysis
Dashboard Element: Price Elasticity Analysis & Strategic Recommendations (Sheet 2)

Price Elasticity Analysis

Elasticity (PED): 2.59
Demand is highly elastic, even after a 25% price increase.

Key Metrics
COGS ↑ 25.8%
Price increased from €3.99 → €4.99 (+25%).
Customer base increased by 65%.
Profit more than doubled with no drop in demand.

Interpretation
Customers remained highly responsive despite the price increase.
Demand grew faster than price, showing strong pricing power.
A further price increase is unlikely to significantly reduce customer volume.

## Dashboard Design
The dashboard layout was designed for clarity and ease of exploration,  
with consistent styling and interactive elements that support intuitive analysis.
- Clean, intuitive layout for easy navigation
- Interactive slicers for flexible exploration
- Company logo integrated into the design
- Consistent color palette and typography

## Dashboard Preview
Screenshot of the dashboard:
![Dashboard](images/screenshots/screeenshot_dashboard_version_b_sheet1.png)

## How to Use the Dashboard
- Download the `.pbix` file from the /powerbi folder
- Download the processed CSV from `/data/processed/` folder
- Open the `.pbix` file in Power BI Desktop
- Update the file path to the CSV if needed
- Use the slicers and visuals to explore insights

## Conclusions & Recommendations
### Recommended Pricing Approach
#### Primary Strategy: Staircase Pricing
Market‑driven approach that leverages strong elasticity.
Steps:
- Step 1: Increase price by 5%.
- Step 2: Monitor for 4–8 weeks, tracking:
         * Units sold
         * Customer complaints
         * Repeat purchase rate
         * Social media sentiment
         * Competitor pricing
- Step 3: If demand remains stable, increase an additional 5–10%.

#### Secondary Guideline: Cost‑Aligned Adjustments
A safeguard to ensure price increases remain justified.
- COGS increased from 1.24 → 1.56 (+25.8%), aligning with the previous price increase.
- Future price adjustments should consider COGS trends.
- If COGS remains stable, apply price increases more cautiously.

## Recommendations Preview
Screenshot of the analysis and recommendations:
![Recommendations](images/screenshots/screeenshot_dashboard_version_b_sheet2.png)

## Contact
If you have questions or would like to connect, feel free to reach out through the links below:
- [LinkedIn](https://www.linkedin.com/in/theofilosptheodoridis/)
- [Portfolio Projects Website](https://theoptheod.github.io/)

## Acknowledgments  
This project was inspired by a [YouTube tutorial](https://www.youtube.com/watch?v=jdGJWloo-OU&t=2477s)
created by [Absent Data](https://www.youtube.com/@absentdata).

While the tutorial provided valuable guidance, my implementation diverges in several key areas:
- Built a PostgreSQL database using pgAdmin instead of SQL Server and SQL Server Management Studio (SSMS)
- Exported the cleaned dataset to CSV for use in Power BI, rather than connecting directly to SQL Server
- Addressed multiple data quality issues that were not covered in the tutorial
- Designed a custom dashboard layout and visual set

## License
This project is released under the MIT License. See the LICENSE file for details.


