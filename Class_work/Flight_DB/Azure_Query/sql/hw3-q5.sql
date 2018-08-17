--(15 points) List all cities that cannot be reached from Seattle through a direct flight nor with one stop (i.e., with any two flights that go through an intermediate city). Do not include Seattle as one of these destinations. Warning: this query might take a while to execute. We will learn about how to speed this up in later lectures. Name the output column city. You can assume "all cities" to be the collection of all origin_city or all dest_city. Do not worry if this query takes a while to execute. We are mostly concerned with the results. Output relation cardinality is 3 or 4, depending on what you consider to be the set of all cities.
select F1.dest_city as city
From (select dest_city
      from FLIGHTS
      group by dest_city) F1
where F1.dest_city not in (select dest_city
                           from FLIGHTS
                           where origin_city = 'Seattle WA'
                           group by dest_city) and
      F1.dest_city not in (select F2.dest_city
                           from FLIGHTS F1, FLIGHTS F2
                           where F1.origin_city = 'Seattle WA' and
                                 F1.dest_city = F2.origin_city
                           group by F2.dest_city);