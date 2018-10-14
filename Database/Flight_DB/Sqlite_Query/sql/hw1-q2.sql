select C.name                          as 'name',
       F1.flight_num                   as 'f1_flight_num',
       F1.origin_city                  as 'f1_origin_city',
       F1.dest_city                    as 'f1_dest_city',
       F1.actual_time                  as 'f1_actual_time',
       F2.flight_num                   as 'f2_flight_num',
       F2.origin_city                     'f2_origin_city',
       F2.dest_city                    as 'f2_dest_city',
       F2.actual_time                  as 'f2_actual_time',
       F1.actual_time + F2.actual_time as 'actual_time'
from FLIGHTS as F1,
     FLIGHTS as F2,
     CARRIERS as C
where F1.dest_city = F2.origin_city -- join property (routing city)
  and F1.carrier_id = C.cid         -- join property
  and F1.carrier_id = F2.carrier_id -- join property
  and F1.day_of_month = 15
  and F1.day_of_month = F2.day_of_month
  and F1.origin_city = 'Seattle WA'
  and F2.dest_city = 'Boston MA'
  and F1.actual_time+F2.actual_time < 420;