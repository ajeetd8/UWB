-- (8 points) Express the same query as above, but do so without using a nested query. Again, name the output column carrier.
select C.name as 'Carrier'
from CARRIERS C, FLIGHTS F
where C.cid = F.carrier_id and F.dest_city = 'San Francisco CA' and F.origin_city = 'Seattle WA'
group by C.name;