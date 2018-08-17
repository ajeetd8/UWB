-- (15 points) For each origin city, find the destination city (or cities) with the longest direct flight. By direct flight, we mean a flight with no intermediate stops. Determine the longest flight in time, not distance. Name the output columns origin_city, dest_city, and time representing the the flight time between them. Do not include duplicates of the same origin/destination city pair. Order the result by origin_city and then dest_city in ascending (default) order.
select
  F1.origin_city,
  F1.dest_city,
  F1.actual_time as 'time'
from FLIGHTS as F1 inner join (select
                                 origin_city,
                                 max(actual_time) as 'max'
                               from FLIGHTS
                               group by origin_city) as F2
    on F1.origin_city = F2.origin_city and F1.actual_time = F2.max
group by F1.origin_city, F1.dest_city, F1.actual_time
order by F1.origin_city asc, F1.dest_city asc;