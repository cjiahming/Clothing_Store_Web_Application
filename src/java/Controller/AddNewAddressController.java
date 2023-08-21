package Controller;

import Model.DA.DAAddress;
import Model.Domain.Address;
import Model.Domain.Customer;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "AddNewAddressController", urlPatterns = {"/AddNewAddressController"})
public class AddNewAddressController extends HttpServlet {

    private DAAddress addressDA;
    private Address address;

    public void init() throws ServletException {
        addressDA = new DAAddress();
        address = new Address();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession httpSession = request.getSession();
        Customer c = (Customer) (httpSession.getAttribute("customer"));

        if (c == null) {
            response.sendRedirect("Customer_LoginPage_customerView.jsp");
        } else {
            String addressID = address.getAddressRows(c.getUserID());
            String fullName = request.getParameter("newaddress-fullname");
            String phoneNum = request.getParameter("newaddress-phonenumber");
            String states = request.getParameter("stateSelect");
            String area = request.getParameter("areaSelect");
            String poscode = request.getParameter("newaddress-poscode");
            String addressLine = request.getParameter("newaddress-addressline");
            String errorMessage = "You can only have a maximum of 3 address only!";

            try {
                if (addressID.equals(errorMessage)) {
                    out.println("<html>");
                    out.println("<style>");
                    out.println("body{background-color:lightgreen;}"
                            + "#infoLog{\n"
                            + "	background-color: #FF8F8F;\n"
                            + "    height:25px;\n"
                            + "}");
                    out.println("</style>");
                    out.println(" <body> <div id=\"infoLog\"> ERROR: " + errorMessage + "</div></body>");
                    out.println("</html>");

                    RequestDispatcher rd = request.getRequestDispatcher("Customer_ManageProfile_customerView.jsp");
                    rd.include(request, response);
                } else {
                    Address address = new Address(addressID, fullName, phoneNum, states, area, addressLine, poscode, c);
                    addressDA.addNewAddress(address);

                    String msg = "Successfully added new address!";
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
            } finally {
                out.close();
            }
        }
    }
}
