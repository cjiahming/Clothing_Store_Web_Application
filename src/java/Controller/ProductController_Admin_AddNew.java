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
import java.sql.SQLException;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Arrays;
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
@WebServlet(name = "ProductController_Admin_AddNew", urlPatterns = {"/ProductController_Admin_AddNew"})
@MultipartConfig
public class ProductController_Admin_AddNew extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession();
        
        //obtain the parameters from user
        String prodName = request.getParameter("prodName");
        String prodDesc = request.getParameter("prodDesc");
        float prodPrice = Float.parseFloat(request.getParameter("prodPrice"));
        String prodCategory = request.getParameter("prodCategory");

        Part file = request.getPart("prodImage");
        String prodImage = Paths.get(file.getSubmittedFileName()).getFileName().toString();

        //uploading the image to server
        String path = request.getRealPath("assets") + File.separator + "products" + File.separator + file.getSubmittedFileName();       //String path = request.getRealPath("assets/product/" + file.getSubmittedFileName());

        try {
            FileOutputStream fos = new FileOutputStream(path);  //write
            InputStream is = file.getInputStream();             //read

            byte[] data = new byte[is.available()];
            is.read(data);
            fos.write(data);
            fos.close();
        } catch (Exception ex) {
            ex.printStackTrace();
        }

        //capitalize the first character of each word in the product name
        prodName = capitalizeProdName(prodName);

        //capitalize the first character of the product description
        prodDesc = prodDesc.substring(0, 1).toUpperCase() + prodDesc.substring(1);

        Product prod = new Product(prodName, prodDesc, prodPrice, prodCategory, prodImage);

        session.setAttribute("product", prod);
        request.setAttribute("product", prod);

        //Servlet JSP communication
        RequestDispatcher reqDispatcher = request.getRequestDispatcher("Product_Confirmation-adminView.jsp");
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
