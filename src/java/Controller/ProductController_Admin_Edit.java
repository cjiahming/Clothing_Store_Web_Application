/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Controller;

import Model.DA.DAProduct;
import Model.Domain.Product;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.nio.file.Paths;
import java.util.ArrayList;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
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
@WebServlet(name = "ProductController_Admin_Edit", urlPatterns = {"/ProductController_Admin_Edit"})
@MultipartConfig
public class ProductController_Admin_Edit extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        //retrieve the product that the user would like to edit
        try {
            String prodID = request.getParameter("prodID");

            DAProduct prodDA = new DAProduct();
            Product prod = prodDA.getRecord(prodID);

            HttpSession session = request.getSession();

            session.setAttribute("product", prod);
            response.sendRedirect("Product_Edit-adminView.jsp");

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
        
        //get a HttpSession or create one if it does not exist
        HttpSession session = request.getSession();

        //obtain the parameters from user
        String prodID = request.getParameter("prodID");
        String prodName = request.getParameter("prodName");
        String prodDesc = request.getParameter("prodDesc");
        float prodPrice = Float.parseFloat(request.getParameter("prodPrice"));
        String prodCategory = request.getParameter("prodCategory");
        String prodImage = request.getParameter("prodImage");

        //capitalize the first character of each word in the product name
        prodName = capitalizeProdName(prodName);

        //capitalize the first character of the product description
        prodDesc = prodDesc.substring(0, 1).toUpperCase() + prodDesc.substring(1);
        
        Product prod = new Product(prodID, prodName, prodDesc, prodPrice, prodCategory, prodImage);

        session.setAttribute("product", prod);
        request.setAttribute("product", prod);

        //Servlet JSP communication
        RequestDispatcher reqDispatcher = request.getRequestDispatcher("Product_EditConfirmation-adminView.jsp");
        reqDispatcher.forward(request, response);

    }
    
    //capitalize the first character of each word in the product name method
    public String capitalizeProdName(String prodName) {

        String words[] = prodName.split("\\s");
        String capitalizeWord = "";

        for (String w : words) {
            String first = w.substring(0, 1);
            String afterfirst = w.substring(1);
            capitalizeWord += first.toUpperCase() + afterfirst + " ";
        }

        return capitalizeWord.trim();
    }
}
