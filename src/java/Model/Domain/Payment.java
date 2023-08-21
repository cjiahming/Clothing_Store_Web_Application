package Model.Domain;

import Model.DA.DAPayment;

import java.io.Serializable;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class Payment implements Serializable {
    private String paymentId;
    private String paymentMethod;//Credit/Debit card ,Online Banking
    private double paymentAmount;
    private Timestamp paymentDateTime;
    private Order order;//Foreign key
    private DAPayment paymentDA=new DAPayment();

    public Payment(){

    }


    public Payment(String paymentId,String paymentMethod,double paymentAmount,Timestamp paymentDateTime,Order order){
        this.paymentId=paymentId;
        this.paymentAmount=paymentAmount;
        this.paymentMethod=paymentMethod;
        this.paymentDateTime=paymentDateTime;
        this.order=order;
    }

    public String getPaymentId() {
        return paymentId;
    }

    public void setPaymentId(String paymentId) {
        this.paymentId = paymentId;
    }

    public double getPaymentAmount() {
        return paymentAmount;
    }

    public void setPaymentAmount(double paymentAmount) {
        this.paymentAmount = paymentAmount;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public Timestamp getPaymentDateTime() {
        return paymentDateTime;
    }

    public void setPaymentDateTime(Timestamp paymentDateTime) {
        this.paymentDateTime = paymentDateTime;
    }

    public Order getOrder() {
        return order;
    }

    public void setOrder(Order order) {
        this.order = order;
    }



    //Example : 220315OB001
    public String generatePaymentId() throws SQLException {
        //Create first 6 number based on date
        LocalDateTime now=LocalDateTime.now();
        DateTimeFormatter format=DateTimeFormatter.ofPattern("yyMMdd");
        String formatDateTime=now.format(format);

        //Get payment method from controller
        //If paid by credit card - CC , debit card - DC ,online banking - OB
        String paymentMethod="";
        paymentMethod=getPaymentMethod().equals("Online Banking")?"OB" :
                      getPaymentMethod().equals("Credit Card")?"CC" :
                              "DB";

        //Get total records of order in that day from database
        int totalNo=paymentDA.getPaymentCount();
        return String.format(formatDateTime+paymentMethod+String.format("%03d",totalNo+1));
    }

}
