/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Controller;

import Model.DA.DACustomer;
import Model.Domain.Customer;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author Benjamin Choong
 */
@WebServlet(name = "ResetCustomerPasswordController", urlPatterns = {"/ResetCustomerPasswordController"})
public class ResetCustomerPasswordController extends HttpServlet {

    private DACustomer custDA;
    private Customer customer;
    
    public void init() throws ServletException{
        custDA = new DACustomer();
        customer = new Customer();
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        int countError = 0;
        
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("email");
        String otpcode = (String) session.getAttribute("authcode");

        String newPassword = request.getParameter("newpassword");
        String confirmNewPassword = request.getParameter("confirmnewpassword");
        
        //encryptedPassword
        String newPasswordEncrypted = customer.getMd5(newPassword); 
        String confirmNewPasswordEncrypted = customer.getMd5(confirmNewPassword);
        
        if(newPassword.equals("")){
            request.setAttribute("newPasswordErrMsg", "Do not leave field empty!");
            countError++;
        }
        else if(!validatePassword(newPassword)){
            request.setAttribute("newPasswordErrMsg", "Password must be alphanumeric, have special characters and 8 characters long!");
            countError++;
            RequestDispatcher rd = request.getRequestDispatcher("Customer_ResetPassword-customerView.jsp");
            rd.forward(request,response);
        }
        
        if(confirmNewPassword.equals("")){
            request.setAttribute("confirmNewPasswordErrMsg", "Do not leave field empty!");
            countError++;
        }
        else if(!confirmNewPasswordEncrypted.equals(newPasswordEncrypted)){
            request.setAttribute("confirmNewPasswordErrMsg", "Password does not match new password!");
            countError++;
        }
        
        if(countError > 0){
            RequestDispatcher rd = request.getRequestDispatcher("Customer_ResetPassword-customerView.jsp");
            rd.forward(request,response);
        }
        else{
            String custID = custDA.getCustomerID2(email);
            Customer c = new Customer(custID, confirmNewPasswordEncrypted);
            custDA.updateCustomerPassword(c); 
            
            session.invalidate();
            
            String msg = "Your password has been reset!";
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

            RequestDispatcher rd = request.getRequestDispatcher("Customer_LoginPage_customerView.jsp");
            rd.include(request, response);
        }
    }
    
    public static boolean validatePassword(String password){
        String regex = "^(?=.*\\d)(?=.*[a-z])(?=.*[./!@^*#$%]).{8,20}$";
        Pattern pattern = Pattern.compile(regex);
        Matcher matcher = pattern.matcher(password);
        return matcher.matches();
    }

}
