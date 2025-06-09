-- Data Wrangling
-- creating database 
create database sql_capstone_project;

-- Accessing the database
use sql_capstone_project;

-- creating table
create table amazon_sales (
    invoice_id varchar(30) primary key not null ,
    branch varchar(5) not null,
    city varchar(30) not null,
    customer_type varchar(30) not null,
    gender varchar(10) not null,
    product_line varchar(100) not null,
    unit_price decimal(10, 2) not null,
    quantity int not null,
    vat float not null,
    total decimal(10, 2) not null,
    date date not null,
    time time not null,
    payment_method varchar(50) not null, 
    cogs decimal(10, 2) not null,
    gross_margin_percentage float not null,
    gross_income decimal(10, 2) not null,
    rating float not null
);

-- VERIFYING DATA
select * from amazon_sales;

-- Total row count
select count(*) from amazon_sales;

-- Check for duplicate Invoice IDs
select invoice_id, count(*)  from amazon_sales
group by invoice_id 
having count(*)  > 1;

-- Check for NULL values in each column
select
    count(*) - count(invoice_id) as invoice_id_nulls,
    count(*) - count(branch) as branch_nulls,
    count(*) - count(city) as city_nulls,
    count(*) - count(customer_type) as customer_type_nulls,
    count(*) - count(gender) as gender_nulls,
    count(*) - count(product_line) as product_line_nulls,
    count(*) - count(unit_price) as unit_price_nulls,
    count(*) - count(quantity) as quantity_nulls,
    count(*) - count(VAT) as VAT_nulls,
    count(*) - count(total) as total_nulls,
    count(*) - count(date) as date_nulls,
    count(*) - count(time) as time_nulls,
    count(*) - count(payment_method) as payment_method_nulls,
    count(*) - count(cogs) as cogs_nulls,
    count(*) - count(gross_margin_percentage) as gross_margin_percentage_nulls,
    count(*) - count(gross_income) as gross_income_nulls,
    count(*) - count(rating) as rating_nulls
from Amazon_sales;

-- Feature Engineering:

--  add timeofday column (morning, afternoon, evening)
alter table amazon_sales add column timeofday varchar(20);

set sql_safe_updates = 0;
update amazon_sales
set timeofday = 
    case 
        when time(time) between '06:00:00' and '12:00:00' then 'morning'
        when time(time) between '12:00:01' and '18:00:00' then 'afternoon'
        else 'evening'
    end;

--  add dayname column (mon, tue, etc.)
alter table amazon_sales add column dayname varchar(10);

update amazon_sales
set dayname = 
    case dayofweek(date)
        when 1 then 'sun'
        when 2 then 'mon'
        when 3 then 'tue'
        when 4 then 'wed'
        when 5 then 'thu'
        when 6 then 'fri'
        when 7 then 'sat'
    end;

--  add monthname column (jan, feb, etc.)
alter table amazon_sales add column monthname varchar(10);

update amazon_sales
set monthname = 
    case month(date)
        when 1 then 'jan'
        when 2 then 'feb'
        when 3 then 'mar'
        when 4 then 'apr'
        when 5 then 'may'
        when 6 then 'jun'
        when 7 then 'jul'
        when 8 then 'aug'
        when 9 then 'sep'
        when 10 then 'oct'
        when 11 then 'nov'
        when 12 then 'dec'
    end;
set sql_safe_updates = 1;

--  EXPLORATORY DATA ANALYSIS (EDA)
-- Business questions
-- 1.What is the count of distinct cities in the dataset?
select count(distinct city) as distinct_city_count   from amazon_sales;

-- 2. For each branch, what is the corresponding city?
select  distinct branch , city from amazon_sales ;

-- 3.What is the count of distinct product lines in the dataset?
select count(distinct product_line)  as productline_count from amazon_sales;

-- 4.Which payment method occurs most frequently?
select payment_method,count(*)  from amazon_sales 
group by payment_method 
order by count(*) desc
limit 1;

-- 5.Which product line has the highest sales?
select product_line ,round(sum(total) ,2) as sales from amazon_sales 
group by product_line
order by sales desc
limit 1;

-- 6.How much revenue is generated each month?
select monthname, sum(total) as net_revenue from amazon_sales 
group by  monthname;

-- 7. In which month did the cost of goods sold reach its peak
select monthname ,sum(cogs) as total_cogs from amazon_sales 
group by monthname 
order by total_cogs desc
limit 1;

-- 8. Which product line generated the highest revenue?
select product_line ,round(sum(total) ,2) as revenue from amazon_sales 
group by product_line
order by revenue desc
limit 1;

-- 9. In which city was the highest revenue recorded?
select city ,round(sum(total) ,2) as revenue from amazon_sales 
group by city
order by revenue desc
limit 1;

-- 10. Which product line incurred the highest Value Added Tax?
select product_line ,round(sum(vat) ,2) as high_tax_added from amazon_sales 
group by product_line
order by high_tax_added desc
limit 1;

-- 11. For each product line, add a column indicating "Good" if its sales are above average, otherwise "Bad."

select 
    product_line,
    round(sum(total), 2) as total_sales,
    case 
	when sum(total) > (select avg(sales) 
	from (select sum(total) as sales from amazon_sales 
		 group by product_line) as avg_sales) 
         then 'good'
         else 'bad'
    end as performance
from amazon_sales
group by product_line
order by total_sales desc;

-- 12. Branches exceeding average products sold
with branch_sales as (
    select 
        branch,
        sum(quantity) as total_products_sold
    from amazon_sales
    group by branch
)
select 
    branch,
    total_products_sold,
    (select avg(total_products_sold) from branch_sales) as avg_products_sold
from branch_sales
where total_products_sold > (select avg(total_products_sold) from branch_sales)
order by total_products_sold desc;

-- 13. Which product line is most frequently associated with each gender?
with gender_product_frequency as (
    select 
        gender,
        product_line,
        count(*) as frequency,
        rank() over (partition by gender order by count(*) desc) as popularity_rank
    from amazon_sales
    group by gender, product_line
)
select
    gender,
    product_line as most_frequent_product_line,
    frequency as purchase_count
from gender_product_frequency
where popularity_rank = 1
order by gender;

-- 14. Calculate the average rating for each product line.
select product_line , round(avg(rating),2) as average_rating  from amazon_sales 
group by product_line;

-- 15. Count the sales occurrences for each time of day on every weekday.
select dayname,timeofday,count(*) as sales_count from amazon_sales 
group by dayname,timeofday;

-- 16.Identify the customer type contributing the highest revenue.
select customer_type, sum(total) as revenue from amazon_sales 
group by customer_type
order by revenue
limit 1;

-- 17.Determine the city with the highest VAT percentage.
select city, (sum(vat)/sum(cogs)) * 100  vat_percentage from amazon_sales group by city
order by vat_percentage desc
limit 1;

-- 18. Identify the customer type with the highest VAT payments.

select customer_type, sum(vat) as vat_payments_count from amazon_sales
group by customer_type
order by vat_payments_count desc;

-- 19. What is the count of distinct customer types in the dataset?
select count(distinct customer_type) as customertype_count from amazon_sales;

-- 20.What is the count of distinct payment methods in the dataset?
select count(distinct payment_method) as payment_method_count from amazon_sales;

-- 21. Which customer type occurs most frequently?
select customer_type, count(*) as frequency from amazon_sales 
group by customer_type 
order by frequency desc 
limit 1;

-- 22. Identify the customer type with the highest purchase frequency.
select customer_type, count(invoice_id) as highest_purchase_frequency from amazon_sales 
group by customer_type 
order by highest_purchase_frequency desc 
limit 1;

-- 23. Determine the predominant gender among customers.
select gender , count(*) as gender_count from amazon_sales
group by gender
order by gender_count desc
limit 1;

-- 24. Examine the distribution of genders within each branch.
select branch, gender , count(*) as frequency from amazon_sales group by branch, gender
order by branch ;

-- 25 .Identify the time of day when customers provide the most ratings
select timeofday, count(rating) as most_rating from amazon_sales 
group by timeofday 
order by most_rating desc
limit 1;

-- 26. Determine the time of day with the highest customer ratings for each branch.
select branch,timeofday, count(rating) as most_rating from amazon_sales 
group by branch,timeofday 
order by branch;

-- 27.Identify the day of the week with the highest average ratings.
select dayname, round(avg(rating),2) as highest_avg_rating from amazon_sales 
group by dayname
order by highest_avg_rating desc
limit 1;

-- 28. Determine the day of the week with the highest average ratings for each branch.
select * from
(select branch,dayname, round(avg(rating)) as avg_rating, 
dense_rank() over(partition by  branch order by avg(rating) desc   ) as ranking from amazon_sales
group by branch,dayname) as rank_data
where ranking  =1;