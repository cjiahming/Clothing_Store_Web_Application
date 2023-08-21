/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Controller;

import Model.DA.DAProduct;
import Model.Domain.Product;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.Paths;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

/**
 *
 * @author Ashley
 */
@WebServlet(name = "ProductController_Customer_Details", urlPatterns = {"/ProductController_Customer_Details"})
public class ProductController_Customer_Details extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        //retrieve product record
        try {
            String prodID = request.getParameter("prodID");

            DAProduct prodDA = new DAProduct();
            Product prod = prodDA.getRecord(prodID);

            HttpSession session = request.getSession();
            
            session.setAttribute("product", prod);
            response.sendRedirect("Product_Details-customerView.jsp");

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

}
