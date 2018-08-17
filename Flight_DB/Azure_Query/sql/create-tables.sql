-- Please create table and upload the information correctly.
-- If you drop the table once you populate the flight, you will waste lots of hours!!!!

-- drop table CARRIERS;
-- drop table FLIGHTS;
-- drop table MONTHS;
-- drop table WEEKDAYS;

create table CARRIERS
(
  cid  varchar(7) not null
    primary key,
  name varchar(83)
)
go

create table FLIGHTS
(
  fid             int not null
    primary key,
  month_id        int
    references MONTHS,
  day_of_month    int,
  day_of_week_id  int
    references WEEKDAYS,
  carrier_id      varchar(7)
    references CARRIERS,
  flight_num      int,
  origin_city     varchar(34),
  origin_state    varchar(47),
  dest_city       varchar(34),
  dest_state      varchar(46),
  departure_delay int,
  taxi_out        int,
  arrival_delay   int,
  canceled        int,
  actual_time     int,
  distance        int,
  capacity        int,
  price           int
)
go

create index Flights__oc
  on FLIGHTS (origin_city)
go

create index nci_wi_FLIGHTS_D6091CAD8B2CE7DCE613C4715D6E596A
  on FLIGHTS (origin_city, dest_city)
go

create index nci_wi_FLIGHTS_BB76DADB721128D8472004B33D4FA67A
  on FLIGHTS (actual_time, origin_city, dest_city)
go


create table MONTHS
(
  mid   int not null
    primary key,
  month varchar(9)
)
go

create table WEEKDAYS
(
  did         int not null
    primary key,
  day_of_week varchar(9)
)
go