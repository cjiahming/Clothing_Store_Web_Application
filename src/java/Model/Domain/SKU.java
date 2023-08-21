package Model.Domain;

public class SKU {
    private String skuNo;
    private String colour;
    private String prodSize;
    private int prodWidth;
    private int prodLength;
    private int skuQty;
    private Product product;
    
    public SKU(){
        
    }
    
    public SKU(String skuNo){
        this.skuNo = skuNo;
    }
    
    public SKU(String skuNo,String colour,String prodSize,int prodWidth,int prodLength,int skuQty,Product product){
        this.skuNo = skuNo;
        this.colour = colour;
        this.prodSize = prodSize;
        this.prodWidth = prodWidth;
        this.prodLength = prodLength;
        this.skuQty = skuQty;
        this.product = product;
        
    }
    
    //GABRIEL ADDED THIS FOR GENERATING SKU 
    public SKU(String colour,String prodSize,int prodWidth,int prodLength,int skuQty,Product product){
        this.colour = colour;
        this.prodSize = prodSize;
        this.prodWidth = prodWidth;
        this.prodLength = prodLength;
        this.skuQty = skuQty;
        this.product = product;
        generateSkuNo();
    }
    
    //GABRIEL ADDED THIS FOR CONSTRUCTOR IN ADD TO CART
    public SKU(String colour,String prodSize,Product product){
        this.colour = colour;
        this.prodSize = prodSize;
        this.product = product;
        generateSkuNo();
    }
    
    //JENNY ADDED THIS CONSTRUCTOR FOR ORDER
     public SKU(String skuNo,String colour,String prodSize,int prodWidth,int prodLength,Product product){
        this.skuNo=skuNo;
        this.colour=colour;
        this.prodSize=prodSize;
        this.prodWidth=prodWidth;
        this.prodLength=prodLength;
        this.product=product;
    }
    
    
    public void generateSkuNo(){
        String col = "";
        
        switch (this.colour) {
            case "White":
                col = "WHT";
                break;
            case "Black":
                col = "BLK";
                break;
            case "Blue":
                col = "BLU";
                break;
            case "Red":
                col = "RED";
                break;
            case "Yellow":
                col = "YEL";
                break;
            case "Green":
                col = "GRN";
                break;
            case "Grey":
                col = "GRY";
                break;
            case "Orange":
                col = "ORG";
                break;
            case "Purple":
                col = "PUR";
                break;
            case "Pink":
                col = "PIN";
                break;
            case "Brown":
                col = "BRW";
                break;
            case "Maroon":
                col = "MAR";
                break;
            case "Beige":
                col = "BEI";
                break;
            default:
                break;
        }
        
        
        this.skuNo = this.product.getProdID() + "-" + this.prodSize + "-" + col;
    }
    
    public String getSkuNo(){
        return skuNo;
    }
    
    public String getColour(){
        return colour;
    }
    
    public String getProdSize(){
        return prodSize;
    }
    
    public int getProdWidth(){
        return prodWidth;
    }
    
    public int getProdLength(){
        return prodLength;
    }
    
    public int getSkuQty(){
        return skuQty;
    }
    
    public Product getProduct(){
        return product;
    }
    
    public void setSkuNo(String skuNo){
        this.skuNo = skuNo;
    }
    
    public void setColour(String colour){
        this.colour = colour;
    }
    
    public void setProdSize(String prodSize){
        this.prodSize = prodSize;
    }
    
    public void setProdWidth(int prodWidth){
        this.prodWidth = prodWidth;
    }
    
    public void setProdLength(int prodLength){
        this.prodLength = prodLength;
    }
    
    public void setSkuQty(int skuQty){
        this.skuQty = skuQty;
    }
    
    public void setProduct(Product product){
        this.product = product;
    }
    
    
}
