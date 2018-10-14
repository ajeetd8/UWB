-- Problem #6
select c.name as 'carrier', max(F.price) as 'max_price'
from FLIGHTS as F,
     CARRIERS as C
where F.carrier_id = C.cid  -- Join property
  and F.origin_city = 'Seattle WA'
  and F.dest_city = 'New York NY'
group by F.carrier_id;