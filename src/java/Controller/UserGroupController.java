package Controller;

import Model.DA.DAUserGroup;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import Model.Domain.UserGroup;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;

@WebServlet(name = "UserGroupController", urlPatterns = {"/UserGroupController"})
public class UserGroupController extends HttpServlet {

    protected void refreshTable(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        int totalR;

        //display records
        try {
            DAUserGroup uGrpA = new DAUserGroup();
            ArrayList<UserGroup> list = uGrpA.getUserGroups();
            totalR = list.size();
            UserGroup[] uGrps = new UserGroup[totalR];
            for (int i = 0; i < list.size(); i++) {
                uGrps[i] = list.get(i);
            }
            HttpSession s = request.getSession();
            s.setAttribute("userGroupList", uGrps);

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
            s.setAttribute("errStatus-UG", "null");
            s.setAttribute("accessErr-UG", null);
            response.sendRedirect("UserGroup_AddNew-adminView.jsp");
        }else{
            response.sendRedirect("UserGroup_Summary-adminView.jsp");
        }
        
    }

    

}
