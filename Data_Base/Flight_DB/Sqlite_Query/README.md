# Basic SQL Queries

## About the Assignment

### Objectives

To create and import databases and to practice simple SQL queries using SQLite.

## Assignment Details

In this homework, you will write several SQL queries on a relational flights database. The data in this database is abridged from the [Bureau of Transportation Statistics](http://www.transtats.bts.gov/DL_SelectFields.asp?Table_ID=236&DB_Short_Name=On-Time) The database consists of four tables regarding a subset of flights that took place in 2015:

```SQL
FLIGHTS (fid int,
         month_id int,        -- 1-12
         day_of_month int,    -- 1-31
         day_of_week_id int,  -- 1-7, 1 = Monday, 2 = Tuesday, etc
         carrier_id varchar(7),
         flight_num int,
         origin_city varchar(34),
         origin_state varchar(47),
         dest_city varchar(34),
         dest_state varchar(46),
         departure_delay int, -- in mins
         taxi_out int,        -- in mins
         arrival_delay int,   -- in mins
         canceled int,        -- 1 means canceled
         actual_time int,     -- in mins
         distance int,        -- in miles
         capacity int,
         price int            -- in $
         )

CARRIERS (cid varchar(7), name varchar(83))
MONTHS (mid int, month varchar(9))
WEEKDAYS (did int, day_of_week varchar(9))
```

We leave it up to you to decide how to declare these tables and translate their types to sqlite. But make sure that your relations include all the attributes listed above. In addition, make sure you impose the following constraints to the tables above:

- The primary key of the `FLIGHTS` table is `fid`.
- The primary keys for the other tables are `cid`, `mid`, and `did` respectively. Other than these, *do not assume any other attribute(s) is a key / unique across tuples.*
- `Flights.carrier_id` references `Carrier.cid`
- `Flights.month_id` references `Months.mid`
- `Flights.day_of_week_id` references `Weekdays.did`

We provide the flights database as a set of plain-text data files in the linked `.tar.gz` archive. Each file in this archive contains all the rows for the named table, one row per line.

In this homework, there are two parts:

1. Import the flights dataset into SQLite
2. Run SQL queries to answer a set of questions about the data.

## Problems

### Part 1: Importing the Flights Database (20 points)

To import the flights database into SQLite, you will need to run sqlite3 with a new database file. For example `sqlite3 hw2.db`. Then you can run `CREATE TABLE` statement to create the tables, choosing appropriate types for each column and specifying all key constraints as described above.

Currently, SQLite does not enforce foreign keys by default. To enable foreign keys use the following command. The command will have no effect if you installed your own version of SQLite was not compiled with foreign keys enabled. In that case do not worry about it (i.e., you will need to enforce foreign key constraints yourself as you insert data into the table).

```SQLite
PRAGMA foreign_keys=ON;
```

Then, you can use the SQLite `.import` command to read data from each text file into its table after setting the input data to be in CSV (comma separated value) form:

```SQLite
.mode csv
.import filename tablename
```

See examples of `.import` statements in the section notes, and also look at the SQLite documentation or sqlite3's help online for details.

Put all the code for this part (four `create table` statements) into the file called `create-tables.sql` inside the `hw2/submission` directory. A reminder: Make sure to think about the primary and foreign key constraints and the order in which you are creating your tables. As in HW1, when creating tables, specify attributes in the order that they are prompted.

### Writing SQL QUERIES (80 points, 10 points each)

Guidelines:

- Like in HW1, unless otherwise stated, keep the default column names (the ones from when you create tables). The test suite *should* catch this. Also, write all your SQL query statements following our mini-style guide below.
- **The predicates in your queries should correspond to the English descriptions**. For example, if a question asks you to find flights by "Alaska Airlines Inc.", the query should include a predicate that checks for that specific name as opposed to checking for the matching carrier ID. Same for predicates over months, weekdays, etc.
- In the following questions below flights, **include canceled flights as well, unless otherwise noted**. Also, when asked to output times you can report them in minutes and don’t need to do minute-hour conversion.
- If a query uses a `GROUP BY` clause, make sure that all attributes in your `SELECT` clause for that query are either grouping keys or aggregate values. SQLite will let you select other attributes but that is wrong as we discussed in lectures. Almost all other database systems would reject the such a query.

HINT: You should be able to answer all the questions below without subqueries!

1. (10 points) List the distinct flight numbers of all flights from Seattle to Boston by Alaska Airlines Inc. on Mondays. Also notice that, in the database, the city names include the state. So Seattle appears as "Seattle WA". Name the output column `flight_num`.

2. (10 points) Find all itineraries from Seattle to Boston on July 15th. Search only for itineraries that have one stop (i.e., flight 1: Seattle -> [somewhere], flight2: [somewhere] -> Boston). **Both flights must depart on the same day** (same day here means the date of flight) and **must be with the same carrier**. It's fine if the landing date is different from the departing date (i.e., in the case of an overnight flight). You don't need to check whether the first flight overlaps with the second one since the departing and arriving time of the flights are not provided. The total flight time (`actual_time`) of the entire itinerary should be fewer than 7 hours (420 minutes). For each itinerary, the query should return the name of the carrier, the first flight number, the origin and destination of that first flight, the flight time, the second flight number, the origin and destination of the second flight, the second flight time, and finally the total flight time. Only count flight times here; do not include any layover time. Name the output columns `name` as the name of the carrier, `f1_flight_num`, `f1_origin_city`, `f1_dest_city`, `f1_actual_time`, `f2_flight_num`, `f2_origin_city`, `f2_dest_city`, `f2_actual_time`, and `actual_time` as the total flight time.

3. (10 points) Find the day of the week with the longest average arrival delay. Return the name of the day and the average delay. Name the output columns `day_of_week` and `delay`. (Hint: consider using `LIMIT`. Look up what it does!)

4. (10 points) Find the names of all airlines that ever flew more than 1000 flights in one day (i.e., a specific day/month, but not any 24-hour period). Return only the names of the airlines. Do not return any duplicates (i.e., airlines with the exact same name). Name the output column `name`.

5. (10 points) Find all airlines that had more than 0.5 percent of their flights out of Seattle be canceled. Return the name of the airline and the percentage of canceled flight out of Seattle. Order the results by the percentage of canceled flights in ascending order. Name the output columns `name` and `percent`, in that order.

6. (10 points) Find the maximum price of tickets between Seattle and New York, NY. Show the maximum price for each airline separately. Name the output columns `carrier` and `max_price`, in that order.

7. (10 points) Find the total capacity of all direct flights that fly between Seattle and San Francisco, CA on July 10th. Name the output column `capacity`.

8. (10 points) Compute the total departure delay of each airline across all flights. Name the output columns `name` and `delay`, in that order.

## Grading and Using the Testing Suite

For most of your assignemnts you will be provided a junit test suite. The tests you will be given are only **basic tests**. Your actual grade will be determined from a more complete test suite as well as an evaluation from the graders.

Feel free to add more tests if you want! Check out the `Grader.java` file. We use JDBC to connect to database instances and execute statements. Java also supports relational data stuctures in its core utilities so the classes we use are well documented for you to play around with.

### Running the tests

There are only two things to do for your assignments:

1. Modify the dbconn.properties file so it contains the appropriate information (read the comments in the file).

2. Use the run-tests.sh script to set up the environment. Do this by going into your hw folder and typing the terminal command `./run-tests.sh`

If you have trouble runnning the tests and are stuck on how to fix it ask a friend or ask on Piazza.

## Programming style

To encourage good SQL programming style (and sanity) please follow these two simple style rules:

1. Give explicit names to all tables referenced in the `FROM` clause. Notice the `AS` so that it is clear which table you are referring to. For instance, instead of writing:

```sql
SELECT * FROM Flights, Carriers WHERE carrier_id = cid
```

write

```sql
SELECT * FROM flights AS F, carriers AS C WHERE F.carrier_id = C.cid
```

2. Similarly, reference to all attributes must be qualified by the table name. Instead of writing:

```sql
SELECT * FROM flights WHERE fid = 1
```

write

```sql
SELECT * FROM flights AS F WHERE F.fid = 1
```

These style guidelines will be useful when you write queries involving self joins in later assignments.

## Collaboration

All assignments are to be completed **INDIVIDUALLY**! However, you may discuss your high-level approach to solving each lab with other students in the class (and you are always welcome to discuss with any of the course staff).
