package Controller;

import Model.DA.DAAdmin;
import Model.DA.DACustomer;
import Model.Domain.Admin;
import Model.Domain.Customer;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "UpdateAdminController", urlPatterns = {"/UpdateAdminController"})
public class UpdateAdminController extends HttpServlet {

    private DACustomer custDA;
    private Customer customer;
    private DAAdmin adminDA;
    private Admin admin;

    public void init() throws ServletException {
        try {
            custDA = new DACustomer();
            customer = new Customer();
            adminDA = new DAAdmin();
            admin = new Admin();
        } catch (SQLException ex) {
            Logger.getLogger(UpdateAdminController.class.getName()).log(Level.SEVERE, null, ex);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(UpdateAdminController.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession httpSession = request.getSession();
        Admin a2 = (Admin) (httpSession.getAttribute("admin"));

        int countError = 0;
        int success = 0;
        int phonenumChanged = 0;
        int emailChanged = 0;
        String adminID = a2.getUserID();
        String phoneNum = request.getParameter("admin-edit-phonenumber");
        String email = request.getParameter("admin-edit-email");
        String gender = request.getParameter("admin-edit-gender");

        try {
            ArrayList<Customer> custArrayList = custDA.displayAllCustomerRecords();
            ArrayList<Admin> adminArrayList = adminDA.getUsers();

            if (phoneNum.equals(a2.getPhoneNum()) && email.equals(a2.getEmail())) {
                success++;
            } 
            else if (!phoneNum.equals(a2.getPhoneNum()) && !email.equals(a2.getEmail())) {
                phonenumChanged++;
                emailChanged++;
            } 
            else if (phoneNum.equals(a2.getPhoneNum()) && !email.equals(a2.getEmail())) {
                emailChanged++;
            } 
            else if (!phoneNum.equals(a2.getPhoneNum()) && email.equals(a2.getEmail())) {
                phonenumChanged++;
            }

            if (phonenumChanged > 0) {
                //checking customer database existing phoneNum
                for (int i = 0; i < custArrayList.size(); i++) {
                    if (phoneNum.equals(custArrayList.get(i).getPhoneNum())) {
                        request.setAttribute("editPhoneNumErrMsg", "Phone Number taken. Please enter another phone number.");
                        countError++;
                    }
                }
                //checking admin database existing phoneNum
                for (int i = 0; i < adminArrayList.size(); i++) {
                    if (phoneNum.equals(adminArrayList.get(i).getPhoneNum())) {
                        request.setAttribute("editPhoneNumErrMsg", "Phone Number taken. Please enter another phone number.");
                        countError++;
                    }
                }
            }

            if (emailChanged > 0) {
                //checking customer database existing email
                for (int i = 0; i < custArrayList.size(); i++) {
                    if (email.equals(custArrayList.get(i).getEmail())) {
                        request.setAttribute("editEmailErrMsg", "Email taken. Please enter another email.");
                        countError++;
                    }
                }
                //checking admin database existing email
                for (int i = 0; i < adminArrayList.size(); i++) {
                    if (email.equals(adminArrayList.get(i).getEmail())) {
                        request.setAttribute("editEmailErrMsg", "Email taken. Please enter another email.");
                        countError++;
                    }
                }
            }

            if (success == 0 || phonenumChanged > 0 || emailChanged > 0) {
                if (phoneNum.equals("")) {
                    request.setAttribute("editPhoneNumErrMsg", "Do not leave field empty!");
                    countError++;
                } else if (!validatePhoneNumber(phoneNum)) {
                    request.setAttribute("editPhoneNumErrMsg", "Please enter a valid Phone Number!");
                    countError++;
                }
                if (email.equals("")) {
                    request.setAttribute("editEmailErrMsg", "Do not leave field empty!");
                    countError++;
                } else if (!validateEmail(email)) {
                    request.setAttribute("editEmailErrMsg", "Please enter a valid email!");
                    countError++;
                }
                if (gender.equals("")) {
                    request.setAttribute("editGenderErrMsg", "Do not leave field empty!");
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
                    out.println(" <body> <div id=\"infoLog\"> ERROR: " + "Your details is not updated!" + "</div></body>");
                    out.println("</html>");

                    RequestDispatcher rd = request.getRequestDispatcher("Admin_editProfile-adminView.jsp");
                    rd.include(request, response);
                }
            }
            if (countError == 0) {
                Admin admin = new Admin(adminID, phoneNum, email, gender);
                adminDA.updateAdminRecords(admin);

                String msg = "Your details had been updated!";
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
                AdminUserController refresh = new AdminUserController();
                refresh.refreshTable(request, response);
                httpSession.setAttribute("admin", adminDA.getRecord(adminID));
                RequestDispatcher rd = request.getRequestDispatcher("Admin_editProfile-adminView.jsp");
                rd.include(request, response);
            }
        } catch (Exception ex) {
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

            RequestDispatcher rd = request.getRequestDispatcher("Admin_editP.jsp");
            rd.include(request, response);
        } finally {
            out.close();
        }
    }

    private static boolean validatePhoneNumber(String phoneNum) { //phone validation
        //validating phone number must have "-" and total must have 10 numbers,
        if (phoneNum.matches("\\d{3}[-s]\\d{7}")) {
            return true;
        } else if (phoneNum.matches("\\d{3}[-s]\\d{8}")) {  //validating phone number must have "-" and total must have 1 numbers
            return true;
        } else {
            System.out.println("\t\t\t\t\t(Please enter a valid phone number)");
            System.out.println("");
            return false;
        }
    }

    private static boolean validateEmail(String email) { //email validation
        String regex = "^[\\w-_\\.+]*[\\w-_\\.]\\@([\\w]+\\.)+[\\w]+[\\w]$";
        return email.matches(regex);
    }
}
