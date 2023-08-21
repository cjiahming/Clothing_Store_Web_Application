package Controller;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "VerifyOTPController", urlPatterns = {"/VerifyOTPController"})
public class VerifyOTPController extends HttpServlet {

   
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            
            HttpSession session = request.getSession();
            String email = (String) session.getAttribute("email");
            String otpcode = (String) session.getAttribute("authcode");
            
            String code = request.getParameter("otpnumber");
            
            if(code.equals(otpcode)){
                response.sendRedirect("Customer_ResetPassword-customerView.jsp");
            }else{
                request.setAttribute("otpErrMsg", "Invalid OTP Number!");
                RequestDispatcher rd = request.getRequestDispatcher("Customer_EnterOTPNumber-customerView.jsp");
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