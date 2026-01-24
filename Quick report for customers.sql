

with Report_Data as (

select c.cst_id,
concat (c.cst_firstname,'   ',c.cst_lastname) as CustomerName ,
s.sls_quantity,
s.sls_sales,
s.sls_order_dt,
s.sls_ord_num
from [Fact.Sales] s
 join [Dim.Customer] c 
on s.sls_cust_id = c.cst_id)
, Calculations as (
--aggrgation data --
select 
cst_id as Customer_ID,
CustomerName,
 sum(sls_sales) as Total_Sales,
 count ( distinct sls_ord_num) as Total_Order,
 min (sls_order_dt) as First_Order,
  max(sls_order_dt) as Last_Order
from Report_Data
group by 
cst_id,
CustomerName )


-- Customer Segment--
select 
 Customer_ID,
CustomerName,
Total_Sales,
Total_Order,
First_Order,
Last_Order,
case 
when Total_Sales > 8000 then 'VIP'
when Total_Sales >= 5000 then 'Regular'
when  Total_Sales < 5000 then 'Light'
else 'New'
end Customer_Segment
from Calculations