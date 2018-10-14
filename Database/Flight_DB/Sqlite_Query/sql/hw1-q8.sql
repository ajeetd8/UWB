-- Problem #8
select C.name as 'name', sum(F.departure_delay) as 'delay'
from FLIGHTS as F,
     CARRIERS as C
where F.carrier_id = C.cid
group by F.carrier_id