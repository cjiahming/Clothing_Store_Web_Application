package Controller;

import Model.DA.DAAddress;
import Model.DA.DACustomer;
import Model.Domain.Address;
import Model.Domain.Customer;
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

@WebServlet(name = "DeleteCustomerAddressController", urlPatterns = {"/DeleteCustomerAddressController"})
public class DeleteCustomerAddressController extends HttpServlet {

    private DAAddress addressDA;
    
    public void init() throws ServletException{
        addressDA = new DAAddress();
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        HttpSession httpSession = request.getSession(); 
        Customer c = (Customer) (httpSession.getAttribute("customer"));
        ArrayList<Address> a = addressDA.displayAllAddressRecords(c.getUserID());
        
        try{
            for(int i=0; i<a.size(); i++){
                if(request.getParameter(a.get(i).getAddressID()) != null){
                    String addressID = request.getParameter(a.get(i).getAddressID());
                    addressDA.deleteAddress(addressID);
                }
            }
            String msg = "Address selected has been deleted!";
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
            RequestDispatcher rd = request.getRequestDispatcher("Customer_ManageProfile_customerView.jsp");
            rd.include(request, response);
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

            RequestDispatcher rd = request.getRequestDispatcher("Customer_ManageProfile_customerView.jsp");
            rd.include(request, response);
        }
    }
}
