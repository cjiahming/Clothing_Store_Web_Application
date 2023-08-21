<%-- 
    Document   : Sales_UpdateStatus-adminView.jsp
    Created on : April
    Author     : Jenny
    Purpose    : This page used for update ORDER STATUS
--%>
<%@ page errorPage="404Error.jsp" %>  
<%@page import="Model.Domain.Admin"%>
<%
    Admin admin = (Admin) session.getAttribute("admin");
    if(admin.getUserGroup().getAccessRights().charAt(6)=='0'){ 
%>  <jsp:forward page="401Error.jsp" /> <%}%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Model.DA.DAPayment"%>
<%@page import="Model.Domain.Payment"%>
<%@page import="java.util.Map"%>
<%@page import="Model.Domain.Cart"%>
<%@page import="java.util.ArrayList"%>
<%@page import="Model.DA.DAOrder"%>
<%@page import="Model.DA.DAPayment"%>
<%@page import="Model.Domain.Order"%>
<%
    ArrayList<Map<String, ArrayList<Cart>>> orderDetails = null;
    ArrayList<Payment> payments = null;

    if ((ArrayList<Payment>) session.getAttribute("payments") != null) {
        payments = (ArrayList<Payment>) session.getAttribute("payments");
    }

    if ((ArrayList<Map<String, ArrayList<Cart>>>) session.getAttribute("orderDetails") != null) {
        orderDetails = (ArrayList<Map<String, ArrayList<Cart>>>) session.getAttribute("orderDetails");
    }

%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
        <link rel="shortcut icon" type="image/x-icon" href="assets/siteIcon.png" />
        <link rel="stylesheet" href="css/styles.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
        <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/js/all.min.js" crossorigin="anonymous"></script>
        <script src="components/topNavBar.js" type="text/javascript" defer></script>
        <script src="components/middleNavBar.js" type="text/javascript" defer></script>
        <script src="components/footer.js" type="text/javascript" defer></script>
        <script src="components/Sales_header.js" type="text/javascript" defer></script>
        <title>Update Sales Status - Fast&Fashion</title>
    </head>
    <body>
        <nav class="sb-topnav navbar navbar-expand navbar-dark bg-dark">
            <header-component></header-component>
        </nav>
        <div id="layoutSidenav">
            <div id="layoutSidenav_nav">
                <nav class="sb-sidenav accordion sb-sidenav-dark" id="sidenavAccordion">
                    <div class="sb-sidenav-menu">
                        <middle-component></middle-component>
                    </div>
                    <div class="sb-sidenav-footer">
                        <!--pass in logged in user details-->
                        <div class="small">Logged in as:</div>
                        <%= admin.getUsername()%>
                        <a href="LogoutConfirmation.html"><i class="fas fa-sign-out-alt" id="sideBarIcon" style="float:right;margin-right:10px;"></i></a>
                    </div>
                </nav>
            </div>
            <div id="layoutSidenav_content">
                <!-------------------------------------------------------->
                <main>
                    <!--Content Page-->
                    <div class="container-fluid px-4">
                        <!--Page Title-->
                        <h1 class="mt-4">
                            <sales-header></sales-header>
                        </h1>
                        <div class="card mb-4" id="innerPart">
                            <div class="card-header">
                                <i class="fa fa-info-circle" class="sb-nav-link-icon" style="font-size:28px; color: #353535;"></i>
                                <!--Table Title, action perform ?-->
                                Overview | Update Sales Status   
                                <!--Action link to search record, link back to summary page-->
                                <a href="Sales_UpdateStatus-adminView.jsp" title="Summary"><i class="fa fa-filter" id="tableHeader-link-icon" ></i></a>
                            </div>
                            <div class="card-body">
                                <form action="OrderAdminController" method="post" id="updateShipping">
                                    <table id="table-skuEnquiry">
                                        <tr>
                                            <td>
                                                <label for="lname">Order ID </label><br/>
                                                <input type="text" id="orderID" name="orderID" placeholder="Order ID">
                                            </td>
                                            <td>
                                                <label for="status">Status</label> <br/>
                                                <select id="status" name="status">
                                                    <option value="PACKAGING" name="PACKAGING">Packaging</option>
                                                    <option value="SHIPPING" name="SHIPPING">Shipping</option>
                                                    <option value="COMPLETED" name="COMPLETED">Completed</option>
                                                </select>
                                            </td>
                                    </table><br/>
                                    <button id="action-button" type="submit" name="searchStatus" style="margin-top: 5px;height: 40px;width: 40px;font-size: 18px;margin-right: 25px;"><i class="fa fa-search"></i></button><br/><br/><br/>
                                    <div style="overflow-x:auto;">
                                    <table id="accessRightLists" style="white-space: nowrap;" style="margin-left:15px;" >
                                        <!--Data Fields-->
                                        <thead id="view-thead">
                                            <tr>
                                                <th style="padding-right: 100px;">Order ID</th>
                                                <th style="padding-right: 400px;">Product(s)</th>
                                                <th style="padding-right: 80px;">Variation</th>
                                                <th style="padding-right: 80px;">Order Status</th>
                                                <th >Order Remark</th>
                                                <th style="padding-right: 60px;">Total Price</th>
                                                <th style="padding-right: 30px;">Update Status</th>
                                            </tr>
                                        </thead>
                                        <!--Table Records--> 
                                        <%  if (orderDetails != null) {
                                                for (int i = 0; i < orderDetails.size(); i++) {
                                                    for (String orderID : orderDetails.get(i).keySet()) {
                                                        ArrayList<Cart> sameCart = orderDetails.get(i).get(orderID);
                                                        int j = 0;
                                                        Payment payment = payments.get(i);
                                                        for (Cart cart : sameCart) {

                                        %>
                                        <tbody>
                                            <tr>
                                                <td style="padding-bottom:25px;">
                                                    <% if (j == 0) {%>
                                                    <span style="font-size:15px;font-weight: bold"><%=orderID%></span> <br>
                                                    <span style="font-size:13px;"> Buyer name : <%=sameCart.get(0).getCustomer().getUsername()%> </span>
                                                    <% }%>
                                                </td>
                                                <td style="padding-bottom:25px;">
                                                    <span style="font-size:14px;font-weight: bold;"><%=cart.getSKU().getProduct().getProdName()%></span> <span style="font-size:12px;font-weight: normal;">   x<%=cart.getQty()%></span>
                                                </td>
                                                <td style="padding-bottom:25px;">
                                                    <span style="font-size:14px;font-weight: bold;"><%=cart.getSKU().getColour()%>  ,<%=cart.getSKU().getProdSize()%> size</span> 
                                                </td>
                                                <td style="padding-bottom:25px;">
                                                    <span style="font-size:14px;color:blue;font-weight: bold;"><%=cart.getOrder().getOrderStatus()%></span> <br>
                                                    <span style="font-size:13px;"><%=cart.getOrder().getOrderCreatedTime()%></span>
                                                </td>
                                                <td style="padding-bottom:25px;padding-right: 30px;">
                                                    <span style="font-size:13px;font-weight: bold;"><%=cart.getOrder().getOrderRemark()%></span>  
                                                </td>
                                                <td style="padding-bottom:25px;">
                                                    <% if (j == 0) {%>
                                                    <span style="font-size:14px;font-weight: bold;">RM<%=payment.getPaymentAmount()%></span>  <br>
                                                    <span style="font-size:13px;font-weight: normal;"><%=payment.getPaymentMethod()%></span>
                                                    <% } %>
                                                </td>
                                                <% if (cart.getOrder().getOrderStatus().equals("PACKAGING") && j == 0) {%>
                                                <td style="padding-bottom:25px;" >
                                                    <input type="hidden" value="<%=orderID%>" name="updateOrderID">
                                                    <button class="ship"  name="updateShipping" style=" background-color: white;color: black;border: 2px solid #e7e7e7;">To Ship</button>
                                                    <style>.ship:hover {background-color: #e7e7e7;}</style>
                                                </td>
                                                <% } %>
                                                <% if (cart.getOrder().getOrderStatus().equals("COMPLETED")) { %>
                                                <td style="padding-bottom:25px;" > 
                                                    <span style="padding-left: 20px;font-size:12px;font-weight: bold;">DONE</span>
                                                </td>
                                                <% } %>
                                            </tr>
                                            <%  j++;
                                     } %>
                                        </tbody>
                                        <% }
                                      }
                                  }%>
                                    </table>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </main>
                <!--footer-->
                <footer class="py-4 bg-light mt-auto">
                    <footer-component></footer-component>
                </footer>
            </div>
        </div>
        <script>
            document.querySelector('#ship').addEventListener('click', () => {
                Confirm.open({
                    title: 'Update Order Status to "SHIPPING"',
                    message: 'Are you confirm to update the order status ?',
                    onok: () => {
                        // Submit the form using javascript
                        var form = document.getElementById("updateShipping");
                        form.submit();
                    }
                })
            });
        </script>
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
    <script src="js/scripts.js"></script>
    <script src="js/confirm.js"></script>
</body>
</html>