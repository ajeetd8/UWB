-- (15 points) List all cities that cannot be reached from Seattle though a direct flight but can be reached with one stop (i.e., with any two flights that go through an intermediate city). Do not include Seattle as one of these destinations (even though you could get back with two flights). Name the output column city
select F2.dest_city as 'city'
from FLIGHTS F1, FLIGHTS F2
where F1.origin_city = 'Seattle WA' and
      F1.dest_city = F2.origin_city and
      F2.dest_city != F1.origin_city and
      F2.dest_city not in (select F1.dest_city
                           from FLIGHTS F1
                           where F1.origin_city =
                                 'Seattle WA'
                           group by F1.dest_city)
group by F2.dest_city
order by F2.dest_city;