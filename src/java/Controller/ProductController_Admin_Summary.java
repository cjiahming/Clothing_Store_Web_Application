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
@WebServlet(name = "ProductController_Admin_Summary", urlPatterns = {"/ProductController_Admin_Summary"})
public class ProductController_Admin_Summary extends HttpServlet {

    public void refreshTable(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        //obtain data from the form
        String prodPriceMin = request.getParameter("prodPriceMin");
        String prodPriceMax = request.getParameter("prodPriceMax");
        String prodCategory = request.getParameter("prodCategory");

        //get a HttpSession or create one if it does not exist
        HttpSession session = request.getSession();

        int totalRows;
        DAProduct prodDA = new DAProduct();

        //display products
        try {
            //default products display
            if (prodPriceMin == null || prodPriceMax == null || prodCategory == null) {
                ArrayList<Product> productList = prodDA.getRecords();
                totalRows = productList.size();

                Product[] products = new Product[totalRows];
                for (int i = 0; i < productList.size(); i++) {
                    products[i] = productList.get(i);
                }

                session.setAttribute("productList", products);
            }

            //filtered by price range product display
            if (prodPriceMin != null && prodPriceMax != null && prodCategory == null) {
                ArrayList<Product> productList = prodDA.getRecordsByPriceRange(prodPriceMin, prodPriceMax);
                totalRows = productList.size();

                Product[] products = new Product[totalRows];
                for (int i = 0; i < productList.size(); i++) {
                    products[i] = productList.get(i);
                }

                session.setAttribute("productList", products);
            }
            
            //filtered by price range and product category product display
            if (prodPriceMin != null && prodPriceMax != null && prodCategory != null) {
                ArrayList<Product> productList = prodDA.getRecordsByPriceRangeCategory(prodPriceMin, prodPriceMax, prodCategory);
                totalRows = productList.size();

                Product[] products = new Product[totalRows];
                for (int i = 0; i < productList.size(); i++) {
                    products[i] = productList.get(i);
                }

                session.setAttribute("productList", products);
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
        response.sendRedirect("Product_Summary-adminView.jsp");
    }
}
