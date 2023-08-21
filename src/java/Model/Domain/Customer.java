package Model.Domain;

import java.io.Serializable;
import java.math.BigInteger;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class Customer extends User implements Serializable{
    
    public Customer() {
        
    }
    
    public Customer(String userID) {
        super(userID);
    }
    
    public Customer(String userID, String password){
        super(userID, password);
    }
    
    public Customer(String userID, String phoneNum, String email, String gender){
        super(userID, phoneNum, email, gender);
    }
    
    public Customer(String userID, String username, String phoneNum, String email, String password){
        super(userID, username, phoneNum, email, password);
    }
    
    public Customer(String userID, String username, String phoneNum, String email, String password, String gender){
        super(userID, username, phoneNum, email, password, gender);
    }
    
    //Use for encrypting password
    public static String getMd5(String input){
        try {

            // Static getInstance method is called with hashing MD5
            MessageDigest md = MessageDigest.getInstance("MD5");

            // digest() method is called to calculate message digest
            //  of an input digest() return array of byte
            byte[] messageDigest = md.digest(input.getBytes());

            // Convert byte array into signum representation
            BigInteger no = new BigInteger(1, messageDigest);

            // Convert message digest into hex value
            String hashtext = no.toString(16);
            while (hashtext.length() < 32) {
                hashtext = "0" + hashtext;
            }
            return hashtext;
        }

        // For specifying wrong message digest algorithms
        catch (NoSuchAlgorithmException e) {
            throw new RuntimeException(e);
        }
    }
    
    //Use for counting number of total rows in customer table for generating userID purposes
    public String getCustomerRows(){
        Connection conn;
        PreparedStatement stmt;
        String host = "jdbc:derby://localhost:1527/fnfdb";
        String user = "nbuser";
        String password = "nbuser";
        
        int countCustomerRows = 0;
        String nextCustomerRows;
        String nextCustomerRows2;
        
        try{
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            conn = DriverManager.getConnection(host, user, password);
            String sql = "SELECT * FROM CUSTOMER";
            stmt = conn.prepareStatement(sql);
            
            ResultSet resultSet = stmt.executeQuery();
            
            while(resultSet.next()){
                countCustomerRows++;
            }
        }
        catch (Exception ex) {
            ex.printStackTrace();
        }
        
        countCustomerRows++;
        nextCustomerRows = Integer.toString(countCustomerRows);
        nextCustomerRows2 = String.format("C%04d", Integer.parseInt(nextCustomerRows));
        return nextCustomerRows2;
    }
}
