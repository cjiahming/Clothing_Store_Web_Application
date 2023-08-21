package Controller;

import Model.DA.DAAdmin;
import Model.Domain.Admin;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "EditAdminPasswordController", urlPatterns = {"/EditAdminPasswordController"})
public class EditAdminPasswordController extends HttpServlet {

    private DAAdmin adminDA;
    private Admin admin;
    
    public void init() throws ServletException {
        try{
            adminDA = new DAAdmin();
            admin = new Admin();   
        }
        catch(ClassNotFoundException ex) {
            Logger.getLogger(EditAdminPasswordController.class.getName()).log(Level.SEVERE, null, ex);
        } 
        catch(SQLException ex) {
            Logger.getLogger(EditAdminPasswordController.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        HttpSession httpSession = request.getSession();
        Admin a = (Admin) (httpSession.getAttribute("admin"));
        
        int countError = 0;
        String currentPasswordForValidation = a.getPassword();
        String currentPassword = request.getParameter("admin-currentpassword");
        String newPassword = request.getParameter("admin-edit-newpassword");
        String confirmNewPassword = request.getParameter("admin-edit-confirmnewpassword");
        
        //encryptedPassword
        String currentPasswordEncrypted = admin.getMd5(currentPassword);
        String newPasswordEncrypted = admin.getMd5(newPassword);
        String confirmNewPasswordEncrypted = admin.getMd5(confirmNewPassword);
        
        try{
            if(currentPassword.equals("")){
                request.setAttribute("currentPasswordErrMsg", "Do not leave field empty!");
                countError++;
            }
            else if(!currentPasswordEncrypted.equals(currentPasswordForValidation)){
                request.setAttribute("currentPasswordErrMsg", "Password is not the same as current password!");
                countError++;
            }
        
            if(newPassword.equals("")){
                request.setAttribute("newPasswordErrMsg", "Do not leave field empty!");
                countError++;
            }
            else if(newPasswordEncrypted.equals(currentPasswordEncrypted)){
                request.setAttribute("newPasswordErrMsg", "Password cannot same with current password!");
                countError++;
            }
            else if(!validatePassword(newPassword)){
                request.setAttribute("newPasswordErrMsg", "Password must be alphanumeric, have special characters and 8 characters long!");
                countError++;
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
                out.println("<html>");
                out.println("<style>");
                out.println("body{background-color:lightgreen;}"
                        + "#infoLog{\n"
                        + "	background-color: #FF8F8F;\n"
                        + "    height:25px;\n"
                        + "}");
                out.println("</style>");
                out.println(" <body> <div id=\"infoLog\"> ERROR: " + "Unable to change password!" + "</div></body>");
                out.println("</html>");
                
                RequestDispatcher rd = request.getRequestDispatcher("Admin_editProfile-adminView.jsp");
                rd.include(request,response);
            }
            else{
                Admin a2 = new Admin(a.getUserID(), confirmNewPasswordEncrypted);
                adminDA.updateAdminPassword(a2);

                //clear the session after successfully update password
                httpSession.invalidate();

                String msg = "Your password has been updated!";
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
        catch(Exception ex){
            out.println("<html>");
            out.println("<style>");
            out.println("body{background-color:lightgreen;}"
                    + "#infoLog{\n"
                    + "	background-color: #FF8F8F;\n"
                    + "    height:25px;\n"
                    + "}");
            out.println("</style>");
            out.println(" <body> <div id=\"infoLog\"> ERROR: " + ex.getMessage() + "</div></body>");
            out.println("</html>");

            RequestDispatcher rd = request.getRequestDispatcher("Admin_editProfile-adminView.jsp");
            rd.include(request, response);
        }
        finally{
            out.close();
        }
        
    }

    public static boolean validatePassword(String password){
        String regex = "^(?=.*\\d)(?=.*[a-z])(?=.*[./!@^*#$%]).{8,20}$";
        Pattern pattern = Pattern.compile(regex);
        Matcher matcher = pattern.matcher(password);
        return matcher.matches();
    }
}
