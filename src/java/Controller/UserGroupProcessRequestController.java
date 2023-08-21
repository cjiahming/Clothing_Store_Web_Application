package Controller;

import Exceptions.*;
import Model.DA.DAUserGroup;
import Model.Domain.UserGroup;
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

@WebServlet(name = "UserGroupProcessRequestController", urlPatterns = {"/UserGroupProcessRequestController"})
public class UserGroupProcessRequestController extends HttpServlet {

    protected String getAccessRights(HttpServletRequest request) throws InvalidInputFormatException {
        String[] activated = request.getParameterValues("activated");
        String[] radioInput = {"activated", "Product", "SKU", "StockAd", "SKUEnquiry", "Sales", "SalesStatus", "Review", "ReturnReq", "Return", "Report", "User", "UserGrp", "Customer","resetPasswd"};
        char[] accessR = new char[15];//[0]= activate status, others follow the sequence
        boolean validAccess = false;
        for (int a = 0; a < 15; a++) {
            if(a==0 && activated!=null && activated[0].equalsIgnoreCase(radioInput[a]) ){
                accessR[a] = '1';
            } else if (a!=0 && request.getParameter(radioInput[a]).equalsIgnoreCase(radioInput[a])) {
                accessR[a] = '1';
                validAccess = true;
            } else {
                accessR[a] = '0';
            }
        }
        if (validAccess == false) {
            throw new InvalidInputFormatException(InvalidInputFormatException.INVALID_ACCESS);
        }
        String accessRights = new String(accessR);
        return accessRights;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        //get id
        String name = request.getParameter("userGroupName");
        String desc = request.getParameter("userGroupDesc");
        String id = request.getParameter("p");
        String action = request.getParameter("ac");
        PrintWriter out = response.getWriter();
        UserGroup uGrp =null;
        HttpSession session = request.getSession();
        String accessR;
        try {
            DAUserGroup uGrpDA = new DAUserGroup();
            ArrayList<UserGroup> list = uGrpDA.getUserGroups();

            switch (action) {
                case "add":
                    accessR = getAccessRights(request);
                    uGrp = new UserGroup(name, desc, accessR);
                    //check whether input field is null
                    name = notNullInput(name);
                    desc = notNullInput(desc);
                    accessR = getAccessRights(request);
                    //check whether usergroup name is duplicated
                    for (int a = 0; a < list.size(); a++) {
                        if (name.equalsIgnoreCase(list.get(a).getName())) {
                            throw new DuplicatedRecordException(DuplicatedRecordException.DUPLICATED_UG_NAME);
                        }
                    }
                    //set UserGroupID
                    String lastID;

                    int totalR = list.size();
                    if (totalR == 0) {
                        lastID = "0000";
                    } else {
                        uGrp = list.get(totalR - 1);
                        lastID = uGrp.getID().substring(2);
                    }
                    // process access rights
                    // Create Programme object
                    uGrp = new UserGroup(String.format("UG%04d", Integer.parseInt(lastID) + 1), name, desc, accessR);
                    session.setAttribute("userGroup", uGrp);
                    session.setAttribute("actionPerformed", action);
                    response.sendRedirect("UserGroup_Confirmation-adminView1.jsp");
                    break;

                case "view":
                    uGrp = uGrpDA.getRecord(id);
                    session.setAttribute("userGroupView", uGrp);
                    response.sendRedirect("UserGroup_View-adminView.jsp");
                    break;

                case "edit":
                case "edit2":
                    desc = request.getParameter("userGroupDesc");
                    uGrp = uGrpDA.getRecord(id);
                    if (action.equalsIgnoreCase("edit")) {
                        session.setAttribute("accessErr-UG", null);
                        session.setAttribute("userGroupView", uGrp);
                        response.sendRedirect("UserGroup_Edit-adminView.jsp");
                    } else {
                        uGrp.setDesc(desc);
                        //process access rights
                        session.setAttribute("userGroupView", uGrp);
                        accessR = getAccessRights(request);
                        uGrp.setAccessRights(accessR);
                        desc = notNullInput(desc);
                        session.setAttribute("userGroup", uGrp);
                        session.setAttribute("actionPerformed", action);
                        response.sendRedirect("UserGroup_Confirmation-adminView1.jsp");
                    }
                    break;

                case "delete":
                    uGrp = uGrpDA.getRecord(id);
                    session.setAttribute("userGroup", uGrp);
                    session.setAttribute("actionPerformed", action);
                    response.sendRedirect("UserGroup_Confirmation-adminView1.jsp");
                    break;

            }
        } catch (DuplicatedRecordException  ex) { //duplicated SKU or null value
             out.println("<html>");
            out.println("<style>");
            out.println("body{background-color:red;}"
                    + "#infoLog{\n"
                    + "	background-color: #FF8F8F;\n"
                    + "    height:25px;\n"
                    + "}");
            out.println("</style>");
            out.println(" <body> <div id=\"infoLog\"> ERROR: " + ex.getMessage() + "</div></body>");
            out.println("</html>");

            RequestDispatcher rd = request.getRequestDispatcher("/UserGroup_Summary-adminView.jsp");
            rd.include(request, response);

        } catch (EmptyInputException ex) {
            session.setAttribute("accessErr-UG", null);
            session.setAttribute("errStatus-UG", "error");
            session.setAttribute("errMsg-UG", ex.getMessage());
            session.setAttribute("tempUG", uGrp);
            if (action.equalsIgnoreCase("edit2")) {
                out.print(ex.getMessage()+ ex.getCause().getMessage());
                response.sendRedirect("UserGroup_Edit-adminView.jsp");
            } else {
                response.sendRedirect("UserGroup_AddNew-adminView.jsp");
            }

        } catch (InvalidInputFormatException er) { //invalid input entered
            session.setAttribute("accessErr-UG", er.getMessage());
            if (action.equalsIgnoreCase("edit2")) {
                out.print("Invalid" +er.getMessage());
                response.sendRedirect("UserGroup_Edit-adminView.jsp");
            } else {
                response.sendRedirect("UserGroup_AddNew-adminView.jsp");
            }
        } catch (Exception ex) {
            out.println("Error: " + ex.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html");
        //get id
        String name = request.getParameter("userGroupName");
        String desc = request.getParameter("userGroupDesc");
        String id = request.getParameter("p");
        String action = request.getParameter("ac");
        PrintWriter out = response.getWriter();
        UserGroup uGrp;
        HttpSession session = request.getSession();
        String actionPerformed = (String) session.getAttribute("actionPerformed");
        //UserGroup 

        try {
            DAUserGroup uGrpDA = new DAUserGroup();
            String msg = "";
            switch (actionPerformed) { //add record to
                case "add":
                    uGrp = (UserGroup) (session.getAttribute("userGroup"));
                    uGrpDA.addRecord(uGrp);
                    msg = "New User Group " + uGrp.getName() + " (" + uGrp.getDesc() + ") has been added to the database successfully.";
                    break;

                case "edit2":
                    uGrp = (UserGroup) (session.getAttribute("userGroup"));
                    uGrpDA.updateRecord(uGrp);
                    msg = "User Group " + uGrp.getName() + " (" + uGrp.getDesc() + ") has been updated to the database successfully.";
                    break;

                case "delete":
                    uGrp = (UserGroup) (session.getAttribute("userGroup"));
                    uGrpDA.deleteRecord(uGrp);
                    msg = "User Group " + uGrp.getName() + " (" + uGrp.getDesc() + ") has been deleted from the database successfully.";
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
            UserGroupController refresh = new UserGroupController();
            refresh.refreshTable(request, response);
            RequestDispatcher rd = request.getRequestDispatcher("/UserGroup_Summary-adminView.jsp");
            rd.include(request, response);

        } catch (java.sql.SQLIntegrityConstraintViolationException  ex) { 
            out.println("<html>");
            out.println("<style>");
            out.println("body{background-color:lightgreen;}"
                    + "#infoLog{\n"
                    + "	background-color: #FF8F8F;\n"
                    + "    height:25px;\n"
                    + "}");
            out.println("</style>");
            out.println(" <body> <div id=\"infoLog\"> ERROR: There are users linked under this user group. No deletion is allowed, please deactivate instead. </div></body>");
            out.println("</html>");

            RequestDispatcher rd = request.getRequestDispatcher("/UserGroup_Summary-adminView.jsp");
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

            RequestDispatcher rd = request.getRequestDispatcher("/UserGroup_Summary-adminView.jsp");
            rd.include(request, response);

        } finally {
            out.close();
        }
    }

    protected String notNullInput(String input) throws EmptyInputException {
        if (input.isEmpty()) {
            throw new EmptyInputException(EmptyInputException.NULL_INPUT);
        }
        return input;
    }
}
