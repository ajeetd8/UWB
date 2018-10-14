-- -- Create Table
-- drop table IF EXISTS FLIGHTS;
-- drop table IF EXISTS CARRIERS;
-- drop table IF EXISTS MONTHS;
-- drop table IF EXISTS WEEKDAYS;

create table FLIGHTS (
  fid             int,
  month_id        int, -- 1-12
  day_of_month    int, -- 1-31
  day_of_week_id  int, -- 1-7, 1 = Monday, 2 = Tuesday, etc
  carrier_id      varchar(7),
  flight_num      int,
  origin_city     varchar(34),
  origin_state    varchar(47),
  dest_city       varchar(34),
  dest_state      varchar(46),
  departure_delay int, -- in mins
  taxi_out        int, -- in mins
  arrival_delay   int, -- in mins
  canceled        int, -- 1 means canceled
  actual_time     int, -- in mins
  distance        int, -- in miles
  capacity        int,
  price           int, -- in $
  primary key (fid),
  foreign key (day_of_week_id) references WEEKDAYS,
  foreign key (month_id) references MONTHS,
  foreign key (carrier_id) references CARRIERS
);

create table CARRIERS (
  cid  varchar(7) primary key,
  name varchar(83)
);
create table MONTHS (
  mid   int primary key,
  month varchar(9)
);
create table WEEKDAYS (
  did         int primary key,
  day_of_week varchar(9)
);

-- PRAGMA foreign_keys=ON;

-- go
-- .mode csv
-- .import /mnt/c/Users/khara/Documents/cse344-18su-public/hw2/data/carriers.csv CARRIERS
-- .import /mnt/c/Users/khara/Documents/cse344-18su-public/hw2/data/months.csv MONTHS
-- .import /mnt/c/Users/khara/Documents/cse344-18su-public/hw2/data/weekdays.csv WEEKDAYS
-- .import /mnt/c/Users/khara/Documents/cse344-18su-public/hw2/data/flights-small.csv FLIGHTS

-- go
-- create index Flights__dc
--   on FLIGHTS (dest_city);

-- create index Flights__dc_oc
--   on FLIGHTS (dest_city, origin_city);

-- create index Flights__oc
--   on FLIGHTS (origin_city);

-- create index Flights__oc_dc
--   on FLIGHTS (origin_city, dest_city);