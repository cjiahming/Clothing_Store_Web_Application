/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Model.DA;

import Model.Domain.Cart;
import Model.Domain.Customer;
import Model.Domain.Order;
import Model.Domain.Product;
import Model.Domain.Review;
import Model.Domain.SKU;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;

public class DAReview {

    private String host = "jdbc:derby://localhost:1527/fnfdb";
    private String user = "nbuser";
    private String password = "nbuser";
    private String tableName = "REVIEW";
    private Connection conn;
    private PreparedStatement stmt;

    public DAReview() {
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

    //Get all review 
    public Review getReview(String reviewID) {
        String queryStr = "SELECT * FROM " + tableName + " WHERE REVIEWID = ?";
        Review review = new Review();

        try {
            stmt = conn.prepareStatement(queryStr);
            stmt.setString(1, reviewID);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                review = new Review(rs.getString("reviewID"), rs.getString("ReviewDesc"), rs.getInt("reviewRating"), rs.getTimestamp("reviewtime").toLocalDateTime(), rs.getString("Hide"));

            }

        } catch (SQLException ex) {

            System.out.println(ex.getMessage() + " ERROR GET RECORD ");

        }

        return review;
    }

    public void addRecord(Review review) {

        String sqlStr = "INSERT INTO " + tableName + " VALUES (?,?,?,?,?)";

        int rows = 0;

        try {
            stmt = conn.prepareStatement(sqlStr);

            //LocalDateTime now = LocalDateTime.now();
            //Timestamp timestamp = Timestamp.valueOf(review.getReviewRating());
            stmt.setString(1, review.getReviewID());
            stmt.setString(2, review.getReviewDesc());
            stmt.setInt(3, review.getReviewRating());
            stmt.setTimestamp(4, Timestamp.valueOf(review.getReviewTime()));
            stmt.setString(5, review.getHide());

            rows = stmt.executeUpdate();

        } catch (SQLException ex) {
            System.out.println(ex.getMessage() + " Update Cart Record ");
        }

        if (rows > 0) {
            System.out.println(rows + "rows added");
        } else if (rows == 0) {
            System.out.println("Rows does not added");
        }

    }

    public void UpdateRecord(Review review) {
        int rows = 0;

        try {
            String sqlStr = "UPDATE " + tableName + " SET REVIEWDESC = ? , REVIEWRATING = ? , REVIEWTIME = ? ,HIDE=?  WHERE REVIEWID =?";
            stmt = conn.prepareStatement(sqlStr);

            stmt.setString(1, review.getReviewDesc());
            stmt.setInt(2, review.getReviewRating());
            stmt.setTimestamp(3, Timestamp.valueOf(review.getReviewTime()));
            stmt.setString(4, review.getHide());
            stmt.setString(5, review.getReviewID());

            rows = stmt.executeUpdate();

        } catch (SQLException ex) {
            System.out.println(ex.getMessage() + " Update review Record ");
        }

        if (rows > 0) {
            System.out.println(rows + "rows updated");
        } else if (rows == 0) {
            System.out.println("Rows does not updated");
        }
    }

    public void deleteRecord(Review review) {
        int rows = 0;
        try {
            String sqlStr = "DELETE FROM " + tableName + " WHERE REVIEWID=?";

            stmt = conn.prepareStatement(sqlStr);
            stmt.setString(1, review.getReviewID());
            rows = stmt.executeUpdate();

        } catch (SQLException ex) {
            System.out.println(ex.getMessage() + " Delete review Record ");
        }

        if (rows > 0) {
            System.out.println(rows + "rows delete");
        } else if (rows == 0) {
            System.out.println("Rows does not Deleted");
        }
    }

    //this will getAllReview include those hide one 
    public ArrayList<Review> getAllReviewAdmin() {
        ArrayList<Review> reviewArrList = new ArrayList<Review>();
        try {
            String sqlStr = "SELECT * FROM " + tableName;
            stmt = conn.prepareStatement(sqlStr);

            ResultSet rs = stmt.executeQuery();
            Review review = new Review();
            while (rs.next()) {
                review = new Review(rs.getString("reviewID"), rs.getString("ReviewDesc"), rs.getInt("reviewRating"), rs.getTimestamp("reviewtime").toLocalDateTime(), rs.getString("hide"));

                //only add to review if admin does not set hide
                reviewArrList.add(review);

            }

        } catch (SQLException ex) {
            System.out.println(ex.getMessage() + " Get All Review Record ");
        }

        return reviewArrList;
    }

    //this will get all review data which has not been hide from admin
    public ArrayList<Review> getAllReview() {
        ArrayList<Review> reviewArrList = new ArrayList<Review>();
        try {
            String sqlStr = "SELECT * FROM " + tableName;
            stmt = conn.prepareStatement(sqlStr);

            ResultSet rs = stmt.executeQuery();
            Review review = new Review();
            while (rs.next()) {
                review = new Review(rs.getString("reviewID"), rs.getString("ReviewDesc"), rs.getInt("reviewRating"), rs.getTimestamp("reviewtime").toLocalDateTime(), rs.getString("hide"));

                //only add to review if admin does not set hide
                if (review.getHide().equals("no")) {
                    reviewArrList.add(review);
                }

            }

        } catch (SQLException ex) {
            System.out.println(ex.getMessage() + " Get All Review Record ");
        }

        return reviewArrList;
    }

    public ArrayList<Cart> getAllReviewCart() {
        DACart cartDA = new DACart();
        ArrayList<Cart> cart = cartDA.getAllCartData();
        DASKU skuDA = new DASKU();
        SKU localSku = new SKU();

        ArrayList<Cart> filterCart = new ArrayList<Cart>();

        DAReview reviewDA = new DAReview();

        //get all review cartItem
        for (int i = 0; i < cart.size(); i++) {
            if (cart.get(i).getReview().getReviewID() != null) {
                //After review is not null 
                try {
                    //get the localSku    
                    localSku = skuDA.getSKU(cart.get(i).getSKU().getSkuNo());

                    //if it has the same product ID then add into arraylist
                    filterCart.add(cart.get(i));

                } catch (SQLException e) {
                    System.out.println(e.toString());
                }
            }
        }

        Review localReview = new Review();
        //fill in all the review with data into this filterCart arraylist
        for (int i = 0; i < filterCart.size(); i++) {
            localReview = reviewDA.getReview(filterCart.get(i).getReview().getReviewID());

            Cart localCart = filterCart.get(i);
            localCart.setReview(localReview);

            filterCart.set(i, localCart);
        }

        return filterCart;

    }

    //this is filter all the cartItem with the same productID (For displaying in Product - review)
    public ArrayList<Cart> getAllReviewDataSameProductID(Product prod) {
        DACart cartDA = new DACart();
        ArrayList<Cart> cart = cartDA.getAllCartData();
        DASKU skuDA = new DASKU();
        SKU localSku = new SKU();

        ArrayList<Cart> filterCart = new ArrayList<Cart>();

        DAReview reviewDA = new DAReview();

        System.out.println(cart.size());
        //get all review cartItem
        for (int i = 0; i < cart.size(); i++) {
            Review review = reviewDA.getReview(cart.get(i).getReview().getReviewID());
            //and check the reviewID is not null
            if (cart.get(i).getReview().getReviewID() != null) {

                //After review is not null 
                try {
                    //get the localSku    
                    localSku = skuDA.getSKU(cart.get(i).getSKU().getSkuNo());

                    if (localSku.getProduct().getProdID().equals(prod.getProdID())) {
                        //if it has the same product ID then add into arraylist

                        if (review.getHide().equals("no")) {

                            filterCart.add(cart.get(i));
                        }

                    }

                } catch (SQLException e) {
                    System.out.println(e.toString());
                }
            }
        }

        Review localReview = new Review();
        //fill in all the review with data into this filterCart arraylist
        for (int i = 0; i < filterCart.size(); i++) {
            localReview = reviewDA.getReview(filterCart.get(i).getReview().getReviewID());

            Cart localCart = filterCart.get(i);
            localCart.setReview(localReview);

            filterCart.set(i, localCart);
        }

        return filterCart;

    }

    //change all review to hidden YES once they have change to refunded 
    public void changeReviewToHidden(Order order) {
        
        //only after process refunded the review must be hidden
        if (order.getOrderStatus().equals("REFUNDED")) {
            //get all cartItem that has the orderID
            DACart cartDA = new DACart();
            ArrayList<Cart> cartArrList = cartDA.getSpecificCartAllCartItem(order);
            
            System.out.println(cartArrList.size());
            DAReview reviewDA = new DAReview();

            for (int i = 0; i < cartArrList.size(); i++) {
                //check if it got reviewID hide the review
                if (cartArrList.get(i).getReview().getReviewID() != null) {
                    Review review = reviewDA.getReview(cartArrList.get(i).getReview().getReviewID());
                    review.setHide("yes");

                    //edit the review(Set it to hidden)
                    reviewDA.UpdateRecord(review);

                }
            }
        }

    }

    public static void main(String args[]) {

        DAReview reviewDA = new DAReview();
        
        //2204151134002
        Order order = new Order();
        order.setOrderStatus("REFUNDED");
        order.setOrderId("2204151134002");
        reviewDA.changeReviewToHidden(order);
                
        /*
        ArrayList<Cart> cart = reviewDA.getAllReviewDataSameProductID(new Product("WT0002"));

        int total = 0;
        for (int i = 0; i < cart.size(); i++) {
            System.out.println(cart.get(i).getReview().getReviewID());
            System.out.println(cart.get(i).getReview().getReviewDesc());
            System.out.println(cart.get(i).getReview().getReviewRating());

            //total+=cart.get(i).getReview().getReviewRating();
        }
        */
        
        
        //System.out.println("\n\n"+(double)total/(cart.size()*5)*100);
        /*
        DAReview reviewDA = new DAReview();
        Review newReview = new Review("This product is very good and its very good to wear ",4);
        reviewDA.addRecord(newReview);
         */
    }

}
