package Model.DA;

import Model.Domain.AdjustedItem;
import java.sql.*;
import Model.Domain.StockAdjustment;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import javax.enterprise.inject.Instance;

public class DAStockAdjustment {

    private String host = "jdbc:derby://localhost:1527/fnfdb";
    private String user = "nbuser";
    private String password = "nbuser";
    private String tableName = "STOCKADJUSTMENT";
    private Connection conn;
    private PreparedStatement stmt;
    private ResultSet rs;
    private DAStockAdjustmentDetails adjItemDA;
    private DAAdmin adminDA;
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    public DAStockAdjustment() throws SQLException, ClassNotFoundException {
        createConnection();
        adjItemDA = new DAStockAdjustmentDetails();
        adminDA = new DAAdmin();
    }

    private void createConnection() throws SQLException, ClassNotFoundException {
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        conn = DriverManager.getConnection(host, user, password);
    }

    public ArrayList<StockAdjustment> getRecords() throws SQLException, ClassNotFoundException {

        ArrayList<StockAdjustment> stockAdList = new ArrayList<StockAdjustment>();
        String sqlQueryStr = "SELECT * from " + tableName;

        stmt = conn.prepareStatement(sqlQueryStr);
        rs = stmt.executeQuery();
        while (rs.next()) {
            stockAdList.add(getCurrentRecord());
        }

        return stockAdList;
    }

    public void addRecord(StockAdjustment stockAd) throws SQLException {
        String insertStr = "INSERT INTO " + tableName + " VALUES(?, ?, ?, ?, ?, ?, ?, ?)";

        stmt = conn.prepareStatement(insertStr);
        stmt.setString(1, stockAd.getAdjustmentNo());
        stmt.setString(2, stockAd.getStockAction());
        stmt.setString(3, stockAd.getRemark());
        stmt.setString(4, stockAd.getCreated_by().getUserID());
        stmt.setString(5, stockAd.getCreated_at().format(formatter));
        stmt.setString(6, null);
        stmt.setString(7, null);
        stmt.setString(8, stockAd.getStatus());
        stmt.executeUpdate();

        for (int a = 0; a < stockAd.getAdjustedItems().length; a++) {
            adjItemDA.addRecord(stockAd, a);
        }
    }

    public StockAdjustment getCurrentRecord() throws SQLException, ClassNotFoundException {
        StockAdjustment stockAd = null;
        ArrayList<AdjustedItem> adjItemList = null;
        adjItemList = adjItemDA.getAdjustedItems(rs.getString(1));
        AdjustedItem[] adjItems = new AdjustedItem[adjItemList.size()];
        for (int i = 0; i < adjItemList.size(); i++) {
            adjItems[i] = adjItemList.get(i);
        }
        if (rs.getString(6) == null) {
            stockAd = new StockAdjustment(rs.getString(1), adjItems, rs.getString(2), rs.getString(3), adminDA.getRecord(rs.getString(4)), rs.getTimestamp(5).toLocalDateTime(), rs.getString(8));
        } else {
            stockAd = new StockAdjustment(rs.getString(1), adjItems, rs.getString(2), rs.getString(3), rs.getString(8), adminDA.getRecord(rs.getString(4)), rs.getTimestamp(5).toLocalDateTime(), adminDA.getRecord(rs.getString(6)), rs.getTimestamp(7).toLocalDateTime());
        }
        return stockAd;
    }

    public StockAdjustment getRecord(String stockAdNo) throws SQLException, ClassNotFoundException {
        String queryStr = "SELECT * FROM " + tableName + " WHERE STOCK_AD_NO = ?";
        ArrayList<AdjustedItem> adjItemList = adjItemDA.getAdjustedItems(stockAdNo);
        AdjustedItem[] adjItems = new AdjustedItem[adjItemList.size()];
        for (int i = 0; i < adjItemList.size(); i++) {
            adjItems[i] = adjItemList.get(i);
        }
        StockAdjustment stockAd = null;
        stmt = conn.prepareStatement(queryStr);
        stmt.setString(1, stockAdNo);
        rs = stmt.executeQuery();

        if (rs.next()) {
            if (rs.getString(6) == null) {
                stockAd = new StockAdjustment(rs.getString(1), adjItems, rs.getString(2), rs.getString(3), adminDA.getRecord(rs.getString(4)), rs.getTimestamp(5).toLocalDateTime(), rs.getString(8));
            } else {
                stockAd = new StockAdjustment(rs.getString(1), adjItems, rs.getString(2), rs.getString(3), rs.getString(8), adminDA.getRecord(rs.getString(4)), rs.getTimestamp(5).toLocalDateTime(), adminDA.getRecord(rs.getString(6)), rs.getTimestamp(7).toLocalDateTime());
            }
        }
        return stockAd;
    }

    public void updateRecord(StockAdjustment stockAd) throws SQLException, ClassNotFoundException {
        String updateStr = "UPDATE " + tableName + " SET ACTIONPERFORMED= ?, ACTION_REMARK = ?, UPDATED_BY = ?, UPDATED_AT = ?, STATUS = ? WHERE STOCK_AD_NO = ? ";
        //delete currentlist and create new list
        StockAdjustment s = getRecord(stockAd.getAdjustmentNo());
        for (AdjustedItem adjustedItem : s.getAdjustedItems()) {
            adjItemDA.deleteRecord(adjustedItem, stockAd.getAdjustmentNo());
        }
        for (int a = 0; a < stockAd.getAdjustedItems().length; a++) {
            adjItemDA.addRecord(stockAd, a);
        }

        stmt = conn.prepareStatement(updateStr);
        stmt.setString(1, stockAd.getStockAction());
        stmt.setString(2, stockAd.getRemark());
        stmt.setString(3, stockAd.getUpdated_by().getUserID());
        stmt.setString(4, stockAd.getUpdated_at().format(formatter));
        stmt.setString(5, stockAd.getStatus());
        stmt.setString(6, stockAd.getAdjustmentNo());
        stmt.executeUpdate();
    }

    public void deleteRecord(StockAdjustment stockAd) throws SQLException {
        String deleteStr = "DELETE FROM " + tableName + " WHERE STOCK_AD_NO = ?";
        for (AdjustedItem adjustedItem : stockAd.getAdjustedItems()) {
            adjItemDA.deleteRecord(adjustedItem, stockAd.getAdjustmentNo());
        }
        stmt = conn.prepareStatement(deleteStr);
        stmt.setString(1, stockAd.getAdjustmentNo());
        stmt.executeUpdate();
    }

    public ArrayList<StockAdjustment> searchByDate(String fromDate, String toDate) throws SQLException, ClassNotFoundException {

        ArrayList<StockAdjustment> stockAdList = new ArrayList<StockAdjustment>();
        String sqlQueryStr = "SELECT * from " + tableName + " WHERE  Created_at >= '" + fromDate + " 00:00:00' AND Created_at <= '" + toDate + " 23:59:59'";

        stmt = conn.prepareStatement(sqlQueryStr);
        rs = stmt.executeQuery();
        while (rs.next()) {
            stockAdList.add(getCurrentRecord());
        }

        return stockAdList;
    }

    public ArrayList<StockAdjustment> searchByAll(String fromDate, String toDate, String stockAction, String status) throws SQLException, ClassNotFoundException {

        ArrayList<StockAdjustment> stockAdList = new ArrayList<StockAdjustment>();
        String sqlQueryStr = "SELECT * from " + tableName + " WHERE  Created_at >= '" + fromDate + " 00:00:00' AND Created_at <= '" + toDate + " 23:59:59' AND ACTIONPERFORMED = ? AND STATUS = ?";

        stmt = conn.prepareStatement(sqlQueryStr);
        stmt.setString(1, stockAction);
        stmt.setString(2, status);
        rs = stmt.executeQuery();
        while (rs.next()) {
            stockAdList.add(getCurrentRecord());
        }

        return stockAdList;
    }

    public ArrayList<StockAdjustment> searchByDateAndAction(String fromDate, String toDate, String stockAction) throws SQLException, ClassNotFoundException {

        ArrayList<StockAdjustment> stockAdList = new ArrayList<StockAdjustment>();
        String sqlQueryStr = "SELECT * from " + tableName + " WHERE  Created_at >= '" + fromDate + " 00:00:00' AND Created_at <= '" + toDate + " 23:59:59' AND ACTIONPERFORMED = ?";

        stmt = conn.prepareStatement(sqlQueryStr);
        stmt.setString(1, stockAction);
        rs = stmt.executeQuery();
        while (rs.next()) {
            stockAdList.add(getCurrentRecord());
        }

        return stockAdList;
    }

    public ArrayList<StockAdjustment> searchByDateAndStatus(String fromDate, String toDate, String status) throws SQLException, ClassNotFoundException {

        ArrayList<StockAdjustment> stockAdList = new ArrayList<StockAdjustment>();
        String sqlQueryStr = "SELECT * from " + tableName + " WHERE  Created_at >= '" + fromDate + " 00:00:00' AND Created_at <= '" + toDate + " 23:59:59' AND STATUS = ?";

        stmt = conn.prepareStatement(sqlQueryStr);
        stmt.setString(1, status);
        rs = stmt.executeQuery();
        while (rs.next()) {
            stockAdList.add(getCurrentRecord());
        }

        return stockAdList;
    }

    public ArrayList<StockAdjustment> searchByAction(String stockAction) throws SQLException, ClassNotFoundException {

        ArrayList<StockAdjustment> stockAdList = new ArrayList<StockAdjustment>();
        String sqlQueryStr = "SELECT * from " + tableName + " WHERE ACTIONPERFORMED = ?";

        stmt = conn.prepareStatement(sqlQueryStr);
        stmt.setString(1, stockAction);
        rs = stmt.executeQuery();
        while (rs.next()) {
            stockAdList.add(getCurrentRecord());
        }

        return stockAdList;
    }

    public ArrayList<StockAdjustment> searchByStatus(String status) throws SQLException, ClassNotFoundException {

        ArrayList<StockAdjustment> stockAdList = new ArrayList<StockAdjustment>();
        String sqlQueryStr = "SELECT * from " + tableName + " WHERE STATUS = ?";

        stmt = conn.prepareStatement(sqlQueryStr);
        stmt.setString(1, status);
        rs = stmt.executeQuery();
        while (rs.next()) {
            stockAdList.add(getCurrentRecord());
        }

        return stockAdList;
    }

    private void shutDown() throws SQLException {
        if (conn != null) {
            conn.close();
        }
    }
}
