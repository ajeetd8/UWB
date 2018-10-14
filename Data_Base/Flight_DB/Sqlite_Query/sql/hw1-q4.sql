-- Problem #4
select distinct C.name as 'name'
from FLIGHTS as F,
     CARRIERS as C
where F.carrier_id = C.cid -- join property
  and F.actual_time < 1440 -- fly less than 24 hours
group by F.carrier_id, F.day_of_month, F.month_id
having count(F.carrier_id)>1000;