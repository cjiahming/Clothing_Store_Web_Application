/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Model.Domain;
import java.io.Serializable;
import java.sql.Date;
import java.text.SimpleDateFormat;


/**
 *
 * @author Gab
 */
public class Cart  implements Serializable {
    String cartItemID;
    int qty;
    SKU sku ;
    Customer customer;
    Order order;
    Review review;
   
   public Cart(){
       
   }
   
   //This is used for delete or other used 
   public Cart(String cartItemID){
       this.cartItemID = cartItemID;
   }
   
   //This method is for direct add into the cart 
   public Cart(String cartItemID,int qty,SKU sku,Customer customer,Order order,Review review){
       this.cartItemID = cartItemID;
       this.qty = qty;
       this.sku = sku;
       this.customer = customer;
       this.order = order;
       this.review = review;
   }
   
   //this will auto generate the orderID when insert new data into 
   public Cart(int qty,SKU sku,Customer customer,Order order,Review review){
       //implement orderID (This constructor is for INSERT)

       this.qty = qty;
       this.sku = sku;
       this.customer = customer;
       this.order = order;
       this.review = review;
       generateCartItemID();
   }
   
   
   
   //used for add to cart
   public Cart(int qty,SKU sku,Customer customer){
       //implement orderID (This constructor is for INSERT)
       
       this.order = new Order(null);
       this.review = new Review(null);
       
       this.qty = qty;
       this.sku = sku;
       this.customer = customer;
       generateCartItemID();
       
   }
   
   //Jenny Added this for the order part 
   public Cart(String cartItemID,int qty,SKU sku,Order order){
        this.cartItemID=cartItemID;
        this.qty=qty;
        this.sku=sku;
        this.order=order;
    }
   
   
   //search admin
   public Cart(String cartItemID , int qty ,Order order, SKU sku,Customer customer){
       this.cartItemID = cartItemID;
       this.qty = qty;
       this.sku = sku;
       this.customer = customer;
       this.order = order;
       
   }
   
  
   
   
   private void generateCartItemID(){
       
       SimpleDateFormat formatter= new SimpleDateFormat("yyyyMMdd|HH:mm:ss");
       Date date = new Date(System.currentTimeMillis());
       cartItemID = formatter.format(date) + " " + this.customer.getUserID();
   }
   
   
   
   public String getCartItemID(){
       return this.cartItemID;
   }
   
   public int getQty(){
       return this.qty;
   }
   
   public SKU getSKU(){
       return this.sku;
   }
    
   public Customer getCustomer(){
       return this.customer;
   }
   
   public Order getOrder(){
       return this.order;
   }
   
   public Review getReview(){
       return review;
   }

    public void setCartItemID(String cartItemID) {
        this.cartItemID = cartItemID;
    }

    public void setQty(int qty) {
        
        if(qty < 1 ){
            this.qty = 1; 
        }
        else if (qty > 15){
            this.qty = 15;
        }
        else{
            this.qty = qty;
        }
    }

    public void setSKU(SKU sku) {
        this.sku = sku;
    }

    public void setCustomer(Customer customer) {
        this.customer = customer;
    }

    public void setOrder(Order order) {
        this.order = order;
    }

    public void setReview(Review review) {
        this.review = review;
    }
   
   public boolean equals(Cart obj){
       if(obj.getSKU().getSkuNo().equals(this.sku.getSkuNo())){
           return true;
       }
       return false;
   }
}
