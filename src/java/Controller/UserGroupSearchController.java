package Controller;

import Model.DA.DAUserGroup;
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

@WebServlet(name = "UserGroupSearchController", urlPatterns = {"/UserGroupSearchController"})
public class UserGroupSearchController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        // Obtain data from the form
        String name = "";
        String id = "";
        String status = "";
        name = request.getParameter("userGroupName");
        id = request.getParameter("userGroupID");
        status = request.getParameter("status");
        int active = 0;
        UserGroup[] uGrp = null;
        HttpSession s = request.getSession();
        try {
            DAUserGroup uGrpA = new DAUserGroup();
            if (!(id.isEmpty())) { //search by id if not empty
                UserGroup u = uGrpA.getRecord(id);
                if(u!=null){
                    uGrp = new UserGroup[1];
                    uGrp[0]=u;
                }else{
                    uGrp = new UserGroup[0];
                }
                
            } else if (!(name.isEmpty()|| status.isEmpty())) {//search by name and status (when both not-empty)
                if(status.equalsIgnoreCase("active")){
                    active=1;
                }
                ArrayList<UserGroup> list = uGrpA.searchUserGroupNameAndStatus(name, active);
                uGrp = new UserGroup[list.size()];
                for (int i = 0; i < list.size(); i++) {
                    uGrp[i] = list.get(i);
                }
                
            } else if (name.length() > 0) {//search by name if id is empty but name is not
                ArrayList<UserGroup> list = uGrpA.searchUserGroupName(name);
                uGrp = new UserGroup[list.size()];
                for (int i = 0; i < list.size(); i++) {
                    uGrp[i] = list.get(i);
                }
                
            } else if(status.length()>0){ //search by name if id and name is empty but status is not
                if(status.equalsIgnoreCase("active")){
                    active=1;
                }
                ArrayList<UserGroup> list = uGrpA.searchUserGroupStatus(active);
                uGrp = new UserGroup[list.size()];
                for (int i = 0; i < list.size(); i++) {
                    uGrp[i] = list.get(i);
                }
            }else{ //nothing entered
                response.sendRedirect("UserGroup_Summary-adminView.jsp");
            }
            s.setAttribute("userGroup", uGrp);
            s.setAttribute("action", "search");
            response.sendRedirect("UserGroup_Search-adminView.jsp");
        } catch (Exception ex) {
            out.println("Error2: " + ex.getMessage());
        }

    }

}
