package Model.DA;

import Model.Domain.Admin;
import java.sql.*;
import java.io.Serializable;
import java.util.ArrayList;

public class DAAdmin implements Serializable {

    private String host = "jdbc:derby://localhost:1527/fnfdb";
    private String user = "nbuser";
    private String password = "nbuser";
    private String tableName = "ADMIN";
    private Connection conn;
    private PreparedStatement stmt;
    private ResultSet rs;
    private DAUserGroup uG;

    public DAAdmin() throws SQLException, ClassNotFoundException {
        createConnection();
        uG = new DAUserGroup();
    }

    private void createConnection() throws SQLException, ClassNotFoundException {
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        conn = DriverManager.getConnection(host, user, password);
    }

    public void addRecord(Admin user) throws SQLException {
        String insertStr = "INSERT INTO " + tableName + " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?)";
        stmt = conn.prepareStatement(insertStr);
        stmt.setString(1, user.getUserID());
        stmt.setString(2, user.getUsername());
        stmt.setString(3, user.getFirstName());
        stmt.setString(4, user.getLastName());
        stmt.setString(5, user.getPhoneNum());
        stmt.setString(6, user.getEmail());
        stmt.setString(7, user.getPassword());
        stmt.setString(8, user.getGender());
        stmt.setString(9, user.getUserGroup().getID());
        stmt.executeUpdate();
    }

    public Admin getRecord(String userId) throws SQLException, ClassNotFoundException {
        String queryStr = "SELECT * FROM " + tableName + " WHERE ADMINID = ?";
        Admin user = null;
        stmt = conn.prepareStatement(queryStr);
        stmt.setString(1, userId);
        ResultSet rs = stmt.executeQuery();

        if (rs.next()) {
            user = new Admin(rs.getString(1), rs.getString(2), rs.getString(3), rs.getString(4), rs.getString(5), rs.getString(6), rs.getString(7), rs.getString(8), uG.getRecord(rs.getString(9)));
        }
        return user;
    }
    
    public String getAdminID(String username) throws SQLException{
        String getAdminID = "SELECT ADMINID FROM "+tableName+" WHERE USERNAME=?";
        String adminID = "";
        stmt = conn.prepareStatement(getAdminID);
        stmt.setString(1, username);
        ResultSet rs = stmt.executeQuery();
        
        if(rs.next()){
            adminID = rs.getString("ADMINID");
        }
        return adminID;
    }

    public void updateRecord(Admin user) throws SQLException {
        String updateStr = "UPDATE " + tableName + " SET FIRSTNAME = ?, LASTNAME = ?, PHONENUM = ?, EMAIL = ?, PASSWORD = ?, GENDER = ?, USERGROUPID = ?  WHERE ADMINID = ?";
        stmt = conn.prepareStatement(updateStr);
        stmt.setString(1, user.getFirstName());
        stmt.setString(2, user.getLastName());
        stmt.setString(3, user.getPhoneNum());
        stmt.setString(4, user.getEmail());
        stmt.setString(5, user.getPassword());
        stmt.setString(6, user.getGender());
        stmt.setString(7, user.getUserGroup().getID());
        stmt.setString(8, user.getUserID());
        stmt.executeUpdate();
    }
    
    public void updateAdminRecords(Admin admin) throws SQLException {
        String updateStr = "UPDATE "+tableName+" SET PHONENUM=?, EMAIL=?, GENDER=? WHERE ADMINID=?";
        stmt = conn.prepareStatement(updateStr);
        stmt.setString(1, admin.getPhoneNum());
        stmt.setString(2, admin.getEmail());
        stmt.setString(3, admin.getGender());
        stmt.setString(4, admin.getUserID());
        stmt.executeUpdate();
    }
    
    public void updateAdminPassword(Admin admin) throws SQLException {
        String updatePasswordStr = "UPDATE "+tableName+" SET PASSWORD=? WHERE ADMINID=?";
        stmt = conn.prepareStatement(updatePasswordStr);
        stmt.setString(1, admin.getPassword());
        stmt.setString(2, admin.getUserID());
        stmt.executeUpdate();
    }

    public Admin getCurrentRecord() throws SQLException {
        Admin user = null;
        user = new Admin(rs.getString(1), rs.getString(2), rs.getString(3), rs.getString(4), rs.getString(5), rs.getString(6), rs.getString(7), rs.getString(8), uG.getRecord(rs.getString(9)));

        return user;
    }

    public ArrayList<Admin> getUsers() throws SQLException {

        ArrayList<Admin> users = new ArrayList<Admin>();
        String sqlQueryStr = "SELECT * from " + tableName;

        stmt = conn.prepareStatement(sqlQueryStr);
        rs = stmt.executeQuery();
        while (rs.next()) {
            users.add(getCurrentRecord());
        }
        
        return users;
    }

    public void deleteRecord(Admin user) throws SQLException {
        String deleteStr = "DELETE FROM " + tableName + " WHERE ADMINID = ?";
        stmt = conn.prepareStatement(deleteStr);
        stmt.setString(1, user.getUserID());
        stmt.executeUpdate();
    }
    
    public boolean checkAdminLoginDetails(String username, String password) throws SQLException{
        String sql = "SELECT * FROM "+tableName+" WHERE USERNAME=? AND PASSWORD=?";
        boolean loginDetails = false;
        
        stmt = conn.prepareStatement(sql);
        stmt.setString(1, username);
        stmt.setString(2, password);
            
        ResultSet rs = stmt.executeQuery();
            
        if(rs.next()){
            loginDetails = true;
        }

        return loginDetails;
    }

    private void shutDown() throws SQLException {
        if (conn != null) {
            conn.close();
        }
    }
}
