/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Controller;

import Model.DA.DAReview;
import Model.Domain.Customer;
import Model.Domain.Review;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "ReviewController_Admin_UpdateReview", urlPatterns = {"/ReviewController_Admin_UpdateReview"})
public class ReviewController_Admin_UpdateReview extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
            response.setContentType("text/html");
            PrintWriter out = response.getWriter();
        try {
            //Get the review Full Record
            DAReview reviewDA = new DAReview();
            Review review = reviewDA.getReview(request.getParameter("submit"));

            //Edit the review if previous is yes then change no , if no then change yes
            if(review.getHide().equals("no")){
                review.setHide("yes");
                reviewDA.UpdateRecord(review);
            }else if(review.getHide().equals("yes")){
                review.setHide("no");
                reviewDA.UpdateRecord(review);
            }
            
            
            
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

                    out.println("<body><div id=\"infoLog\">&nbsp;&nbsp;&nbsp;&nbsp;<span id=\"infoIcon\"><i class=\"fa fa-check\"></i></span> &nbsp;&nbsp; " + "Review Updated" + "</div></body>");
                    out.println("</html>");
            
            RequestDispatcher rd = request.getRequestDispatcher("Review_Summary-adminView.jsp");
            rd.include(request, response);
            
            
        } catch (Exception ex) {
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

            out.println("<body><div id=\"infoLog\">&nbsp;&nbsp;&nbsp;&nbsp;<span id=\"infoIcon\"><i class=\"fa fa-check\"></i></span> &nbsp;&nbsp; " + "Error: Review not Updated " + "</div></body>");
            out.println("</html>");
        }

    }

}
