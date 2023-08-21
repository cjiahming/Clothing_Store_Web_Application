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

/**
 *
 * @author Gab
 */
@WebServlet(name = "ValidateToRefundPage", urlPatterns = {"/ValidateToRefundPage"})
public class ValidateToRefundPage extends HttpServlet {

    
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        PrintWriter out = response.getWriter();
        response.setContentType("text/html");
        out.println(request.getParameter("submit"));
    }

    
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
