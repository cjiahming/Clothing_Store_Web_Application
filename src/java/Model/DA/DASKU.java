package Model.DA;

import Model.Domain.Cart;
import Model.Domain.Customer;
import Model.Domain.Order;
import Model.Domain.SKU;
import Model.Domain.Product;
import Model.Domain.Review;
import java.sql.*;
import java.util.ArrayList;
import javax.swing.*;

public class DASKU {
    private String host = "jdbc:derby://localhost:1527/fnfdb";
    private String user = "nbuser";
    private String password = "nbuser";
    private String tableName = "SKU";
    private Connection conn;
    private PreparedStatement stmt;
    private DAProduct daProd;
    
    public DASKU(){
        createConnection();
        
    }
    
    public void addSKU(SKU sku) throws SQLException{
        String insertStr = "INSERT INTO " + tableName + " VALUES(?, ?, ?, ?, ?, ?, ?)";//sql query to insert the new record into database table
        
            stmt = conn.prepareStatement(insertStr);
            stmt.setString(1, sku.getSkuNo());
            stmt.setString(2, sku.getColour());
            stmt.setString(3, String.valueOf(sku.getProdSize()));
            stmt.setInt(4, sku.getProdWidth());
            stmt.setInt(5, sku.getProdLength());
            stmt.setInt(6, sku.getSkuQty());
            stmt.setString(7, sku.getProduct().getProdID());
            stmt.executeUpdate();
           
    }
    
    public SKU searchSKU(String prodID,String colour,String prodSize) throws SQLException{
        String queryStr = "SELECT * FROM " + tableName + " WHERE prodID = ? AND colour = ? AND prodSize = ?" ;  //sql query to search the Sku record base on product ID,colour and product size
        SKU sku = null;
        
            stmt = conn.prepareStatement(queryStr);
            stmt.setString(1, prodID);
            stmt.setString(2, colour);
            stmt.setString(3, prodSize);
            
            ResultSet rs = stmt.executeQuery();
            
            if(rs.next()){
                sku = new SKU(rs.getString("skuNo"),rs.getString("colour"),rs.getString("prodSize"),rs.getInt("prodWidth"),
                        rs.getInt("prodLength"),rs.getInt("skuQty"),new Product(rs.getString("prodId")));
            }
        
        return sku;
    }
    
     public ArrayList<SKU> getAllSKU() throws SQLException{
    String queryStr = "SELECT * FROM " + tableName;  //sql query to get all the data from sku table
    ArrayList<SKU> skuList = new ArrayList<SKU>();
        
        stmt = conn.prepareStatement(queryStr);
        ResultSet rs = stmt.executeQuery();
            
        while(rs.next()){
            skuList.add(new SKU(rs.getString("skuNo"),rs.getString("colour"),rs.getString("prodSize"),rs.getInt("prodWidth"),
                rs.getInt("prodLength"),rs.getInt("skuQty"),new Product(rs.getString("prodId")))) ;
        }
        
        return skuList;
    }
    
    public SKU getSKU(String skuNo) throws SQLException{
        String queryStr = "SELECT * FROM " + tableName + " WHERE skuNo = ?";//sql query to get a specific row of record from sku table 
        SKU sku = new SKU();
        
        
            stmt = conn.prepareStatement(queryStr);
            stmt.setString(1, skuNo);
            ResultSet rs = stmt.executeQuery();
            
            
            if(rs.next()){

                sku = new SKU(skuNo,rs.getString("colour"),rs.getString("prodSize"),rs.getInt("prodWidth"),rs.getInt("prodLength"),rs.getInt("skuQty"),new Product(rs.getString("prodid")));
      
            }
        
        return sku;
    }
    
    public void updateSKU(SKU sku) throws SQLException{
        String updateStr = "UPDATE " + tableName + " SET Colour = ?, ProdSize = ?,ProdWidth = ?,ProdLength = ?, SKUQTY = ? WHERE skuNo = ?";
        
            stmt = conn.prepareStatement(updateStr);
            stmt.setString(1, sku.getColour());
            stmt.setString(2,String.valueOf(sku.getProdSize()));
            stmt.setInt(3,sku.getProdWidth());
            stmt.setInt(4,sku.getProdLength());
            stmt.setInt(5,sku.getSkuQty());
            stmt.setString(6,sku.getSkuNo());
            stmt.executeUpdate();
        
    }
    
    public void deleteSKU(String skuNo) throws SQLException{
        String deleteStr = "DELETE FROM " + tableName + " WHERE skuNo = ?";//sql query to delete Sku record from the sku table
       
            stmt = conn.prepareStatement(deleteStr);
            stmt.setString(1, skuNo);
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
    
    //CREATED BY FGABRIEL FOR SPECIFIC DETAILS PAGE
    public ArrayList<SKU> getAllSKUbyProductID(Product prod){
        ArrayList<SKU> skuArrList = new ArrayList<SKU>();
        
        try {
            String sqlStr = "SELECT * FROM " + tableName + " WHERE PRODID = ?";
            stmt = conn.prepareStatement(sqlStr);

            stmt.setString(1, prod.getProdID());
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                SKU sku = new SKU(rs.getString("colour"),rs.getString("prodsize"),rs.getInt("prodwidth"),rs.getInt("prodlength"),rs.getInt("skuqty"),new Product(rs.getString("prodid")));
                skuArrList.add(sku);

            }

        } catch (SQLException ex) {
            System.out.println(ex.getMessage() + " Delete sku Record ");
        }
        
        return skuArrList;
    }
    
    //get Total size(Added by Gabriel)
    public ArrayList<String> getAllSize(Product prod){
        DASKU dasku = new DASKU();
        ArrayList<SKU> skuArrList = dasku.getAllSKUbyProductID(prod);
        ArrayList<String> allSizeArr = new ArrayList<String>();
        
        //out loop 
            //inner loop (size of looping) 
                //if 
        
        int duplicateFound;
        for (int i = 0; i < skuArrList.size(); i++) {
            duplicateFound = 0;
            //check whether is the same with the ordList inside 
            for (int j = 0; j < allSizeArr.size(); j++) {
                //if its the same means got duplicate
                if (allSizeArr.get(j).equals(skuArrList.get(i).getProdSize())) {
                    duplicateFound++;
                }

            }

            if (duplicateFound == 0) {
                //if no duplicate found add into arraylist order
                    allSizeArr.add(skuArrList.get(i).getProdSize());
            }
        }
        
        return allSizeArr;
        
    }
    
    //get Total color(Added by Gabriel)
    public ArrayList<String> getAllColour(Product prod){
        //without filter
        DASKU dasku = new DASKU();
        ArrayList<SKU> skuArrList = dasku.getAllSKUbyProductID(prod);
        ArrayList<String> allColorArr = new ArrayList<String>();
        
        //out loop 
            //inner loop (size of looping) 
                //if 
        
        int duplicateFound;
        for (int i = 0; i < skuArrList.size(); i++) {
            duplicateFound = 0;
            //check whether is the same with the ordList inside 
            for (int j = 0; j < allColorArr.size(); j++) {
                //if its the same means got duplicate
                if (allColorArr.get(j).equals(skuArrList.get(i).getColour())) {
                    duplicateFound++;
                }

            }

            if (duplicateFound == 0) {
                //if no duplicate found add into arraylist order
                    allColorArr.add(skuArrList.get(i).getColour());
            }
        }
        
        return allColorArr;
    }
    
    //added by Gabriel
    public ArrayList<SKU> getAllSizeUnderColour(Product prod, String colour){
        //With Filter
        //compare colour then ok which means that 
        DASKU dasku = new DASKU();
        ArrayList<SKU> skuArrList = dasku.getAllSKUbyProductID(prod);
        ArrayList<SKU> sizeUnderColour = new ArrayList<SKU>();
        
        
        
        for(int i = 0 ; i < skuArrList.size() ; i++){
            if(skuArrList.get(i).getColour().equals(colour)){
                sizeUnderColour.add(skuArrList.get(i));
            }
        }
        
        return sizeUnderColour;
    }
    
    
    public static void main(String[] args){
        DASKU d = new DASKU();
        
        ArrayList<String> allSizeArr = d.getAllSize(new Product("WT0001"));
        ArrayList<String> allColorArr = d.getAllColour(new Product("WT0001"));
        
        ArrayList<SKU> Allsizeundercolour = d.getAllSizeUnderColour(new Product("WT0002"),"White");
        
        for(int i= 0 ; i < allSizeArr.size(); i++ ){
            System.out.println(Allsizeundercolour.get(i).getSkuNo());
            System.out.println("\n");
        }
    }

    //additional -ling ern
    public ArrayList<SKU> getSKUs(String prodID) throws SQLException{
        String queryStr = "SELECT * FROM " + tableName + " WHERE PRODID = ?";
        ArrayList<SKU> skuList = new ArrayList<SKU>();
        
            stmt = conn.prepareStatement(queryStr);
            stmt.setString(1, prodID);
            ResultSet rs = stmt.executeQuery();
            
            while(rs.next()){
                skuList.add(new SKU(rs.getString("skuNo"),rs.getString("colour"),rs.getString("prodSize"),rs.getInt("prodWidth"),
                        rs.getInt("prodLength"),rs.getInt("skuQty"),new Product(rs.getString("prodId")))) ;
            }
        
        return skuList;
    }
    
}
