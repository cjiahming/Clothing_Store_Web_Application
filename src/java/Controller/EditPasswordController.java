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

@WebServlet(name = "EditPasswordController", urlPatterns = {"/EditPasswordController"})
public class EditPasswordController extends HttpServlet {

    private DACustomer custDA;
    private Customer customer;

    public void init() throws ServletException {
        custDA = new DACustomer();
        customer = new Customer();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession httpSession = request.getSession();
        Customer c = (Customer) (httpSession.getAttribute("customer"));

        if (c == null) {
            response.sendRedirect("Customer_LoginPage_customerView.jsp");
        } else {
            int countError = 0;
            String currentPasswordForValidation = c.getPassword();
            String currentPassword = request.getParameter("profile-currentpassword");
            String newPassword = request.getParameter("profile-newpassword");
            String confirmNewPassword = request.getParameter("profile-confirmnewpassword");

            //encryptedPassword
            String currentPasswordEncrypted = customer.getMd5(currentPassword);
            String newPasswordEncrypted = customer.getMd5(newPassword);
            String confirmNewPasswordEncrypted = customer.getMd5(confirmNewPassword);

            if (currentPassword.equals("")) {
                request.setAttribute("currentPasswordErrMsg", "Do not leave field empty!");
                countError++;
            } else if (!currentPasswordEncrypted.equals(currentPasswordForValidation)) {
                request.setAttribute("currentPasswordErrMsg", "Password is not the same as current password!");
                countError++;
            }

            if (newPassword.equals("")) {
                request.setAttribute("newPasswordErrMsg", "Do not leave field empty!");
                countError++;
            } else if (newPasswordEncrypted.equals(currentPasswordEncrypted)) {
                request.setAttribute("newPasswordErrMsg", "Password cannot same with current password!");
                countError++;
            } else if (!validatePassword(newPassword)) {
                request.setAttribute("newPasswordErrMsg", "Password must be alphanumeric, have special characters and 8 characters long!");
                countError++;
            }

            if (confirmNewPassword.equals("")) {
                request.setAttribute("confirmNewPasswordErrMsg", "Do not leave field empty!");
                countError++;
            } else if (!confirmNewPasswordEncrypted.equals(newPasswordEncrypted)) {
                request.setAttribute("confirmNewPasswordErrMsg", "Password does not match new password!");
                countError++;
            }

            if (countError > 0) {
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

                RequestDispatcher rd = request.getRequestDispatcher("Customer_ManageProfile_customerView.jsp");
                rd.include(request, response);
            } else {
                Customer c2 = new Customer(c.getUserID(), confirmNewPasswordEncrypted);
                custDA.updateCustomerPassword(c2);

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
    }

    public static boolean validatePassword(String password) {
        String regex = "^(?=.*\\d)(?=.*[a-z])(?=.*[./!@^*#$%]).{8,20}$";
        Pattern pattern = Pattern.compile(regex);
        Matcher matcher = pattern.matcher(password);
        return matcher.matches();
    }
}
