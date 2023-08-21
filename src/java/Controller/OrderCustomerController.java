/* 
   Document   : OrderCustomerController
   Created on : April
   Author     : Jenny
   Purpose    : Inside this controller will incharge of customer order actions
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

import Model.Domain.Order;
import Model.Domain.Payment;
import Model.Domain.Address;
import Model.Domain.Cart;
import Model.Domain.Customer;
import Model.Domain.Tracking;
import Model.DA.DAOrder;
import Model.DA.DAPayment;
import Model.DA.DACart;
import Model.DA.DAProduct;
import Model.DA.DASKU;
import Model.DA.DATracking;
import Model.Domain.SKU;

import java.text.DecimalFormat;
import java.util.Map;

@WebServlet(name = "OrderCustomerController", urlPatterns = {"/OrderCustomerController"})
public class OrderCustomerController extends HttpServlet {
    private Connection conn;
    private PreparedStatement stmt;
    private String host = "jdbc:derby://localhost:1527/fnfdb";
    private String user = "nbuser";
    private String password = "nbuser";

    private DAOrder daOrder;
    private DAPayment daPayment;
    private DACart daCart;
    private DASKU daSKU;
    private DAProduct daProduct;
    private DATracking daTracking;

    //Initialize variables (init method is execute once the server starts,loads the driver and connects to the database)
    @Override
    public void init() throws ServletException {
        daOrder = new DAOrder();
        daPayment = new DAPayment();
        daCart = new DACart();
        daSKU=new DASKU();
        daProduct=new DAProduct();
        daTracking=new DATracking();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        try{
            out.println("THIS CONTROLLERE");
            checkOut(request, response);
            calculatePayment(request, response);
            response.sendRedirect("Order_OrderForm-customerView.jsp");
        }catch (SQLException ex) {
            printSQLException(ex, response);
        }     
    }
    
    
    
    
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        try {
            //After cart will comes inside this checkOut method to proceed to order form page
            if (request.getParameter("checkOut") != null) {
                checkOut(request, response);
                calculatePayment(request, response);
                response.sendRedirect("Order_OrderForm-customerView.jsp");
            }

            //After customer confirmed their payment will go to order receipt page
            if (request.getParameter("confirmPayment") != null) {
                newOrder(request, response);//Only after payment will create a new order
                response.sendRedirect("Order_Receipt-customerView.jsp");
            }

            //This method used to display customer order history page
            if (request.getParameter("orderHistory") != null) {
                orderHistory(request, response);
                response.sendRedirect("Order_OrderHistory-customerView.jsp");
            }
            
            //This is used to let customer to search their orders
            if (request.getParameter("searchOrders") != null) {
                searchOrders(request, response);
            }
        } catch (SQLException ex) {
            printSQLException(ex, response);
        }
    }

    //Display orders and delivery address
    private void checkOut(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        HttpSession session = request.getSession();
        DAAddress addressDA = new DAAddress();
        Customer customer = (Customer) session.getAttribute("customer");
        ArrayList<Address> address = addressDA.displayAllAddressRecords(customer.getUserID());
        ArrayList<Address> deliveryAddress = new ArrayList<Address>();
        Address address1;
        Address address2;
        Address address3;
        ArrayList<Cart> carts = (ArrayList<Cart>) session.getAttribute("summarisecartItem");
        ArrayList<Cart> cartItems = new ArrayList<Cart>();
        int i = 0;
        for (Cart c : carts) {
            //Only retrieve those records with null order
            if (c.getOrder().getOrderId() == null) {
                carts.get(i).setSKU(daSKU.getSKU(c.getSKU().getSkuNo()));
                carts.get(i).getSKU().setProduct(daProduct.getRecord(c.getSKU().getProduct().getProdID()));
                cartItems.add(c);
            }
            i++;
        }
        //If the user don't have the delivery address details will go to the address form
        if (address.size() == 0) {
            response.sendRedirect("Customer_ManageProfile_customerView.jsp");
        } else {
            if (address.size() > 0) {
                address1 = address.get(0);
            } else {
                address1 = new Address("", "", "", "", "", "", "", customer);
            }
            if (address.size() > 1) {
                address2 = address.get(1);
            } else {
                address2 = new Address("", "", "", "", "", "", "", customer);
            }
            if (address.size() > 2) {
                address3 = address.get(2);
            } else {
                address3 = new Address("", "", "", "", "", "", "", customer);
            }
            //Add delivery address
            deliveryAddress.add(address1);
            deliveryAddress.add(address2);
            deliveryAddress.add(address3);
            //Set attribute in session
            session.setAttribute("summariseCartItem", cartItems);
            session.setAttribute("customer", customer);
            session.setAttribute("deliveryAddress", deliveryAddress);
        }
    }

    //Calculate cart payment
    private void calculatePayment(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        HttpSession session = request.getSession();
        ArrayList<Cart> carts = (ArrayList<Cart>) session.getAttribute("summarisecartItem");
        //Use map to store items -Each cart id(key) is associated with a list of price (value) which is the customer bought
        Map<String, Double> cartPrice = daOrder.calculatePayment(carts);
        Double subtotal = 0.0;
        //Calculate total carts items price
        for (Double price : cartPrice.values()) {
            subtotal += price;//Calculate subtotal price
        }
        //Set attribute in session
        session.setAttribute("cartPrice", cartPrice);
        session.setAttribute("subtotal", Double.valueOf(String.format("%.2f",subtotal)));
    }

    //After payment create a new order
    private void newOrder(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        PrintWriter out = response.getWriter();
        HttpSession session = request.getSession();
        Order order = new Order();
        Date date = new Date();
        //Get address object from session
        Address delivery = (Address) session.getAttribute("deliveryAddress");
    
        //Obtain Payment Method
        String paymentMethod = request.getParameter("paymentMethod");
        //Obtain remark from the order form
        String orderRemark = request.getParameter("orderRemark");
        if (orderRemark == null || orderRemark.isEmpty()) {
            orderRemark = "-";//Set remark to "-" if the remark is null or blank
        }
        //Obtain Payment Amount
        Double subtotal = (Double) session.getAttribute("subtotal");
        //subtotal *= 0.03;
        subtotal = subtotal * 0.03 + subtotal;
        order = new Order(order.generateOrderId(), "PACKAGING", new Timestamp(date.getTime()), orderRemark, (Address) session.getAttribute("deliveryAddress"));
        //--Insert New Order--
        Order newOrder = daOrder.insertOrderRecord(order);
        if (newOrder == null) {
            out.println("Order cannot be created");
        } else {
            out.println("Order ID : " + order.getOrderId() + " has been successfully created by " + order.getOrderCreatedTime());
            //--Insert Payment--
            Payment payment = new Payment();
            payment.setPaymentMethod(request.getParameter("paymentMethod"));
            System.out.println("SUBTOTALLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL"+subtotal);
            payment = new Payment( payment.generatePaymentId(), paymentMethod, Double.parseDouble((String.format("%.2f", subtotal))), new Timestamp(date.getTime()), order);
            daPayment.insertPaymentRecord(payment);
            //Set order to cart
            ArrayList<Cart> carts = (ArrayList<Cart>) session.getAttribute("carts");
            for (Cart c : carts) {
                c.setOrder(order);
                //Update SKU qty
                SKU localSKU = daSKU.getSKU(c.getSKU().getSkuNo());
                localSKU.setSkuQty(localSKU.getSkuQty() - c.getQty());
                daSKU.updateSKU(localSKU);
                
                //Update cart order in database
                daCart.UpdateRecord(c);
            }
            //Store payment and order object into the session
            session.setAttribute("order", order);
            session.setAttribute("payment", payment);
            session.setAttribute("deliveryAddress", delivery);
            session.setAttribute("carts", carts);
            session.setAttribute("customer", session.getAttribute("customer"));
        }
    }

    //Display customer order history records
    private void orderHistory(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        HttpSession session = request.getSession();
        Customer customer = (Customer) session.getAttribute("customer");
        ArrayList<Cart> carts = (ArrayList<Cart>) session.getAttribute("carts");
        ArrayList<Cart> cartItems = new ArrayList<Cart>();
        ArrayList<Tracking> trackings = new ArrayList<Tracking>();
        for (Cart c : carts) {
            //Only retrieve those records with exist order id
            if (c.getOrder().getOrderId() != null) {
                c.setSKU(daSKU.getSKU(c.getSKU().getSkuNo()));
                c.getSKU().setProduct(daProduct.getRecord(c.getSKU().getProduct().getProdID()));
                c.setOrder(daOrder.getOrderRecord(c.getOrder().getOrderId()));
                trackings.add(daTracking.getTrackingRecord(c.getOrder().getOrderId()));
                cartItems.add(c);
            }
        }
        //Set session attribute
        session.setAttribute("trackings", trackings);
        session.setAttribute("customer", customer);
        session.setAttribute("carts", cartItems);//Only pass the cart items with order id
    }
    
    //Validate customer search within date (NOT ALLOWED IF INVALID WITHIN DATE)
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

    //Display order records based on customer search items - Order ID, Product Name , Keywords
    private void searchOrders(HttpServletRequest request, HttpServletResponse response) throws IOException, SQLException, ServletException {
        HttpSession session = request.getSession();
        Customer customer = (Customer) session.getAttribute("customer");
        ArrayList<Cart> carts = (ArrayList<Cart>) session.getAttribute("carts");
        String searchBy = request.getParameter("cat");
        String inputValue = request.getParameter("searchInput");//Get the user search
        String dateFrom = request.getParameter("from");
        String dateTo = request.getParameter("to");
        int searchByField;
        searchByField = searchBy.equals("1") ? 1 : searchBy.equals("2") ? 2 : 3;
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
                request.setAttribute("carts", carts);
                //forward request back to order hisotry page
                RequestDispatcher rd = request.getRequestDispatcher("Order_OrderHistory-customerView.jsp");
                rd.forward(request, response);
            }
        }
        ArrayList<Cart> orderCarts = daOrder.searchOrders(searchByField, inputValue, sortBy, dateFrom, dateTo, customer.getUserID());
        //If no order records found , go to no order record found page
        if (orderCarts.size() == 0) {
            session.setAttribute("carts", carts);
            session.setAttribute("customer", customer);
            response.sendRedirect("Order_NoRecord-customerView.jsp");
        } else {
            ArrayList<Tracking> trackings = new ArrayList<Tracking>();
            ArrayList<Cart> cartItems = new ArrayList<Cart>();
            for (Cart c : orderCarts) {
            //Only retrieve those records with exist order id
            if (c.getOrder().getOrderId() != null) {
                c.setSKU(daSKU.getSKU(c.getSKU().getSkuNo()));
                c.getSKU().setProduct(daProduct.getRecord(c.getSKU().getProduct().getProdID()));
                c.setOrder(daOrder.getOrderRecord(c.getOrder().getOrderId()));
                trackings.add(daTracking.getTrackingRecord(c.getOrder().getOrderId()));
                cartItems.add(c);
               }
            }
            //Redirect to Purchase page again to show after the filter
            session.setAttribute("trackings", trackings);
            session.setAttribute("carts", cartItems);
            session.setAttribute("customer", customer);  
            response.sendRedirect("Order_OrderHistory-customerView.jsp");
        }
    }

    //Error display message
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









