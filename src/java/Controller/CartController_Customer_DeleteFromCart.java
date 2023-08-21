/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Controller;

import Model.DA.DACart;
import Model.Domain.Cart;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Gab
 */
@WebServlet(name = "CartController_Customer_DeleteFromCart", urlPatterns = {"/CartController_Customer_DeleteFromCart"})
public class CartController_Customer_DeleteFromCart extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String cartItemID = request.getParameter("cartItemID");
        String page = request.getParameter("page");
        
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        System.out.println(page);
        
        try{
        //Delete the cart Item
        DACart cartDA = new DACart();
        cartDA.deleteRecord(new Cart(cartItemID));
        
        //if succesfully deleted
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

                    out.println("<body><div id=\"infoLog\">&nbsp;&nbsp;&nbsp;&nbsp;<span id=\"infoIcon\"><i class=\"fa fa-check\"></i></span> &nbsp;&nbsp; " + "Successfully deleted Product from cart" + "</div></body>");
                    out.println("</html>");

                    //Return to the specific page
                    RequestDispatcher rd = request.getRequestDispatcher(page+".jsp");
                    rd.include(request, response);
        
        }catch(Exception ex){
            out.println("Error" + ex.toString() + "</br></br>");

            StackTraceElement[] elements = ex.getStackTrace();
            for (StackTraceElement e : elements) {
                out.println("File name " + e.getFileName() + "<br/>");
                out.println("class name " + e.getClassName() + "<br/>");
                out.println("Method name " + e.getMethodName() + "<br/>");
                out.println("Line number " + e.getLineNumber() + "<br/>");
            }
        }
        
        
    }

   
   

}
