package Model.DA;

import Model.Domain.Order;
import Model.Domain.Tracking;

import java.sql.*;
import java.util.Date;

public class DATracking {

    private String host = "jdbc:derby://localhost:1527/fnfdb";
    private String user = "nbuser";
    private String password = "nbuser";
    private Tracking tracking=new Tracking();

    private PreparedStatement stmt;
    private Connection connection;

    public DATracking(){
        createConnection();
    }

    //Get total tracking record count in order to create tracking id
    public int getTrackingCountToday() throws SQLException {
        stmt = connection.prepareStatement("SELECT COUNT (*) FROM TRACKING ");
        ResultSet rs = stmt.executeQuery();
        //if rs.next return number of count record else return 0
        return rs.next() ? rs.getInt(1) : 0;
    }

    public void insertTrackingRecord(String orderID) throws SQLException{
        stmt=connection.prepareStatement("INSERT INTO TRACKING VALUES(?,?,?)");
        stmt.setString(1, tracking.generateTrackingId());
        stmt.setTimestamp(2,new Timestamp(new Date().getTime()));
        stmt.setString(3, orderID);
        stmt.executeUpdate();
    }

    public Tracking getTrackingRecord(String orderId) throws SQLException {
        //ArrayList<Tracking> trackings=new ArrayList<>();
        Tracking tracking = null;
        String getTrackingSQL = "SELECT * FROM TRACKING T "+
                "INNER JOIN ORDERS O ON T.ORDERID=O.ORDERID WHERE T.ORDERID LIKE '%"+orderId+"%'";
        stmt = connection.prepareStatement(getTrackingSQL);
        ResultSet rs = stmt.executeQuery();
        while (rs.next()) {
            DAOrder daOrder = new DAOrder();
            Order order = daOrder.getOrderRecord(rs.getString(3));
            tracking = new Tracking(rs.getString(1), rs.getTimestamp(2), order);
        }
        return tracking;
    }

    private void shutDown() {
        if (connection != null) {
            try {
                connection.close();
            } catch (SQLException ex) {
                System.out.println("Query failed: " + ex.getMessage());
            }
        }
    }

    private void createConnection() {
        try {
            connection = DriverManager.getConnection(host, user, password);
            System.out.println("***TRACE: Connection established.");
        } catch (SQLException e) {
            System.out.println("Query failed: " + e.getMessage());
        }
    }

}
