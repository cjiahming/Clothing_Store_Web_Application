/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Model.DA;

import Model.Domain.SKU;
import Model.Domain.Cart;
import Model.Domain.Customer;
import Model.Domain.Order;
import Model.Domain.Product;
import Model.Domain.Review;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Collections;

public class DACart {

    private String host = "jdbc:derby://localhost:1527/fnfdb";
    private String user = "nbuser";
    private String password = "nbuser";
    private String tableName = "CART";
    private Connection conn;
    private PreparedStatement stmt;

    public DACart() {
        createConnection();

    }

    public void createConnection() {
        try {
            conn = DriverManager.getConnection(host, user, password);
            System.out.println("***TRACE: Connection established.");
        } catch (SQLException ex) {
            System.out.println("Error cannot connect to the database");
        }
    }

    public Cart getRecord(String cartItemID) {
        String queryStr = "SELECT * FROM " + tableName + " WHERE CARTITEMID = ?";
        Cart cart = new Cart();

        try {
            stmt = conn.prepareStatement(queryStr);
            stmt.setString(1, cartItemID);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                //this should be putting their DA with string to get their data
                System.out.println(rs.getString("SKUNO"));
                cart = new Cart(rs.getString("cartItemID"), rs.getInt("qty"), new SKU(rs.getString("SKUNO")), new Customer(rs.getString("customerID")), new Order(rs.getString("orderID")), new Review(rs.getString("reviewID")));
            }

        } catch (SQLException ex) {
            System.out.println(ex.getMessage() + " ERROR GET RECORD ");
        }

        return cart;
    }

    public void addRecord(Cart cart) throws SQLException {
        int alreadyExist = 0;
        //check duplicate same SKU 

        //Get all the cart Item that the customer has
        ArrayList<Cart> cartArrList = getAllCartData(cart.getCustomer());

        //Checking the cartArrList whether it exist the same SKU 
        for (int i = 0; i < cartArrList.size(); i++) {

            if (cartArrList.get(i).getSKU().getSkuNo().equals(cart.getSKU().getSkuNo())) {
                //if its not already in the order then it will continue as added to the current cart (Because the cart item is still in the cart )
                if (cartArrList.get(i).getOrder().getOrderId() == null) {
                    //if the adding sku is already added, add the quantity into it 
                    //add the new quantity to the old quantity 
                    cartArrList.get(i).setQty(cartArrList.get(i).getQty() + cart.getQty());

                    //execute the update the record
                    DACart cartDA = new DACart();
                    cartDA.UpdateRecord(cartArrList.get(i));

                    alreadyExist = 1;
                }
            }
        }

        if (alreadyExist == 0) {
            String sqlStr = "INSERT INTO " + tableName + " VALUES (?,?,?,?,?,?)";
            stmt = conn.prepareStatement(sqlStr);

            stmt.setString(1, cart.getCartItemID());
            stmt.setInt(2, cart.getQty());
            stmt.setString(3, cart.getSKU().getSkuNo());
            stmt.setString(4, cart.getCustomer().getUserID());

            if (cart.getOrder().getOrderId() != null) {
                stmt.setString(5, cart.getOrder().getOrderId());
            } else {
                stmt.setNull(5, Types.VARCHAR);
            }

            if (cart.getReview().getReviewID() != null) {
                stmt.setString(6, cart.getReview().getReviewID());
            } else {
                stmt.setNull(6, Types.VARCHAR);
            }

            stmt.executeUpdate();

        }
    }

    public void UpdateRecord(Cart cart) {
        int rows = 0;

        try {
            String sqlStr = "UPDATE " + tableName + " SET QTY = ? , SKUNO = ? , CUSTOMERID = ? , ORDERID = ? ,REVIEWID = ? WHERE CARTITEMID =?";
            stmt = conn.prepareStatement(sqlStr);

            stmt.setInt(1, cart.getQty());
            stmt.setString(2, cart.getSKU().getSkuNo());
            stmt.setString(3, cart.getCustomer().getUserID());
            stmt.setString(4, cart.getOrder().getOrderId());
            stmt.setString(5, cart.getReview().getReviewID());

            stmt.setString(6, cart.getCartItemID());

            rows = stmt.executeUpdate();

        } catch (SQLException ex) {
            System.out.println(ex.getMessage() + " Update Cart Record ");
        }

        if (rows > 0) {
            System.out.println(rows + "rows updated");
        } else if (rows == 0) {
            System.out.println("Rows does not updated");
        }
    }

    public void deleteRecord(Cart cart) {
        int rows = 0;

        try {
            String sqlStr = "DELETE FROM " + tableName + " WHERE CARTITEMID=?";

            stmt = conn.prepareStatement(sqlStr);
            stmt.setString(1, cart.getCartItemID());
            rows = stmt.executeUpdate();

        } catch (SQLException ex) {
            System.out.println(ex.getMessage() + " Delete Cart Record ");
        }

        if (rows > 0) {
            System.out.println(rows + "rows delete");
        } else if (rows == 0) {
            System.out.println("Rows does not Deleted");
        }
    }

    public Cart getSpecificCartDataByReviewID(Review review) {
        String queryStr = "SELECT * FROM " + tableName + " WHERE REVIEWID = ?";
        Cart cart = new Cart();

        try {
            stmt = conn.prepareStatement(queryStr);
            stmt.setString(1, review.getReviewID());
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                //this should be putting their DA with string to get their data
                System.out.println(rs.getString("SKUNO"));
                cart = new Cart(rs.getString("cartItemID"), rs.getInt("qty"), new SKU(rs.getString("SKUNO")), new Customer(rs.getString("customerID")), new Order(rs.getString("orderID")), new Review(rs.getString("reviewID")));
            }

        } catch (SQLException ex) {
            System.out.println(ex.getMessage() + " ERROR GET RECORD ");
        }

        return cart;
    }

    public ArrayList<Cart> getAllCartData(Customer cust) {

        ArrayList<Cart> cartArrList = new ArrayList<Cart>();
        try {
            String sqlStr = "SELECT * FROM " + tableName + " WHERE CUSTOMERID = ?";
            stmt = conn.prepareStatement(sqlStr);

            stmt.setString(1, cust.getUserID());
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Cart cart = new Cart(rs.getString("cartItemID"), rs.getInt("qty"), new SKU(rs.getString("SKUNO")), new Customer(rs.getString("customerID")), new Order(rs.getString("orderID")), new Review(rs.getString("reviewID")));

                cartArrList.add(cart);

            }

        } catch (SQLException ex) {
            System.out.println(ex.getMessage() + " Delete Cart Record ");
        }

        return cartArrList;
    }

    public ArrayList<Cart> getAllCartData() {
        ArrayList<Cart> cartArrList = new ArrayList<Cart>();
        try {
            String sqlStr = "SELECT * FROM " + tableName;
            stmt = conn.prepareStatement(sqlStr);

            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Cart cart = new Cart(rs.getString("cartItemID"), rs.getInt("qty"), new SKU(rs.getString("SKUNO")), new Customer(rs.getString("customerID")), new Order(rs.getString("orderID")), new Review(rs.getString("reviewID")));

                cartArrList.add(cart);

            }

        } catch (SQLException ex) {
            System.out.println(ex.getMessage() + " Get All Cart Record ");
        }

        return cartArrList;
    }

    public ArrayList<Cart> getAllCartDataNoOrd(Customer cust) {
        //This allows to get All Cart Record that has no yet Have order id from the specific Customer(Which mean is still in the cart)

        //Get all cart item from particular customer 
        DACart cartDA = new DACart();
        ArrayList<Cart> cartArrList = cartDA.getAllCartData(cust);

        //Arraylist that keeps cart item that does not have order which means those are in the cart
        ArrayList<Cart> cartArrListNoHaveOrder = new ArrayList<Cart>();

        //filter whether for those data that did not have order ID (Which mean have order dy)
        for (int i = 0; i < cartArrList.size(); i++) {
            if (cartArrList.get(i).getOrder().getOrderId() == null) {
                //Add into new Arraylist if they have orderID
                cartArrListNoHaveOrder.add(cartArrList.get(i));
            }
        }

        return cartArrListNoHaveOrder;
    }

    public ArrayList<Cart> getAllCartDataHaveOrd(Customer cust) {
        //This allows to get All Cart Record that has order id from the specific Customer

        //Get all cart item from particular customer 
        DACart cartDA = new DACart();
        ArrayList<Cart> cartArrList = cartDA.getAllCartData(cust);

        //Arraylist that keeps cart item that have the order already
        ArrayList<Cart> cartArrListHaveOrder = new ArrayList<Cart>();

        //filter whether they have order ID (Which mean have order dy)
        for (int i = 0; i < cartArrList.size(); i++) {
            if (cartArrList.get(i).getOrder().getOrderId() != null) {
                //Add into new Arraylist if they have orderID
                cartArrListHaveOrder.add(cartArrList.get(i));
            }
        }

        //Perform filter to line up Cart by OrderID correct
        cartArrListHaveOrder = cartDA.sortingCartbyOrderID(cartArrListHaveOrder);

        return cartArrListHaveOrder;
    }

    public ArrayList<Cart> getSpecificCartSameOrd(Order order, Customer cust) {
        //This allows to get Cart Item which are in the same orders
        DACart cartDA = new DACart();
        ArrayList<Cart> cartArrList = cartDA.getAllCartData(cust);

        //Arraylist that keeps all the cart item with the same order id 
        ArrayList<Cart> cartArrListHaveSameOrder = new ArrayList<Cart>();

        for (int i = 0; i < cartArrList.size(); i++) {
            if (cartArrList.get(i).getOrder().getOrderId() != null) {
                if (cartArrList.get(i).getOrder().getOrderId().equals(order.getOrderId())) {
                    //add into new Arraylist if they have the same orderID
                    cartArrListHaveSameOrder.add(cartArrList.get(i));
                }
            }
        }

        return cartArrListHaveSameOrder;
    }

    public ArrayList<Cart> getSpecificCartAllCartItem(Order order) {
        //This allows to get Cart Item which are in the same orders\
        DACart cartDA = new DACart();
        ArrayList<Cart> cartArrList = cartDA.getAllCartData();

        //Arraylist that keeps all the cart item with the same order id 
        ArrayList<Cart> cartArrListHaveSameOrder = new ArrayList<Cart>();
        
        
        for (int i = 0; i < cartArrList.size(); i++) {
            if (cartArrList.get(i).getOrder().getOrderId() != null) {
                if (cartArrList.get(i).getOrder().getOrderId().equals(order.getOrderId())) {
                    //add into new Arraylist if they have the same orderID
                    cartArrListHaveSameOrder.add(cartArrList.get(i));

                }
            }
        }

        return cartArrListHaveSameOrder;
    }

    public ArrayList<Order> getAllOrdersUnderCust(Customer cust) {
        //This method allow user to get All the order that are under specific customer without duplicate

        //Get all cart item from particular customer 
        DACart cartDA = new DACart();
        ArrayList<Cart> cartArrList = cartDA.getAllCartData(cust);

        //Create a arraylist that keep the unique orderID 
        ArrayList<Order> ordList = new ArrayList<Order>();

        int duplicateFound;

        for (int i = 0; i < cartArrList.size(); i++) {
            duplicateFound = 0;
            //check whether is the same with the ordList inside 
            for (int j = 0; j < ordList.size(); j++) {
                //if its the same means got duplicate
                if (ordList.get(j).getOrderId().equals(cartArrList.get(i).getOrder().getOrderId())) {
                    duplicateFound++;
                }

            }

            if (duplicateFound == 0) {
                //if no duplicate found add into arraylist order

                //Only not null can be keep
                if (cartArrList.get(i).getOrder().getOrderId() != null) {
                    ordList.add(cartArrList.get(i).getOrder());
                }
            }
        }

        //Get all the full Orders into the arraylist
        DAOrder orderda = new DAOrder();
        try {
            for (int i = 0; i < ordList.size(); i++) {
                ordList.set(i, orderda.getOrderRecord(ordList.get(i).getOrderId()));
            }
        } catch (Exception ex) {
            System.out.println(ex.getMessage());
        }

        return ordList;

    }

    //this sortingbyOrderID , the orderID cannot be null 
    private ArrayList<Cart> sortingCartbyOrderID(ArrayList<Cart> cartArrList) {

        for (int j = 0; j < cartArrList.size(); j++) {
            for (int i = j + 1; i < cartArrList.size(); i++) {
                if (cartArrList.get(i).getOrder().getOrderId().compareTo(cartArrList.get(j).getOrder().getOrderId()) < 0) {
                    Collections.swap(cartArrList, j, i);
                }
            }
        }

        return cartArrList;
    }

    public ArrayList<Product> top5Product() {

        ArrayList<Cart> cartArrList = getAllCartData();

        DAProduct productDA = new DAProduct();
        DAOrder orderDA = new DAOrder();
        DASKU skuDA = new DASKU();
        DAProduct prodDA = new DAProduct();

        try {
            //This keep all the product Arr and empty the prodprice
            ArrayList<Product> proArrList = productDA.getRecords();
            System.out.println("productda size" + proArrList.size());
            for (int i = 0; i < proArrList.size(); i++) {
                //set all of the product price to 0 so that we can add all the payment that has the same product into the prolocal 
                Product prolocal = new Product(proArrList.get(i).getProdID());
                prolocal.setProdName(proArrList.get(i).getProdName());
                prolocal.setProdPrice(0);
                proArrList.set(i, prolocal);
            }

            for (int i = 0; i < cartArrList.size(); i++) {
                //filter those have orderID
                if (cartArrList.get(i).getOrder().getOrderId() != null) {
                    //filter the order is completed
                    Order order = orderDA.getOrderRecord(cartArrList.get(i).getOrder().getOrderId());
                    if (order.getOrderStatus().equals("COMPLETED")) {
                        SKU skulocal = skuDA.getSKU(cartArrList.get(i).getSKU().getSkuNo());
                        Product prodlocal = prodDA.getRecord(skulocal.getProduct().getProdID());

                        //compare if its has the same productID then
                        //add into the overall prodlocal (let Qty keep inside the product price )
                        for (int j = 0; j < proArrList.size(); j++) {
                            if (proArrList.get(j).getProdID().equals(prodlocal.getProdID())) {
                                //add the qty inside the product 

                                //Set local prolocalforArr to update into the arraylist
                                Product prolocalforArr = new Product(proArrList.get(j).getProdID());
                                prolocalforArr.setProdName(proArrList.get(j).getProdName());
                                //add the quantity inside + qty in the new cart item
                                prolocalforArr.setProdPrice(proArrList.get(j).getProdPrice() + cartArrList.get(i).getQty());
                                proArrList.set(j, prolocalforArr);

                            }
                        }
                    }
                }
            }

            //sort proArrList by top 5 
            ArrayList<Product> filter = sortingProductPrice(proArrList);

            return filter;

        } catch (Exception ex) {
            System.out.println(ex.getMessage());
        }

        return null;
    }

    //sort by price 
    private ArrayList<Product> sortingProductPrice(ArrayList<Product> proArrList) {

        for (int j = 0; j < proArrList.size(); j++) {
            for (int i = j + 1; i < proArrList.size(); i++) {
                if (proArrList.get(i).getProdPrice() > proArrList.get(j).getProdPrice()) {
                    Collections.swap(proArrList, j, i);
                }
            }
        }

        return proArrList;
    }

    public static void main(String args[]) {
        DACart cartDA = new DACart();

        ArrayList<Product> prodArrList = cartDA.top5Product();
        //ArrayList<Cart> prodArrList = cartDA.getSpecificCartAllCartItem(new Order("O0001"));

        System.out.println("=========");
        for (int i = 0; i < prodArrList.size(); i++) {

            System.out.println(prodArrList.get(i).getProdPrice());
        }
        
    }
}
