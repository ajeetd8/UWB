-- add all your SQL setup statements here. 

-- You can assume that the following base table has been created with data loaded for you when we test your submission 
-- (you still need to create and populate it in your instance however),
-- although you are free to insert extra ALTER COLUMN ... statements to change the column 
-- names / types if you like.

--FLIGHTS (fid int, 
--         month_id int,        -- 1-12
--         day_of_month int,    -- 1-31 
--         day_of_week_id int,  -- 1-7, 1 = Monday, 2 = Tuesday, etc
--         carrier_id varchar(7), 
--         flight_num int,
--         origin_city varchar(34), 
--         origin_state varchar(47), 
--         dest_city varchar(34), 
--         dest_state varchar(46), 
--         departure_delay int, -- in mins
--         taxi_out int,        -- in mins
--         arrival_delay int,   -- in mins
--         canceled int,        -- 1 means canceled
--         actual_time int,     -- in mins
--         distance int,        -- in miles
--         capacity int, 
--         price int            -- in $             
--         )
go
drop table Users;
drop table Reservations;
drop function getUserBalance;
drop function checkReservationExist;
drop function checkPayStatus;
drop function ReservationPrice;
drop function ReservationPriceHelper;
drop function Flight_Cap_Cal;
drop function Flight_Day;
drop FUNCTION dayOverlap;


-- User Defined Functions
-- Function needed to retrieve the information.
---- Function for getting the balance of a user.
go
CREATE FUNCTION getUserBalance(@username varchar(255))
  RETURNS INT AS
  BEGIN
    RETURN (select U.balance from Users as U where username = @username);
  END;
go
---- Function for getting the whether itinerary exist or not.
CREATE FUNCTION checkReservationExist(@res_ID INT, @username varchar(255))
  RETURNS BIT AS
  BEGIN
    RETURN (select count(R_ID)
            from Reservations as R
            where R.R_ID = @res_ID  --
              and R.username = @username)
  END;
go

go
-- Check the reservation payment status
create function checkPayStatus(@res_ID INT, @username varchar(255))
  RETURNS BIT AS
  BEGIN
    RETURN (select case when R.status = 'PAID' then 1 else 0 end
            from Reservations as R
            where R.R_ID = @res_ID  --
              and R.username = @username)
  END;

go
-- Calculate the ticket price.
CREATE FUNCTION ReservationPriceHelper(@flight INT)
  RETURNS INT AS
  BEGIN
    RETURN (select F.price from FLIGHTS as F where F.fid = @flight)
  END;
  go

-- flight capacity calculator
CREATE FUNCTION Flight_Cap_Cal(@f_ID INT)
  RETURNS INT AS
  BEGIN
    declare @f_capacity int   -- flight capacity
    declare @r_number int   -- reservation number
    set @f_capacity = (select capacity from FLIGHTS where fid = @f_ID);
    set @r_number = (select count(R_ID) from Reservations where flight1 = @f_ID
                                                             or flight2 = @f_ID);
    return @f_capacity - @r_number;
  end;

go
-- Calculate the ticket price.
CREATE FUNCTION ReservationPrice(@flight1 INT, @flight2 INT)
  RETURNS INT AS
  BEGIN
    DECLARE @returnVal INT

    IF (@flight2 <> 0)
      BEGIN
        SET @returnVal = dbo.ReservationPriceHelper(@flight1) + dbo.ReservationPriceHelper(@flight2)
      END
    ELSE
      BEGIN
        SET @returnVal = dbo.ReservationPriceHelper(@flight1)
      END
    RETURN (select @returnVal)
  END;

go
CREATE FUNCTION Flight_Day(@flightID INT)
  returns int as
  begin
    return (select F.day_of_month from FLIGHTS as F where F.fid = @flightID)
  end;

  -- Function to check day overlap.
go
create function dayOverlap(@flightID INT, @username varchar(255))
  returns bit as
  begin
    return (select count(R.R_ID)
            from Reservations as R
            where dbo.Flight_Day(@flightID) = dbo.Flight_Day(R.flight1)
              and R.username = @username)
  end;

  -- User Table
go
create table Users (
  username varchar(255) not null primary key,
  password varchar(255) not null,
  balance  int          not null check (balance > 0)
);

-- Table for reservation
go
create table Reservations (
  R_ID     int          not null                            identity primary key, -- Reservation ID
  username varchar(255) not null, -- the username of the account.
  flight1  int          not null check (dbo.Flight_Cap_Cal(flight1) >= 0),
  flight2  int check (dbo.Flight_Cap_Cal(flight2) >= 0),
  status   varchar(10) check (status in ('PAID', 'UNPAID')) default 'UNPAID',
  foreign key (flight1) references FLIGHTS (fid),
  foreign key (flight2) references FLIGHTS (fid)
);

