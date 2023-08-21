/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Controller;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import Model.Domain.SKU;
import Model.Domain.Customer;
import Model.Domain.Product;
import Model.DA.DACart;
import Model.DA.DAProduct;
import Model.DA.DASKU;
import Model.Domain.Cart;
import Model.Domain.Order;
import Model.Domain.Review;
import java.sql.SQLException;
import javax.servlet.RequestDispatcher;

/**
 *
 * @author Gab
 */
@WebServlet(name = "CartController_Customer_AddToCart", urlPatterns = {"/CartController_Customer_AddToCart"})
public class CartController_Customer_AddToCart extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        try {
            String size = request.getParameter("size");
            String color = request.getParameter("color");
            int qty = Integer.parseInt(request.getParameter("qty"));
            String prodID = request.getParameter("productID");

            //Session need to get Customer ID from the session
            HttpSession httpSession = request.getSession();
            Customer customer = (Customer) httpSession.getAttribute("customer");

            SKU sku = new SKU(color, size,new Product(prodID));

            //Check if DA has this SKU if no dont add 
            DASKU skuDA = new DASKU();

            sku = skuDA.getSKU(sku.getSkuNo());

            //if not null means only add into the cart , if null or qty too less than dont add into cart direct exception
            if (sku != null) {
                if (sku.getSkuQty() >= qty) {
                    //If the qty of the customer choose is smaller  or equal than the qty have , add to cart

                    DACart cartDA = new DACart();
                    cartDA.addRecord(new Cart(qty, sku, customer));

                    //Successful Message
                    out.println("<html><head><link rel=\"shortcut icon\" type=\"image/x-icon\" href=\"assets/siteIcon.png\" /></head>");
                    out.println("<style>");
                    out.println("body{background-color:lightgreen;}"
                            + "#infoIcon{\n"
                            + "	background-color:lightgreen;\n"
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

                    out.println("<body><div id=\"infoLog\">&nbsp;&nbsp;&nbsp;&nbsp;<span id=\"infoIcon\"><i class=\"fa fa-check\"></i></span> &nbsp;&nbsp; " + "Successfully added Product" + "</div></body>");
                    out.println("</html>");

                    //Return to the specific page
                    RequestDispatcher rd = request.getRequestDispatcher("Product_Details-customerView.jsp");
                    rd.include(request, response);
                } else {
                    //if the quantity is less than desired quantity then no add to cart and prompt error 
                    //The maximum quantity is (sku.getQty())
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

                    out.println("<body><div id=\"infoLog\">&nbsp;&nbsp;&nbsp;&nbsp;<span id=\"infoIcon\"><i class=\"fa fa-check\"></i></span> &nbsp;&nbsp; " + "Error : The Maximum of this " + sku.getSkuNo() + " is " + sku.getSkuQty() + "</div></body>");
                    out.println("</html>");

                    RequestDispatcher rd = request.getRequestDispatcher("Product_Details-customerView.jsp");
                    rd.include(request, response);
                }
            } else {
                //This means that the sku does not exist 
                //PROMPT ERROR "This variation havent released"
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

                out.println("<body><div id=\"infoLog\">&nbsp;&nbsp;&nbsp;&nbsp;<span id=\"infoIcon\"><i class=\"fa fa-check\"></i></span> &nbsp;&nbsp; " + "This variation havent been released" + "</div></body>");
                out.println("</html>");

                RequestDispatcher rd = request.getRequestDispatcher("Product_Details-customerView.jsp");
                rd.include(request, response);
            }

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
    }

}
