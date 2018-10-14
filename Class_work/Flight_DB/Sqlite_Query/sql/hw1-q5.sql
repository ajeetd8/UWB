-- Problem #5
select C.name as 'name', ((1.0 * sum(F.canceled)) / (count(F.carrier_id)) * 100.0) as 'percent'
from FLIGHTS as F,
     CARRIERS as C
where F.origin_city = 'Seattle WA'
  and F.carrier_id = C.cid -- joining property
group by F.carrier_id
having (1.0 * sum(F.canceled) / (1.0 * count(F.carrier_id)) * 100.0) > 0.5;