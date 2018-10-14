select F.flight_num as 'flight_num'
from FLIGHTS as F,
     CARRIERS as C,
     WEEKDAYS as W
where F.origin_city = 'Seattle WA'
  and F.dest_city = 'Boston MA'
  and F.carrier_id = C.cid
  and C.name = 'Alaska Airlines Inc.'
  and F.day_of_week_id = W.did
  and W.day_of_week = 'Monday'
group by F.flight_num;