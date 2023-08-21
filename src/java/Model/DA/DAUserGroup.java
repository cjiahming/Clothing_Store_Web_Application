package Model.DA;

import java.sql.*;
import Model.Domain.UserGroup;
import java.io.Serializable;
import java.util.ArrayList;

public class DAUserGroup implements Serializable {

    private String host = "jdbc:derby://localhost:1527/fnfdb";
    private String user = "nbuser";
    private String password = "nbuser";
    private String tableName = "USERGROUP";
    private Connection conn;
    private PreparedStatement stmt;
    private ResultSet rs;

    public DAUserGroup() throws SQLException, ClassNotFoundException {
        createConnection();
    }

    private void createConnection() throws SQLException, ClassNotFoundException {
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        conn = DriverManager.getConnection(host, user, password);
    }

    public void addRecord(UserGroup userGrp) throws SQLException {
        String insertStr = "INSERT INTO " + tableName + " VALUES(?, ?, ?, ?)";
        stmt = conn.prepareStatement(insertStr);
        stmt.setString(1, userGrp.getID());
        stmt.setString(2, userGrp.getName());
        stmt.setString(3, userGrp.getDesc());
        stmt.setString(4, userGrp.getAccessRights());
        stmt.executeUpdate();
    }
    
    public UserGroup getRecord(String id) throws SQLException  {
        String queryStr = "SELECT * FROM " + tableName + " WHERE USERGROUPID = ?";
        UserGroup uGroup = null;
            stmt = conn.prepareStatement(queryStr);
            stmt.setString(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                uGroup = new UserGroup(rs.getString(1),rs.getString(2), rs.getString(3), rs.getString(4));
            }
        return uGroup;
    }
    
    public void updateRecord(UserGroup uGroup) throws SQLException {
            String updateStr = "UPDATE " + tableName + " SET GROUP_DESC = ?, ACCESS = ? WHERE USERGROUPID = ?";
            stmt = conn.prepareStatement(updateStr);
            stmt.setString(1, uGroup.getDesc());
            stmt.setString(2, uGroup.getAccessRights());
            stmt.setString(3, uGroup.getID());
            stmt.executeUpdate();
    }

    public UserGroup getCurrentRecord() throws SQLException {
        UserGroup uGroup = null;
        //groupname, desc, accessrights
        uGroup = new UserGroup(rs.getString(1),rs.getString(2), rs.getString(3), rs.getString(4));

        return uGroup;
    }

    public ArrayList<UserGroup> getUserGroups() throws SQLException {

        ArrayList<UserGroup> uGroups = new ArrayList<UserGroup>();
        String sqlQueryStr = "SELECT * from " + tableName;

        stmt = conn.prepareStatement(sqlQueryStr);
        rs = stmt.executeQuery();
        while (rs.next()) {
            uGroups.add(getCurrentRecord());
        }

        return uGroups;
    }
    
    public void deleteRecord(UserGroup uGroup)throws SQLException {
            String deleteStr = "DELETE FROM " + tableName + " WHERE USERGROUPID = ?";
            stmt = conn.prepareStatement(deleteStr);
            stmt.setString(1, uGroup.getID());
            stmt.executeUpdate();
    }
    
    //search record
    public ArrayList<UserGroup> searchUserGroupName(String name) throws SQLException {
        String filter = "'" + name + "%'";
        String queryStr = "SELECT * FROM " + tableName + " WHERE GROUP_NAME = ? OR GROUP_NAME LIKE " + filter;
        ArrayList<UserGroup> uGroups = new ArrayList<UserGroup>();

        stmt = conn.prepareStatement(queryStr);
        stmt.setString(1, name);
        rs = stmt.executeQuery();
        while (rs.next()) {
            uGroups.add(getCurrentRecord());
        }
        return uGroups;
    }
    
    public ArrayList<UserGroup> searchUserGroupNameAndStatus(String name, int status) throws SQLException {
        String filter = "'" + name + "%'";
        String queryStr;
        if(status == 1){
             queryStr = "SELECT * FROM " + tableName + " WHERE GROUP_NAME = ? OR GROUP_NAME LIKE " + filter + " AND ACCESS LIKE '1%' " ;
        }else{
             queryStr = "SELECT * FROM " + tableName + " WHERE GROUP_NAME = ? OR GROUP_NAME LIKE " + filter + " AND ACCESS LIKE '0%' " ;
        }
        ArrayList<UserGroup> uGroups = new ArrayList<UserGroup>();

        stmt = conn.prepareStatement(queryStr);
        stmt.setString(1, name);
        rs = stmt.executeQuery();
        while (rs.next()) {
            uGroups.add(getCurrentRecord());
        }
        return uGroups;
    }
        
   

    
    public ArrayList<UserGroup> searchUserGroupStatus(int status) throws SQLException {

        String queryStr;
        if(status == 1){
             queryStr = "SELECT * FROM " + tableName + " WHERE ACCESS LIKE '1%' " ;
        }else{
             queryStr = "SELECT * FROM " + tableName + " WHERE ACCESS LIKE '0%' " ;
        }
        ArrayList<UserGroup> uGroups = new ArrayList<UserGroup>();

        stmt = conn.prepareStatement(queryStr);
        rs = stmt.executeQuery();
        while (rs.next()) {
            uGroups.add(getCurrentRecord());
        }
        return uGroups;
    }
    
        

    private void shutDown() throws SQLException {
        if (conn != null) {
            conn.close();
        }
    }
}
