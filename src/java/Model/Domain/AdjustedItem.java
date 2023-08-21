/*
    author: Cheng Ling Ern
 */
package Model.Domain;

import java.io.Serializable;

public class AdjustedItem implements Serializable {

    private SKU sku;
    private int adjustQty;
    private int initialQty;
    private int adjustedQty;
    private String remark;

    public AdjustedItem() {
    }

    public AdjustedItem(SKU sku, int adjustQty, int adjustedQty, int initialQty, String remark) {
        this.sku = sku;
        this.adjustedQty = adjustedQty;
        this.adjustQty = adjustQty;
        this.initialQty = initialQty;
        this.remark = remark;
    }

    public SKU getSku() {
        return sku;
    }

    public int getAdjustedQty() {
        return adjustedQty;
    }

    public int getAdjustQty() {
        return adjustQty;
    }

    public int getInitialQty() {
        return initialQty;
    }

    public String getRemark() {
        return remark;
    }

    public void setSku(SKU sku) {
        this.sku = sku;
    }
    


    public void setAdjustedQty(int adjustedQty) {
        this.adjustedQty = adjustedQty;
    }

    public void setAdjustQty(int adjustQty) {
        this.adjustQty = adjustQty;
    }

    public void setInitialQty(int initialQty) {
        this.initialQty = initialQty;
    }

    public void setRemark(String remark) {
        this.remark = remark;
    }
}
