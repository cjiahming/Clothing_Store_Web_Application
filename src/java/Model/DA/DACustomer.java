package Model.DA;

import Model.Domain.Customer;
import static java.lang.System.out;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import javax.swing.JOptionPane;

public class DACustomer {
    
    private String host = "jdbc:derby://localhost:1527/fnfdb";
    private String user = "nbuser";
    private String password = "nbuser";
    private String tableName = "CUSTOMER";
    private Connection conn;
    private PreparedStatement stmt;
    
    public DACustomer() {
        createConnection();
    }
    
    //To display all customer records
    public ArrayList<Customer> displayAllCustomerRecords() {
        ArrayList<Customer> customers = new ArrayList<>();
        String displayAllCustRecords = "SELECT * FROM " + tableName;
        
        try{
            stmt = conn.prepareStatement(displayAllCustRecords);
            ResultSet rs = stmt.executeQuery();
            
            while(rs.next()){
                String custID = rs.getString("CUSTOMERID");
                String username = rs.getString("USERNAME");
                String phoneNum = rs.getString("PHONENUM");
                String email = rs.getString("EMAIL");
                String password = rs.getString("PASSWORD");
                String gender = rs.getString("GENDER");
                customers.add(new Customer(custID, username, phoneNum, email, password, gender));
            }
        }
        catch(SQLException ex){
            ex.printStackTrace();
        }
        return customers;
    }
    
    //To display user profile details
    public Customer displaySpecificCustomer(String custID) {
        Customer customer = null;
        String displaySpecificCustomer = "SELECT * FROM " +tableName+ " WHERE CUSTOMERID = ?";
        
        try{
            stmt = conn.prepareStatement(displaySpecificCustomer);
            stmt.setString(1, custID);
            ResultSet rs = stmt.executeQuery();
            
            if(rs.next()){
                String customerID = custID;
                String username = rs.getString("USERNAME");
                String phoneNum = rs.getString("PHONENUM");
                String email = rs.getString("EMAIL");
                String password = rs.getString("PASSWORD");
                String gender = rs.getString("GENDER");
                customer = new Customer(customerID, username, phoneNum, email, password, gender);
            }
        }
        catch(SQLException ex){
            ex.printStackTrace();
        }
        return customer;
    }

    public void registerCustomer(Customer customer){
        String insertStr = "INSERT INTO " + tableName + " VALUES(?, ?, ?, ?, ?, ?)";
        
        try{
            stmt = conn.prepareStatement(insertStr);
            stmt.setString(1, customer.getUserID());
            stmt.setString(2, customer.getUsername());
            stmt.setString(3, customer.getPhoneNum());
            stmt.setString(4, customer.getEmail());
            stmt.setString(5, customer.getPassword());
            stmt.setString(6, "");
            
            stmt.executeUpdate();
        }
        catch(SQLException ex){
            ex.getMessage();
        }
    }
    
    public String getCustomerID(String username){
        String getCustomerID = "SELECT CUSTOMERID FROM "+tableName+" WHERE USERNAME=?";
        String custID = "";
        
        try{
            stmt = conn.prepareStatement(getCustomerID);
            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();
            
            if(rs.next()){
                custID = rs.getString("CUSTOMERID");
            }
        }
        catch(SQLException ex){
            ex.printStackTrace();
        }
        return custID;
    }
    
    public String getCustomerID2(String email){
        String getCustomerID = "SELECT CUSTOMERID FROM "+tableName+" WHERE EMAIL=?";
        String custID = "";
        
        try{
            stmt = conn.prepareStatement(getCustomerID);
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            
            if(rs.next()){
                custID = rs.getString("CUSTOMERID");
            }
        }
        catch(SQLException ex){
            ex.printStackTrace();
        }
        return custID;
    }
    
    public void updateCustomerRecords(Customer customer) {
        String updateStr = "UPDATE "+tableName+ " SET PHONENUM=?, EMAIL=?, GENDER=? WHERE CUSTOMERID=?";
        
        try{
            stmt = conn.prepareStatement(updateStr);
            stmt.setString(1, customer.getPhoneNum());
            stmt.setString(2, customer.getEmail());
            stmt.setString(3, customer.getGender());
            stmt.setString(4, customer.getUserID());
            
            stmt.executeUpdate();
        }
        catch(SQLException ex){
            ex.printStackTrace();
        }
    }
    
    public void updateCustomerPassword(Customer customer) {
        String updatePasswordStr = "UPDATE "+tableName+" SET PASSWORD=? WHERE CUSTOMERID=?";
        
        try{
            stmt = conn.prepareStatement(updatePasswordStr);
            stmt.setString(1, customer.getPassword());
            stmt.setString(2, customer.getUserID());
            
            stmt.executeUpdate();
        }
        catch(SQLException ex){
            ex.printStackTrace();
        }
    }
    
    public void deleteCustomer(String custID){
        String deleteStr = "DELETE FROM " + tableName + " WHERE CUSTOMERID = ?";
        
        try{
            stmt = conn.prepareStatement(deleteStr);
            stmt.setString(1, custID);
            
            stmt.executeUpdate();
            System.out.println("in here");
        }
        catch(SQLException ex){
            ex.printStackTrace();
        }
    }
    
    public boolean checkCustomerLoginDetails(String username, String password){
        String sql = "SELECT * FROM "+tableName+" WHERE USERNAME=? AND PASSWORD=?";
        boolean loginDetails = false;
        
        try{
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, username);
            stmt.setString(2, password);
            
            ResultSet rs = stmt.executeQuery();
            
            if(rs.next()){
                loginDetails = true;
            }
        }
        catch(Exception ex){
            System.out.println(ex.getMessage());
        }
        return loginDetails;
    }
    
    private void createConnection() {
        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            conn = DriverManager.getConnection(host, user, password);
        } catch (Exception ex) {
            JOptionPane.showMessageDialog(null, ex.getMessage(), "ERROR", JOptionPane.ERROR_MESSAGE);
        }
    }
}
