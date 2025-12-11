DROP TABLE if exists Zepto;

CREATE TABLE Zepto(
Sku_id SERIAL PRIMARY KEY,
Category VARCHAR(120),
Name VARCHAR(150) NOT NULL,
MRP NUMERIC(8,2),
DiscountPercent NUMERIC(5,2),
AvailableQuantity INTEGER,
DicountedSellingPrice NUMERIC(8,2),
WeightInGms INTEGER,
OutOfStock BOOLEAN,
Quantity INTEGER
);

SELECT * FROM Zepto;

--Data Exploration--

--Count of rows--
SELECT COUNT(*) FROM zepto;

--Sample Data--
SELECT * FROM Zepto
LIMIT 10;

--Null Values--
SELECT * FROM Zepto
WHERE Name is NULL
OR
Category IS NULL
OR
MRP IS NULL
OR
DiscountPercent IS NULL
OR
DicountedSellingPrice IS NULL
OR
WeightInGms IS NULL
OR
AvailableQuantity IS NULL
OR
OutOfStock IS NULL
OR
Quantity IS NULL;

-- Different product category--
SELECT DISTINCT Category
FROM Zepto
ORDER BY Category;

-- Products in stock vs out of stock--
SELECT OutOfStock, COUNT (Sku_id)
FROM Zepto
GROUP BY OutOfStock;

--Product names present_multiple times--
SELECT Name, COUNT(Sku_id) as "Number of SKUs"
FROM Zepto
GROUP BY Name
HAVING COUNT(Sku_id)>1
ORDER BY COUNT(Sku_id) DESC;

-- Data Cleaning--

-- Products with price = 0
SELECT * FROM Zepto
WHERE MRP = 0 OR DicountedSellingPrice = 0;

DELETE FROM Zepto
WHERE MRP = 0;

-- Convert paise to rupees--
UPDATE zepto
SET MRP = MRP/100.0,
DicountedSellingPrice = DicountedSellingPrice/100.0;

SELECT MRP, DicountedSellingPrice FROM Zepto

-- Q1. Find the top 10 best-value products based on the discount percentage.
SELECT DISTINCT Name, MRP, DiscountPercent
FROM Zepto
ORDER BY DiscountPercent DESC
LIMIT 10;

-- Q2. What are the products with high MRP but Out Of Stock
SELECT DISTINCT Name,MRP
FROM Zepto
WHERE OutOfStock = TRUE AND MRP > 300
ORDER BY MRP DESC;

-- Q3. Calculate Estimated Revenue for each category
SELECT Category,
SUM(DicountedSellingPrice * AvailableQuantity) AS Total_Revenue
FROM Zepto
GROUP BY Category
ORDER BY Total_Revenue;

-- Q4. Final all products where MRP is greater than 500 rupees and discount is less than 10%.
SELECT DISTINCT Name, MRP, DiscountPercent
FROM Zepto
WHERE MRP > 500 AND DiscountPercent < 10
ORDER BY MRP DESC, DiscountPercent DESC;

-- Q5. Identify the top 5 categories offering the highest average discount percentage.
SELECT Category,
ROUND(AVG(DiscountPercent),2) AS  Avg_Discount
FROM Zepto
GROUP BY Category
ORDER BY Avg_Discount DESC
LIMIT 5;

-- Q6. Find the price per gram for products above 100g and sort by best value.
SELECT DISTINCT Name, WeightInGms, DicountedSellingPrice,
ROUND (DicountedSellingPrice/WeightInGms,2) AS price_per_gram
FROM Zepto
WHERE WeightInGms >= 100
ORDER BY price_per_gram;

-- Q7.Group the product into categories like Low, Medium, Bulk.
SELECT DISTINCT Name, WeightInGms,
CASE WHEN WeightInGms < 1000 THEN 'Low'
     WHEN WeightInGms < 5000 THEN 'Medium'
	 ELSE 'Bulk'
	 END AS weight_category
FROM Zepto;

-- Q8. What is the Total Inventory Weight Per Category.
SELECT Category,
SUM(WeightInGms * AvailableQuantity) AS Total_Weight
FROM Zepto 
GROUP BY Category
ORDER BY Total_Weight;

 
