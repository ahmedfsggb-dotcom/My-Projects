






CREATE VIEW gold.report_products AS

/*----------------------
    --Base Query--
-----------------------*/
with product_data as (
select 
p.product_id,
p.product_name,
p.product_number,
p.category,
p.subcategory,
s.order_date,
s.order_number,
s.quantity,
s.sales_amount,
c.customer_id,
c.customer_key ,
p.cost

from gold.fact_sales s 
left join 
gold.dim_products p 
on s.product_key = p.product_key  
left join gold.dim_customers c
on c.customer_key = s.customer_key
where s.order_date is not null 
)
/*---------------------------------
    --Product Aggregations--
---------------------------------*/
,  product_aggergations  as (

select product_name,product_id,category,subcategory,cost,
DATEDIFF(month ,min(order_date) ,max(order_date)) as lifespen,
max(order_date) as  last_sales_order,
sum(sales_amount) as total_sales,
sum(quantity) as total_quantity,
count( distinct order_number) as total_order,
count (distinct  customer_key) as total_customer
from product_data 
group by product_name,product_id,category,subcategory ,cost  
)

 /*---------------------------------
      --final query --
---------------------------------*/
select  
product_id,
product_name,
category,
subcategory,
cost,
last_sales_order ,
total_sales ,
total_quantity,
total_order,
total_customer,
Case
when total_sales > 50000 then 'hight performer'
when total_sales >= 10000 then 'mid-range'
else 'low-performer'
end product_segment ,
--avg_order_revenue--
case 
when total_order = 0 then 0 
else total_sales / total_order
end avg_order_revenue
from product_aggergations



