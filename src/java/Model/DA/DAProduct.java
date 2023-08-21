/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Model.DA;

/**
 *
 * @author Ashley
 */
import Model.Domain.Product;
import java.sql.*;
import java.util.ArrayList;
import javax.swing.*;

public class DAProduct {

    //to initiate the database connection
    private String host = "jdbc:derby://localhost:1527/fnfdb";
    private String user = "nbuser";
    private String password = "nbuser";
    private String tableName = "Product";
    private Connection conn;
    private PreparedStatement stmt;

    public DAProduct() {
        createConnection();
    }

    //retrieve a single product method
    public Product getRecord(String prodID) throws SQLException {
        //create retrieve product SQL statement
        String queryStr = "SELECT * FROM " + tableName + " WHERE ProdID = ?";

        Product product = null;

        //update parameter
        stmt = conn.prepareStatement(queryStr);
        stmt.setString(1, prodID);
        ResultSet rs = stmt.executeQuery();                                       //execute the SQL statement

        if (rs.next()) {
            product = new Product(prodID, rs.getString("prodName"), rs.getString("prodDesc"), rs.getFloat("prodPrice"), rs.getString("prodCategory"), rs.getString("prodImage"));
        }

        return product;
    }
    
    //retrieve all products method
    public ArrayList<Product> getRecords() throws SQLException {
        ArrayList<Product> products = new ArrayList<Product>();
        
        //create retrieve products SQL statement
        String queryStr = "SELECT * FROM " + tableName;
        
        stmt = conn.prepareStatement(queryStr);
        ResultSet rs = stmt.executeQuery();                                       //execute the SQL statement
        
        while (rs.next()) {
            Product product = null;
            product = new Product(rs.getString(1), rs.getString(2), rs.getString(3), rs.getFloat(4), rs.getString(5), rs.getString(6));
            products.add(product);
        }
        
        return products;
    }
    
    //retrieve all products by category method
    public ArrayList<Product> getRecordsByCategory(String prodCategory) throws SQLException {
        ArrayList<Product> products = new ArrayList<Product>();
        
        //create retrieve products by category SQL statement
        String queryStr = "SELECT * FROM " + tableName + " WHERE ProdCategory = ?";
        
        //update parameter
        stmt = conn.prepareStatement(queryStr);
        stmt.setString(1, prodCategory);
        ResultSet rs = stmt.executeQuery();                                       //execute the SQL statement
        
        while (rs.next()) {
            Product product = null;
            product = new Product(rs.getString("prodID"), rs.getString("prodName"), rs.getString("prodDesc"), rs.getFloat("prodPrice"), prodCategory, rs.getString("prodImage"));
            products.add(product);
        }
        
        return products;
    }
    
    //product filtering method (Price Range)
    public ArrayList<Product> getRecordsByPriceRange(String prodPriceMin, String prodPriceMax) throws SQLException {
        ArrayList<Product> products = new ArrayList<Product>();
        
        //create filter products by price range SQL statement
        String queryStr = "SELECT * FROM " + tableName + " WHERE ProdPrice BETWEEN ? AND ?";
        
        //update parameters
        stmt = conn.prepareStatement(queryStr);
        stmt.setString(1, prodPriceMin);
        stmt.setString(2, prodPriceMax);
        ResultSet rs = stmt.executeQuery();                                       //execute the SQL statement
        
        while (rs.next()) {
            Product product = null;
            product = new Product(rs.getString("prodID"), rs.getString("prodName"), rs.getString("prodDesc"), rs.getFloat("prodPrice"), rs.getString("prodCategory"), rs.getString("prodImage"));
            products.add(product);
        }
        
        return products;
    }
    
    //product filtering method (Price Range and Category)
    public ArrayList<Product> getRecordsByPriceRangeCategory(String prodPriceMin, String prodPriceMax, String prodCategory) throws SQLException {
        ArrayList<Product> products = new ArrayList<Product>();
        
        //create filter products by price range and category SQL statement
        String queryStr = "SELECT * FROM " + tableName + " WHERE ProdCategory = ? AND ProdPrice BETWEEN ? AND ?";
        
        //update parameters
        stmt = conn.prepareStatement(queryStr);
        stmt.setString(1, prodCategory);
        stmt.setString(2, prodPriceMin);
        stmt.setString(3, prodPriceMax);
        ResultSet rs = stmt.executeQuery();                                       //execute the SQL statement
        
        while (rs.next()) {
            Product product = null;
            product = new Product(rs.getString("prodID"), rs.getString("prodName"), rs.getString("prodDesc"), rs.getFloat("prodPrice"), prodCategory, rs.getString("prodImage"));
            products.add(product);
        }
        
        return products;
    }
    
    //product sorting (Price: Low to High)
    public ArrayList<Product> getRecordsSortByPriceLow(String prodCategory) throws SQLException {
        ArrayList<Product> products = new ArrayList<Product>();
        
        //create sort products by price low to high SQL statement
        String queryStr = "SELECT * FROM " + tableName + " WHERE ProdCategory = ? ORDER BY ProdPrice ASC";
        
        //update parameter
        stmt = conn.prepareStatement(queryStr);
        stmt.setString(1, prodCategory);
        ResultSet rs = stmt.executeQuery();                                       //execute the SQL statement
        
        while (rs.next()) {
            Product product = null;
            product = new Product(rs.getString("prodID"), rs.getString("prodName"), rs.getString("prodDesc"), rs.getFloat("prodPrice"), prodCategory, rs.getString("prodImage"));
            products.add(product);
        }
        
        return products;
    }
    
    //product sorting (Price: High to Low)
    public ArrayList<Product> getRecordsSortByPriceHigh(String prodCategory) throws SQLException {
        ArrayList<Product> products = new ArrayList<Product>();
        
        //create sort products by price high to low SQL statement
        String queryStr = "SELECT * FROM " + tableName + " WHERE ProdCategory = ? ORDER BY ProdPrice DESC";
        
        //update parameter
        stmt = conn.prepareStatement(queryStr);
        stmt.setString(1, prodCategory);
        ResultSet rs = stmt.executeQuery();                                       //execute the SQL statement
        
        while (rs.next()) {
            Product product = null;
            product = new Product(rs.getString("prodID"), rs.getString("prodName"), rs.getString("prodDesc"), rs.getFloat("prodPrice"), prodCategory, rs.getString("prodImage"));
            products.add(product);
        }
        
        return products;
    }
    
    //product sorting (Latest)
    public ArrayList<Product> getRecordsSortByLatest(String prodCategory) throws SQLException {
        ArrayList<Product> products = new ArrayList<Product>();
        
        //create sort latest products SQL statement
        String queryStr = "SELECT * FROM " + tableName + " WHERE ProdCategory = ? ORDER BY ProdID DESC";
        
        //update parameter
        stmt = conn.prepareStatement(queryStr);
        stmt.setString(1, prodCategory);
        ResultSet rs = stmt.executeQuery();                                       //execute the SQL statement
        
        while (rs.next()) {
            Product product = null;
            product = new Product(rs.getString("prodID"), rs.getString("prodName"), rs.getString("prodDesc"), rs.getFloat("prodPrice"),  prodCategory, rs.getString("prodImage"));
            products.add(product);
        }
        
        return products;
    }
    
    //product sorting (Oldest)
    public ArrayList<Product> getRecordsSortByOldest(String prodCategory) throws SQLException {
        ArrayList<Product> products = new ArrayList<Product>();
        
        //create sort oldest products SQL statement
        String queryStr = "SELECT * FROM " + tableName + " WHERE ProdCategory = ? ORDER BY ProdID ASC";
        
        //update parameter
        stmt = conn.prepareStatement(queryStr);
        stmt.setString(1, prodCategory);
        ResultSet rs = stmt.executeQuery();                                       //execute the SQL statement
        
        while (rs.next()) {
            Product product = null;
            product = new Product(rs.getString("prodID"), rs.getString("prodName"), rs.getString("prodDesc"), rs.getFloat("prodPrice"),  prodCategory, rs.getString("prodImage"));
            products.add(product);
        }
        
        return products;
    }

    //add product method
    public void addRecord(Product product) throws SQLException {
        //create add product SQL statement
        String insertStr = "INSERT INTO " + tableName + " VALUES(?, ?, ?, ?, ?, ?)";

        //update parameters
        stmt = conn.prepareStatement(insertStr);
        stmt.setString(1, product.getProdID());
        stmt.setString(2, product.getProdName());
        stmt.setString(3, product.getProdDesc());
        stmt.setFloat(4, product.getProdPrice());
        stmt.setString(5, product.getProdCategory());
        stmt.setString(6, product.getProdImage());
        stmt.executeUpdate();                                                     //execute the SQL statement
    }

    //update or edit product method
    public void updateRecord(Product product) throws SQLException {
        //create update product SQL statement
        String updateStr = "UPDATE " + tableName + " SET prodName = ?, prodDesc = ?, prodPrice = ?, prodCategory = ?, prodImage = ? WHERE prodID = ?";
        
        //update parameters
        stmt = conn.prepareStatement(updateStr);
        stmt.setString(1, product.getProdName());
        stmt.setString(2, product.getProdDesc());
        stmt.setFloat(3, product.getProdPrice());
        stmt.setString(4, product.getProdCategory());
        stmt.setString(5, product.getProdImage());
        stmt.setString(6, product.getProdID());
        stmt.executeUpdate();                                                     //execute the SQL statement
    }

    //delete product method
    public void deleteRecord(Product product) throws SQLException {
        //create delete product SQL statement
        String deleteStr = "DELETE FROM " + tableName + " WHERE prodID = ?";
        
        //update parameters
        stmt = conn.prepareStatement(deleteStr);
        stmt.setString(1, product.getProdID());
        stmt.executeUpdate();                                                     //execute the SQL statement
    }

    //create connection method    
    private void createConnection() {
        try {
            conn = DriverManager.getConnection(host, user, password);
            System.out.println("***TRACE: Connection established.");
        } catch (SQLException ex) {
            JOptionPane.showMessageDialog(null, ex.getMessage(), "ERROR", JOptionPane.ERROR_MESSAGE);
        }
    }

    public static void main(String[] args) throws SQLException {
        DAProduct da = new DAProduct();
        Product product = da.getRecord("XXX");
        System.out.println(product);
    }
}
