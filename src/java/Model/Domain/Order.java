package Model.Domain;

import Model.DA.DAOrder;

import java.io.Serializable;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class Order implements Serializable {
    private String orderId;
    private String orderStatus;//Packaging, Shipping, Refunding ,Refunded , Completed
    private Timestamp orderCreatedTime;//After customer made the payment
    private String orderRemark;//Customer order's remark
    private Address address;

    DAOrder DAOrder = new DAOrder();

    public Order() {

    }

    public Order(String orderId, String orderStatus, Timestamp orderCreatedTime, String orderRemark, Address address) {
        this.orderId = orderId;
        this.orderStatus = orderStatus;
        this.orderCreatedTime = orderCreatedTime;
        this.address = address;
        this.orderRemark = orderRemark;
    }


    public Order(String orderId) {
        this.orderId = orderId;
    }

    public String getOrderId() {
        return orderId;
    }

    public void setOrderId(String orderId) {
        this.orderId = orderId;
    }

    public String getOrderStatus() {
        return orderStatus;
    }

    public void setOrderStatus(String orderStatus) {
        this.orderStatus = orderStatus;
    }

    public Timestamp getOrderCreatedTime() {
        return orderCreatedTime;
    }

    public void setOrderCreatedTime(Timestamp orderCreatedTime) {
        this.orderCreatedTime = orderCreatedTime;
    }

    public String getOrderRemark() {
        return orderRemark;
    }

    public void setOrderRemark(String orderRemark) {
        this.orderRemark = orderRemark;
    }

    public Address getAddress() {
        return address;
    }

    public void setAddress(Address address) {
        this.address = address;
    }

    public String generateOrderId() throws SQLException {
        //Create first 10 number based on date and time
        LocalDateTime now = LocalDateTime.now();
        DateTimeFormatter format = DateTimeFormatter.ofPattern("yyMMddHHmm");
        String formatDateTime = now.format(format);
        //Get total records of order in that day from database
        int totalNo = DAOrder.getOrderCount();
        //Increase each count of the order
        return String.format(formatDateTime + String.format("%03d", totalNo += 1));
    }

    //This subtotal not including tax fee only include (product*qty)
    public Double getSubtotal(String orderId) throws SQLException {
        return DAOrder.totalOrder(orderId);
    }

    //This method including tax fee (subtotal*0.03)
    public Double getTotalPayment(String orderId) throws SQLException {
        return Double.valueOf(String.format("%.2f",getSubtotal(orderId)+(getSubtotal(orderId) * 0.03)));
    }

    public Double getCartPrice(String cartId) throws SQLException{
        return Double.valueOf(String.format("%.2f",DAOrder.totalCartPrice(cartId)));
    }
    

}
