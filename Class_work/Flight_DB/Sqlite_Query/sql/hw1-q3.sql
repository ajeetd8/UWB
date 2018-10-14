-- Problem #3
select W.day_of_week as 'day_of_week', avg(F.arrival_delay) as 'delay'
from FLIGHTS as F,
     WEEKDAYS as W
    where F.day_of_week_id = W.did-- Join Week and Flight
group by F.day_of_week_id
order by delay desc
limit 1;