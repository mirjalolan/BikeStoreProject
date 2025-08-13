--Total Revenue per store 
select store_id, SUM(list_price * quantity * (1-oi.discount)) AS TotalRevenueByStore from order_items group by store_id 
