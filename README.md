# Super Market Sales Analysis

## Project Overview
This project analyzes supermarket sales data (January 2015 to December 2018) to understand sales performance across products, customers, regions, and time. It demonstrates a data analytics workflow using Python, SQL, Excel, and Power BI.

## Objectives
- Clean and prepare sales data for analysis.
- Explore sales trends and patterns.
- Identify top-performing categories and sub-categories.
- Analyze sales by customer, region, segment, and shipping mode.
- Build a formula-based Excel dashboard.
- Build an interactive Power BI dashboard.

## Tools Used
- **Python:** Pandas, data cleaning, and exploratory data analysis (EDA)
- **SQL / MySQL:** Filtering, grouping, aggregation, and sorting
- **Excel:** Dashboard, SUMIFS and COUNTIFS summary tables, and charts
- **Power BI:** Interactive dashboard and visualizations

## Project Files
- `data/train.csv` — Original uncleaned dataset (9,800 rows)
- `data/Super_market_clean.csv` — Cleaned dataset (9,789 rows)
- `Supermarket_Sales_EDA.ipynb` — Python notebook
- `Supermarket_Sales_SQL_Project.sql` — SQL queries
- `Supermarket_Sales_Excel_Project.xlsx` — Excel dashboard (Dashboard, Detailed Charts, Summary Tables, Raw Data)
- `Super_Market_Sales_Project.pbix` — Power BI dashboard
- `Super_Market_Sales_Analysis_Presentation.pptx` — Project presentation

## Data Cleaning
- Removed 11 rows with a missing Postal Code (9,800 rows reduced to 9,789).
- Added Month, Month Name, and Year-Month columns for time-based analysis.
- The Excel file uses the same cleaned data (9,789 rows) with an extra Year column.

## Analysis Areas
- Sales by category and sub-category
- Monthly and yearly sales trends
- Top customers and products
- Sales by region, state, and city
- Segment and shipping-mode analysis

## Excel Dashboard
- 4 sheets: Dashboard, Detailed Charts, Summary Tables, and Raw Data.
- 11 charts: monthly trend, sales by year, category, region, segment, ship mode, sub-category, top 10 products, customers, states, and cities.
- Summary tables use SUMIFS and COUNTIFS formulas on the Raw Data sheet.
- KPI cards show total sales, orders, customers, unique products, average sales per order, and 2018 vs 2017 growth.

## Key Findings
- **Total Sales:** $2.25M across 4,916 orders and 793 customers
- **Top Category:** Technology (36.7% of sales)
- **Top Sub-Category:** Phones ($326K)
- **Top Customer:** Sean Miller ($25.0K)
- **Highest Sales Month:** November ($345K, all years combined)
- **Lowest Sales Month:** February ($59K, all years combined)
- **Best Year:** 2018 ($721K, up 21% from 2017)
- **Top Region:** West (31.5% of sales)

*The dataset does not contain a Profit column, so profit analysis is not included.*

## How to Use
1. Download or clone this repository.
2. Open the Python notebook in Google Colab or Jupyter Notebook.
3. Make sure the notebook uses the correct CSV file path (`data/Super_market_clean.csv`).
4. Run the notebook cells in order.
5. Run the SQL queries in MySQL Workbench, adjusting the table name if needed.
6. Open `Supermarket_Sales_Excel_Project.xlsx` in Excel to view the dashboard.
7. Open the Power BI `.pbix` file in Power BI Desktop.

## Author
Arunkumar R — [LinkedIn](https://www.linkedin.com/in/arunkumar-r-06aa1143b/)
