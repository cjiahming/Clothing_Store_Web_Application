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
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "RegisterCustomerController", urlPatterns = {"/RegisterCustomerController"})
public class RegisterCustomerController extends HttpServlet {

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
            Logger.getLogger(RegisterCustomerController.class.getName()).log(Level.SEVERE, null, ex);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(RegisterCustomerController.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        HttpSession httpSession = request.getSession();
        Customer c2 = (Customer) (httpSession.getAttribute("customer"));

        if (c2 != null) {
            response.sendRedirect("Customer_ManageProfile_customerView.jsp");
        } else {
            response.setContentType("text/html");
            PrintWriter out = response.getWriter();

            int countError = 0;
            String custID = customer.getCustomerRows();
            String username = request.getParameter("register-username");
            String phoneNum = request.getParameter("register-phoneNum");
            String email = request.getParameter("register-email");
            String password = request.getParameter("register-password");
            String passwordEncrypted = customer.getMd5(password);

            try {
                ArrayList<Customer> custArrayList = custDA.displayAllCustomerRecords();
                ArrayList<Admin> adminArrayList = adminDA.getUsers();

                if (username.equals("")) {
                    request.setAttribute("registerUsernameErrMsg", "Do not leave field empty!");
                    countError++;
                }

                for (int i = 0; i < custArrayList.size(); i++) {
                    if (username.equals(custArrayList.get(i).getUsername())) {
                        request.setAttribute("registerUsernameErrMsg", "Username taken. Please enter a new username.");
                        countError++;
                    }
                    if (phoneNum.equals(custArrayList.get(i).getPhoneNum())) {
                        request.setAttribute("registerPhoneNumErrMsg", "Phone Number taken. Please enter another phone number.");
                        countError++;
                    }
                    if (email.equals(custArrayList.get(i).getEmail())) {
                        request.setAttribute("registerEmailErrMsg", "Email taken. Please enter another email.");
                        countError++;
                    }
                }

                for (int i = 0; i < adminArrayList.size(); i++) {
                    if (username.equals(adminArrayList.get(i).getUsername())) {
                        request.setAttribute("registerUsernameErrMsg", "Username taken. Please enter a new username.");
                        countError++;
                    }
                    if (phoneNum.equals(adminArrayList.get(i).getPhoneNum())) {
                        request.setAttribute("registerPhoneNumErrMsg", "Phone Number taken. Please enter another phone number.");
                        countError++;
                    }
                    if (email.equals(adminArrayList.get(i).getEmail())) {
                        request.setAttribute("registerEmailErrMsg", "Email taken. Please enter another email.");
                        countError++;
                    }
                }

                if (phoneNum.equals("")) {
                    request.setAttribute("registerPhoneNumErrMsg", "Do not leave field empty!");
                    countError++;
                } else if (!validatePhoneNumber(phoneNum)) {
                    request.setAttribute("registerPhoneNumErrMsg", "Please enter a valid Phone Number!");
                    countError++;
                }

                if (email.equals("")) {
                    request.setAttribute("registerEmailErrMsg", "Do not leave field empty!");
                    countError++;
                } else if (!validateEmail(email)) {
                    request.setAttribute("registerEmailErrMsg", "Please enter a valid email!");
                    countError++;
                }

                if (password.equals("")) {
                    request.setAttribute("registerPasswordErrMsg", "Do not leave field empty!");
                    countError++;
                } else if (!validatePassword(password)) {
                    request.setAttribute("registerPasswordErrMsg", "Password must be alphanumeric, have special characters and 8 characters long!");
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
                    out.println(" <body> <div id=\"infoLog\"> ERROR: " + "Unable to register account!" + "</div></body>");
                    out.println("</html>");

                    RequestDispatcher rd = request.getRequestDispatcher("Customer_LoginPage_customerView.jsp");
                    rd.include(request, response);
                } else {
                    Customer c = new Customer(custID, username, phoneNum, email, passwordEncrypted);
                    custDA.registerCustomer(c);

                    String msg = "Account created successfully!";
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

                RequestDispatcher rd = request.getRequestDispatcher("Customer_LoginPage_customerView.jsp");
                rd.include(request, response);
            } finally {
                out.close();
            }
        }
    }

    private static boolean validatePhoneNumber(String phoneNum) { //phone validation
        //validating phone number must have "-" and total must have 10 numbers,
        if (phoneNum.matches("\\d{3}[-s]\\d{7}")) {
            return true;
        } else if (phoneNum.matches("\\d{3}[-s]\\d{8}")) {  //validating phone number must have "-" and total must have 11 numbers
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

    public static boolean validatePassword(String password) {
        String regex = "^(?=.*\\d)(?=.*[a-z])(?=.*[./!@^*#$%]).{8,20}$";
        Pattern pattern = Pattern.compile(regex);
        Matcher matcher = pattern.matcher(password);
        return matcher.matches();
    }
}
