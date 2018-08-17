-- (7 points) List the names of carriers that operate flights from Seattle to San Francisco, CA. Return each carrier's name only once. Use a nested query to answer this question. Name the output column carrier.
select C.name as 'Carrier'
from CARRIERS C, (select carrier_id
                  from FLIGHTS
                  where dest_city = 'San Francisco CA' and origin_city = 'Seattle WA') F
where C.cid = F.carrier_id
group by C.name;