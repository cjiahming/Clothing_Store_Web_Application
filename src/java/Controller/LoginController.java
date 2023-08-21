package Controller;

import Model.DA.DAAdmin;
import Model.DA.DACustomer;
import Model.Domain.Admin;
import Model.Domain.Customer;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "LoginController", urlPatterns = {"/LoginController"})
public class LoginController extends HttpServlet {
    
    private DACustomer custDA;
    private Customer customer;
    private DAAdmin adminDA;
    private Admin admin;

    public void init() throws ServletException{
        try{
            custDA = new DACustomer();
            customer = new Customer();
            adminDA = new DAAdmin();
            admin = new Admin();
        }
        catch(ClassNotFoundException ex) {
            Logger.getLogger(LoginController.class.getName()).log(Level.SEVERE, null, ex);
        } 
        catch(SQLException ex) {
            Logger.getLogger(LoginController.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        RequestDispatcher req = null;
        
        int countError = 0;
        String username = request.getParameter("signin-username");
        String password = request.getParameter("signin-password");
        String passwordEncrypt = customer.getMd5(password);
        
        try{
            boolean loginDetails = custDA.checkCustomerLoginDetails(username, passwordEncrypt);
            boolean adminLoginDetails = adminDA.checkAdminLoginDetails(username, passwordEncrypt);
            
            if(loginDetails){          
                String custID = custDA.getCustomerID(username);
                Customer c = custDA.displaySpecificCustomer(custID);
                
                HttpSession httpSession = request.getSession();
                httpSession.setAttribute("customer", c);
                response.sendRedirect("Product_SelectCategory-customerView.jsp");
            }
            else if(adminLoginDetails){
                String adminID = adminDA.getAdminID(username);
                Admin a = adminDA.getRecord(adminID);
                
                HttpSession httpSession = request.getSession();
                httpSession.setAttribute("admin", a);
                response.sendRedirect("Dashboard-adminView.jsp");
            }
            else{
                if(username.equals("")){
                    request.setAttribute("loginUsernameErrMsg", "Do not leave field empty!");
                    countError++;
                }
                if(password.equals("")){
                    request.setAttribute("loginPasswordErrMsg", "Do not leave field empty!");
                    countError++;
                }
                else if(!loginDetails){
                    request.setAttribute("loginErrorMessage","User ID or Password Incorrect");
                    countError++;
                }
                if(countError > 0){
                    req = request.getRequestDispatcher("Customer_LoginPage_customerView.jsp");
                    req.forward(request, response);
                }
            }
        }
        catch(Exception ex){
            System.out.println(ex.getMessage());
        }
        out.close();
    }
}
