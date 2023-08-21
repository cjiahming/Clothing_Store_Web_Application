package Model.Domain;

import Model.DA.DATracking;

import java.io.Serializable;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.Random;

public class Tracking implements Serializable {
    private String trackingId;//Tracking id will be generated after the admin update order status to  “SHIPPING”
    private Timestamp shipTime;
    private Order orderId;//Foreign Key

    public Tracking() {

    }

    public Tracking(String trackingId, Timestamp shipTime, Order orderId) {
        this.trackingId = trackingId;
        this.shipTime = shipTime;
        this.orderId = orderId;
    }

    public String getTrackingId() {
        return trackingId;
    }

    public void setTrackingId(String trackingId) {
        this.trackingId = trackingId;
    }

    public Timestamp getShipTime() {
        return shipTime;
    }

    public void setShipTime(Timestamp shipTime) {
        this.shipTime = shipTime;
    }

    public void setOrder(Order order) {
        this.orderId=order;
    }

    public Order getOrder() {
        return orderId;
    }


    public String generateTrackingId() throws SQLException {
        //Random generate 6 alphabets + 3 running no for tracking id
        Random random = new Random();
        String alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
        String trackingId = "";
        //Generate 6 alphabets
        for (int j = 0; j < 5; j++) {
            trackingId += alphabet.charAt(random.nextInt(alphabet.length()));
        }
        DATracking daTracking=new DATracking();
        //Get total records of order in that day from database
        int totalNo = daTracking.getTrackingCountToday();
        //Increase each count of the order
        return String.format("T"+trackingId + String.format("%03d", totalNo += 1));
    }

}
