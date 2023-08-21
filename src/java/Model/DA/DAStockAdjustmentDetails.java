/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Model.DA;

import java.sql.*;
import Model.Domain.AdjustedItem;
import Model.Domain.SKU;
import Model.Domain.StockAdjustment;
import java.util.ArrayList;

public class DAStockAdjustmentDetails {

    private String host = "jdbc:derby://localhost:1527/fnfdb";
    private String user = "nbuser";
    private String password = "nbuser";
    private String tableName = "STOCKADJUSTMENTDETAILS";
    private Connection conn;
    private PreparedStatement stmt;
    private ResultSet rs;
    private DASKU skuDA;
    private DAProduct prodDA;

    public DAStockAdjustmentDetails() throws SQLException, ClassNotFoundException {
        createConnection();
        skuDA = new DASKU();
        prodDA = new DAProduct();
    }

    private void createConnection() throws SQLException, ClassNotFoundException {
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        conn = DriverManager.getConnection(host, user, password);
    }

    public void addRecord(StockAdjustment stockAd, int index) throws SQLException {
        String insertStr = "INSERT INTO " + tableName + " VALUES(?, ?, ?, ?, ?, ?)";
        
        if(stockAd.getStatus().equalsIgnoreCase("CLOSED")){
            stockAd.getAdjustedItems()[index].getSku().setSkuQty(stockAd.getAdjustedItems()[index].getAdjustedQty());
            skuDA.updateSKU(stockAd.getAdjustedItems()[index].getSku());
        }
        stmt = conn.prepareStatement(insertStr);
        stmt.setString(1, stockAd.getAdjustmentNo());
        stmt.setString(2, stockAd.getAdjustedItems()[index].getSku().getSkuNo());
        stmt.setString(3, String.format("%s", stockAd.getAdjustedItems()[index].getInitialQty()));
        stmt.setString(4, String.format("%s", stockAd.getAdjustedItems()[index].getAdjustQty()));
        stmt.setString(5, String.format("%s", stockAd.getAdjustedItems()[index].getAdjustedQty()));
        stmt.setString(6, stockAd.getAdjustedItems()[index].getRemark());
        stmt.executeUpdate();
        
    }

    public ArrayList<AdjustedItem> getAdjustedItems(String stockAdNo) throws SQLException {

        ArrayList<AdjustedItem> adjItems = new ArrayList<AdjustedItem>();
        String sqlQueryStr = "SELECT * from " + tableName + " WHERE STOCK_AD_NO = ? ";

        stmt = conn.prepareStatement(sqlQueryStr);
        stmt.setString(1, stockAdNo);
        rs = stmt.executeQuery();
        while (rs.next()) {
            adjItems.add(getCurrentRecord());
        }

        return adjItems;
    }

    public AdjustedItem getCurrentRecord() throws SQLException {
        AdjustedItem adjItem = null;
        adjItem = new AdjustedItem(skuDA.getSKU(rs.getString(2)), Integer.parseInt(rs.getString(4)), Integer.parseInt(rs.getString(5)), Integer.parseInt(rs.getString(3)), rs.getString(6));
        return adjItem;
    }
    
    public AdjustedItem getRecord(String stockAdNo) throws SQLException  {
        String sqlQueryStr = "SELECT * from " + tableName + " WHERE STOCK_AD_NO = ? ";
        AdjustedItem adjItem = null;
            stmt = conn.prepareStatement(sqlQueryStr);
            stmt.setString(1, stockAdNo);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                adjItem = new AdjustedItem(skuDA.getSKU(rs.getString(2)), Integer.parseInt(rs.getString(3)), Integer.parseInt(rs.getString(4)), Integer.parseInt(rs.getString(5)), rs.getString(6));
            }
        return adjItem;
    }
    
    public void updateRecord(AdjustedItem adjItem, String stockAdNo) throws SQLException {
            String updateStr = "UPDATE " + tableName + " SET INITIALQTY = ?, ADJUSTQTY = ?, ADJUSTEDQTY = ?, REMARK = ? WHERE STOCK_AD_NO = ? AND SKUNO = ?";
            stmt = conn.prepareStatement(updateStr);
            stmt.setString(1, String.format("%s",adjItem.getInitialQty()));
            stmt.setString(2, String.format("%s",adjItem.getAdjustQty()));
            stmt.setString(3, String.format("%s",adjItem.getAdjustedQty()));
            stmt.setString(4, adjItem.getRemark());
            stmt.setString(5, stockAdNo);
            stmt.setString(6, adjItem.getSku().getSkuNo());
            stmt.executeUpdate();
    }
    
    public void deleteRecord(AdjustedItem adjItem, String stockAdNo)throws SQLException {
            String deleteStr = "DELETE FROM " + tableName + " WHERE STOCK_AD_NO = ? AND SKUNO = ?";
            stmt = conn.prepareStatement(deleteStr);
            stmt.setString(1, stockAdNo);
            stmt.setString(2, adjItem.getSku().getSkuNo());
            stmt.executeUpdate();
    }

}
