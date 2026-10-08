-- Industrial Manufacturing Finance Project
-- Assumed table: sales_orders

-- Executive KPIs
SELECT SUM(Revenue) AS revenue, SUM(Total_COGS) AS cogs,
       SUM(Gross_Profit) AS gross_profit,
       SUM(Gross_Profit)/NULLIF(SUM(Revenue),0) AS gross_margin
FROM sales_orders;

-- Product profitability
SELECT Model, SUM(Qty) AS units, SUM(Revenue) AS revenue,
       SUM(Total_COGS) AS cogs, SUM(Gross_Profit) AS gross_profit,
       SUM(Gross_Profit)/NULLIF(SUM(Revenue),0) AS gross_margin
FROM sales_orders
GROUP BY Model ORDER BY gross_profit DESC;

-- Customer profitability
SELECT Customer, SUM(Revenue) AS revenue, SUM(Gross_Profit) AS gross_profit,
       SUM(Gross_Profit)/NULLIF(SUM(Revenue),0) AS gross_margin
FROM sales_orders
GROUP BY Customer ORDER BY gross_profit DESC;

-- Monthly trend
SELECT DATE_TRUNC('month', SO_Date) AS month, SUM(Revenue) AS revenue,
       SUM(Gross_Profit) AS gross_profit,
       SUM(Gross_Profit)/NULLIF(SUM(Revenue),0) AS gross_margin
FROM sales_orders
GROUP BY DATE_TRUNC('month', SO_Date) ORDER BY month;

-- Open orders
SELECT Status, COUNT(*) AS orders, SUM(Revenue) AS order_value
FROM sales_orders WHERE Status <> 'Completed'
GROUP BY Status ORDER BY order_value DESC;

-- Outstanding payment exposure
SELECT Customer, SUM(Revenue) AS outstanding_revenue,
       AVG(Credit_Days) AS avg_credit_days
FROM sales_orders WHERE Payment_Status='Outstanding'
GROUP BY Customer ORDER BY outstanding_revenue DESC;

-- High-value low-margin orders
SELECT SO_Number, Customer, Model, Revenue, Gross_Profit, Gross_Margin, Status
FROM sales_orders WHERE Revenue >= 1500000 AND Gross_Margin < 0.25
ORDER BY Revenue DESC;
