/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Controller;

import Model.DA.DACart;
import Model.DA.DAProduct;
import Model.DA.DASKU;
import Model.Domain.Cart;
import Model.Domain.Customer;
import Model.Domain.Product;
import Model.Domain.SKU;
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
@WebServlet(name = "CartController_Customer_SubmitCart", urlPatterns = {"/CartController_Customer_SubmitCart"})
public class CartController_Customer_SubmitCart extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        Customer customer = (Customer) session.getAttribute("customer");

        String submitCheckBox = request.getParameter("submitCheckBox");

        DACart cartDA = new DACart();
        ArrayList<Cart> cartArrList = cartDA.getAllCartDataNoOrd(customer);
        DASKU skuDA = new DASKU();
        DAProduct productDA = new DAProduct();

        ArrayList<Cart> summariseCartItem = new ArrayList<Cart>();

        try {

            if (submitCheckBox.equals("")) {
                //if they did not check any checkbox
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

                out.println("<body><div id=\"infoLog\">&nbsp;&nbsp;&nbsp;&nbsp;<span id=\"infoIcon\"><i class=\"fa fa-check\"></i></span> &nbsp;&nbsp; " + "No cartItem added to order,Please click the checkbox " + "</div></body>");
                out.println("</html>");

                //send back to display cart page
                RequestDispatcher rd = request.getRequestDispatcher("Cart_displayCart-customerView.jsp");
                rd.include(request, response);
            } else {
                String validate = "";
                for (int i = 0; i < cartArrList.size(); i++) {
                    validate = validate + "0";
                }

                if (!submitCheckBox.equals(validate)) {

                    for (int i = 0; i < cartArrList.size(); i++) {

                        SKU sku = skuDA.getSKU(cartArrList.get(i).getSKU().getSkuNo());
                        Product product = productDA.getRecord(sku.getProduct().getProdID());

                        if (submitCheckBox.charAt(i) == '1') {
                            //send to ArrayList 
                            summariseCartItem.add(cartArrList.get(i));
                        }

                        
                    }
                    
                    
                        session.setAttribute("summarisecartItem", summariseCartItem);
                        
                        out.print("<input type=\"hidden\" name=\"checkOut\" >");
                        //request dispatcher to ur order page
                         response.sendRedirect("OrderCustomerController");
                        //RequestDispatcher rd = request.getRequestDispatcher("OrderCustomerController");
                        //rd.include(request, response);

                }else{
                    //if they did not check any checkbox 00 
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

                out.println("<body><div id=\"infoLog\">&nbsp;&nbsp;&nbsp;&nbsp;<span id=\"infoIcon\"><i class=\"fa fa-check\"></i></span> &nbsp;&nbsp; " + "No cartItem added to order,Please click the checkbox " + "</div></body>");
                out.println("</html>");

                //send back to display cart page
                RequestDispatcher rd = request.getRequestDispatcher("Cart_displayCart-customerView.jsp");
                rd.include(request, response);
                }
            }
        } catch (Exception ex) {

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
