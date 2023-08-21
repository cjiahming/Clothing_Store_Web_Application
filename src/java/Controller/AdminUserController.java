package Controller;

import Model.DA.DAAdmin;
import Model.DA.DAUserGroup;
import Model.Domain.Admin;
import Model.Domain.UserGroup;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "AdminUserController", urlPatterns = {"/AdminUserController"})
public class AdminUserController extends HttpServlet {
    protected void refreshTable(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        int totalRecords;
        int totalR;

        //display records
        try {
            DAUserGroup d = new DAUserGroup();
            ArrayList<UserGroup> uGrpList = d.getUserGroups();
            totalR = uGrpList.size();
            UserGroup[] uGrps = new UserGroup[totalR];
            for (int i = 0; i < uGrpList.size(); i++) {
                uGrps[i] = uGrpList.get(i);
            }
            
            HttpSession s = request.getSession();
            s.setAttribute("userGroupList", uGrps);
            
            DAAdmin daAdmin = new DAAdmin();
            ArrayList<Admin> list = daAdmin.getUsers();
            totalRecords = list.size();
            Admin[] admins = new Admin[totalRecords];
            for (int i = 0; i < list.size(); i++) {
                admins[i] = list.get(i);
            }
            
            s.setAttribute("adminUsers", admins);

        } catch (Exception ex) {
            out.println("Error: " + ex.getMessage());
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String toAddNew = request.getParameter("toAddNew");
        refreshTable(request, response);
        
        if(toAddNew.equalsIgnoreCase("true")){
            HttpSession s = request.getSession();
            s.setAttribute("errStatus", "null");
            response.sendRedirect("User_AddNew-adminView.jsp");
        }else{
            response.sendRedirect("User_Summary-adminView.jsp");
        }
        
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        refreshTable(request, response);
        response.sendRedirect("User_Summary-adminView.jsp");
    }
}
