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

#Using ROW_NUMBER
SELECT 
    salesperson,
    sale_amount,
    ROW_NUMBER() OVER (PARTITION BY salesperson ORDER BY sale_date) AS sale_rank
FROM 
    sales;
    
#Using RANK and DENSE_RANK
SELECT 
    salesperson,
    sale_amount,
    RANK() OVER (ORDER BY sale_amount DESC) AS sales_rank,
    DENSE_RANK() OVER (ORDER BY sale_amount DESC) AS dense_sales_rank
FROM 
    sales;
    
#Using Aggregate Functions with Window Functions
SELECT 
    salesperson,
    sale_amount,
    AVG(sale_amount) OVER (PARTITION BY salesperson) AS avg_sale
FROM 
    sales;
    
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









