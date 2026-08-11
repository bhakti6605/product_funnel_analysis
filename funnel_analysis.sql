SELECT * FROM user_events;

--Define funnel stages 

WITH funnel_stages AS (
  SELECT 
     COUNT(DISTINCT CASE WHEN event_type ='page_view' THEN user_id END ) AS page_views,
	 COUNT(DISTINCT CASE WHEN event_type ='add_to_cart' THEN user_id END ) AS add_to_cart,
	 COUNT(DISTINCT CASE WHEN event_type ='checkout_start' THEN user_id END ) AS checkout_start,
	 COUNT(DISTINCT CASE WHEN event_type ='payment_info' THEN user_id END ) AS payment_info,
	 COUNT(DISTINCT CASE WHEN event_type ='purchase' THEN user_id END ) AS purchase
  FROM user_events
	 
)

SELECT * FROM funnel_stages;


--conversion rates through the funnel

WITH funnel_stages AS (
  SELECT 
     COUNT(DISTINCT CASE WHEN event_type ='page_view' THEN user_id END ) AS page_views,
	 COUNT(DISTINCT CASE WHEN event_type ='add_to_cart' THEN user_id END ) AS add_to_cart,
	 COUNT(DISTINCT CASE WHEN event_type ='checkout_start' THEN user_id END ) AS checkout_start,
	 COUNT(DISTINCT CASE WHEN event_type ='payment_info' THEN user_id END ) AS payment_info,
	 COUNT(DISTINCT CASE WHEN event_type ='purchase' THEN user_id END ) AS purchase
  FROM user_events
	 
)
SELECT
    ROUND(add_to_cart * 100.0 / NULLIF(page_views, 0), 2) AS page_to_cart_rate,
    ROUND(checkout_start * 100.0 / NULLIF(add_to_cart, 0), 2) AS cart_to_checkout_rate,
    ROUND(payment_info * 100.0 / NULLIF(checkout_start, 0), 2) AS checkout_to_payment_rate,
    ROUND(purchase * 100.0 / NULLIF(payment_info, 0), 2) AS payment_to_purchase_rate
FROM funnel_stages;



--funnel by source
WITH funnel_source AS (

SELECT 
     traffic_source,
     COUNT(DISTINCT CASE WHEN event_type ='page_view' THEN user_id END) AS page_views,
	 COUNT(DISTINCT CASE WHEN event_type ='add_to_cart' THEN user_id END ) AS add_to_cart,
	 COUNT(DISTINCT CASE WHEN event_type ='checkout_start' THEN user_id END ) AS checkout_start,
	 COUNT(DISTINCT CASE WHEN event_type ='payment_info' THEN user_id END ) AS payment_info,
	 COUNT(DISTINCT CASE WHEN event_type ='purchase' THEN user_id END ) AS purchase
FROM user_events
GROUP BY traffic_source
)

SELECT 
*
FROM funnel_source;

--funnel by source conversion rate
WITH funnel_source AS (

SELECT 
     traffic_source,
     COUNT(DISTINCT CASE WHEN event_type ='page_view' THEN user_id END) AS page_views,
	 COUNT(DISTINCT CASE WHEN event_type ='add_to_cart' THEN user_id END ) AS add_to_cart,
	 COUNT(DISTINCT CASE WHEN event_type ='checkout_start' THEN user_id END ) AS checkout_start,
	 COUNT(DISTINCT CASE WHEN event_type ='payment_info' THEN user_id END ) AS payment_info,
	 COUNT(DISTINCT CASE WHEN event_type ='purchase' THEN user_id END ) AS purchase
FROM user_events
GROUP BY traffic_source
)

SELECT 
   traffic_source,
   ROUND(add_to_cart*100/page_views,2) AS views_to_cart_conversion,
   ROUND(checkout_start*100/add_to_cart,2) AS cart_to_checkout_conversion,
   ROUND(payment_info*100/checkout_start,2) AS checkout_to_payment_conversion,
   ROUND(purchase*100/payment_info,2) AS payment_to_purchase_conversion
FROM funnel_source;


--revenue funnel analysis
WITH funnel_revenue AS(
SELECT
     COUNT(DISTINCT CASE WHEN event_type='page_view' THEN user_id END) AS Total_visitors,
	 COUNT(DISTINCT CASE WHEN event_type='purchase' THEN user_id END) AS Total_buyers,
	 SUM(CASE WHEN event_type='purchase' THEN amount END) AS Total_revenue,
	 SUM(CASE WHEN event_type='purchase' THEN 1 END) AS Total_orders
FROM user_events
)

SELECT
    Total_visitors,
	Total_buyers,
	Total_revenue,
	Total_orders,
	ROUND(Total_revenue/Total_buyers,2) AS revenue_per_buyer, 
	ROUND(Total_revenue/Total_orders,2) AS average_order_value
FROM funnel_revenue;

--time to conversion analysis

WITH user_journey AS(
SELECT
     user_id,
     MIN(CASE WHEN event_type='page_view' THEN event_date END) AS first_page_view,
	 MIN(CASE WHEN event_type='purchase' THEN event_date END) AS first_purchase
	 
FROM user_events
GROUP BY user_id
)

SELECT 
     user_id,
     first_page_view,
	 first_purchase,
     first_purchase - first_page_view  AS time_to_conversion
FROM user_journey
WHERE first_page_view IS NOT NULL
  AND first_purchase IS NOT NULL;