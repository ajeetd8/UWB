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
    public static final int MAXT = Integer.MAX_VALUE;

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
    public static void connect() throws FileNotFoundException, IOException, SQLException, ClassNotFoundException, InstantiationException, IllegalAccessException {
        // Grab absolute path from dbconn.properties file
        Properties configProps = new Properties();
        configProps.load(new FileInputStream(DBCONFIG_FILENAME));
        
        String jSQLDriver = configProps.getProperty("flightservice.jdbc_driver");
        String jSQLUrl = configProps.getProperty("flightservice.url");
        String jSQLUser = configProps.getProperty("flightservice.sqlazure_username");
        String jSQLPassword = configProps.getProperty("flightservice.sqlazure_password");

        absPath = configProps.getProperty("hw3");

        // load jdbc drivers
        Class.forName(jSQLDriver).newInstance();

        // Establish connection
        try {
            conn = DriverManager.getConnection(jSQLUrl, jSQLUser, jSQLPassword);
            System.out.println("SQL Server connection has been established");
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

    @Test(timeout = MAXT)
    public void test01() throws SQLException, FileNotFoundException {
        System.out.println("Part C, Question 1");

        // Process DML statements
        Statement statement = conn.createStatement();
        List<String> statements = getSQLStatements("hw3-q1.sql");
        assertNotNull(statements);
        assertEquals(1, statements.size());

        // Check column names
        ResultSet result = statement.executeQuery(statements.get(0));
        ResultSetMetaData metadata = result.getMetaData();
        assertEquals("origin_city", metadata.getColumnName(1).toLowerCase());
        assertEquals("dest_city", metadata.getColumnName(2).toLowerCase());
        assertEquals("time", metadata.getColumnName(3).toLowerCase());

        int numRows = 0;
        Set<Row> expected = new HashSet<Row>();
        expected.add(new Row("Wrangell AK", "Petersburg AK", 51));
        expected.add(new Row("Yakutat AK", "Juneau AK", 68));
        expected.add(new Row("Yuma AZ", "Phoenix AZ", 93));
        Set<Row> actual = new HashSet<Row>();
        while (result.next()) {
            numRows++;
            actual.add(new Row(result.getString("origin_city"), result.getString("dest_city"), result.getInt("time")));
        }
        assertTrue(actual.containsAll(expected));
        assertEquals(334, numRows);
    }

    @Test(timeout = MAXT)
    public void test02() throws SQLException, FileNotFoundException {
        System.out.println("Part C, Question 2");

        // Process DML statements
        Statement statement = conn.createStatement();
        List<String> statements = getSQLStatements("hw3-q2.sql");
        assertNotNull(statements);
        assertEquals(1, statements.size());

        // Check column names
        ResultSet result = statement.executeQuery(statements.get(0));
        ResultSetMetaData metadata = result.getMetaData();
        assertEquals("city", metadata.getColumnName(1).toLowerCase());

        int numRows = 0;
        Set<Row> expected = new HashSet<Row>();
        expected.add(new Row("Kodiak AK"));
        expected.add(new Row("King Salmon AK"));
        expected.add(new Row("Dillingham AK"));
        Set<Row> actual = new HashSet<Row>();
        while (result.next()) {
            numRows++;
            actual.add(new Row(result.getString("city")));
        }
        assertTrue(actual.containsAll(expected));
        assertEquals(109, numRows);
    }

    @Test(timeout = MAXT)
    public void test03() throws SQLException, FileNotFoundException {
        System.out.println("Part C, Question 3");

        // Process DML statements
        Statement statement = conn.createStatement();
        List<String> statements = getSQLStatements("hw3-q3.sql");
        assertNotNull(statements);
        assertEquals(1, statements.size());

        // Check column names
        ResultSet result = statement.executeQuery(statements.get(0));
        ResultSetMetaData metadata = result.getMetaData();
        assertEquals("origin_city", metadata.getColumnName(1).toLowerCase());
        assertEquals("percentage", metadata.getColumnName(2).toLowerCase());

        int numRows = 0;
        Set<Row> expected = new HashSet<Row>();
        expected.add(new Row("Williston ND", 0.871485943775));
        expected.add(new Row("Wilmington NC", 0.984070796460));
        expected.add(new Row("Worcester MA", 0.661290322580));
        Set<Row> actual = new HashSet<Row>();
        while (result.next()) {
            numRows++;
            actual.add(new Row(result.getString("origin_city"), result.getDouble("percentage")));
        }
        assertTrue(actual.containsAll(expected));
        assertEquals(327, numRows);
    }

    @Test(timeout = MAXT)
    public void test04() throws SQLException, FileNotFoundException {
        System.out.println("Part C, Question 4");

        // Process DML statements
        Statement statement = conn.createStatement();
        List<String> statements = getSQLStatements("hw3-q4.sql");
        assertNotNull(statements);
        assertEquals(1, statements.size());

        // Check column names
        ResultSet result = statement.executeQuery(statements.get(0));
        ResultSetMetaData metadata = result.getMetaData();
        assertEquals("city", metadata.getColumnName(1).toLowerCase());

        int numRows = 0;
        Set<Row> expected = new HashSet<Row>();
        expected.add(new Row("Sioux City IA"));
        expected.add(new Row("Sioux Falls SD"));
        expected.add(new Row("South Bend IN"));
        Set<Row> actual = new HashSet<Row>();
        while (result.next()) {
            numRows++;
            actual.add(new Row(result.getString("city")));
        }
        assertTrue(actual.containsAll(expected));
        assertEquals(256, numRows);
    }

    @Test(timeout = MAXT)
    public void test05() throws SQLException, FileNotFoundException {
        System.out.println("Part C, Question 5");
        
        // Process DML statements
        Statement statement = conn.createStatement();
        List<String> statements = getSQLStatements("hw3-q5.sql");
        assertNotNull(statements);
        assertEquals(1, statements.size());

        // Check column names
        ResultSet result = statement.executeQuery(statements.get(0));
        ResultSetMetaData metadata = result.getMetaData();
        assertEquals("city", metadata.getColumnName(1).toLowerCase());

        int numRows = 0;
        Set<Row> expected = new HashSet<Row>();
        expected.add(new Row("Devils Lake ND"));
        expected.add(new Row("St. Augustine FL"));
        Set<Row> actual = new HashSet<Row>();
        while (result.next()) {
            numRows++;
            actual.add(new Row(result.getString("city")));
        }
        assertTrue(actual.containsAll(expected));
        assertTrue(3 == numRows || 4 == numRows);
    }

    @Test
    public void test06() throws SQLException, FileNotFoundException {
        System.out.println("Part C, Question 6");

        // Process DML statements
        Statement statement = conn.createStatement();
        List<String> statements = getSQLStatements("hw3-q6.sql");
        assertNotNull(statements);
        assertEquals(1, statements.size());

        // Check column names
        ResultSet result = statement.executeQuery(statements.get(0));
        ResultSetMetaData metadata = result.getMetaData();
        assertEquals("carrier", metadata.getColumnName(1).toLowerCase());

        int numRows = 0;
        Set<Row> expected = new HashSet<Row>();
        expected.add(new Row("Alaska Airlines Inc."));
        expected.add(new Row("United Air Lines Inc."));
        Set<Row> actual = new HashSet<Row>();
        while (result.next()) {
            numRows++;
            actual.add(new Row(result.getString("carrier")));
        }
        assertTrue(actual.containsAll(expected));
        assertEquals(4, numRows);
    }

    @Test(timeout = MAXT)
    public void test07() throws SQLException, FileNotFoundException {
        System.out.println("Part C, Question 7");
        
        // Process DML statements
        Statement statement = conn.createStatement();
        List<String> statements = getSQLStatements("hw3-q7.sql");
        assertNotNull(statements);
        assertEquals(1, statements.size());

        // Check column names
        ResultSet result = statement.executeQuery(statements.get(0));
        ResultSetMetaData metadata = result.getMetaData();
        assertEquals("carrier", metadata.getColumnName(1).toLowerCase());

        int numRows = 0;
        Set<Row> expected = new HashSet<Row>();
        expected.add(new Row("Alaska Airlines Inc."));
        expected.add(new Row("United Air Lines Inc."));
        Set<Row> actual = new HashSet<Row>();
        while (result.next()) {
            numRows++;
            actual.add(new Row(result.getString("carrier")));
        }
        assertTrue(actual.containsAll(expected));
        assertEquals(4, numRows);
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
