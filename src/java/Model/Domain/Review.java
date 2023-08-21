/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Model.Domain;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDateTime;

import Model.DA.DAReview;
import java.time.format.DateTimeFormatter;
public class Review {
    
    String reviewID;
    String reviewDesc;
    int reviewRating;
    LocalDateTime reviewTime;
    String hide;
    
    public Review(){}
    
    //for generate new review 
    public Review(String reviewDesc,int reviewRating){
        this.reviewDesc = reviewDesc;
        this.reviewRating = reviewRating;
        this.hide = "no";
        generateTime(); //for creating review time 
        getReviewRows(); // for creating reviewID
    }

    
    //for directly paste review into the database 
    public Review(String reviewID ,String reviewDesc,int reviewRating,LocalDateTime reviewTime){
        this.reviewID = reviewID;
        this.reviewDesc = reviewDesc;
        this.reviewRating = reviewRating;
        this.hide="no";
        generateTime();
    }
    
    //Use in DA to get all the value 
    public Review(String reviewID ,String reviewDesc,int reviewRating,LocalDateTime reviewTime,String hide){
        this.reviewID = reviewID;
        this.reviewDesc = reviewDesc;
        this.reviewRating = reviewRating;
        this.hide=hide;
        generateTime();
    }
    
    public Review(String reviewID){
        this.reviewID = reviewID;
    }
    
    public String getHide() {
        return hide;
    }

    public void setHide(String hide) {
        this.hide = hide;
    }
    
    
    public String getReviewID(){
        return this.reviewID;
    }

    public String getReviewDesc() {
        return reviewDesc;
    }

    public int getReviewRating() {
        return reviewRating;
    }

    public LocalDateTime getReviewTime() {
        return reviewTime;
    }

    public void setReviewID(String reviewID) {
        this.reviewID = reviewID;
    }
    
    public String getFormatDate(){
        DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy/MM/dd HH:mm:ss");  
        return dtf.format(this.reviewTime);
    }
    
    public String getFormatDateOnly(){
         DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd/MM/yyyy");  
        return dtf.format(this.reviewTime);
    }
    
    public void setReviewDesc(String reviewDesc) {
        this.reviewDesc = reviewDesc;
    }

    public void setReviewRating(int reviewRating) {
        this.reviewRating = reviewRating;
    }

    public void setReviewTime(LocalDateTime reviewTime) {
        this.reviewTime = reviewTime;
    }
    
    private void generateTime(){
        reviewTime = LocalDateTime.now();
    }
    
    private void getReviewRows(){
        Connection conn;
        PreparedStatement stmt;
        String host = "jdbc:derby://localhost:1527/fnfdb";
        String user = "nbuser";
        String password = "nbuser";
        
        int countReviewRows = 0;
        String nextReviewRows;
        
        
        try{
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            conn = DriverManager.getConnection(host, user, password);
            String sql = "SELECT * FROM REVIEW";
            stmt = conn.prepareStatement(sql);
            
            ResultSet resultSet = stmt.executeQuery();
            
            while(resultSet.next()){
                countReviewRows++;
            }
        }
        catch (Exception ex) {
            ex.printStackTrace();
        }
        
        //add review time 
        DateTimeFormatter dtf = DateTimeFormatter.ofPattern("-yyyy/MM/dd-HH:mm:ss");  
        LocalDateTime now = LocalDateTime.now();   
        
        countReviewRows++;
        nextReviewRows = Integer.toString(countReviewRows);
        this.reviewID = String.format("R%04d%s", Integer.parseInt(nextReviewRows),dtf.format(now));
         
    }
    
    /*
    public static void main(String args[]){
        Review review = new Review("HAHAHAHHAA",4);
        System.out.println(review.getReviewID());
    }
*/
}
