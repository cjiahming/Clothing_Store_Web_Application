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

@WebServlet(name = "UpdateCustomerAddressController", urlPatterns = {"/UpdateCustomerAddressController"})
public class UpdateCustomerAddressController extends HttpServlet {

    private DACustomer custDA;
    private DAAddress addressDA;
    private Address address;

    public void init() throws ServletException {
        custDA = new DACustomer();
        addressDA = new DAAddress();
        address = new Address();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession httpSession = request.getSession();
        Customer c = (Customer) (httpSession.getAttribute("customer"));

            ArrayList<Address> a = addressDA.displayAllAddressRecords(c.getUserID());
            String addressID = "";

            for (int i = 0; i < a.size(); i++) {
                if (request.getParameter(a.get(i).getAddressID()) != null) {
                    addressID = request.getParameter(a.get(i).getAddressID());
                }
            }

            address = addressDA.displaySpecificAddress(addressID);
            httpSession.setAttribute("editAddress", address);
            
            System.out.println(address.getAddressID());

            response.sendRedirect("Customer_EditAddress_customerView.jsp");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession httpSession = request.getSession();
        Customer c = (Customer) (httpSession.getAttribute("customer"));

        if (c == null) {
            response.sendRedirect("Customer_LoginPage_customerView.jsp");
        } else {
            ArrayList<Address> a = addressDA.displayAllAddressRecords(c.getUserID());
            
            String addressid = request.getParameter("updateaddress-addressid");
            String fullName = request.getParameter("updateaddress-fullname");
            String phoneNum = request.getParameter("updateaddress-phonenumber");
            String state = request.getParameter("stateSelect");
            String area = request.getParameter("areaSelect");
            String posCode = request.getParameter("updateaddress-poscode");
            String addressLine = request.getParameter("updateaddress-addressline");

            try {
                Address address = new Address(addressid, fullName, phoneNum, state, area, addressLine, posCode, c);
                addressDA.updateAddress(address);

                String msg = "Your address has been updated!";
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

                RequestDispatcher rd = request.getRequestDispatcher("Customer_ManageProfile_customerView.jsp");
                rd.include(request, response);
            }
        }
    }
}
