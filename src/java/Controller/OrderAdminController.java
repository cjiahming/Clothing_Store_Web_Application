/* 
   Document   : OrderAdminController
   Created on : April
   Author     : Jenny
   Purpose    : Inside this controller will incharge of admin order actions (Search orders,update order status) 
*/
package Controller;

import Model.DA.DAAddress;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.RequestDispatcher;
import java.sql.*;
import java.util.Date;
import java.util.ArrayList;
import java.time.LocalDate;

import Model.Domain.Payment;
import Model.Domain.Cart;
import Model.DA.DAOrder;
import Model.DA.DAPayment;
import Model.DA.DACart;
import Model.DA.DATracking;
import Model.Domain.Tracking;
import java.util.Map;

@WebServlet(name = "OrderAdminController", urlPatterns = {"/OrderAdminController"})
public class OrderAdminController extends HttpServlet {
    private Connection conn;
    private PreparedStatement stmt;
    private String host = "jdbc:derby://localhost:1527/fnfdb";
    private String user = "nbuser";
    private String password = "nbuser";

    private DAOrder daOrder;
    private DAPayment daPayment;
    private DATracking daTracking;

    //Initialize variables (init method is execute once the server starts,loads the driver and connects to the database)
    @Override
    public void init() throws ServletException {
        daOrder = new DAOrder();
        daPayment = new DAPayment();
        daTracking = new DATracking();
    }
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)throws ServletException, IOException{
        doPost(request,response);
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            //Used to display all the orders in the update page - update status page & tracking status page
            if (request.getParameter("displayAllOrdersUpdatePage") != null) {
                displayAllOrdersUpdatePage(request, response);
            }
            //Used when the admin clicked "reset" button , the system will display all the order details again
            if (request.getParameter("reset") != null) {
                resetSearch(request, response);
            }
            //Summary admin page - For admin to search the orders
            if (request.getParameter("searchOrdersAdmin") != null) {
                searchOrdersAdmin(request, response);
            }
            //Used for admin to search based on the order status "PACKAGING","SHIPPING","COMPLETED"
            if (request.getParameter("searchStatus") != null) {
                searchStatus(request, response);
            }
            //Used for admin to update the order status from "PACKAGING" to "SHIPPING"
            if (request.getParameter("updateShipping") != null) {
                updateOrderShipping(request, response);
                searchStatus(request, response);
            }
            //Used for admin to update the order status from "SHIPPING" to "COMPLETED"
            if (request.getParameter("updateComplete") != null) {
                updateOrderComplete(request, response);
                searchStatus(request, response);
            }

        } catch (SQLException ex) {
            printSQLException(ex, response);
        }
    }

    //Validate Admin Input Between Date
    private boolean validateDate(String dateFrom, String dateTo) {
        //If date from later than late to
        if ((LocalDate.parse(dateFrom).compareTo(LocalDate.parse(dateTo))) > 0) {
            return false;
        }
        //If the current date from > today date
        if (LocalDate.parse(dateFrom).compareTo(LocalDate.now()) > 0) {
            return false;
        }
        return true;
    }

    private void displayAllOrdersUpdatePage(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        HttpSession session = request.getSession();
        ArrayList<Map<String, ArrayList<Cart>>> orderDetails = new ArrayList<Map<String, ArrayList<Cart>>>();
        ArrayList<Payment> payments = new ArrayList<Payment>();
        //Pass to orderDA to retrieve records
        orderDetails = daOrder.searchStatus("PACKAGING");
        for (int i = 0; i < orderDetails.size(); i++) {
            for (String orderID : orderDetails.get(i).keySet()) {
                payments.add(daPayment.getPaymentRecord(orderID));
            }
        }
        //Redirect to Purchase page again to show after the filter
        session.setAttribute("payments", payments);
        session.setAttribute("orderDetails", orderDetails);
        response.sendRedirect("Sales_UpdateStatus-adminView.jsp");
    }

    private void resetSearch(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        HttpSession session = request.getSession();
        ArrayList<Map<String, ArrayList<Cart>>> orderDetails = daOrder.resetSearchAdmin();
        ArrayList<Payment> payments = new ArrayList<>();
        for (int i = 0; i < orderDetails.size(); i++) {
            for (String orderID : orderDetails.get(i).keySet()) {
                payments.add(daPayment.getPaymentRecord(orderID));
            }
        }
        session.setAttribute("payments", payments);
        session.setAttribute("orderDetails", orderDetails);
        response.sendRedirect("Sales_Summary-adminView.jsp");
    }

    private void searchOrdersAdmin(HttpServletRequest request, HttpServletResponse response) throws  SQLException, ServletException, IOException {
        HttpSession session = request.getSession();
        String searchBy = request.getParameter("cat");
        String inputValue = request.getParameter("searchInput");//Get the user search
        String dateFrom = request.getParameter("from");
        String dateTo = request.getParameter("to"); 
        String sortBy = request.getParameter("sortby");
        //If both from and to date is null then display all the records
        if (request.getParameter("from").isEmpty() && request.getParameter("to").isEmpty()) {
            dateFrom = null;
            dateTo = null;
        }
        //If to input date is null then display select the date after the from date
        else if (!request.getParameter("from").isEmpty() && request.getParameter("to").isEmpty()) {
            dateTo = null;
        }
        //If the input from date is input is null display the records before the date
        else if (request.getParameter("from").isEmpty() && !request.getParameter("to").isEmpty()) {
            dateFrom = null;
        }
        //If both from and to date is choosen then display records between the date
        else if (!request.getParameter("from").isEmpty() && !request.getParameter("to").isEmpty()) {
            boolean dateValidation = validateDate(dateFrom, dateTo);
            if (dateValidation == false) {
                //Set the error message request
                request.setAttribute("invalidDate", "Please choose the valid date range ");
                //forward request back to admin summary page
                RequestDispatcher rd = request.getRequestDispatcher("Sales_Summary-adminView.jsp");
                rd.forward(request, response);
            }
        }
        ArrayList<Map<String, ArrayList<Cart>>> orderDetails = daOrder.searchOrdersAdmin(inputValue, sortBy, dateFrom, dateTo,request.getParameter("status"));
        //If no order records found , go to no order record found page
        ArrayList<Payment> payments = new ArrayList<>();
        for (int i = 0; i < orderDetails.size(); i++) {
                for (String orderID : orderDetails.get(i).keySet()) {
                    payments.add(daPayment.getPaymentRecord(orderID));
                }
        }
        //Redirect to Purchase page again to show after the filter
        session.setAttribute("payments", payments);
        session.setAttribute("orderDetails", orderDetails);
        response.sendRedirect("Sales_Summary-adminView.jsp");
    }

    private void searchStatus(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException, ServletException {
        PrintWriter out=response.getWriter();
        HttpSession session=request.getSession();
        String id = request.getParameter("orderID");
        //Retrieve status selected - returns either PACKAGING,SHIPPING,COMPLETED
        String orderStatus = request.getParameter("status");
        ArrayList<Map<String, ArrayList<Cart>>> orderDetails = new ArrayList<Map<String, ArrayList<Cart>>>();
        ArrayList<Payment> payments = new ArrayList<Payment>();
        //If admin want to search based on the order id will display according based on the order id and order status
        if (!id.isEmpty()) {
            orderDetails = daOrder.searchIDStatus(id, orderStatus);
        }
        //Order ID is null will display ALL records based on the status
        else if (id.isEmpty()) {
            //Pass to orderDA to retrieve records
            orderDetails = daOrder.searchStatus(orderStatus);
        }
        for (int i = 0; i < orderDetails.size(); i++) {
            for (String orderID : orderDetails.get(i).keySet()) {
                payments.add(daPayment.getPaymentRecord(orderID));
            }
        }
        //Redirect to Purchase page again to show after the filter
        session.setAttribute("payments", payments);
        session.setAttribute("orderDetails", orderDetails);
        switch (orderStatus) {
            case "PACKAGING":
            case "COMPLETED":
                response.sendRedirect("Sales_UpdateStatus-adminView.jsp");
                break;
            case "SHIPPING":
                out.print("Hi");
                ArrayList<Tracking> trackings =new ArrayList<Tracking>();
                for (int i = 0; i < orderDetails.size(); i++) {
                    for (String orderID : orderDetails.get(i).keySet()) {
                        out.print(orderID);
                        trackings.add(daTracking.getTrackingRecord(orderID));
                    }
                }
                out.print(trackings.size());
                session.setAttribute("trackings", trackings);
                response.sendRedirect("Sales_TrackingStatus-adminView.jsp");
                break;
        }
    }

    private void updateOrderShipping(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        String orderID = request.getParameter("updateOrderID");
        daOrder.updateOrderStatus("SHIPPING", orderID);
    }

    private void updateOrderComplete(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        String orderID = request.getParameter("updateOrderID");
        daOrder.updateOrderStatus("COMPLETED", orderID);
    }

    private void printSQLException(SQLException ex, HttpServletResponse response) throws IOException {
        PrintWriter out = response.getWriter();
        StackTraceElement[] elements = ex.getStackTrace();
        out.println("SQL Error : " + ex);
        ex.printStackTrace();//Output stack trace
        out.println("Stack Trace       : " + ex.getStackTrace() + "<br>");
        out.println("Get error message : " + ex.getMessage() + "<br>");

        for (StackTraceElement e : elements) {
            out.println("File Name   : " + e.getFileName() + "<br>");
            out.println("Class Name  : " + e.getClassName() + "<br>");
            out.println("Method Name : " + e.getMethodName() + "<br>");
            out.println("Line Number : " + e.getLineNumber() + "<br><br>");
            out.print("--------------------------------\n");
        }

    }

}











