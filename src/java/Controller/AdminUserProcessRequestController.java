package Controller;

import Exceptions.DuplicatedRecordException;
import Exceptions.EmptyInputException;
import Exceptions.InvalidInputFormatException;
import Model.DA.DAAdmin;
import Model.DA.DAUserGroup;
import Model.Domain.Admin;
import Model.Domain.UserGroup;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.validation.ConstraintViolationException;

@WebServlet(name = "AdminUserProcessRequestController", urlPatterns = {"/AdminUserProcessRequestController"})
public class AdminUserProcessRequestController extends HttpServlet {

    protected String notNullInput(String input) throws EmptyInputException {
        if(input.isEmpty()){
            throw new EmptyInputException(EmptyInputException.NULL_INPUT);
        }
        return input;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        //get id
        String username = request.getParameter("username");
        String gender = request.getParameter("gender");
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String phoneNum = request.getParameter("phoneNum");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String conPassword = request.getParameter("conPassword");
        String usergroupID = request.getParameter("userGroup");
        String id = request.getParameter("p");
        String action = request.getParameter("ac");
        PrintWriter out = response.getWriter();
        Admin admin;
        HttpSession session = request.getSession();

        try {
            DAUserGroup uGrpDA = new DAUserGroup();
            DAAdmin adminDA = new DAAdmin();
            UserGroup uG = uGrpDA.getRecord(usergroupID);
            String lastID;
                    ArrayList<Admin> list = adminDA.getUsers();
            switch (action) {
                case "add":
                    //check whether confirmed pass is null --> null err msg will be shown 1st
                    username =notNullInput(username);
                    firstName = notNullInput(firstName);
                    lastName = notNullInput(lastName);
                    password=notNullInput(password);
                    conPassword = notNullInput(conPassword);
                    if(phoneNum.isEmpty()==false && validatePhoneNumber(phoneNum)==false){
                        throw new InvalidInputFormatException(InvalidInputFormatException.INVALID_PHONE_NUM);
                    }
                    if(email.isEmpty()==false && validateEmail(email)==false ){
                        throw new InvalidInputFormatException(InvalidInputFormatException.INVALID_EMAIL);
                    }
                    //check username is not duplicated
                    for(int a=0; a< list.size();a++){
                        if(username.equalsIgnoreCase(list.get(a).getUsername()) ){
                            throw new DuplicatedRecordException(DuplicatedRecordException.DUPLICATED_USERNAME);
                        }
                    }
                    
                    //password checking
                    matchedPassword(password,conPassword); //if not match will throw exception
                    //check whether the passwd is in a valid format
                    if(!validatePassword(password)){
                        throw new InvalidInputFormatException(InvalidInputFormatException.INVALID_PASSWORD);
                    }
                     //set userID
                    int totalR = list.size();
                    if (totalR == 0) {
                        lastID = "0000";
                    } else {
                        admin = list.get(totalR - 1);
                        lastID = admin.getUserID().substring(1);
                    }
                    admin = new Admin(String.format("A%04d", Integer.parseInt(lastID) + 1), username, firstName, lastName, phoneNum, email, password, gender, uG);
                    session.setAttribute("adminUser", admin);
                    session.setAttribute("actionPerformed", action);
                    response.sendRedirect("User_Confirmation-adminView.jsp");
                    break;
                case "view":
                    admin = adminDA.getRecord(id);
                    session.setAttribute("adminView", admin);
                    response.sendRedirect("User_View-adminView.jsp");
                    break;
                case "edit":
                case "edit2":
                    admin = adminDA.getRecord(id);
                    if (action.equalsIgnoreCase("edit")) {
                        session.setAttribute("adminView", admin);
                        response.sendRedirect("User_Edit-adminView.jsp");
                    } else {
                        admin.setFirstName(firstName);
                        admin.setLastName(lastName);
                        admin.setEmail(email);
                        admin.setGender(gender);
                        admin.setPhoneNum(phoneNum);
                        admin.setUserGroup(uG);
                        session.setAttribute("adminUser", admin);
                        session.setAttribute("actionPerformed", action);
                        response.sendRedirect("User_Confirmation-adminView.jsp");
                    }
                    break;
                case "delete":
                    admin = adminDA.getRecord(id);
                    session.setAttribute("adminUser", admin);
                    session.setAttribute("actionPerformed", action);
                    response.sendRedirect("User_Confirmation-adminView.jsp");
                    break;

                case "reset":
                    admin = adminDA.getRecord(id);
                    session.setAttribute("adminUser", admin);
                    session.setAttribute("actionPerformed", action);
                    session.setAttribute("resetErr-AU", null);
                    response.sendRedirect("User_ResetPasswd-adminView.jsp");
                    break;

                case "processUG":
                    admin = adminDA.getRecord(id);
                    session.setAttribute("adminUser", admin);
                    session.setAttribute("actionPerformed", action);
                    response.sendRedirect("User_ResetPasswd-adminView.jsp");
                    break;

            }

        } catch (EmptyInputException  ex) { //duplicated SKU or null value
            session.setAttribute("errStatus", "error");
            session.setAttribute("errMsg-AU", ex.getMessage());
            session.setAttribute("errMsg-AU-OPT", null); 
            Admin tempAdmin = new Admin("", username, firstName, lastName,phoneNum, email, password, gender, new UserGroup(usergroupID));
            session.setAttribute("tempAdmin", tempAdmin);
            response.sendRedirect("User_AddNew-adminView.jsp");

        } catch (DuplicatedRecordException  ex) { //duplicated SKU or null value
            session.setAttribute("errStatus", "error");
            session.setAttribute("errMsg-AU", null);
            session.setAttribute("errMsg-AU-OPT", ex.getMessage()); 
            Admin tempAdmin = new Admin("", username, firstName, lastName,phoneNum, email, password, gender, new UserGroup(usergroupID));
            session.setAttribute("tempAdmin", tempAdmin);
            response.sendRedirect("User_AddNew-adminView.jsp");

        } catch (InvalidInputFormatException  ex) { //invalid input entered
            session.setAttribute("errStatus", "error");
            session.setAttribute("errMsg-AU", ex.getMessage()); //required input error
            session.setAttribute("errMsg-AU-OPT", ""); //optional data error
            Admin tempAdmin = new Admin("", username, firstName, lastName,phoneNum, email, password, gender, new UserGroup(usergroupID));
            if(ex.getMessage().equals(InvalidInputFormatException.INVALID_PHONE_NUM) || ex.getMessage().equals(InvalidInputFormatException.INVALID_EMAIL)){
                 session.setAttribute("errMsg-AU-OPT", ex.getMessage()); 
                 session.setAttribute("errMsg-AU", "");
            }
            session.setAttribute("tempAdmin", tempAdmin);
            response.sendRedirect("User_AddNew-adminView.jsp");

        }catch (Exception ex) {
            out.println("Error: " + ex.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        Admin admin;
        HttpSession session = request.getSession();
        String actionPerformed = (String) session.getAttribute("actionPerformed");

        try {
            DAAdmin adminDA = new DAAdmin();
            String msg = "";
            switch (actionPerformed) { //add record to
                case "add":
                    admin = (Admin) (session.getAttribute("adminUser"));
                    admin.setPassword(Admin.getMd5(admin.getPassword()));
                    adminDA.addRecord(admin);
                    msg = "New User " + admin.getUsername() + " (" + admin.getFirstName() + ") has been added to the database successfully.";
                    break;
                case "edit2":
                    admin = (Admin) (session.getAttribute("adminUser"));
                    adminDA.updateRecord(admin);
                    msg = "User " + admin.getUsername() + " (" + admin.getFirstName() + ") has been updated to the database successfully.";
                    break;
                case "delete":
                    admin = (Admin) (session.getAttribute("adminUser"));
                    adminDA.deleteRecord(admin);
                    msg = "User " + admin.getUsername() + " (" + admin.getFirstName() + ") has been deleted to the database successfully.";
                    break;
                case "reset":
                    String password = request.getParameter("password");
                    String conPassword = request.getParameter("conPasswd");
                    password=notNullInput(password);
                    conPassword = notNullInput(conPassword);
                     //password checking
                    matchedPassword(password,conPassword); //if not match will throw exception
                    //check whether the passwd is in a valid format
                    if(!validatePassword(password)){
                        throw new InvalidInputFormatException(InvalidInputFormatException.INVALID_PASSWORD);
                    }
                    admin = (Admin) (session.getAttribute("adminUser"));
                    admin.setPassword(Admin.getMd5(password));
                    adminDA.updateRecord(admin);
                    msg = "User Password for " + admin.getUsername() + " (" + admin.getFirstName() + ") has been reset successfully.";
                    break;

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

            out.println("<body><div id=\"infoLog\">&nbsp;&nbsp;&nbsp;&nbsp;<span id=\"infoIcon\"><i class=\"fa fa-check\"></i></span> &nbsp;&nbsp; " + msg + "</div></body>");
            out.println("</html>");
            AdminUserController refresh = new AdminUserController();
            refresh.refreshTable(request, response);
            RequestDispatcher rd = request.getRequestDispatcher("/User_Summary-adminView.jsp");
            rd.include(request, response);

        } catch (EmptyInputException  ex) { //duplicated SKU or null value
            session.setAttribute("resetErr-AU", ex.getMessage());
            response.sendRedirect("User_ResetPasswd-adminView.jsp");

        } catch (InvalidInputFormatException  ex) { //invalid input entered
            session.setAttribute("resetErr-AU", ex.getMessage());
            response.sendRedirect("User_ResetPasswd-adminView.jsp");

        } catch (java.sql.SQLIntegrityConstraintViolationException  ex) { 
            out.println("<html>");
            out.println("<style>");
            out.println("body{background-color:lightgreen;}"
                    + "#infoLog{\n"
                    + "	background-color: #FF8F8F;\n"
                    + "    height:25px;\n"
                    + "}");
            out.println("</style>");
            out.println(" <body> <div id=\"infoLog\"> ERROR: The user has modified the system's record before, no deletion is allowed. Action Canceled. </div></body>");
            out.println("</html>");

            RequestDispatcher rd = request.getRequestDispatcher("/User_Summary-adminView.jsp");
            rd.include(request, response);

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

            RequestDispatcher rd = request.getRequestDispatcher("/User_Summary-adminView.jsp");
            rd.include(request, response);

        } finally {
            out.close();
        }
    }

    //validation
    private static boolean validatePhoneNumber(String phoneNum) { //phone validation
        //validating phone number must have "-" and total must have 10 numbers,
        if (phoneNum.matches("\\d{3}[-s]\\d{8}")) {
            return true;
        } else if (phoneNum.matches("\\d{3}[-s]\\d{7}")) {  //validating phone number must have "-" and total must have 1 numbers
            return true;
        } else {
            System.out.println("\t\t\t\t\t(Please enter a valid phone number)");
            System.out.println("");
            return false;
        }
    }

    private static boolean validateEmail(String email) { //email validation
        String regex = "^[\\w-\\.+]*[\\w-\\.]\\@([\\w]+\\.)+[\\w]+[\\w]$";
        return email.matches(regex);
    }

    private static boolean validatePassword(String password) {
        String regex = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%]).{8,20}$";
        Pattern pattern = Pattern.compile(regex);
        Matcher matcher = pattern.matcher(password);
        return matcher.matches();
    }
    
    private static void matchedPassword(String password, String conPass)throws InvalidInputFormatException {
        if(password.equals(conPass)==false){
            throw new InvalidInputFormatException(InvalidInputFormatException.PASSWORD_NOT_MATHCED);
        }
    }

}
