/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Controller;

import Controller.ProductController_Admin_Summary;
import Model.DA.DAProduct;
import Model.Domain.Product;
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
 * @author Ashley
 */
@WebServlet(name = "ProductController_Admin_AddConfirmation", urlPatterns = {"/ProductController_Admin_AddConfirmation"})
public class ProductController_Admin_AddConfirmation extends HttpServlet {

    protected void refreshTable(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        int totalRows;

        //display product records
        try {
            DAProduct prodDA = new DAProduct();
            ArrayList<Product> productList = prodDA.getRecords();
            totalRows = productList.size();

            Product[] products = new Product[totalRows];
            for (int i = 0; i < productList.size(); i++) {
                products[i] = productList.get(i);
            }
            HttpSession s = request.getSession();
            s.setAttribute("productList", products);

        } catch (Exception ex) {
            out.println("ERROR: " + ex.toString() + "<br /><br />");

            StackTraceElement[] elements = ex.getStackTrace();
            for (StackTraceElement e : elements) {
                out.println("File Name: " + e.getFileName() + "<br />");
                out.println("Class Name: " + e.getClassName() + "<br />");
                out.println("Method Name: " + e.getMethodName() + "<br />");
                out.println("Line Number: " + e.getLineNumber() + "<br /><br />");
            }
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        //add product
        try {
            DAProduct prodDA = new DAProduct();

            HttpSession session = request.getSession();

            Product prod = (Product) session.getAttribute("product");

            prodDA.addRecord(prod);

            String msg = "New Product with the Product ID of " + prod.getProdID() + " has been added to the database.";
            
            //<-------------------Successfuly msg (green background)---------------------------------->
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

            out.println("<body><div id=\"infoLog\">&nbsp;&nbsp;&nbsp;&nbsp;<span id=\"infoIcon\"><i class=\"fa fa-check\"></i></span> &nbsp;&nbsp; " + msg + "</div></body>");
            out.println("</html>");

            ProductController_Admin_Summary refresh = new ProductController_Admin_Summary();
            refresh.refreshTable(request, response);

            //Servlet JSP communication
            RequestDispatcher rd = request.getRequestDispatcher("Product_Summary-adminView.jsp");
            rd.include(request, response);

        } catch (Exception ex) {
            //<-------------------Error msg (red background)---------------------------------->
            out.println("<html>");
            out.println("<style>");
            out.println("body{background-color:lightgreen;}"
                    + "#infoLog{\n"
                    + "	background-color: #FF8F8F;\n"
                    + "    height:25px;\n"
                    + "}");
            out.println("</style>");
            out.println(" <body> <div id=\"infoLog\"> ERROR: " + ex.getMessage() + "</div></body>");
            out.println("</html>");

            //Servlet JSP communication
            RequestDispatcher rd = request.getRequestDispatcher("Product_Summary-adminView.jsp");
            rd.include(request, response);
        }
    }
}
