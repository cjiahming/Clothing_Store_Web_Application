//Author : Cheng Cai Yuan

package Model.DA;

import Model.Domain.Refund;
import Model.Domain.Order;
import java.sql.*;
import java.util.ArrayList;
import javax.swing.*;

public class DARefund {
    private String host = "jdbc:derby://localhost:1527/fnfdb";
    private String user = "nbuser";
    private String password = "nbuser";
    private String tableName = "Refund";
    private Connection conn;
    private PreparedStatement stmt;
    private DAOrder daOrder;
    
    public DARefund(){
        createConnection();
        
    }
    
    public boolean addRefund(Refund refund) throws SQLException{
        String insertStr = "INSERT INTO " + tableName + " VALUES(?, ?, ?, ?, ?, ?)";   //sql query to insert the new record into database table
        
            stmt = conn.prepareStatement(insertStr);
            stmt.setString(1, refund.getRefundId());
            stmt.setTimestamp(2, Timestamp.valueOf(refund.getRefundCreatedTime()));
            stmt.setString(3, refund.getRefundReason());
            stmt.setString(4, refund.getRefundStatus());
            stmt.setString(5, refund.getRefundRemark());
            stmt.setString(6, refund.getOrder().getOrderId());
            return stmt.executeUpdate() > 0;  
    }
    
    public Refund getRefund(String refundId) throws SQLException{
        String queryStr = "SELECT * FROM " + tableName + " WHERE ID = ?";   //sql query to get a specific row of record from refund table 
        Refund refund = null;
        
            stmt = conn.prepareStatement(queryStr);
            stmt.setString(1, refundId);
            ResultSet rs = stmt.executeQuery();
            
            if(rs.next()){
                Order order = daOrder.getOrderRecord(rs.getString("orderID"));
                refund = new Refund(refundId,rs.getTimestamp("refundCreatedTime").toLocalDateTime(),
                        rs.getString("refundReason"),rs.getString("refundStatus"),rs.getString("refundRemark"),order);
            }
        
        return refund;
    }
    
    //added by Gabriel
    public Refund getRefundbyOrderID(String orderID) throws SQLException{
        String queryStr = "SELECT * FROM " + tableName + " WHERE ORDERID = ?";   //sql query to get a specific row of record from refund table 
        Refund refund = null;
        
            stmt = conn.prepareStatement(queryStr);
            stmt.setString(1, orderID);
            ResultSet rs = stmt.executeQuery();
            
            if(rs.next()){
                Order order = daOrder.getOrderRecord(rs.getString("orderID"));
                refund = new Refund(orderID,rs.getTimestamp("refundCreatedTime").toLocalDateTime(),
                        rs.getString("refundReason"),rs.getString("refundStatus"),rs.getString("refundRemark"),order);
            }
        
        return refund;
    }
    
    
    public ArrayList<Refund> getAllRefund() throws SQLException{
        String queryStr = "SELECT * FROM " + tableName;  //sql query to get all the data from refund table
        ArrayList<Refund> refundList = new ArrayList<Refund>();
        
            stmt = conn.prepareStatement(queryStr);
            ResultSet rs = stmt.executeQuery();
            
            while(rs.next()){
                refundList.add(new Refund(rs.getString("refundId"),rs.getTimestamp("refundCreatedTime").toLocalDateTime(),rs.getString("refundReason"),rs.getString("refundStatus"),
                        rs.getString("refundRemark"),new Order(rs.getString("orderId")))) ;
            }
        
        return refundList;
    }
    
    public void updateRefundStatus(String refundId) throws SQLException{
        String updateStr = "UPDATE " + tableName + " SET refundStatus = 'Approval' WHERE refundId = ?";  //sql query to update the status to "approval"
       
            stmt = conn.prepareStatement(updateStr);
            stmt.setString(1, refundId);
            stmt.executeUpdate();
    }
    
    private void createConnection() {
        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            conn = DriverManager.getConnection(host, user, password);
        } catch (Exception ex) {
            JOptionPane.showMessageDialog(null, ex.getMessage(), "ERROR", JOptionPane.ERROR_MESSAGE);
        }
    }
    
    public static void main(String[] args) throws SQLException{
        DARefund d = new DARefund();
        //Refund refund = new Refund("RF0002",LocalDateTime.of(0, 0, 0, 0, 0),"Duplicate select on the same product","Disapproval","",new Order("0011223344"));
       // System.out.println(refund.generateRefundId());
       //SKU sku1 = new SKU("WT0001-S-WHT","White","S",20,30,0,new Product("WT0001"));
       //d.updateRefundStatus("RF0002");
       
    }
}
