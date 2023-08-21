//Author : Cheng Cai Yuan

package Model.Domain;

import Model.DA.DARefund;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.ArrayList;

public class Refund {
    //declare variables for Refund class
    private String refundId;
    private LocalDateTime refundCreatedTime;
    private String refundReason;
    private String refundStatus;
    private String refundRemark;
    private Order order;
    
    //constructors
    public Refund(){

    }
    
    public Refund(String refundId){
        this.refundId = refundId;
    }
    
    public Refund(String refundId,LocalDateTime refundCreatedTime,String refundReason,String refundStatus,String refundRemark,Order order){
        this.refundId = refundId;
        this.refundCreatedTime = refundCreatedTime;
        this.refundReason = refundReason;
        this.refundStatus = refundStatus;
        this.refundRemark = refundRemark;
        this.order = order;
    }

    public String generateRefundId() throws SQLException{
        DARefund daRefund = new DARefund();
        String refundId = "";
    
        ArrayList<Refund> refundList = daRefund.getAllRefund();
        int total = refundList.size();  //set the number of refund records into the total variable
        refundId = String.format("RF%04d", total + 1);   //every new refund Id will plus 1 from the previous refund Id
        return refundId;
    }
    
    //getter
    public String getRefundId(){
        return refundId;
    }
    
    public LocalDateTime getRefundCreatedTime(){
        return refundCreatedTime;
    }
    
    public String getRefundReason(){
        return refundReason;
    }
    
    public String getRefundStatus(){
        return refundStatus;
    }
    
    public String getRefundRemark(){
        return refundRemark;
    }
    
    public Order getOrder(){
        return order;
    }
    
    //setter
    public void setRefundId(String refundId){
        this.refundId = refundId;
    }
    
    public void setRefundCreatedTime(LocalDateTime refundCreatedTime){
        this.refundCreatedTime = refundCreatedTime;
    }
    
    public void setRefundReason(String refundReason){
        this.refundReason = refundReason;
    }
    
    public void setRefundStatus(String refundStatus){
        this.refundStatus = refundStatus;
    }
    
    public void setRefundRemark(String refundRemark){
        this.refundRemark = refundRemark;
    }
    
    public void setOrder(Order order){
        this.order = order;
    }
    
    
}


