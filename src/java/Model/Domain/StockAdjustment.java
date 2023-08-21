/*
    author: Cheng Ling Ern
 */
package Model.Domain;

import java.io.Serializable;
import java.time.LocalDateTime;

public class StockAdjustment implements Serializable {

    private String adjustmentNo;
    private AdjustedItem[] adjustedItem;
    private String stockAction;
    private String remark;
    private Admin created_by;
    private LocalDateTime created_at;
    private Admin updated_by;
    private LocalDateTime updated_at;
    private String status;

    public StockAdjustment() {

    }

    public StockAdjustment(String adjustmentNo, AdjustedItem[] adjustedItem, String stockAction, String remark, Admin created_by, LocalDateTime created_at, String status) {
        this.adjustmentNo = adjustmentNo;
        this.adjustedItem = adjustedItem;
        this.remark = remark;
        this.stockAction = stockAction;
        this.created_by = created_by;
        this.created_at = created_at;
        this.status = status;
    }

    public StockAdjustment(String adjustmentNo, AdjustedItem[] adjustedItem, String stockAction, String remark, String status, Admin created_by, LocalDateTime created_at, Admin updated_by, LocalDateTime updated_at) {
        this(adjustmentNo, adjustedItem, stockAction, remark, created_by, created_at, status);
        this.updated_by = updated_by;
        this.updated_at = updated_at;
    }

    public String getAdjustmentNo() {
        return adjustmentNo;
    }

    public AdjustedItem[] getAdjustedItems() {
        return adjustedItem;
    }

    public String getRemark() {
        return remark;
    }

    public String getStockAction() {
        return stockAction;
    }

    public Admin getCreated_by() {
        return created_by;
    }

    public Admin getUpdated_by() {
        return updated_by;
    }
    
    public LocalDateTime getCreated_at(){
        return created_at;
    }

    public LocalDateTime getUpdated_at(){
        return updated_at;
    }
    
    public String getStatus(){
        return status;
    }
    
    public String getStockActionInFormal(){
        if(stockAction.equalsIgnoreCase("stockIn")){
            return "STOCK IN";
        }else if(stockAction.equalsIgnoreCase("stockOut")){
            return "STOCK OUT";
        }else{
            return "STOCK TAKE";
        }
    }

    public void setRemark(String remark) {
        this.remark = remark;
    }

    public void setStockAction(String stockAction) {
        this.stockAction = stockAction;
    }

    public void setCreatedBy(Admin created_by) {
        this.created_by = created_by;
    }

    public void setUpdatedBy(Admin updated_by) {
        this.updated_by = updated_by;
    }
    
    public void setStatus(String status){
        this.status = status;
    }

}
