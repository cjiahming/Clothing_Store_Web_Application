//Author : Cheng Cai Yuan

package Controller;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import Model.DA.DASKU;
import Model.DA.DAProduct;
import Model.Domain.SKU;
import Model.Domain.Product;
import java.sql.SQLException; 
import javax.servlet.RequestDispatcher;


@WebServlet(name = "SKUController", urlPatterns = {"/SKUController"})
public class SKUController extends HttpServlet {
    
    private DASKU daSku = new DASKU();
    private DAProduct daProd = new DAProduct();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        HttpSession session = request.getSession();
        session.removeAttribute("errorWidthMessage");
        session.removeAttribute("errorLengthMessage");

        // get value of the "action" from other page
        String action = request.getParameter("action");
        
        switch(action){
            case "add":  //go to add sku function
                addSku(request,response);
                break;
            case "update":  //go to update sku function
                updateSku(request,response);
                break;
            case "search":  //go to search sku function
                searchSku(request,response);
                break;
            default:
                break;
        }    
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        HttpSession session = request.getSession();
        session.removeAttribute("errorWidthMessage");
        session.removeAttribute("errorLengthMessage");
        int selected = Integer.parseInt(request.getParameter("selectedRow"));    // get value of the "selectedRow" from other page
        String action = request.getParameter("action");    // get value of the "action" from other page
        
        if(action.equals("getSku")){  //go to view sku function 
            getSku(request,response,selected);
        }
        else if(action.equals("deleteSku")){  //go to delete sku function 
            deleteSku(request,response,selected);
        }
    }
    
    public void addSku(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        
        String prodId = request.getParameter("prodId");
        String prodSize = request.getParameter("prodSize");
        String prodWidth = request.getParameter("prodWidth");
        String colour = request.getParameter("colour");
        String prodLength = request.getParameter("prodLength");
        int skuQty = 0;
        
        try {
            //validation to check if the product ID exits in the database
            Product prodIdExist = daProd.getRecord(prodId);
            if(prodIdExist == null){   //if the product ID not exits in the database,error message shown
                request.setAttribute("errorProdIDMessage","Product ID cannot found in database.");
                RequestDispatcher dispatcher=request.getRequestDispatcher("SKU_AddNew-adminView.jsp");
                dispatcher.forward(request,response);
            }
                  
            boolean prodWidthValid = ValidateWidth(prodWidth);  //validate the product width 
            boolean prodLengthValid = ValidateLength(prodLength);  //validate the product length 
                  
            if(prodWidthValid == false){  //if the product width return false,error message shown
                request.setAttribute("errorWidthMessage","Product width must be numeric and in the range from 0 to 200!");
                RequestDispatcher dispatcher=request.getRequestDispatcher("SKU_AddNew-adminView.jsp");
                dispatcher.forward(request,response);
            }
            
            if(prodLengthValid == false){  //if the product length return false,error message shown
                request.setAttribute("errorLengthMessage","Product length must be numeric and in the range from 0 to 200!");
                RequestDispatcher dispatcher=request.getRequestDispatcher("SKU_AddNew-adminView.jsp");
                dispatcher.forward(request,response);
            }
                
            Product p = daProd.getRecord(prodId);  //get product ID from the Product database
            SKU sku = new SKU("",colour,prodSize,Integer.parseInt(prodWidth),Integer.parseInt(prodLength),skuQty,p);
            sku.generateSkuNo();  //auto generate skuNo based on product ID,colour and product size
             
            HttpSession session = request.getSession();
            session.setAttribute("sku",sku);  
            response.sendRedirect("SKU_ConfirmationAdd-adminView.jsp");
        } 
        catch(IOException | SQLException ex){
            out.println("Error:"+ex.toString()+"<br/>");
            StackTraceElement[] elements = ex.getStackTrace();

            for(StackTraceElement e: elements){
                out.println("File Name: "+e.getFileName() + "<br>");
                out.println("Class Name: "+e.getClassName()+ "<br>");
                out.println("Method Name: "+e.getMethodName()+ "<br>");
                out.println("Line Name: "+e.getLineNumber()+ "<br><br>");
            }
        }
        out.close();
    }
    
    public void updateSku(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        
        HttpSession session = request.getSession();
        int selected = (int)session.getAttribute("selected");   //get the attribute of selected from SKU_Update-adminView.jsp
        session.setAttribute("selected", selected);
        SKU sku = (SKU)session.getAttribute("skuObj");
        
        String prodWidth = request.getParameter("prodWidth");    
        String prodLength = request.getParameter("prodLength");  
        
        try {
            boolean prodWidthValid = ValidateWidth(prodWidth);       //validate the product width 
            boolean prodLengthValid = ValidateLength(prodLength);    //validate the product length 
                  
            if(prodWidthValid == false){    //if the product width return false,error message shown
                session.setAttribute("errorWidthMessage","Product width must be numeric and in the range from 0 to 200!");
                response.sendRedirect("SKU_Update-adminView.jsp");
            }
            if(prodLengthValid == false){   //if the product length return false,error message shown
                session.setAttribute("errorLengthMessage","Product length must be numeric and in the range from 0 to 200!");
                response.sendRedirect("SKU_Update-adminView.jsp");
            }

            SKU sku1 = new SKU(sku.getSkuNo(),sku.getColour(),sku.getProdSize(),Integer.parseInt(prodWidth),Integer.parseInt(prodLength),sku.getSkuQty(),sku.getProduct());
              
            session.setAttribute("sku1", sku1);
            response.sendRedirect("SKU_ConfirmationUpdate-adminView.jsp");
        }
        
        catch(Exception ex){
            out.println("Error:"+ex.toString()+"<br/>");
            StackTraceElement[] elements = ex.getStackTrace();

            for(StackTraceElement e: elements){
                out.println("File Name: "+e.getFileName() + "<br>");
                out.println("Class Name: "+e.getClassName()+ "<br>");
                out.println("Method Name: "+e.getMethodName()+ "<br>");
                out.println("Line Name: "+e.getLineNumber()+ "<br><br>");
            }
        }
        
        out.close();
    }
    
    public void searchSku(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        
        String prodId = request.getParameter("prodId");
        String prodSize = request.getParameter("prodSize");        
        String colour = request.getParameter("colour");
        
        SKU sku = new SKU();
      
        try {
            sku = daSku.searchSKU(prodId,colour,prodSize);     //pass in product id,colour and product size into the searchSKU method in DASKU to perform the search function
            HttpSession session = request.getSession();
            session.setAttribute("sku",sku);
                
            if(sku == null){  //if the database does not have any records for the search result
                response.sendRedirect("SKU_SummarySearchNoRecord-adminView.jsp");
            }
            else{   //if the database have the record for the search result
                response.sendRedirect("SKU_SummarySearch-adminView.jsp");
            }

        } 
        catch (IOException | SQLException ex) {
            out.println("Error:"+ex.toString()+"<br/>");
                StackTraceElement[] elements = ex.getStackTrace();

                for(StackTraceElement e: elements){
                    out.println("File Name: "+e.getFileName() + "<br>");
                    out.println("Class Name: "+e.getClassName()+ "<br>");
                    out.println("Method Name: "+e.getMethodName()+ "<br>");
                    out.println("Line Name: "+e.getLineNumber()+ "<br><br>");
                }
            }
          
            out.close();
        }
    
    public void getSku(HttpServletRequest request, HttpServletResponse response,int selected)
            throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        SKU sku = new SKU();
      
        try {
            sku = daSku.getAllSKU().get(selected);    //get all the details for the selected sku in the summary page
                
            HttpSession session = request.getSession();
            session.setAttribute("sku",sku);
                
            response.sendRedirect("SKU_View-adminView.jsp");
        } 
        
        catch (IOException | SQLException ex) {
            out.println("Error:"+ex.toString()+"<br/>");
            StackTraceElement[] elements = ex.getStackTrace();

            for(StackTraceElement e: elements){
                out.println("File Name: "+e.getFileName() + "<br>");
                out.println("Class Name: "+e.getClassName()+ "<br>");
                out.println("Method Name: "+e.getMethodName()+ "<br>");
                out.println("Line Name: "+e.getLineNumber()+ "<br><br>");
            }
        }
            
        out.close();
    }
    
    public void deleteSku(HttpServletRequest request, HttpServletResponse response,int selected)
            throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        SKU sku = new SKU();
      
        try {
            sku = daSku.getAllSKU().get(selected);    //get all the details for the selected sku in the summary page
                
            HttpSession session = request.getSession();
            session.setAttribute("sku",sku);
                
            response.sendRedirect("SKU_ConfirmationDelete-adminView.jsp");
                
        } 
        catch (IOException | SQLException ex) {
            out.println("Error:"+ex.toString()+"<br/>");
            StackTraceElement[] elements = ex.getStackTrace();

            for(StackTraceElement e: elements){
                out.println("File Name: "+e.getFileName() + "<br>");
                out.println("Class Name: "+e.getClassName()+ "<br>");
                out.println("Method Name: "+e.getMethodName()+ "<br>");
                out.println("Line Name: "+e.getLineNumber()+ "<br><br>");
            }
        }
  
        out.close();
    }
    
    public static boolean ValidateWidth(String prodWidth){
        boolean isValid = true;
        
        for(int i=0; i < prodWidth.length(); i++){  //check if every words in the String is number
            if(!Character.isDigit(prodWidth.charAt(i))){
                isValid = false;
                break;
            }
        }
        if(isValid == true){  //if the words in String is all numeric,check if the product width is in the range 0 to 200
            if(Integer.parseInt(prodWidth) < 0 || Integer.parseInt(prodWidth) > 200){
                isValid = false;
            }
        }
        return isValid;
    }
    
    public static boolean ValidateLength(String prodLength){
        boolean isValid = true;
        
        for(int i=0; i < prodLength.length(); i++){  //check if every words in the String is number
            if(!Character.isDigit(prodLength.charAt(i))){
                isValid = false;
                break;
            }
        }
        if(isValid == true){  //if the words in String is all numeric,check if the product length is in the range 0 to 200
            if(Integer.parseInt(prodLength) < 0 || Integer.parseInt(prodLength) > 200){
                isValid = false;
            }
        }
        return isValid;
    }
   
}
        

