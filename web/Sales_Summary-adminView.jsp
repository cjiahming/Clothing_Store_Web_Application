<%-- 
   Document   : Sales_Summary-adminView
   Created on : April
   Author     : Jenny
   Purpose    : This page mainly used for display all order details together with the extra filter function
--%>
<%@ page errorPage="404Error.jsp" %>  
<%@page import="Model.Domain.Admin"%>
<%
    Admin admin = (Admin) session.getAttribute("admin");
    if(admin.getUserGroup().getAccessRights().charAt(5)=='0'){ 
%>  <jsp:forward page="401Error.jsp" /> <%}%>
<%@page import="Controller.OrderAdminController"%>
<%@page import="Model.DA.DAPayment"%>
<%@page import="Model.Domain.Payment"%>
<%@page import="java.util.Map"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Model.Domain.Cart"%>
<%@page import="java.util.ArrayList"%>
<%@page import="Model.DA.DAOrder"%>
<%@page import="Model.DA.DAPayment"%>
<%@page import="Model.Domain.Order"%>
<jsp:include page="/OrderAdminController"/>
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
        <title>Sales Order Summary - Fast&Fashion</title>
        <style>
            #tableWithNoAction{
                background-color: #F1EBDE;
            }
        </style>
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
                <form action="OrderAdminController" method="post">
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
                                Summary   
                                <!--Action link to search record, link back to summary page-->
                                <a href="OrderAdminController?reset=yes" title="Summary"><i class="fa fa-filter" id="tableHeader-link-icon" ></i></a>
                            </div>
                            <div class="card-body">
                                <table id="table-skuEnquiry">
                                    <tr>
                                        <td colspan="3" style="text-align: center; vertical-align: middle;padding-left: 0px;">
                                            <label for="country" >Date between &nbsp;&nbsp;&nbsp;</label>
                                            <input type="date" id="since" name="from" style="width: 25%;"> &nbsp;&nbsp;&nbsp; And &nbsp;&nbsp;&nbsp;
                                            <input type="date" id="until" name="to" style="width:25%;">
                                            <div class="errorDate"  style="padding-left:100px;padding-top:20px;color:red;font-style: italic;font-weight: bold;">${invalidDate}</div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><label for="country">Search By</label>
                                            <input type="text" name="searchInput" placeholder="Input Order ID/Product Name" >
                                        </td>
                                        <td>

                                            <label for="country" >Sort By</label>
                                            <select id="sortby" name="sortby" >
                                                <option value="latest">Latest</option>
                                                <option value="oldest">Oldest</option>
                                            </select> 
                                        </td>
                                        <td>
                                            <label for="status" >Order Status</label>
                                            <select id="staus" name="status" >
                                                <option value="PACKAGING">Packaging</option>
                                                <option value="SHIPPING">Shipping</option>
                                                <option value="COMPLETED">Completed</option>
                                            </select>
                                        </td>
                                    </tr> 
                                </table><br/>
                                <button id="action-button" type="submit" name="searchOrdersAdmin" style="margin-top: 8px;height: 40px;width: 40px;font-size: 18px;margin-right: 20px;"><i class="fa fa-search"></i></button><br/><br/><br/>
                                </form>
                                <!-- HTML !-->
                                <style>
                                    .button-1 {
                                        background-color: initial;
                                        background-image: linear-gradient(-180deg, #FF7E31, #E62C03);
                                        border-radius: 6px;
                                        box-shadow: rgba(0, 0, 0, 0.1) 0 2px 4px;
                                        color: #FFFFFF;
                                        cursor: pointer;
                                        display: inline-block;
                                        font-family: Inter,-apple-system,system-ui,Roboto,"Helvetica Neue",Arial,sans-serif;
                                        height: 40px;
                                        line-height: 40px;
                                        outline: 0;
                                        overflow: hidden;
                                        padding: 0 20px;
                                        pointer-events: auto;
                                        position: relative;
                                        text-align: center;
                                        touch-action: manipulation;
                                        user-select: none;
                                        -webkit-user-select: none;
                                        vertical-align: top;
                                        white-space: nowrap;
                                        width: 100%;
                                        z-index: 9;
                                        border: 0;
                                        transition: box-shadow .2s;
                                        margin-left: 87%;
                                        margin-top:-3%;
                                        width:10%;
                                    }
                                    .button-1:hover {
                                        box-shadow: rgba(253, 76, 0, 0.5) 0 3px 8px;
                                    }
                                </style>
                                <table>
                                    <thead id="tableWithNoAction" >
                                        <tr>
                                            <th style="padding-right:80px;">Order ID</th>
                                            <!--<th style="margin-right: 15px;">Customer Name</th>-->
                                            <th style="padding-right:300px">Product(s)</th>
                                            <th style="padding-right: 75px;">Variation</th>        
                                            <th style="padding-right:30px;">Order Status</th>
                                            <th style="padding-right:10px;">Order Remark</th>  
                                            <th style="padding-right:10px;">Total Price</th>
                                            <th style="padding-right:20px;">Check Details</th> 
                                        </tr>  
                                    </thead>
                                </table>
                                <table id="datatablesSimple" >
                                    <!--Data Fields-->
                                    <thead id="view-thead">
                                    </thead>
                                    <tbody><!--Table Records--> 
                                        <%  if (orderDetails != null) {
                                                for (int i = 0; i < orderDetails.size(); i++) {
                                                    for (String orderID : orderDetails.get(i).keySet()) {
                                                        ArrayList<Cart> sameCart = orderDetails.get(i).get(orderID); %>

                                        <%      int j = 0;
                                            Payment payment = payments.get(i);
                                            for (Cart cart : sameCart) {
                                        %>
                                        <tr>
                                            <td style="padding-bottom:25px;">
                                                <% if (j == 0) {%>
                                                <span style="font-size:15px;font-weight: bold"><%=orderID%></span> <br>
                                                <span style="font-size:13px;"> Buyer name : <%=sameCart.get(0).getCustomer().getUsername()%> </span>
                                                <% }%>
                                            </td>
                                            <td style="padding-bottom:25px; ">
                                                <span style="font-size:14px;font-weight: bold;"><%=cart.getSKU().getProduct().getProdName()%></span> <span style="font-size:12px;font-weight: normal;">   x<%=cart.getQty()%></span>
                                            </td>
                                            <td style="padding-bottom:25px;">
                                                <span style="font-size:14px;font-weight: bold;"><%=cart.getSKU().getColour()%>  ,<%=cart.getSKU().getProdSize()%> size</span> 
                                            </td> 
                                            <td style="padding-bottom:25px;">
                                                <span style="font-size:14px;color:blue;font-weight: bold;"><%=cart.getOrder().getOrderStatus()%></span> <br>
                                                <span style="font-size:13px;"><%=cart.getOrder().getOrderCreatedTime()%></span>
                                            </td> 
                                            <td style="padding-bottom:25px;">
                                                <span style="font-size:13px;font-weight: bold;"><%=cart.getOrder().getOrderRemark()%></span>  
                                            </td>
                                            <td style="padding-bottom:25px;">
                                                <% if (j == 0) {%>
                                                <span style="font-size:14px;font-weight: bold;">RM<%=payment.getPaymentAmount()%></span>  <br>
                                                <span style="font-size:13px;font-weight: normal;"><%=payment.getPaymentMethod()%></span>
                                                <% } %>
                                            </td>
                                            <td style="padding-bottom:25px;" > 
                                                <a href="" title="View" style="padding-left:30px;"><i class="fas fa-book" id="tableBody-link-icon"></i></a>
                                            </td>   
                                        </tr>
                                        <%  j++;
                                            } %>

                                        <% }
                                                }
                                            }%>
                                    </tbody>
                                </table>
                                </form>
                            </div>
                        </div>
                    </div>
                </form>
                <!--footer-->
                <footer class="py-4 bg-light mt-auto">
                    <footer-component></footer-component>
                </footer>
            </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
        <script src="js/scripts.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/simple-datatables@latest" crossorigin="anonymous"></script>
        <script src="js/datatables-simple-demo.js"></script>

    </body>
</html>