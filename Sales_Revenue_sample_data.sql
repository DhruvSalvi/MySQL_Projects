create database sales;
use sales;

-- Preview whole table:
select * from sales_data_sample;

-- select count(*) from sales_data_sample;

-- PrePocessing Data:
-- Check wheather particular columns are NUll or Not.
SELECT 
    (CASE WHEN country IS NULL THEN 1 ELSE 0 END +
     CASE WHEN dealsize IS NULL THEN 1 ELSE 0 END) as total_nulls_in_row
FROM sales_data_sample;

-- Difference between total data to where state is null(String): 
select 
(select count(*) from sales_data_sample) - (select count(*) from sales_data_sample where state = "") 
as difference;


-- TotalRevenue by ProductCode
select productcode, 
sum(sales) as total_revenue
from sales_data_sample
group by productcode
order by total_revenue desc;


-- MonthlyRevenue by month and year
select month_id, year_id,
sum(sales) as monthly_revenue
from sales_data_sample
group by year_id, month_id
order by year_id, month_id;


-- TotalRevenue by dealsize
select dealsize,
sum(sales) as revenue
from sales_data_sample
group by dealsize
order by revenue desc;


-- TotalRevenue by Country
select country,
sum(sales) as revenue
from sales_data_sample
group by country
order by revenue desc
limit 5;

-- TotalSpending by Customers:
select customername,
sum(sales) as Total_spending
from sales_data_sample
group by customername
order by Total_spending desc
limit 10;


-- Revenue by Status and ProductLine
select STATUS, productline,
sum(sales) as revenue
from sales_data_sample
group by  STATUS, productline
order by STATUS, productline;

