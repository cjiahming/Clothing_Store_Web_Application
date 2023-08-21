package Controller;

import OTPClass.SendEmail;
import Model.DA.DACustomer;
import Model.Domain.Customer;
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

@WebServlet(name = "VerifySendEmailController", urlPatterns = {"/VerifySendEmailController"})
public class VerifySendEmailController extends HttpServlet {
    
    private DACustomer custDA;
    
    public void init() throws ServletException{
        custDA = new DACustomer();
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            
            boolean emailExist = false;
            
            //feth form value
           String email = request.getParameter("forgotpassword-email");
           
           if(email.equals("")){
                request.setAttribute("emailErrMsg", "Do not leave field empty!");
                RequestDispatcher rd = request.getRequestDispatcher("Customer_ForgotPassword-customerView.jsp");
                rd.forward(request,response);
           }
           
           ArrayList<Customer> custArrayList = new ArrayList();
           custArrayList = custDA.displayAllCustomerRecords();
           
           for(int i=0; i<custArrayList.size(); i++){
               if(custArrayList.get(i).getEmail().equals(email)){
                   emailExist = true;
               }
           }
           
           if(emailExist){
               	//create instance object of the SendEmail Class
                SendEmail sm = new SendEmail();
                     //get the 6-digit code
                String code = sm.getRandom();

                //call the send email method
                boolean test = sm.sendEmail(email, code);

                     //check if the email send successfully
                if(test){
                    HttpSession session  = request.getSession();
                    session.setAttribute("email", email);
                    session.setAttribute("authcode", code);
                    response.sendRedirect("Customer_EnterOTPNumber-customerView.jsp");
                }else{
                    response.sendRedirect("Customer_ErrorSendingOTPCode-customerView.html");
                }
           }
           else{
                request.setAttribute("emailErrMsg", "Email Does Not Exist!");
                RequestDispatcher rd = request.getRequestDispatcher("Customer_ForgotPassword-customerView.jsp");
                rd.forward(request,response);
           }
      	
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}