-- Problem #7
select sum(F.capacity) as 'capacity'
from FLIGHTS as F,
     MONTHS as M
where F.month_id = M.mid  -- Foreign key constraint. Month & Flight
  and M.month = 'July'
  and F.day_of_month = '10'
  and ((F.origin_city = 'Seattle WA' and F.dest_city = 'San Francisco CA')
         or (F.origin_city = 'San Francisco CA' and F.dest_city = 'Seattle WA'));