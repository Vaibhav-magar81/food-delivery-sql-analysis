USE fooddeliverydb;

-- INSIGHT 1: Revenue & Growth Analysis --
-- Total Revenue --
SELECT sum(TotalAmount) AS TotalRevenue
FROM Orders
WHERE OrderStatus = "Completed";

-- Monthly revenue trend --
SELECT date_format(OrderDate, '%Y-%m') AS Month, sum(TotalAmount) AS MonthyRevenue
FROM Orders
WHERE OrderStatus = "Completed"
GROUP BY Month
ORDER BY Month;

-- INSIGHT 2: Top Performing Customers -- 
-- TOP 5 Customers --
SELECT o.CustomerID, c.CustomerName, sum(o.TotalAmount) AS TotalSpent, rank() OVER (ORDER BY SUM(o.TotalAmount) DESC) AS Ranking
FROM Orders o
JOIN customers c
ON c.CustomerID = o.CustomerID
WHERE OrderStatus = "Completed"
GROUP BY CustomerID
LIMIT 5;

-- Repeat Customers (More Than 1 Order) -- 
SELECT CustomerID, count(OrderID) AS TotalOrders
FROM Orders 
WHERE OrderStatus = "Completed"
group by CustomerID
HAVING count(OrderID) > 1
ORDER BY TotalOrders DESC;

-- INSIGHT 3: Best Performing Restaurants --
-- Top 5 Restaurants by Revenue --
SELECT r.RestaurantName, sum(o.TotalAmount) AS TotalRevenue
From orders o
JOIN restaurants r
ON o.RestaurantID = r.RestaurantID
WHERE o.OrderStatus = "Completed"
GROUP BY r.RestaurantName
ORDER BY TotalRevenue DESC
LIMIT 5;

-- Most Ordered Restaurants --
SELECT r.RestaurantName, COUNT(o.OrderID) AS TotalOrders
FROM orders o
JOIN restaurants r
ON o.RestaurantID = r.RestaurantID
WHERE o.OrderStatus = "Completed"
GROUP BY r.RestaurantName
ORDER BY TotalOrders DESC
LIMIT 5;

-- 	Top 5 highest Rated Restaurants -- 
	SELECT RestaurantID ,RestaurantName, City, Rating
    FROM restaurants	
    ORDER BY Rating DESC
    LIMIT 5;

-- INSIGHT 4: Best Selling Menu Items --
-- Most Ordered Items --
SELECT m.ItemName, sum(oi.Quantity) AS TotalQuantitySold
FROM orderitems oi
JOIN menuitems m
ON m.MenuID = oi.MenuID
GROUP BY m.ItemName
ORDER BY TotalQuantitySold DESC
LIMIT 5;

-- Highest Revenue Generating Items --
SELECT m.ItemName, sum(oi.Quantity * m.Price) AS TotalRevenue
FROM orderitems oi
JOIN menuitems m
ON m.MenuID = oi.MenuID
GROUP BY m.ItemName
ORDER BY TotalRevenue DESC
LIMIT 5;

-- Category Performance -- 
SELECT m.Category, SUM(oi.Quantity) AS TotalItemSold, SUM(oi.Quantity * m.Price) AS TotalRevenue
FROM OrderItems oi
JOIN MenuItems m 
ON oi.MenuID = m.MenuID
GROUP BY m.Category
ORDER BY TotalRevenue DESC;

-- INSIGHT 5: Delivery Performance Analysis --
-- Average Delivery Time -- 
SELECT round(AVG(DeliveryTime),2) AS AvgDeliveryTime
FROM Orders
WHERE OrderStatus = "Completed";

-- Best Delivery Partners (Fastest) --
SELECT dp.PartnerName, round(AVG(o.DeliveryTime),2) AS AvgDeliveryTime
FROM Orders o
JOIN deliverypartners dp
ON o.DeliveryPartnerID = dp.DeliveryPartnerID
WHERE o.OrderStatus = "Completed"
GROUP BY dp.PartnerName
ORDER BY AvgDeliveryTime ASC
LIMIT 5;

-- INSIGHT 6: Cancellation Analysis --
-- Overall Cancellation Rate --
SELECT ROUND(SUM(CASE WHEN OrderStatus = "Cancelled" THEN 1 ELSE 0 END) * 100.00 / COUNT(*),2) AS CancellationRatePercent
FROM Orders;

-- Cancellation by Restaurant -- 
SELECT r.RestaurantName, COUNT(CASE WHEN o.OrderStatus = "Cancelled" THEN 1 ELSE 0 END) AS CancelledOrders
FROM Orders o
JOIN restaurants r 
ON o.RestaurantID = r.RestaurantID
GROUP BY r.RestaurantName
order by CancelledOrders DESC
LIMIT 5;   
        

    