# MYSQL_WINDOWS_FUNCTIONS
SQL examples showcasing window functions for advanced data analysis, including running totals, ranking, and data aggregation for deeper insights.

Create database challenge26;

use challenge26;

CREATE TABLE sales (
    id INT AUTO_INCREMENT PRIMARY KEY,
    salesperson VARCHAR(100),
    sale_amount DECIMAL(10, 2),
    sale_date DATE
);

INSERT INTO sales (salesperson, sale_amount, sale_date) VALUES
('Alice', 200.00, '2024-01-01'),
('Bob', 150.00, '2024-01-02'),
('Alice', 300.00, '2024-01-03'),
('Bob', 100.00, '2024-01-04'),
('Alice', 250.00, '2024-01-05'),
('Bob', 300.00, '2024-01-06');

SELECT * FROM sales;

![Sales_table](https://github.com/user-attachments/assets/b185b128-23c9-431e-8a2b-b8a278bbf9cf)

#calculates the running total of sales for each salesperson.

SELECT 
    salesperson,
    sale_date,
    sale_amount,
    SUM(sale_amount) OVER (PARTITION BY salesperson ORDER BY sale_date) AS running_total
FROM 
    sales
ORDER BY 
    salesperson, sale_date;

![q1](https://github.com/user-attachments/assets/aeec2027-dd5a-435d-924a-48e759644448)

#Using ROW_NUMBER

SELECT 
    salesperson,
    sale_amount,
    ROW_NUMBER() OVER (PARTITION BY salesperson ORDER BY sale_date) AS sale_rank
FROM 
    sales;

![q2](https://github.com/user-attachments/assets/7174cba5-c504-4922-a1b1-c77946ebaf23)

#Using RANK and DENSE_RANK

SELECT 
    salesperson,
    sale_amount,
    RANK() OVER (ORDER BY sale_amount DESC) AS sales_rank,
    DENSE_RANK() OVER (ORDER BY sale_amount DESC) AS dense_sales_rank
FROM 
    sales;

![q3](https://github.com/user-attachments/assets/25530338-a99e-48e6-88b4-7e572ab7a700)

#Using Aggregate Functions with Window Functions

SELECT 
    salesperson,
    sale_amount,
    AVG(sale_amount) OVER (PARTITION BY salesperson) AS avg_sale
FROM 
    sales;

![q4](https://github.com/user-attachments/assets/02ecd096-8530-4276-84bb-dd4efb167bae)
    
#Calculate Total Sales per Day and Compare It to the Average Sales per Day

SELECT 
    sale_date,
    SUM(sale_amount) AS total_sales,
    AVG(SUM(sale_amount)) OVER () AS avg_sales,
    CASE 
        WHEN SUM(sale_amount) > AVG(SUM(sale_amount)) OVER () THEN 'Above Average'
        WHEN SUM(sale_amount) < AVG(SUM(sale_amount)) OVER () THEN 'Below Average'
        ELSE 'Average'
    END AS comparison
FROM 
    sales
GROUP BY 
    sale_date
ORDER BY 
    sale_date;

![q5](https://github.com/user-attachments/assets/528669a4-7c90-40aa-af28-cb4aefde4e2a)
    
#Use Window Functions to Find the Top-Selling Salesperson for Each Week

SELECT 
    salesperson,
    total_sales,
    sale_year,
    sale_week
FROM (
    SELECT 
        salesperson,
        SUM(sale_amount) AS total_sales,
        YEAR(sale_date) AS sale_year,
        WEEK(sale_date) AS sale_week,
        RANK() OVER (PARTITION BY YEAR(sale_date), WEEK(sale_date) ORDER BY SUM(sale_amount) DESC) AS sales_rank
    FROM 
        sales
    GROUP BY 
        salesperson, YEAR(sale_date), WEEK(sale_date)
) AS ranked_sales
WHERE 
    sales_rank = 1
ORDER BY 
    sale_year, sale_week;

![q6](https://github.com/user-attachments/assets/28fb1869-4c1e-40ef-bdf8-897e74ee3d19)











