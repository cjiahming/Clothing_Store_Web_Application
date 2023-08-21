/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Controller;

import Model.DA.DACart;
import Model.DA.DAReview;
import Model.Domain.Cart;
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

@WebServlet(name = "ReviewController_Customer_AddReview", urlPatterns = {"/ReviewController_Customer_AddReview"})
public class ReviewController_Customer_AddReview extends HttpServlet {


    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        PrintWriter out = response.getWriter();
        response.setContentType("text/html");
        
        System.out.println("Inside doget review now");
        try{
        
        HttpSession session = request.getSession();
        
        int validation = 0 ;
        
        if(request.getParameter("rate")==null){
            request.setAttribute("ReviewrateErrMsg","Please give a rating!");
            validation++;
            RequestDispatcher rd = request.getRequestDispatcher("Review_AddReview-customerView.jsp");
            rd.include(request, response);    
        }
        
        if(request.getParameter("reviewDesc").equals("")){
            request.setAttribute("ReviewdescErrMsg","Review Description cannot be empty!");
            validation++;
            RequestDispatcher rd = request.getRequestDispatcher("Review_AddReview-customerView.jsp");
            rd.include(request, response);
        }
        
        int rate = Integer.parseInt(request.getParameter("rate"));
        
        String reviewDesc = request.getParameter("reviewDesc");
        
        String cartItemID = request.getParameter("submit");
            
            System.out.println(request.getParameter("rate"));
            System.out.println(rate);
            System.out.println(reviewDesc);
            System.out.println(cartItemID);
        
        //write a new review 
        //edit current cartItemID data , and link foreign key review in it 
        
        if(validation==0){
        DAReview reviewDA = new DAReview();
        DACart cartDA = new DACart();
        Cart cartEditedNew = cartDA.getRecord(cartItemID);
        
        Review review = new Review();
        
        
        
        if(cartEditedNew.getReview().getReviewID()==null){
        //Create a new review
         review = new Review(reviewDesc,rate);
         //add a new review to database
        reviewDA.addRecord(review);
        
        }
        else{
            //retrieve old review into review
            review = reviewDA.getReview(cartEditedNew.getReview().getReviewID());
            
           review.setReviewDesc(reviewDesc);
           review.setReviewRating(rate);
           
           //edit the cart data with review added inside 
           reviewDA.UpdateRecord(review);
        }
        
        
        
        
        
        cartEditedNew.setReview(review);
        cartDA.UpdateRecord(cartEditedNew);
        
            out.println("<html>");
            out.println("<style>");
            out.println("body{background-color:lightgreen;}"
                    + "#infoLog{\n"
                    + "	background-color: lightgreen;\n"
                    + "    height:25px;\n"
                    + "}");
            out.println("</style>");
            if(cartEditedNew.getReview().getReviewID()==null){
            out.println(" <body> <div id=\"infoLog\">" + "Successfully added review" + "</div></body>");
            out.println("</html>");
            }else {
            out.println(" <body> <div id=\"infoLog\">" + "Successfully Edited review" + "</div></body>");
            out.println("</html>");
            }

            RequestDispatcher rd = request.getRequestDispatcher("Customer_ManageProfile_customerView.jsp");
            rd.include(request, response);
        
        
        response.sendRedirect("Customer_ManageProfile_customerView.jsp");
        }
        //need add successfully message here 
        
        }catch(Exception ex){
                out.println("Error"+ ex.toString()+"</br></br>");
            
            StackTraceElement[] elements = ex.getStackTrace();
            for(StackTraceElement e:elements){
                out.println("File name "+e.getFileName() + "<br/>");
                out.println("class name "+e.getClassName() + "<br/>");
                out.println("Method name "+e.getMethodName() + "<br/>");
                out.println("Line number "+e.getLineNumber() + "<br/>");
        }
        
        }
        
    }

   

}
