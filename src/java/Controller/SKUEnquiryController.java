/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Controller;

import Model.DA.*;
import Model.Domain.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author Ling Ern
 */
@WebServlet(name = "SKUEnquiryController", urlPatterns = {"/SKUEnquiryController"})
public class SKUEnquiryController extends HttpServlet {

  protected void refreshTable(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        //display records
        try {
            //get SKUs
            DASKU skuDA = new DASKU();
            ArrayList<SKU> skuList = skuDA.getAllSKU();
            SKU[] skuArr = new SKU[skuList.size()];
            for (int i = 0; i < skuList.size(); i++) {
                skuArr[i] = skuList.get(i);
            }
            
            //prepare space for data needed (storage)
            int[] totalSales = new int[skuList.size()];
            int[] packagingQty = new int[skuList.size()];
            int[] totalStockOut = new int[skuList.size()];
            int[] totalStockIn = new int[skuList.size()];
            AdjustedItem[] lastStockTake = new AdjustedItem[skuList.size()];
            LocalDateTime[] lastStockTakeDate = new LocalDateTime[skuList.size()];
            int[] inTransit = new int[skuList.size()];
            int[] refundQty = new int[skuList.size()];
            
            //get totalSales amount -> based on each SKU
            DAOrder orderDA = new DAOrder();
            ArrayList<Order> salesList = orderDA.getOrderIDs(); 
            DACart cartDA = new DACart();
            ArrayList<Cart> cartList = cartDA.getAllCartData();
           for(int a=0; a < skuList.size(); a++){
               totalSales[a]=0;
               packagingQty[a]=0;
               inTransit[a]=0;
               refundQty[a]=0;
               
               for(int i=0; i< cartList.size();i++){ //everytime loop in get the cartList
                   for(int j=0; j<salesList.size();j++){
                       if(cartList.get(i).getOrder().getOrderId()!=null && salesList.get(j).getOrderId().equalsIgnoreCase(cartList.get(i).getOrder().getOrderId()) && cartList.get(i).getSKU().getSkuNo().equalsIgnoreCase(skuArr[a].getSkuNo())){
                        //record total sales qty
                       totalSales[a] +=  cartList.get(i).getQty(); 
                       //get sales qty which has not been shipped out (still considered as on hand qty)
                       if(salesList.get(j).getOrderStatus().equalsIgnoreCase("PACKAGING")){
                           packagingQty[a]+= cartList.get(i).getQty(); 
                       }else if(salesList.get(j).getOrderStatus().equalsIgnoreCase("Shipping")){ //get in transit qty
                           inTransit[a] += cartList.get(i).getQty();
                       } else if (salesList.get(j).getOrderStatus().equalsIgnoreCase("REFUNDED")){ //get refund qty
                           refundQty[a] += cartList.get(i).getQty();
                       }else{
                       }
                       }
                   }
                   
               }
           }
           
            
            //get Stock Adjustments 
            DAStockAdjustment stockAdDA = new DAStockAdjustment();
            ArrayList<StockAdjustment> stockAdList = stockAdDA.getRecords(); //get all stock adjustment records
            
            for(int a=0; a < skuList.size(); a++){
               totalStockIn[a]=0;
               totalStockOut[a]=0;
               lastStockTake[a]=null;
               
               for(int i=0; i< stockAdList.size();i++){ //everytime loop in get the cartList
                   AdjustedItem[] adItemList = stockAdList.get(i).getAdjustedItems();  //itemlist for that specific stock adjustment
                   for(int j=0; j< adItemList.length;j++){
                   if(adItemList!=null && skuArr[a].getSkuNo().equalsIgnoreCase(adItemList[j].getSku().getSkuNo())){ //matched sku found
                       
                       //if action = stock in
                       if(stockAdList.get(i).getStockAction().equalsIgnoreCase("stockIn")){
                           totalStockIn[a]+= adItemList[j].getAdjustQty();
                           //if action = stock out
                       }else if(stockAdList.get(i).getStockAction().equalsIgnoreCase("stockOut")){ //get in transit qty
                           totalStockOut[a] +=  adItemList[j].getAdjustQty();
                           //else action = stock take -> to get last stock take date, amount n difference
                       } else { 
                           lastStockTake[a] = adItemList[j];
                           if(stockAdList.get(i).getUpdated_at()!=null){
                               lastStockTakeDate[a]= stockAdList.get(i).getUpdated_at();
                           }else{
                               lastStockTakeDate[a]= stockAdList.get(i).getCreated_at();
                           }
                       }
                   }
                   }
               }
           }
            
           //set attribute 
            HttpSession s = request.getSession();
            s.setAttribute("skuArr", skuArr);
            s.setAttribute("totalSalesQty", totalSales);
            s.setAttribute("packagingQty", packagingQty);
            s.setAttribute("totalStockOut", totalStockOut);
            s.setAttribute("totalStockIn", totalStockIn);
            s.setAttribute("lastStockTake", lastStockTake);
            s.setAttribute("lastStockTakeDate", lastStockTakeDate);
            s.setAttribute("inTransit", inTransit);
            s.setAttribute("refundQty", refundQty);

            
            
        } catch (Exception ex) {
            out.println("Error: " + ex.getMessage());
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        refreshTable(request, response);
        //response.sendRedirect("SKUEnquiry_Summary-adminView.jsp");
    }
    

}
