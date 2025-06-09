
#  Amazon Sales Analysis – SQL Project

##  Project Overview

This SQL Project focuses on analyzing Amazon sales data using structured query language (SQL). The dataset includes transactional information such as invoice ID, customer details, product categories, prices, payment methods, dates, and ratings. The project involved **data wrangling**, **feature engineering**, and **exploratory data analysis** to extract valuable business insights.


##  Dataset Summary

- **Rows**: ~1000 transactions  
- **Columns**: 17 original + 3 engineered columns  
- **Key Columns**:
  - `invoice_id`, `branch`, `city`, `customer_type`, `gender`
  - `product_line`, `unit_price`, `quantity`, `total`
  - `date`, `time`, `payment_method`, `rating`
- **Feature Engineered Columns**:
  - `timeofday` (Morning, Afternoon, Evening)
  - `dayname` (Mon–Sun)
  - `monthname` (Jan–Dec)


## Project Structure

### 1. **Data Wrangling**
- Created database and tables
- Checked for duplicates and NULL values
- Ensured primary keys and data integrity

### 2. **Feature Engineering**
- Extracted `timeofday` based on sale time
- Derived `dayname` from the sale date
- Extracted `monthname` for monthly insights

### 3. **Exploratory Data Analysis (EDA)**
Executed 28 business queries to uncover insights like:
- Revenue trends by month, city, and product line
- Best-selling product lines and high-rated items
- Gender and customer type behavior
- Time and day-based customer preferences
- Performance comparison among branches

##  Skills Demonstrated

- ✅ SQL Basics & Advanced Queries  
- ✅ Data Cleaning & Validation  
- ✅ Use of Aggregates, Subqueries, CTEs, and Window Functions  
- ✅ Case Statements & Conditional Logic  
- ✅ Business Intelligence Thinking

##  Tools Used

- **MySQL** for database creation and query execution  
- **SQL Joins, Window Functions, Aggregates**  
- **MySQL Workbench** 

## Conclusion

This capstone project simulates a real-world data analysis scenario. It reflects how SQL alone can be used to draw powerful insights from structured sales data, supporting decisions around marketing, inventory, and customer engagement.

---

If you liked this project or have suggestions:

- LinkedIn :www.linkedin.com/in/manda-saikumar-94a6202a4
-  Email: saikumarmanda645@gmail.com

