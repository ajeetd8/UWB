-- (15 points) For each origin city, find the percentage (computed as a decimal number between 0 to 1, e.g., 0.5 means 50%) of departing flights shorter than 3 hours. For this question, treat flights with NULL actual_time values as longer than 3 hours. Name the output columns origin_city and percentage. Order by percentage value in ascending (default) order. Be careful to handle cities without any flights shorter than 3 hours. We will accept both 0 and NULL as the result for those cities.
select
  F1.origin_city,
  1.0 * count(case when F1.actual_time < 180
    then 1 end) / count(F1.fid) as 'percentage'
from FLIGHTS as F1
group by F1.origin_city
order by percentage;