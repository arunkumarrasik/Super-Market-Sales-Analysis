/*
PROJECT: Supermarket Sales Data Analysis
TOOL: MySQL 8.0+
DATASET: Super market clean
IMPORTANT: The provided dataset has a Sales column but no Profit column.
           Do not run profit-related analysis on this dataset.

HOW TO USE:
1. Run this script in MySQL Workbench.
2. Import your CSV into the `supermarket_sales.sales_data` table, OR
   if you already imported the CSV, rename your table/columns in the queries below.
3. Run the analysis queries one at a time.

If you import through MySQL Workbench's Table Data Import Wizard, create/use
the `sales_data` table with the column names defined below.
*/

CREATE DATABASE IF NOT EXISTS supermarket_sales;
USE supermarket_sales;

-- Create the table to match the user's dataset.
-- If a table named sales_data already exists, do not run this CREATE TABLE again.
CREATE TABLE IF NOT EXISTS sales_data (
    `Row_ID` INT,
    `Order_ID` VARCHAR(30),
    `Order_Date` DATE,
    `Ship_Date` DATE,
    `Ship_Mode` VARCHAR(50),
    `Customer_ID` VARCHAR(30),
    `Customer_Name` VARCHAR(100),
    `Segment` VARCHAR(50),
    `Country` VARCHAR(100),
    `City` VARCHAR(100),
    `State` VARCHAR(100),
    `Postal_Code` VARCHAR(20),
    `Region` VARCHAR(50),
    `Product_ID` VARCHAR(50),
    `Category` VARCHAR(100),
    `Sub-Category` VARCHAR(100),
    `Product_Name` VARCHAR(255),
    `Sales` DECIMAL(14, 3)
);

-- =========================================================
-- 0. DATA CHECKS
-- =========================================================

-- Preview the data
SELECT * FROM sales_data LIMIT 10;

-- Number of rows
SELECT COUNT(*) AS Total_Rows
FROM sales_data;

-- Check duplicate Row_ID values
SELECT `Row_ID`, COUNT(*) AS Duplicate_Count
FROM sales_data
GROUP BY `Row_ID`
HAVING COUNT(*) > 1;

-- Check missing values in important columns
SELECT
    SUM(`Order_ID` IS NULL OR TRIM(`Order_ID`) = '') AS Missing_Order_ID,
    SUM(`Order_Date` IS NULL) AS Missing_Order_Date,
    SUM(`Customer_ID` IS NULL OR TRIM(`Customer_ID`) = '') AS Missing_Customer_ID,
    SUM(`Product_ID` IS NULL OR TRIM(`Product_ID`) = '') AS Missing_Product_ID,
    SUM(`Sales` IS NULL) AS Missing_Sales
FROM sales_data;

-- Check negative sales values
SELECT *
FROM sales_data
WHERE Sales < 0;

-- =========================================================
-- 1. KEY BUSINESS KPIs
-- =========================================================

-- Total sales, orders, customers, and products
SELECT
    ROUND(SUM(Sales), 2) AS Total_Sales,
    COUNT(DISTINCT `Order_ID`) AS Total_Orders,
    COUNT(DISTINCT `Customer_ID`) AS Total_Customers,
    COUNT(DISTINCT `Product_ID`) AS Total_Products,
    ROUND(AVG(Sales), 2) AS Average_Row_Sales
FROM sales_data;

-- Average sales per order
SELECT
    ROUND(SUM(Sales) / NULLIF(COUNT(DISTINCT `Order_ID`), 0), 2)
        AS Average_Sales_Per_Order
FROM sales_data;

-- =========================================================
-- 2. TIME-BASED ANALYSIS
-- =========================================================

-- Year-wise sales
SELECT
    YEAR(`Order_Date`) AS Sales_Year,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    COUNT(DISTINCT `Order_ID`) AS Total_Orders
FROM sales_data
WHERE `Order_Date` IS NOT NULL
GROUP BY YEAR(`Order_Date`)
ORDER BY Sales_Year;

-- Month-wise sales across all years
SELECT
    MONTH(`Order_Date`) AS Month_Number,
    MONTHNAME(`Order_Date`) AS Month_Name,
    ROUND(SUM(Sales), 2) AS Total_Sales
FROM sales_data
WHERE `Order_Date` IS NOT NULL
GROUP BY MONTH(`Order_Date`), MONTHNAME(`Order_Date`)
ORDER BY Month_Number;

-- Year and month-wise sales trend
SELECT
    YEAR(`Order_Date`) AS Sales_Year,
    MONTH(`Order_Date`) AS Month_Number,
    MONTHNAME(`Order_Date`) AS Month_Name,
    ROUND(SUM(Sales), 2) AS Total_Sales
FROM sales_data
WHERE `Order_Date` IS NOT NULL
GROUP BY YEAR(`Order_Date`), MONTH(`Order_Date`), MONTHNAME(`Order_Date`)
ORDER BY Sales_Year, Month_Number;

-- Best and lowest sales month (month number keeps the calendar order clear)
SELECT
    MONTH(`Order_Date`) AS Month_Number,
    MONTHNAME(`Order_Date`) AS Month_Name,
    ROUND(SUM(Sales), 2) AS Total_Sales
FROM sales_data
WHERE `Order_Date` IS NOT NULL
GROUP BY MONTH(`Order_Date`), MONTHNAME(`Order_Date`)
ORDER BY Total_Sales DESC;

-- =========================================================
-- 3. CATEGORY AND PRODUCT ANALYSIS
-- =========================================================

-- Sales by category
SELECT
    Category,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(100 * SUM(Sales) / NULLIF((SELECT SUM(Sales) FROM sales_data), 0), 2)
        AS Sales_Percentage
FROM sales_data
GROUP BY Category
ORDER BY Total_Sales DESC;

-- Sales by sub-category
SELECT
    `Sub-Category`,
    ROUND(SUM(Sales), 2) AS Total_Sales
FROM sales_data
GROUP BY `Sub-Category`
ORDER BY Total_Sales DESC;

-- Top 10 products by sales
SELECT
    Product_ID,
    Product_Name,
    ROUND(SUM(Sales), 2) AS Total_Sales
FROM sales_data
GROUP BY Product_ID, Product_Name
ORDER BY Total_Sales DESC
LIMIT 10;

-- Bottom 10 products by sales
SELECT
    Product_ID,
    Product_Name,
    ROUND(SUM(Sales), 2) AS Total_Sales
FROM sales_data
GROUP BY Product_ID, Product_Name
ORDER BY Total_Sales ASC
LIMIT 10;

-- =========================================================
-- 4. CUSTOMER ANALYSIS
-- =========================================================

-- Top 10 customers by sales
SELECT
    Customer_ID,
    Customer_Name,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    COUNT(DISTINCT Order_ID) AS Number_Of_Orders
FROM sales_data
GROUP BY Customer_ID, Customer_Name
ORDER BY Total_Sales DESC
LIMIT 10;

-- Customer sales contribution percentage
SELECT
    Customer_ID,
    Customer_Name,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(
        100 * SUM(Sales) / NULLIF((SELECT SUM(Sales) FROM sales_data), 0),
        2
    ) AS Sales_Percentage
FROM sales_data
GROUP BY Customer_ID, Customer_Name
ORDER BY Total_Sales DESC
LIMIT 10;

-- Repeat customers: customers with more than one distinct order
SELECT
    Customer_ID,
    Customer_Name,
    COUNT(DISTINCT Order_ID) AS Number_Of_Orders,
    ROUND(SUM(Sales), 2) AS Total_Sales
FROM sales_data
GROUP BY Customer_ID, Customer_Name
HAVING COUNT(DISTINCT Order_ID) > 1
ORDER BY Number_Of_Orders DESC, Total_Sales DESC;

-- =========================================================
-- 5. GEOGRAPHICAL ANALYSIS
-- =========================================================

-- Region-wise sales
SELECT
    Region,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    COUNT(DISTINCT Order_ID) AS Total_Orders
FROM sales_data
GROUP BY Region
ORDER BY Total_Sales DESC;

-- Top 10 states by sales
SELECT
    State,
    ROUND(SUM(Sales), 2) AS Total_Sales
FROM sales_data
GROUP BY State
ORDER BY Total_Sales DESC
LIMIT 10;

-- Top 10 cities by sales
SELECT
    City,
    State,
    ROUND(SUM(Sales), 2) AS Total_Sales
FROM sales_data
GROUP BY City, State
ORDER BY Total_Sales DESC
LIMIT 10;

-- =========================================================
-- 6. CUSTOMER SEGMENT AND SHIPPING ANALYSIS
-- =========================================================

-- Sales by customer segment
SELECT
    Segment,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    COUNT(DISTINCT Customer_ID) AS Total_Customers
FROM sales_data
GROUP BY Segment
ORDER BY Total_Sales DESC;

-- Sales by shipping mode
SELECT
    Ship_Mode,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    COUNT(DISTINCT Order_ID) AS Total_Orders
FROM sales_data
GROUP BY Ship_Mode
ORDER BY Total_Sales DESC;

-- Average shipping time by shipping mode
SELECT
    Ship_Mode,
    ROUND(AVG(DATEDIFF(`Ship_Date`, `Order_Date`)), 2) AS Avg_Shipping_Days
FROM sales_data
WHERE `Ship_Date` IS NOT NULL
  AND `Order_Date` IS NOT NULL
GROUP BY Ship_Mode
ORDER BY Avg_Shipping_Days;
