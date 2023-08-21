/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Controller;

import Model.DA.DACart;
import Model.Domain.Cart;
import Model.Domain.Customer;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author Gab
 */
@WebServlet(name = "CartController_Customer_UpdateFromCart", urlPatterns = {"/CartController_Customer_UpdateFromCart"})
public class CartController_Customer_UpdateFromCart extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        Customer customer = (Customer) session.getAttribute("customer");

        DACart cartDA = new DACart();
        ArrayList<Cart> cartArrList = cartDA.getAllCartDataNoOrd(customer);

        try {
            //count how many row changes
            int rowsChanged = 0;
            
            for (int i = 0; i < cartArrList.size(); i++) {
                //out.println(request.getParameter("updatefromcart"+i));
                if (request.getParameter("updatefromcart" + i).equals("")) {
                    //means no need update if user does not pass it 

                } else if (request.getParameter("updatefromcart" + i) != null) {
                    //need to be update
                    Cart localCart = cartArrList.get(i);
                    localCart.setQty(Integer.parseInt(request.getParameter("updatefromcart" + i)));
                    cartDA.UpdateRecord(localCart);

                    rowsChanged++;
                    //successfully added
                    

                }
            }
            
            if(rowsChanged !=0){
                //if got rows changed
                out.println("<html><head><link rel=\"shortcut icon\" type=\"image/x-icon\" href=\"assets/siteIcon.png\" /></head>");
                    out.println("<style>");
                    out.println("body{background-color:lightgreen;}"
                            + "#infoIcon{\n"
                            + "	background-color:green;\n"
                            + "    color:white;\n"
                            + "    border-radius:100%;\n"
                            + "    text-align:center;\n"
                            + "    font-size:12px;"
                            + "    padding:5px;\n"
                            + "}"
                            + "#infoLog{\n"
                            + "	background-color: #AAD292;\n"
                            + "    height:25px;\n"
                            + "}");
                    out.println("</style>");

                    out.println("<body><div id=\"infoLog\">&nbsp;&nbsp;&nbsp;&nbsp;<span id=\"infoIcon\"><i class=\"fa fa-check\"></i></span> &nbsp;&nbsp; " + "Successfully added "+rowsChanged+" rows Changes" + "</div></body>");
                    out.println("</html>");
            }
            else{
                //if no rows changed
                out.println("<html><head><link rel=\"shortcut icon\" type=\"image/x-icon\" href=\"assets/siteIcon.png\" /></head>");
                    out.println("<style>");
                    out.println("body{background-color:red;}"
                            + "#infoIcon{\n"
                            + "	background-color:red;\n"
                            + "    color:white;\n"
                            + "    border-radius:100%;\n"
                            + "    text-align:center;\n"
                            + "    font-size:12px;"
                            + "    padding:5px;\n"
                            + "}"
                            + "#infoLog{\n"
                            + "	background-color: #ff726f;\n"
                            + "    height:25px;\n"
                            + "}");
                    out.println("</style>");

                    out.println("<body><div id=\"infoLog\">&nbsp;&nbsp;&nbsp;&nbsp;<span id=\"infoIcon\"><i class=\"fa fa-check\"></i></span> &nbsp;&nbsp; " + "No rows changes " +"</div></body>");
                    out.println("</html>");
            }
            
            RequestDispatcher rd = request.getRequestDispatcher("Cart_displayCart-customerView.jsp");
            rd.include(request, response);
            
        } catch (Exception ex) {
            out.println("Error" + ex.toString() + "</br></br>");

            StackTraceElement[] elements = ex.getStackTrace();
            for (StackTraceElement e : elements) {
                out.println("File name " + e.getFileName() + "<br/>");
                out.println("class name " + e.getClassName() + "<br/>");
                out.println("Method name " + e.getMethodName() + "<br/>");
                out.println("Line number " + e.getLineNumber() + "<br/>");
            }
        }
        /*
        Customer customer = (Customer) session.getAttribute("beanCustomer");
        int rowNeededToUpdate = (int) session.getAttribute("updateRowCartSize");
        ArrayList<Cart> cartNeededToChange = new ArrayList<Cart>();
        
        for(int i = 0 ; i < rowNeededToUpdate ; i++){
            if(session.getAttribute("ssDisplayCart"+i)!=null){
                //means got data 
                Cart localCart = (Cart)session.getAttribute("ssDisplayCart"+i);
                cartNeededToChange.add(localCart);
                out.println(localCart.getCartItemID() + " " + localCart.getQty() + "<br>");
            }
        }
         */

 /*
        out.println(rowNeededToUpdate);
        
        
        
        ArrayList<Cart> cartArrList = new ArrayList<Cart>();
        DACart cartDA = new DACart();
        cartArrList = cartDA.getAllCartData(customer); 
        
        for(int i = 0 ; i < cartArrList.size();i++){
            
            out.println(request.getParameter("qty"+i));
            out.println("\n");
            
        }
         */
    }

}
