# Azure Query: Advanced SQL and Azure

## About the Assignment

### Objectives

To practice advanced SQL. To get familiar with commercial database management systems (SQL Server) and using a database management system in the cloud (SQL Azure).

## Assignment Details


- The queries are more challenging
- You will get to use a commercial database system (i.e., no more SQLite :). SQLite simply cannot execute these queries in any reasonable amount of time; hence, we will use SQL Server, which has one of the most advanced query optimizers. SQL Server also has a very nice client application, [SQL Server Management Studio](https://docs.microsoft.com/en-us/sql/ssms/sql-server-management-studio-ssms), that you will get to use in this assignment.
- You will use the Microsoft Azure cloud.

Here is again the schema of the `Flights` database, for your reference:

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

We leave it up to you to decide how to declare these tables and translate their types in SQL Server. But make sure that your relations include all the attributes listed above. Note that SQL Server will complain if you try to ingest data and it needs to truncate it because VARCHAR fields are too small.

In addition, impose the following constraints as in HW2:

- The primary key of the `FLIGHTS` table is `fid`.
- The primary keys for the other tables are `cid`, `mid`, and `did` respectively. Other than these, *do not assume any other attribute(s) is a key / unique across tuples.*
- `Flights.carrier_id` references `Carrier.cid`
- `Flights.month_id` references `Months.mid`
- `Flights.day_of_week_id` references `Weekdays.did`

In this homework, you will do three things:

1. Create a database in the SQL Server database management system running as a service on Microsoft Azure.
2. Write and test the SQL queries below; keep in mind that the queries are quite challenging, both for you and for the database engine (they may take some time).
3. Reflect on using a database management system running in a public cloud.

### A. Setting up an Azure SQL Database [0 points]

In this assignment, we want you to learn how to use an Azure SQL database from scratch. Your first step will thus be to setup a database in the Azure service and importing your data. This step may seem tedious but it is crucially important. We want you to be able to continue using Azure after the class ends. For this, you need to know how to use the system starting from nothing. **NOTE: These steps will take some time to complete, so start early!**

#### Step 1: Create an Azure account and log in to Azure portal

You should have received an email from invites@microsoft.com inviting you to join an organization. Follow that link to apply the subscription to your account. Afterwards, you will be forwarded to the [Azure portal](https://portal.azure.com/).

#### Step 2: Learn about Azure SQL Server

Spend some time clicking around, reading documentation, watching tutorials, and generally familiarizing yourself with Azure and SQL Server.

#### Step 3: Create a database

From the [Azure portal](https://portal.azure.com/), select "+ New" on the left,

<img width="58" alt="New Button" src="https://courses.cs.washington.edu/courses/cse414/17sp/hw/hw3/new-button.png">

then select "Databases", then select "SQL Database". This will bring up a panel with configuration options for a new DB instance.

Perform the following configuration:

- Choose a database name (e.g., "cse414-18su").
- Choose a name for the resource group that will be created (e.g., "myresourcegroup").
- Select a source: Blank database
- Create a new server by clicking on "Server" (it will say "Configure required settings"). A second panel will appear to the right; click on "Create a new server" and a third panel will appear to the right of this. Fill in the form as follows:
  - Choose a name for the server (e.g., "fooBarSqlserver"). Unlike your database name, the server name must be unique across the universe of Azure SQL databases.
  - Choose an admin login and password. (You will need this when access your database using tools other than the portal.)
  - Set the location to "West US" or "West US 2".
  - Make sure "Allow azure services to access server" is checked.
  - SELECT.
  - Change to a cheaper pricing tier. (The default is currently "Standard S2", which is too expensive.) To do this, click on "Pricing tier", which will open a pane with "Standard" selected. Find the slider for "DTUs", and turn it all the way down to 10. It should now say the monthly cost is only $15/month. **Make sure you do this!** There are two assignments this quarter that use Azure, so if you run out of $ now you won't be able to complete the other assignment. Make sure you check [SQL Azure's pricing info](https://azure.microsoft.com/en-us/pricing/details/sql-database/single/).
  - APPLY
  - Select "Pin to dashboard".

Your configuration should now look like this (again, replace "cse414-17sp" with your own database's name):

<img alt="New DB" width="300" src="https://courses.cs.washington.edu/courses/cse414/17sp/hw/hw3/new-database.png">

Now click on the "Create" button to create this database. You will see a panel on the dashboard that says "Deploying SQL Database" while the database is being set up: this will take a while. Once that is done, it should open up a panel with details on your database. (If not, click on the panel for your SQL database to open it.)

Finally, click on the button near the top that says "Set server firewall"

<img alt="Firewall" width="100" src="https://courses.cs.washington.edu/courses/cse414/17sp/hw/hw3/firewall.png">

You will need to change the settings before you can upload data. The easiest option is to add a rule that allows connections from any client, which you can do as follows:

<img alt="Firewall Rule" width="400" src="https://courses.cs.washington.edu/courses/cse414/17sp/hw/hw3/firewall-rule.png">

Be sure to click "Save" once you have added this rule.

#### Step 4: Try out the database

The simplest way to play with the database is using the built-in query editor in the Azure portal. To launch this, click on the "Tools" button on top (to the left of the firewall settings button you clicked before).

<img alt="Tools" width="80" src="https://courses.cs.washington.edu/courses/cse414/17sp/hw/hw3/tools.png">

Select "Query editor", and accept the warning that this is a preview feature if it shows up. Click on the "Login" button and enter the username and password that you chose when you created your database in Step 3. Once you have done that, you can try entering SQL commands. Press the "Run" button to execute them.

You are welcome to use the query editor to complete the assignment questions. Alternatively, you can use SQL Server Management Studio (SSMS) as we describe below or some other interface.

#### Step 5 (recommended): Use the database from SQL Server Management Studio

As convenient as the Azure portal query editor is, you may want use SQL Server Management Studio (SSMS) in order to examine SQL Server's query execution plans.

SQL Server Management Studio only runs on Windows. You have two options to get access to SQL Server Management Studio:

- Option 1: Use remote desktop connection to connect to CSE's terminal server.
  - First, install [Microsoft's remote desktop client](https://docs.microsoft.com/en-us/windows-server/remote/remote-desktop-services/clients/remote-desktop-clients) for your operating system.
  - If you plan to work off campus, then you will need to install and run [Husky OnNet](http://www.lib.washington.edu/help/connect/husky-onnet) to connect to on campus machines.
  - Start the remote desktop client, add a new connection (i.e., "PC Name") to `cse-seaquill.cs.washington.edu`. Leave the remaining fields blank.
  - Put in your UW Net ID and password as your login credentials. Click "continue" if you get a message about verifying certificates.
  - Once you have logged in, you should see a shortcut to SQL Server Management Studio on your desktop.
  - **Warning**: do not save any files on `cse-seaquill.cs.washington.edu` as they will be deleted after logging out! Please make sure that you commit them to your repository after you are done (via the gitlab web interface / dropbox / emailing the files to yourself).

- Option 2: Install SQL Server Management Studio on your Windows machine. See [this website](https://docs.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms) for instructions. For detailed instructions on installing SSMS, see [this document](https://courses.cs.washington.edu/courses/cse414/17sp/sections/Install_SSMS.pdf).

- Option 3: launch a Windows VM directly in Azure. The process is similar to how we created a database instance above. Once your VM instance is running, open the panel for the instance and click on "Connect" to download a `.rdp` file. On a Mac, you can then connect to your Windows machine by using Microsoft Remote Desktop. Once connected, you can install SSMS using the link above. **Warning:** Note that you will now be incurring costs for *both* running SQL queries on Azure and running the VM!

- Option 4: install [DataGrip](https://www.jetbrains.com/datagrip/), an IDE (like Eclipse or jGRASP) for running queries. Follow these instructions to get started up for HW3:
    1. Go to the [DataGrip students page](https://www.jetbrains.com/student/)
    2. Apply as a student (with your UW email)
    3. You should automatically get a confirmation email. Confirm it.
    4. You should now be able to log into JetBrains and now have access to an offline activation code.
    5. Download DataGrip
    6. Unzip (`tar -xzf datagrip...`) into wherever you want to store the program (ex: `~/Programs/`)
    7. `cd` into `your-path/DataGrip.../bin/`
    8. Run `./datagrip.sh` to startup DataGrip
    9. Register your activation code and any other startup settings
    10. Follow the HW3 spec to set up your database on Azure
    11. To add your Azure database navigate to Database (a widget next to the main window) > + > Data Source > Azure (Microsoft) You may be prompted to download required drivers. Do so if asked. Enter your server name, database name, and your admin username/password credentials you entered when creating your database. Test the connection, click Apply, then click OK.
    12. Have fun with Azure! You can type your queries into the main window and hit the magical green go button to run selected statements or all your statements. DataGrip also has some features including an interface to load data. Play around and see what you can do.

If you decide to use SSMS, it will ask you to connect to a SQL server instance once you launch it. Tell it the name of the server you created in Step 3 above. Then, select "SQL authentication" (rather than Windows authentication) and give it your username and password from Step 3. At that point, you should be able to see the tables of your database in the panel on the left side. Buttons to create a new query and execute it are in the middle of the menu bar, like what you see below:

<img alt="SSMS" width="436" src="https://courses.cs.washington.edu/courses/cse414/17sp/hw/hw3/ssms-menu.png">


Just to the right of the "Execute" button is an option to display the query execution plan. 
(It's highlighted yellow in the middle of the image above.) Once you do so, the query execution plan will appear in a panel 
on the bottom of SSMS, as shown [here](https://courses.cs.washington.edu/courses/cse414/17sp/hw/hw3/ssms-execute.png). We will discuss query plans in class and you may find it useful to examine them. 

Now you are ready to move on to the next part of the assignment!

### B. Ingesting Data (0 points)

Next, you will import all the data from HW2. Make sure that you execute your `CREATE TABLE` statements first so that the tables you will add tuples to already exist. Also, make sure that the types of the columns in the tables you created match the data.

To import data, you can use a utility called `bcp`, which should come with the command prompt on `cse-seaquill.cs.washington.edu`. (click on the `cmd.exe` shortcut on the desktop and type `bcp` on the command prompt).

If you are using a unix system and you prefer to do this on your own, you can use the freebcp utility, which is a part of [freetds](http://www.freetds.org/userguide/). On a Mac, you can install freebcp using the homebrew package manager:

```bash
brew install freetds
```

Make sure that homebrew installs freetds version at least 0.95.79. You may need to run `brew update` and `brew upgrade` to get the most recent versions.

The command to load `[file_name]` into the table `[table_name]` with `bcp` is:

```bash
bcp dbo.[table_name] in [file_name] -U [user_name]@[server_name] -P [password] -S [server_name].database.windows.net -c -t [separator] -r [newline] -d [database]
```

Here is an example with server `foosqlserver.database.windows.net`, user `bar`, and database name `cse414-18su`:

```bash
bcp dbo.Flights in flights-small.csv -U bar@foosqlserver -S foosqlserver.database.windows.net -P "YOUR-PASSWORD" -c -t "," -r "0x0a" -d cse414-18su
```

Usage of `freebcp` is similar to bcp except you need to use `-D` instead of `-d` when specifying the database and you need to use `\n` instead of `0x0a`. The same example from above becomes:

```bash
freebcp dbo.Flights in flights-small.csv -U bar@foosqlserver -S foosqlserver.database.windows.net -P "YOUR-PASSWORD" -c -t "," -r "\n" -D cse414-18su
```

When loading the `flights-small.csv` table, `bcp` may appear to hang toward the end; however, it probably did not hang. It is creating the index on the primary key, which will take what seems like an eternity but is approximately 20 min, and then it will complete.

As a sanity check, count the number of rows in `Flights` and make sure it matches the number of rows in the SQLite Flights table. If the count on SQL Server is too low, the data didn't all get imported. You will need to drop the table and try again.

If it continues to not work, you can try splitting the `flights-small.csv` file into multiple smaller files and importing them one at a time. On Mac, to split the file into 10 smaller files, run:

```bash
split -l 114868 flights-small.csv flights-small-part
```

On Windows, you can either use cygwin (to get the same command) or install something like [HJ-Split](http://www.hjsplit.org/).

As an alternative to the command line, Datagrip has an data importing GUI:

- After running your `CREATE TABLE` statements, right click on the table you wish to import data into.
- Click "Import Data from File..."
- Select the respective data file
- Select CSV as the file type and check "Insert inconvertable values as null"
- Click "OK" and your data should start to import. There will be a progress bar on the bottom of your window.

### C. Writing SQL Queries (90 points)

Use SQL Server Management Studio:

1. Click connect and login into your sql server
2. Choose your database and create new sql file, write your query, and execute it. See below for details.

For each question below, write a single SQL query to answer that question (you can use subqueries this time), and save your submission in the individual files `hw3-q1.sql`, `hw3-q2.sql`, etc.

**For each query, add a comment to each query the number of rows your query returns and how long the query took. You can simply copy and paste the first few rows into the comment.**

Remember to follow the SQL programming style rules from HW2, repeated below.

Note that SQL Server interprets NULL values differently than sqlite! Try using it in a `WHERE` predicate and you will see the difference.

Before you proceed with these questions here is some advice and help:

- Double check you indeed have all the data! Run some sanity checks of your own to make sure the data was all imported.
- If your query is taking well over 30-40 min, something is wrong. Check how you've written your query and make sure to avoid using unnessesary subqueries.
  - We have experienced in the past that queries that use `EXCEPT` often are extremely slow. If you are doing anything complicated with `EXCEPT` consider rewriting your query.
- Here are some `CREATE INDEX` statements to help speed up things (we don't want to waste your time!). Execute them just like any other statement.

```SQL
CREATE INDEX Flights__oc ON Flights (origin_city);
CREATE INDEX Flights__dc ON Flights (dest_city);
CREATE INDEX Flights__oc_dc ON Flights (origin_city, dest_city);
CREATE INDEX Flights__dc_oc ON Flights (dest_city, origin_city);
```

Now answer the following questions:

1. (15 points) For each origin city, find the destination city (or cities) with the longest direct flight. By direct flight, we mean a flight with no intermediate stops. Determine the longest flight in time, not distance. Name the output columns `origin_city`, `dest_city`, and `time` representing the the flight time between them. Do not include duplicates of the same origin/destination city pair. Order the result by `origin_city` and then `dest_city` in ascending (default) order.

2. (15 points) Find all origin cities that only serve flights shorter than 3 hours. You can assume that flights with `NULL` actual_time are not 3 hours or more. Name the output column `city` and sort them. List each city only once in the result.

3. (15 points) For each origin city, find the percentage (computed as a decimal number between 0 to 1, e.g., 0.5 means 50%) of departing flights shorter than 3 hours. For this question, treat flights with `NULL` `actual_time` values as longer than 3 hours. Name the output columns `origin_city` and `percentage`. Order by percentage value in ascending (default) order. Be careful to handle cities without any flights shorter than 3 hours. We will accept both `0` and `NULL` as the result for those cities.

4. (15 points) List all cities that cannot be reached from Seattle though a direct flight but can be reached with one stop (i.e., with any two flights that go through an intermediate city). Do not include Seattle as one of these destinations (even though you could get back with two flights). Name the output column `city`

5. (15 points) List all cities that cannot be reached from Seattle through a direct flight nor with one stop (i.e., with any two flights that go through an intermediate city). Do not include Seattle as one of these destinations. Warning: this query might take a while to execute. We will learn about how to speed this up in later lectures.  Name the output column `city`. You can assume "all cities" to be the collection of all `origin_city` or all `dest_city`. Do not worry if this query takes a while to execute. We are mostly concerned with the results. Output relation cardinality is 3 or 4, depending on what you consider to be the set of all cities.

6. (7 points) List the names of carriers that operate flights from Seattle to San Francisco, CA. Return each carrier's name only once. Use a nested query to answer this question. Name the output column `carrier`.

7. (8 points) Express the same query as above, but do so without using a nested query. Again, name the output column `carrier`.

Save your answer in the file called `hw3-d.txt`.

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
