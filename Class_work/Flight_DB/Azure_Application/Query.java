import java.io.FileInputStream;
import java.sql.*;
import java.util.ArrayList;
import java.util.Properties;

/**
 * Runs queries against a back-end database
 */
public class Query {
    private String configFilename;
    private Properties configProps = new Properties();

    private String jSQLDriver;
    private String jSQLUrl;
    private String jSQLUser;
    private String jSQLPassword;

    // DB Connection
    private Connection conn;

    // Logged In User
    private String username; // customer username is unique

    // Itinerary Search history list
    ArrayList<Itinerary> ItineraryHistory;

    // Canned queries

    private static final String CHECK_FLIGHT_CAPACITY = "SELECT capacity FROM Flights WHERE fid = ?";
    private PreparedStatement checkFlightCapacityStatement;

    // transactions
    private static final String BEGIN_TRANSACTION_SQL = "SET TRANSACTION ISOLATION LEVEL SERIALIZABLE; BEGIN TRANSACTION;";
    private PreparedStatement beginTransactionStatement;

    private static final String COMMIT_SQL = "COMMIT TRANSACTION";
    private PreparedStatement commitTransactionStatement;

    private static final String ROLLBACK_SQL = "ROLLBACK TRANSACTION";
    private PreparedStatement rollbackTransactionStatement;

    class Flight {
        public int fid;
        public int dayOfMonth;
        public String carrierId;
        public String flightNum;
        public String originCity;
        public String destCity;
        public int time;
        public int capacity;
        public int price;

        @Override
        public String toString() {
            return "ID: " + fid + " Day: " + dayOfMonth + " Carrier: " + carrierId +
                    " Number: " + flightNum + " Origin: " + originCity + " Dest: " + destCity + " Duration: " + time +
                    " Capacity: " + capacity + " Price: " + price;
        }
    }

    public Query(String configFilename) {
        this.configFilename = configFilename;
    }

    /* Connection code to SQL Azure.  */
    public void openConnection() throws Exception {
        configProps.load(new FileInputStream(configFilename));

        jSQLDriver = configProps.getProperty("flightservice.jdbc_driver");
        jSQLUrl = configProps.getProperty("flightservice.url");
        jSQLUser = configProps.getProperty("flightservice.sqlazure_username");
        jSQLPassword = configProps.getProperty("flightservice.sqlazure_password");

        /* load jdbc drivers */
        Class.forName(jSQLDriver).newInstance();

        /* open connections to the flights database */
        conn = DriverManager.getConnection(jSQLUrl, // database
                jSQLUser, // user
                jSQLPassword); // password

        conn.setAutoCommit(true); //by default automatically commit after each statement

    /* You will also want to appropriately set the transaction's isolation level through:
       conn.setTransactionIsolation(...)
       See Connection class' JavaDoc for details.
    */
    }

    public void closeConnection() throws Exception {
        conn.close();
    }

    /**
     * Clear the data in any custom tables created. Do not drop any tables and do not
     * clear the flights table. You should clear any tables you use to store reservations
     * and reset the next reservation ID to be 1.
     */
    public void clearTables() {

        try {
            String queryString = "delete from Users;" +
                    "delete from Reservations;" +
                    "DBCC CHECKIDENT (Reservations, RESEED, 0);";
            PreparedStatement preparedStatement = conn.prepareStatement(queryString);
            preparedStatement.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /**
     * prepare all the SQL statements in this method.
     * "preparing" a statement is almost like compiling it.
     * Note that the parameters (with ?) are still not filled in
     */
    public void prepareStatements() throws Exception {
        beginTransactionStatement = conn.prepareStatement(BEGIN_TRANSACTION_SQL);
        commitTransactionStatement = conn.prepareStatement(COMMIT_SQL);
        rollbackTransactionStatement = conn.prepareStatement(ROLLBACK_SQL);

        checkFlightCapacityStatement = conn.prepareStatement(CHECK_FLIGHT_CAPACITY);

        /* add here more prepare statements for all the other queries you need */
        /* . . . . . . */
    }

    /**
     * Takes a user's username and password and attempts to log the user in.
     *
     * @param username the user name of the account
     * @param password the password of the account
     * @return If someone has already logged in, then return "User already logged in\n"
     * For all other errors, return "Login failed\n".
     * <p>
     * Otherwise, return "Logged in as [username]\n".
     */
    public String transaction_login(String username, String password) {

        try {

            if (this.username != null)
                return "User already logged in\n";

            // Query for getting matched ID and password
            String queryString = "select * from Users as A where A.username=? and A.password=?";

            // Create a statement
            PreparedStatement preparedStatement = conn.prepareStatement(queryString);
            preparedStatement.setString(1, username);
            preparedStatement.setString(2, password);
            ResultSet rset = preparedStatement.executeQuery();

            if (rset.next()) {
                this.username = rset.getString(1);

            } else {
                return "Login failed\n";
            }

        } catch (java.sql.SQLException ex) {
            ex.printStackTrace();
        }

        return "Logged in as " + username + "\n";
    }

    /**
     * Implement the create user function.
     *
     * @param username   new user's username. User names are unique the system.
     * @param password   new user's password.
     * @param initAmount initial amount to deposit into the user's account, should be >= 0 (failure otherwise).
     * @return either "Created user {@code username}\n" or "Failed to create user\n" if failed.
     */
    public String transaction_createCustomer(String username, String password, int initAmount) {
        try {

            // Create Statement, check whether the user name exist or not.
            String queryString = "select * from Users as A where A.username=?";
            PreparedStatement preparedStatement = conn.prepareStatement(queryString);
            preparedStatement.setString(1, username);

            // Transaction begins, temporarily lock the database.
            beginTransaction();
            ResultSet rset = preparedStatement.executeQuery();

            if (!rset.next()) {
                // Insert new user into the table
                queryString = "insert into Users(username, password, balance) values (?, ?, ?);";
                preparedStatement = conn.prepareStatement(queryString);
                preparedStatement.setString(1, username);
                preparedStatement.setString(2, password);
                preparedStatement.setInt(3, initAmount);
                preparedStatement.executeUpdate();
                commitTransaction();
            } else {
                rollbackTransaction();
                return "Failed to create user\n";
            }

        } catch (SQLException ex) {
            return "Failed to create user\n";
        }

        return "Created user " + username + "\n";
    }

    /**
     * Implement the search function.
     * <p>
     * Searches for flights from the given origin city to the given destination
     * city, on the given day of the month. If {@code directFlight} is true, it only
     * searches for direct flights, otherwise is searches for direct flights
     * and flights with two "hops." Only searches for up to the number of
     * itineraries given by {@code numberOfItineraries}.
     * <p>
     * The results are sorted based on total flight time.
     *
     * @param originCity
     * @param destinationCity
     * @param directFlight        if true, then only search for direct flights, otherwise include indirect flights as well
     * @param dayOfMonth
     * @param numberOfItineraries number of itineraries to return
     * @return If no itineraries were found, return "No flights match your selection\n".
     * If an error occurs, then return "Failed to search\n".
     * <p>
     * Otherwise, the sorted itineraries printed in the following format:
     * <p>
     * Itinerary [itinerary number]: [number of flights] flight(s), [total flight time] minutes\n
     * [first flight in itinerary]\n
     * ...
     * [last flight in itinerary]\n
     * <p>
     * Each flight should be printed using the same format as in the {@code Flight} class. Itinerary numbers
     * in each search should always start from 0 and increase by 1.
     * @see Flight#toString()
     */
    public String transaction_search(String originCity, String destinationCity, boolean directFlight, int dayOfMonth,
                                     int numberOfItineraries) {

        String queryString;
        PreparedStatement preparedStatement;
        ResultSet rset;
        StringBuffer sb = new StringBuffer();

        try {
            if (ItineraryHistory != null)
                ItineraryHistory.clear();
            else
                ItineraryHistory = new ArrayList<Itinerary>();

            queryString = "SELECT TOP (?) -- select top ?\n" +
                    "           F.fid                     as 'ID',\n" +
                    "           F.day_of_month            as 'Day',\n" +
                    "           F.carrier_id              as 'Carrier',\n" +
                    "           F.flight_num              as 'Number',\n" +
                    "           F.origin_city             as 'Origin',\n" +
                    "           F.dest_city               as 'Dest',\n" +
                    "           F.actual_time             as 'Duration',\n" +
                    "           dbo.Flight_Cap_Cal(F.fid) as 'Capacity',\n" +
                    "           F.price                   as 'Price'\n" +
                    "FROM Flights as F\n" +
                    "WHERE F.origin_city = ? -- select origin city ?\n" +
                    "  AND F.dest_city = ? -- select dest city ?\n" +
                    "  AND F.day_of_month = ? -- select day of month ?\n" +
                    "  AND F.canceled = 0\n" +
                    "ORDER BY actual_time ASC, fid ASC;";

            preparedStatement = conn.prepareStatement(queryString);
            preparedStatement.setInt(1, numberOfItineraries);
            preparedStatement.setString(2, originCity);
            preparedStatement.setString(3, destinationCity);
            preparedStatement.setInt(4, dayOfMonth);

            rset = preparedStatement.executeQuery();

            int count = 0;
            while (rset.next()) {
                int result_flightID = rset.getInt("ID");
                int result_time = rset.getInt("Duration");

                // Add the itinerary history to the user.
                if (username != null) {
                    ItineraryHistory.add(new Itinerary(result_flightID, 0));

                    //ItineraryHistoryHelper(username, count, result_flightID);
                }

                sb.append(ItineraryIntroHelper(count, 1, result_time) +
                        ItineraryGeneratorHelper(result_flightID, 0));

                count++;
            }

            // Customer seek itinerary with one stop also.
            if (!directFlight && count < numberOfItineraries) {
                queryString = "SELECT TOP (?)\n" +
                        "           F1.fid                            as 'ID_1',\n" +
                        "           F2.fid                            as 'ID_2',\n" +
                        "           (F1.actual_time + F2.actual_time) as 'Duration_sum'\n" +
                        "from FLIGHTS as F1,\n" +
                        "     FLIGHTS as F2\n" +
                        "WHERE F1.origin_city = ? --Origin city ?\n" +
                        "  and F2.dest_city = ?  -- dest city ?\n" +
                        "  and F1.day_of_month = ? -- day of month ?\n" +
                        "  and F1.month_id = F2.month_id\n" +
                        "  and F1.day_of_month = F2.day_of_month\n" +
                        "  and F1.dest_city = F2.origin_city\n" +
                        "  and F1.canceled = 0 -- flight not cancelled\n" +
                        "  and F2.canceled = 0 -- flight not cancelled\n" +
                        "ORDER by F1.actual_time + F2.actual_time asc;";

                preparedStatement = conn.prepareStatement(queryString);
                preparedStatement.setInt(1, numberOfItineraries - count);
                preparedStatement.setString(2, originCity);
                preparedStatement.setString(3, destinationCity);
                preparedStatement.setInt(4, dayOfMonth);

                rset = preparedStatement.executeQuery();

                while (rset.next()) {
                    int result_time_sum = rset.getInt("Duration_sum");
                    int result_flightID_1 = rset.getInt("ID_1");
                    int result_flightID_2 = rset.getInt("ID_2");

                    // Add the itinerary history to the user.
                    if (username != null) {
                        ItineraryHistory.add(new Itinerary(result_flightID_1, result_flightID_2));
                    }

                    sb.append(ItineraryIntroHelper(count, 2, result_time_sum)
                            + ItineraryGeneratorHelper(result_flightID_1, result_flightID_2));
                    count++;
                }
            }

            if (count == 0) {
                sb.append("No flights match your selection\n");
            }

        } catch (java.sql.SQLException ex) {
            ex.printStackTrace();
        }

        return sb.toString();
    }

    /**
     * Same as {@code transaction_search} except that it only performs single hop search and
     * do it in an unsafe manner.
     *
     * @param originCity
     * @param destinationCity
     * @param directFlight
     * @param dayOfMonth
     * @param numberOfItineraries
     * @return The search results. Note that this implementation *does not conform* to the format required by
     * {@code transaction_search}.
     */

    /**
     * Implements the book itinerary function.
     *
     * @param itineraryId ID of the itinerary to book. This must be one that is returned by search in the current session.
     * @return If the user is not logged in, then return "Cannot book reservations, not logged in\n".
     * If try to book an itinerary with invalid ID, then return "No such itinerary {@code itineraryId}\n".
     * If the user already has a reservation on the same day as the one that they are trying to book now, then return
     * "You cannot book two flights in the same day\n".
     * For all other errors, return "Booking failed\n".
     * <p>
     * And if booking succeeded, return "Booked flight(s), reservation ID: [reservationId]\n" where
     * reservationId is a unique number in the reservation system that starts from 1 and increments by 1 each time a
     * successful reservation is made by any user in the system.
     */
    public String transaction_book(int itineraryId) {

        // Check whether the user has logged in or not.
        if (this.username == null)
            return "Cannot book reservations, not logged in\n";
        else if (ItineraryHistory == null)
            return "Booking failed\n";

        int ReservationID = 0;

        try {
            int numberOfTicket = ItineraryHistory.size();

            if (itineraryId >= numberOfTicket) {
                return "No such itinerary " + itineraryId + "\n";
            }

            // Getting Flight info
            int flight1 = ItineraryHistory.get(itineraryId).getFlightID1();
            int flight2 = ItineraryHistory.get(itineraryId).getFlightID2();

            String queryString = "select dbo.dayOverlap(?, ?) as 'Overlap'";
            PreparedStatement preparedStatement = conn.prepareStatement(queryString);
            preparedStatement.setInt(1, flight1);
            preparedStatement.setString(2, this.username);

            ResultSet rset = preparedStatement.executeQuery();
            rset.next();

            boolean overlap = rset.getBoolean("Overlap");

            if (overlap)
                return "You cannot book two flights in the same day\n";

            // Setting the insert value to "Reservation Table"
            if (flight2 == 0) {
                // Updating the info to the table.
                queryString = "insert into Reservations(username, flight1) values(?, ?)";
                preparedStatement = conn.prepareStatement(queryString);

            } else {
                queryString = "insert into Reservations(username, flight1, flight2) values(?, ?, ?)";
                preparedStatement = conn.prepareStatement(queryString);
                preparedStatement.setInt(3, flight2);
            }
            preparedStatement.setString(1, this.username);
            preparedStatement.setInt(2, flight1);

            // insert the value into the table.
            // Begin transaction, execute
            preparedStatement.executeUpdate();


            queryString = "select MAX(R_ID) as 'ID' from Reservations;";
            preparedStatement = conn.prepareStatement(queryString);
            rset = preparedStatement.executeQuery();
            rset.next();
            ReservationID = rset.getInt("ID");

        } catch (SQLException e) {
            return "Booking failed\n";
        }

        return "Booked flight(s), reservation ID: " + ReservationID + "\n";
    }

    /**
     * Implements the reservations function.
     *
     * @return If no user has logged in, then return "Cannot view reservations, not logged in\n"
     * If the user has no reservations, then return "No reservations found\n"
     * For all other errors, return "Failed to retrieve reservations\n"
     * <p>
     * Otherwise return the reservations in the following format:
     * <p>
     * Reservation [reservation ID] paid: [true or false]:\n"
     * [flight 1 under the reservation]
     * [flight 2 under the reservation]
     * Reservation [reservation ID] paid: [true or false]:\n"
     * [flight 1 under the reservation]
     * [flight 2 under the reservation]
     * ...
     * <p>
     * Each flight should be printed using the same format as in the {@code Flight} class.
     * @see Flight#toString()
     */
    public String transaction_reservations() {
        // Check whether the information is valid or not.
        if (this.username == null) {
            return "Cannot view reservations, not logged in\n";
        }

        // Set return string.
        StringBuffer sb = new StringBuffer();

        try {
            String queryString = "select * from Reservations where username=?;";
            PreparedStatement preparedStatement = conn.prepareStatement(queryString);
            preparedStatement.setString(1, this.username);
            ResultSet rset = preparedStatement.executeQuery();

            int count = 0;
            while (rset.next()) {
                count++;
                int reservationID = rset.getInt("R_ID");
                int flight1 = rset.getInt("flight1");
                int flight2 = rset.getInt("flight2");
                String status = rset.getString("status");

                sb.append(ReservationHelper(reservationID, flight1, flight2, status));
            }


        } catch (SQLException e) {
            e.printStackTrace();
        }

        if (sb.length() == 0)
            return "No reservations found\n";
        else
            return sb.toString();
    }

    /**
     * Implements the cancel operation.
     *
     * @param reservationId the reservation ID to cancel
     * @return If no user has logged in, then return "Cannot cancel reservations, not logged in\n"
     * For all other errors, return "Failed to cancel reservation [reservationId]"
     * <p>
     * If successful, return "Canceled reservation [reservationId]"
     * <p>
     * Even though a reservation has been canceled, its ID should not be reused by the system.
     */
    public String transaction_cancel(int reservationId) {
        // only implement this if you are interested in earning extra credit for the HW!

        // In case the user is not logged in
        if (this.username == null)
            return "Cannot cancel reservations, not logged in\n";

        try {
            beginTransaction();
            String queryString = "select R.flight1 as 'Flight1', R.flight2 as 'Flight2', dbo.checkPayStatus(?, ?) as 'Status' " +
                    "from Reservations as R where R.R_ID=? and R.username=?;";
            PreparedStatement preparedStatement = conn.prepareStatement(queryString);
            preparedStatement.setInt(1, reservationId);
            preparedStatement.setString(2, this.username);
            preparedStatement.setInt(3, reservationId);
            preparedStatement.setString(4, this.username);
            ResultSet rset = preparedStatement.executeQuery();

            if (!rset.next())
                return "Failed to cancel reservation " + reservationId + "\n";

            int flight1 = rset.getInt("flight1");
            int flight2 = rset.getInt("flight2");
            boolean status = rset.getBoolean("Status");


            queryString = "delete from Reservations where R_ID=" + reservationId;
            preparedStatement = conn.prepareStatement(queryString);
            preparedStatement.executeUpdate();

            if (status) {
                queryString = "update Users set balance=balance+dbo.ReservationPrice(?, ?)";
                preparedStatement = conn.prepareStatement(queryString);
                preparedStatement.setInt(1, flight1);
                preparedStatement.setInt(2, flight2);
                preparedStatement.executeUpdate();
            }

            commitTransaction();

        } catch (SQLException e) {
            return "Failed to cancel reservation " + reservationId + "\n";
        }


        return "Canceled reservation " + reservationId + "\n";
    }

    /**
     * Implements the pay function.
     *
     * @param reservationId the reservation to pay for.
     * @return If no user has logged in, then return "Cannot pay, not logged in\n"
     * If the reservation is not found / not under the logged in user's name, then return
     * "Cannot find unpaid reservation [reservationId] under user: [username]\n"
     * If the user does not have enough money in their account, then return
     * "User has only [balance] in account but itinerary costs [cost]\n"
     * For all other errors, return "Failed to pay for reservation [reservationId]\n"
     * <p>
     * If successful, return "Paid reservation: [reservationId] remaining balance: [balance]\n"
     * where [balance] is the remaining balance in the user's account.
     */
    public String transaction_pay(int reservationId) {

        // Check whether the user is logged in or not.
        if (this.username == null) {
            return "Cannot pay, not logged in\n";
        }

        try {
            // Check whether the reservation and username match the reservation.
            String queryString = "select dbo.checkReservationExist(?, ?) as ID_exist;";
            PreparedStatement preparedStatement = conn.prepareStatement(queryString);
            preparedStatement.setInt(1, reservationId);
            preparedStatement.setString(2, this.username);
            ResultSet rset = preparedStatement.executeQuery();
            rset.next();

            // Check whether the reservation exist or not
            boolean reservationExist = rset.getBoolean("ID_exist");

            // In case there is no reservation
            if (!reservationExist)
                return "Cannot find unpaid reservation " + reservationId + " under user: " + username + "\n";

            // Check whether the reservation is paid or not
            queryString = "select dbo.checkPayStatus(?, ?) as 'status'";
            preparedStatement = conn.prepareStatement(queryString);
            preparedStatement.setInt(1, reservationId);
            preparedStatement.setString(2, this.username);
            rset = preparedStatement.executeQuery();
            rset.next();
            boolean paymentStatus = rset.getBoolean("status");

            if (paymentStatus)
                return "Cannot find unpaid reservation " + reservationId + " under user: " + username + "\n";

            // Check the balance of the user
            queryString = "select dbo.getUserBalance(?) as 'balance'";
            preparedStatement = conn.prepareStatement(queryString);
            preparedStatement.setString(1, username);
            rset = preparedStatement.executeQuery();
            rset.next();
            int userBalance = rset.getInt("balance");

            // Check the price of the ticket
            queryString = "select dbo.ReservationPrice(R.flight1, R.flight2) as 'price' from Reservations AS R where R.R_ID = ?";
            preparedStatement = conn.prepareStatement(queryString);
            preparedStatement.setInt(1, reservationId);
            rset = preparedStatement.executeQuery();
            rset.next();
            int ticketPrice = rset.getInt("price");

            if (userBalance < ticketPrice)
                return "User has only " + userBalance + " in account but itinerary costs " + ticketPrice + "\n";


            beginTransaction();

            queryString = "update Reservations set status='PAID' where R_ID=?;";
            preparedStatement = conn.prepareStatement(queryString);
            preparedStatement.setInt(1, reservationId);
            preparedStatement.executeUpdate();

            queryString = " update Users set balance = balance-?;";
            preparedStatement = conn.prepareStatement(queryString);
            preparedStatement.setInt(1, ticketPrice);
            preparedStatement.executeUpdate();

            commitTransaction();

            return "Paid reservation: " + reservationId + " remaining balance: "
                    + (userBalance - ticketPrice) + "\n";


        } catch (SQLException E) {
            E.printStackTrace();
            System.exit(2);
        }

        return "Failed to pay for reservation " + reservationId + "\n";

    }

    /* some utility functions below */

    public void beginTransaction() throws SQLException {
        conn.setAutoCommit(false);
        beginTransactionStatement.executeUpdate();
    }

    public void commitTransaction() throws SQLException {
        commitTransactionStatement.executeUpdate();
        conn.setAutoCommit(true);
    }

    public void rollbackTransaction() throws SQLException {
        rollbackTransactionStatement.executeUpdate();
        conn.setAutoCommit(true);
    }

    /**
     * Shows an example of using PreparedStatements after setting arguments. You don't need to
     * use this method if you don't want to.
     */
    private int checkFlightCapacity(int fid) throws SQLException {
        checkFlightCapacityStatement.clearParameters();
        checkFlightCapacityStatement.setInt(1, fid);
        ResultSet results = checkFlightCapacityStatement.executeQuery();
        results.next();
        int capacity = results.getInt("capacity");
        results.close();

        return capacity;
    }

    private String ItineraryGeneratorHelper(int flightID1, int flightID2) {
        StringBuffer sb = new StringBuffer();
        try {
            String queryString = "select F.fid as 'ID',\n" +
                    "       F.day_of_month as 'Day',\n" +
                    "       F.carrier_id as 'Carrier',\n" +
                    "       F.flight_num as 'Number',\n" +
                    "       F.origin_city as 'Origin',\n" +
                    "       F.dest_city as 'Dest',\n" +
                    "       F.actual_time as 'Duration',\n" +
                    "       F.capacity as 'Capacity' ,\n" +
                    "       F.price as 'Price'\n" +
                    "from FLIGHTS as F\n" +
                    "where F.fid = ?;";
            PreparedStatement preparedStatement = conn.prepareStatement(queryString);

            int i = 0;
            do {
                if (i == 0)
                    preparedStatement.setInt(1, flightID1);
                else
                    preparedStatement.setInt(1, flightID2);

                ResultSet rset = preparedStatement.executeQuery();
                rset.next();

                int result_flightID = rset.getInt("ID");
                int result_dayOfMonth = rset.getInt("Day");
                String result_carrierId = rset.getString("Carrier");
                int result_flightNum = rset.getInt("Number");
                String result_originCity = rset.getString("Origin");
                String result_destCity = rset.getString("Dest");
                int result_time = rset.getInt("Duration");
                int result_capacity = rset.getInt("Capacity");
                int result_price = rset.getInt("Price");

                sb.append(ItineraryGeneratorHelper(result_flightID, result_dayOfMonth, result_carrierId, result_flightNum,
                        result_originCity, result_destCity, result_time, result_capacity, result_price));
                i++;
            }
            while (flightID2 != 0 && i < 2);

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return sb.toString();
    }

    /**
     * Helper function to show the itinerary information.
     *
     * @param flightID     Flight ID from the SQL.
     * @param dayOfMonth   The day of the month from the information.
     * @param carrierID    Carrier ID.
     * @param flightNumber Flight Number
     * @param originCity   The origin city.
     * @param destCity     The destination city.
     * @param time         The duration in minutes.
     * @param capacity     The capacity of the airplane.
     * @param price        The price of the ticket.
     * @return String information of the ticket.
     */
    private String ItineraryGeneratorHelper(int flightID, int dayOfMonth, String carrierID, int flightNumber, String originCity,
                                            String destCity, int time, int capacity, int price) {
        return "ID: " + flightID + " Day: " + dayOfMonth + " Carrier: " + carrierID +
                " Number: " + flightNumber + " Origin: " + originCity +
                " Dest: " + destCity + " Duration: " + time + " Capacity: "
                + capacity + " Price: " + price + "\n";
    }

    /**
     * Helper function to generate the intro message of the ticket.
     *
     * @param nth            The ticket priority by time.
     * @param numberOfTicket The of ticket.
     * @param totalDuration  The total duration  of the flight
     * @return
     */
    private String ItineraryIntroHelper(int nth, int numberOfTicket, int totalDuration) {
        return "Itinerary " + nth + ": " + numberOfTicket + " flight(s), " + totalDuration + " minutes\n";
    }

    private String ReservationHelper(int R_ID, int flight1, int flight2, String status) {

        StringBuffer sb = new StringBuffer();

        boolean payment = false;
        if (status == "PAID")
            payment = true;

        sb.append("Reservation " + R_ID + " paid: " + payment + ":\n");
        sb.append(ItineraryGeneratorHelper(flight1, flight2));

        return sb.toString();
    }

    private class Itinerary {
        private int flightID1;
        private int flightID2;

        Itinerary(int flightID1, int flightID2) {
            this.flightID1 = flightID1;
            this.flightID2 = flightID2;
        }

        public int getFlightID1() {
            return flightID1;
        }

        public int getFlightID2() {
            return flightID2;
        }
    }
}
