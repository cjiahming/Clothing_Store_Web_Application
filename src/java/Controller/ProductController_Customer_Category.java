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
import java.util.ArrayList;
import java.util.Arrays;
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
@WebServlet(name = "ProductController_Customer_Category", urlPatterns = {"/ProductController_Customer_Category"})
public class ProductController_Customer_Category extends HttpServlet {

    protected void refreshTable(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        //obtain data from the form
        String sortBy = request.getParameter("sortby");
        String prodCategory = request.getParameter("prodCategory");

        //get a HttpSession or create one if it does not exist
        HttpSession session = request.getSession();

        int totalRows;
        DAProduct prodDA = new DAProduct();

        //display products
        try {
            //default products display
            if (sortBy == null && prodCategory != null || "default".equals(sortBy) && prodCategory != null) {
                ArrayList<Product> productList = prodDA.getRecordsByCategory(prodCategory);
                totalRows = productList.size();

                Product[] products = new Product[totalRows];
                for (int i = 0; i < productList.size(); i++) {
                    products[i] = productList.get(i);
                }
                        
                session.setAttribute("products", products);
            }

            //sort by latest product display
            if ("latest".equals(sortBy) && prodCategory != null) {
                ArrayList<Product> productList = prodDA.getRecordsSortByLatest(prodCategory);
                totalRows = productList.size();

                Product[] products = new Product[totalRows];
                for (int i = 0; i < productList.size(); i++) {
                    products[i] = productList.get(i);
                }

                session.setAttribute("products", products);
            }

            //sort by oldest product display
            if ("oldest".equals(sortBy) && prodCategory != null) {
                ArrayList<Product> productList = prodDA.getRecordsSortByOldest(prodCategory);
                totalRows = productList.size();

                Product[] products = new Product[totalRows];
                for (int i = 0; i < productList.size(); i++) {
                    products[i] = productList.get(i);
                }

                session.setAttribute("products", products);
            }

            //sort by price low to high product display
            if ("lowToHigh".equals(sortBy) && prodCategory != null) {
                ArrayList<Product> productList = prodDA.getRecordsSortByPriceLow(prodCategory);
                totalRows = productList.size();

                Product[] products = new Product[totalRows];
                for (int i = 0; i < productList.size(); i++) {
                    products [i] = productList.get(i);
                }
                
                session.setAttribute("products", products);
            }

            //sort by price high to low product display
            if ("highToLow".equals(sortBy) && prodCategory != null) {
                ArrayList<Product> productList = prodDA.getRecordsSortByPriceHigh(prodCategory);
                totalRows = productList.size();

                Product[] products = new Product[totalRows];
                for (int i = 0; i < productList.size(); i++) {
                    products[i] = productList.get(i);
                }

                session.setAttribute("products", products);
            }

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
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        refreshTable(request, response);
        response.sendRedirect("Product_Category-customerView.jsp");
    }
}
