-- (15 points) Find all origin cities that only serve flights shorter than 3 hours. You can assume that flights with NULL actual_time are not 3 hours or more. Name the output column city and sort them. List each city only once in the result.
select origin_city as 'city'
from FLIGHTS
group by origin_city
having max(actual_time) < 180
order by origin_city;