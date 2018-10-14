import org.junit.*;
import static org.junit.Assert.*;
import org.junit.runner.*;
import org.junit.runner.notification.*;
import org.junit.runners.*;
import java.sql.*;
import java.util.*;
import java.util.regex.*;
import java.util.function.*;
import java.io.*;
import java.time.*;

/**
 * Junit test suite for HW2.
 * 
 * @author Jonathan Leang (jleang@cs.uw.edu)
 */
@FixMethodOrder(MethodSorters.NAME_ASCENDING)
public class Grader {

    // File containing JDBC connection properties
    public static final String DBCONFIG_FILENAME = "dbconn.properties";
    // JDBC URL prefix
    public static final String PROTOCOL = "jdbc:sqlite:";
    // Maximum time to complete a test
    public static final int MAXT = 15000;

    public static final String FLIGHTS = "SELECT * FROM Flights;";
    public static final String CARRIERS = "SELECT * FROM Carriers;";
    public static final String MONTHS = "SELECT * FROM Months;";
    public static final String WEEKDAYS = "SELECT * FROM Weekdays;";

    public static String absPath;
    public static Connection conn;

    /*
     * Framework
     */

    @BeforeClass
    public static void connect() throws FileNotFoundException, IOException, SQLException {
        // Grab absolute path from dbconn.properties file
        Properties configProps = new Properties();
        configProps.load(new FileInputStream(DBCONFIG_FILENAME));
        absPath = configProps.getProperty("hw2");

        // Generate the JDBC URL string for database(s)
        System.out.println("SQLite databases specified location: " + absPath);
        String DBURL = PROTOCOL + absPath + "/tmp.db";

        // Establish connection
        try {
            conn = DriverManager.getConnection(DBURL);
            System.out.println("SQLite connections have been established");
            System.out.println();
        } catch (SQLException e) {
            // An error occured when attempting to establish a connection
            // Attempt to close out then throw the original exception
            close();
            throw e;
        }
    }

    @AfterClass
    public static void close() throws SQLException {
        // Close out connections
        if (conn != null) {
            conn.close();
        }
    }

    @AfterClass
    public static void done() {
        System.out.println("All tests finished.");
    }

    @Before
    public void header() {
        System.out.println("------------------------------------------------");
    }

    @After
    public void footer() {
        System.out.println("------------------------------------------------");
        System.out.println();
    }

    /*
     * Tests
     */

    @Test(timeout = 120000)
    public void test00() throws SQLException, FileNotFoundException, IOException, InterruptedException {
        System.out.println("Part 1, Create Tables");

        // Execute DDL statements
        Statement statement = conn.createStatement();
        List<String> statements = getSQLStatements("create-tables.sql");
        assertNotNull(statements);
        assertEquals(4, statements.size());
        statement.execute(statements.get(0));
        statement.execute(statements.get(1));
        statement.execute(statements.get(2));
        statement.execute(statements.get(3));

        // Check column names
        ResultSet result = statement.executeQuery(FLIGHTS);
        ResultSetMetaData metadata = result.getMetaData();
        assertEquals("fid", metadata.getColumnName(1).toLowerCase());
        assertEquals("month_id", metadata.getColumnName(2).toLowerCase());
        assertEquals("day_of_month", metadata.getColumnName(3).toLowerCase());
        assertEquals("day_of_week_id", metadata.getColumnName(4).toLowerCase());
        assertEquals("carrier_id", metadata.getColumnName(5).toLowerCase());
        assertEquals("flight_num", metadata.getColumnName(6).toLowerCase());
        assertEquals("origin_city", metadata.getColumnName(7).toLowerCase());
        assertEquals("origin_state", metadata.getColumnName(8).toLowerCase());
        assertEquals("dest_city", metadata.getColumnName(9).toLowerCase());
        assertEquals("dest_state", metadata.getColumnName(10).toLowerCase());
        assertEquals("departure_delay", metadata.getColumnName(11).toLowerCase());
        assertEquals("taxi_out", metadata.getColumnName(12).toLowerCase());
        assertEquals("arrival_delay", metadata.getColumnName(13).toLowerCase());
        assertEquals("canceled", metadata.getColumnName(14).toLowerCase());
        assertEquals("actual_time", metadata.getColumnName(15).toLowerCase());
        assertEquals("distance", metadata.getColumnName(16).toLowerCase());
        assertEquals("capacity", metadata.getColumnName(17).toLowerCase());
        assertEquals("price", metadata.getColumnName(18).toLowerCase());

        result = statement.executeQuery(CARRIERS);
        metadata = result.getMetaData();
        assertEquals("cid", metadata.getColumnName(1).toLowerCase());
        assertEquals("name", metadata.getColumnName(2).toLowerCase());

        result = statement.executeQuery(MONTHS);
        metadata = result.getMetaData();
        assertEquals("mid", metadata.getColumnName(1).toLowerCase());
        assertEquals("month", metadata.getColumnName(2).toLowerCase());

        result = statement.executeQuery(WEEKDAYS);
        metadata = result.getMetaData();
        assertEquals("did", metadata.getColumnName(1).toLowerCase());
        assertEquals("day_of_week", metadata.getColumnName(2).toLowerCase());

        // Import data
        String[] command = new String[] {"bash", "-c", "echo -e \".separator \",\"\\n.import " + absPath + "/data/carriers.csv Carriers\" | sqlite3 " + absPath + "/tmp.db"};
        Process p = Runtime.getRuntime().exec(command);
        p.waitFor();

        command = new String[] {"bash", "-c", "echo -e \".separator \",\"\\n.import " + absPath + "/data/months.csv Months\" | sqlite3 " + absPath + "/tmp.db"};
        p = Runtime.getRuntime().exec(command);
        p.waitFor();

        command = new String[] {"bash", "-c", "echo -e \".separator \",\"\\n.import " + absPath + "/data/weekdays.csv Weekdays\" | sqlite3 " + absPath + "/tmp.db"};
        p = Runtime.getRuntime().exec(command);
        p.waitFor();

        command = new String[] {"bash", "-c", "echo -e \".separator \",\"\\n.import " + absPath + "/data/flights-small.csv Flights\" | sqlite3 " + absPath + "/tmp.db"};
        p = Runtime.getRuntime().exec(command);
        p.waitFor();
    }

    @Test(timeout = MAXT)
    public void test01() throws SQLException, FileNotFoundException {
        System.out.println("Part 2, Question 1");

        // Process DML statements
        Statement statement = conn.createStatement();
        List<String> statements = getSQLStatements("hw1-q1.sql");
        assertNotNull(statements);
        assertEquals(1, statements.size());

        // Check column names
        ResultSet result = statement.executeQuery(statements.get(0));
        ResultSetMetaData metadata = result.getMetaData();
        assertEquals("flight_num", metadata.getColumnName(1).toLowerCase());

        int numRows = 0;
        Set<Integer> expected = new HashSet<>();
        expected.add(12);
        expected.add(24);
        expected.add(734);
        while (result.next()) {
            numRows++;
            assertTrue(expected.contains(result.getInt("flight_num")));
        }
        assertEquals(3, numRows);
    }

    @Test(timeout = MAXT)
    public void test02() throws SQLException, FileNotFoundException {
        System.out.println("Part 1, Question 2");

        // Process DML statements
        Statement statement = conn.createStatement();
        List<String> statements = getSQLStatements("hw1-q2.sql");
        assertNotNull(statements);
        assertEquals(1, statements.size());

        // Check column names
        ResultSet result = statement.executeQuery(statements.get(0));
        ResultSetMetaData metadata = result.getMetaData();
        assertEquals("name", metadata.getColumnName(1).toLowerCase());
        assertEquals("f1_flight_num", metadata.getColumnName(2).toLowerCase());
        assertEquals("f1_origin_city", metadata.getColumnName(3).toLowerCase());
        assertEquals("f1_dest_city", metadata.getColumnName(4).toLowerCase());
        assertEquals("f1_actual_time", metadata.getColumnName(5).toLowerCase());
        assertEquals("f2_flight_num", metadata.getColumnName(6).toLowerCase());
        assertEquals("f2_origin_city", metadata.getColumnName(7).toLowerCase());
        assertEquals("f2_dest_city", metadata.getColumnName(8).toLowerCase());
        assertEquals("f2_actual_time", metadata.getColumnName(9).toLowerCase());
        assertEquals("actual_time", metadata.getColumnName(10).toLowerCase());

        int numRows = 0;
        while (result.next()) {
            numRows++;
            assertTrue(result.getInt("actual_time") < 420);
            assertEquals("Seattle WA", result.getString("f1_origin_city"));
            assertEquals("Boston MA", result.getString("f2_dest_city"));
        }
        assertEquals(1472, numRows);
    }

    @Test(timeout = MAXT)
    public void test03() throws SQLException, FileNotFoundException {
        System.out.println("Part 1, Question 3");

        // Process DML statements
        Statement statement = conn.createStatement();
        List<String> statements = getSQLStatements("hw1-q3.sql");
        assertNotNull(statements);
        assertEquals(1, statements.size());

        // Check column names
        ResultSet result = statement.executeQuery(statements.get(0));
        ResultSetMetaData metadata = result.getMetaData();
        assertEquals("day_of_week", metadata.getColumnName(1).toLowerCase());
        assertEquals("delay", metadata.getColumnName(2).toLowerCase());

        int numRows = 0;
        while (result.next()) {
            numRows++;
            assertEquals("Friday", result.getString("day_of_week"));
        }
        assertEquals(1, numRows);
    }

    @Test(timeout = MAXT)
    public void test04() throws SQLException, FileNotFoundException {
        System.out.println("Part 1, Question 4");

        // Process DML statements
        Statement statement = conn.createStatement();
        List<String> statements = getSQLStatements("hw1-q4.sql");
        assertNotNull(statements);
        assertEquals(1, statements.size());

        // Check column names
        ResultSet result = statement.executeQuery(statements.get(0));
        ResultSetMetaData metadata = result.getMetaData();
        assertEquals("name", metadata.getColumnName(1).toLowerCase());

        int numRows = 0;
        Set<String> expected = new HashSet<>();
        expected.add("American Airlines Inc.");
        expected.add("Comair Inc.");
        expected.add("Delta Air Lines Inc.");
        expected.add("Envoy Air");
        expected.add("ExpressJet Airlines Inc.");
        expected.add("ExpressJet Airlines Inc. (1)");
        expected.add("JetBlue Airways");
        expected.add("Northwest Airlines Inc.");
        expected.add("SkyWest Airlines Inc.");
        expected.add("Southwest Airlines Co.");
        expected.add("US Airways Inc.");
        expected.add("United Air Lines Inc.");
        while (result.next()) {
            numRows++;
            assertTrue(expected.contains(result.getString("name")));
        }
        assertEquals(12, numRows);
    }

    @Test(timeout = MAXT)
    public void test05() throws SQLException, FileNotFoundException {
        System.out.println("Part 1, Question 5");
        
        // Process DML statements
        Statement statement = conn.createStatement();
        List<String> statements = getSQLStatements("hw1-q5.sql");
        assertNotNull(statements);
        assertEquals(1, statements.size());

        // Check column names
        ResultSet result = statement.executeQuery(statements.get(0));
        ResultSetMetaData metadata = result.getMetaData();
        assertEquals("name", metadata.getColumnName(1).toLowerCase());
        assertEquals("percent", metadata.getColumnName(2).toLowerCase());

        int numRows = 0;
        Set<String> expected = new HashSet<>();
        expected.add("SkyWest Airlines Inc.");
        expected.add("Frontier Airlines Inc.");
        expected.add("United Air Lines Inc.");
        expected.add("JetBlue Airways");
        expected.add("Northwest Airlines Inc.");
        expected.add("ExpressJet Airlines Inc.");
        while (result.next()) {
            numRows++;
            assertTrue(expected.contains(result.getString("name")));
        }
        assertEquals(6, numRows);
    }

    @Test
    public void test06() throws SQLException, FileNotFoundException {
        System.out.println("Part 1, Question 6");

        // Process DML statements
        Statement statement = conn.createStatement();
        List<String> statements = getSQLStatements("hw1-q6.sql");
        assertNotNull(statements);
        assertEquals(1, statements.size());

        // Check column names
        ResultSet result = statement.executeQuery(statements.get(0));
        ResultSetMetaData metadata = result.getMetaData();
        assertEquals("carrier", metadata.getColumnName(1).toLowerCase());
        assertEquals("max_price", metadata.getColumnName(2).toLowerCase());

        int numRows = 0;
        Set<String> expected = new HashSet<>();
        expected.add("American Airlines Inc.");
        expected.add("JetBlue Airways");
        expected.add("Delta Air Lines Inc.");
        while (result.next()) {
            numRows++;
            assertTrue(expected.contains(result.getString("carrier")));
        }
        assertEquals(3, numRows);
    }

    @Test(timeout = MAXT)
    public void test07() throws SQLException, FileNotFoundException {
        System.out.println("Part 2, Question 7");
        
        // Process DML statements
        Statement statement = conn.createStatement();
        List<String> statements = getSQLStatements("hw1-q7.sql");
        assertNotNull(statements);
        assertEquals(1, statements.size());

        // Check column names
        ResultSet result = statement.executeQuery(statements.get(0));
        ResultSetMetaData metadata = result.getMetaData();
        assertEquals("capacity", metadata.getColumnName(1).toLowerCase());

        int numRows = 0;
        while (result.next()) {
            numRows++;
            assertEquals(680, result.getInt("capacity"));
        }
        assertEquals(1, numRows);
    }

    @Test(timeout = MAXT)
    public void test08() throws SQLException, FileNotFoundException {
        System.out.println("Part 2, Question 8");

        // Process DML statements
        Statement statement = conn.createStatement();
        List<String> statements = getSQLStatements("hw1-q8.sql");
        assertNotNull(statements);
        assertEquals(1, statements.size());

        // Check column names
        ResultSet result = statement.executeQuery(statements.get(0));
        ResultSetMetaData metadata = result.getMetaData();
        assertEquals("name", metadata.getColumnName(1).toLowerCase());
        assertEquals("delay", metadata.getColumnName(2).toLowerCase());

        int numRows = 0;
        Map<String, Integer> expected = new HashMap<>();
        expected.put("American Airlines Inc.", 1849386);
        expected.put("Alaska Airlines Inc.", 285111);
        while (result.next()) {
            numRows++;
            if (expected.containsKey(result.getString("name"))) {
                assertEquals((int) expected.get(result.getString("name")), result.getInt("delay"));
            }
        }
        assertEquals(22, numRows);
    }

    /*
     * Utilities
     */

    /**
     * Parse file into all valid statements
     */
    public List<String> getSQLStatements(String filename) throws FileNotFoundException {
        // clean block comments
        String content = (new Scanner(new File(absPath + "/sql/" + filename)).useDelimiter("\\Z")).next();
        Pattern commentPattern = Pattern.compile("/\\*.*?\\*/", Pattern.DOTALL);
        content = commentPattern.matcher(content).replaceAll("");

        // clean single line comments and special commands
        StringBuilder sb = new StringBuilder();
        Scanner sc = new Scanner(content).useDelimiter("\r\n|[\r\n]");
        String s = null;
        while (sc.hasNext()) {
            sb.append(sc.next().trim().replaceAll("--.*|^\\s*\\..*|^\\s*PRAGMA.*", "") + "\n");
        }

        // tokenize statements
        List<String> statements = new ArrayList<>();
        sc = new Scanner(sb.toString()).useDelimiter(";");
        s = null;
        while (sc.hasNext()) {
            s = sc.next().trim() + ";";
            statements.add(s);
        }

        // clean residuals
        statements.removeAll(Collections.singleton(null));
        statements.removeAll(Collections.singleton(";"));

        System.out.println(statements.toString());

        return statements;
    }

    /**
     * Lightweight row object (wrapper over an Object array)
     */
    public class Row {

        public Object[] values;

        public Row(Object... values) {
            this.values = values;
        }

        public int size() {
            return values.length;
        }

        public Object get(int column) {
            return values[column];
        }

        @Override
        public boolean equals(Object o) {
            if (o == this) {
                return true;
            }
            if (!(o instanceof Row)) {
                return false;
            }
            Row row = (Row) o;
            if (row.size() != values.length) {
                return false;
            }
            for (int i = 0; i < values.length; i++) {
                Object v = row.get(i);
                if (!((v == null && values[i] == null) || (v != null && v.equals(values[i])))) {
                    return false;
                }
            }
            return true;
        }

        @Override
        public int hashCode() {
            int hc = 0;
            for (int i = 0; i < values.length; i++) {
                hc = hc ^ (values[i] == null ? -1 : values[i].hashCode());
            }
            return hc;
        }

        @Override
        public String toString() {
            StringBuilder sb = new StringBuilder("{");
            int i;
            for (i = 0; i < values.length - 1; i++) {
                sb.append(values[i] == null ? "null," : (values[i].toString() + ","));
            }
            if (i == values.length - 1) {
                sb.append(values[i] == null ? "null" : (values[i].toString()));
            }
            sb.append("}");
            return sb.toString();
        }

    }

}
