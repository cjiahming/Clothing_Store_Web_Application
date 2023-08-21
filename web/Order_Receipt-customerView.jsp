<%-- 
   Document   : Order_Receipt-customerView
   Created on : April
   Author     : Jenny
   Purpose    : This page will be displayed after the customer confirmed their orders and made the payment 
--%>
<%@page import="java.util.Map"%>
<%@page import="Model.Domain.Customer"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Model.Domain.Order" %>
<%@page import="Model.Domain.Payment" %>
<%@page import="Model.Domain.Address" %>
<%@page import="Model.Domain.Cart"%>
<%@page errorPage="Customer_LoginPage_customerView.jsp"%>
<!-- Plugins CSS File -->
<link rel="stylesheet" href="assets/css/bootstrap.min.css">
<!-- Main CSS File -->
<link rel="stylesheet" href="assets/css/style.css">
<%
     response.setHeader("Cache-Control", "no-cache");
     response.setHeader("Cache-Control", "no-store");
     response.setHeader("Pragma", "no-cache");
     response.setDateHeader("Expires", 0);

     if (session.getAttribute("customer") == null) {
        response.sendRedirect("Customer_LoginPage_customerView.jsp");
     }
     
   Order order=(Order)session.getAttribute("order");
   Payment payment=(Payment)session.getAttribute("payment");
   Address address=(Address)session.getAttribute("deliveryAddress");
   ArrayList<Cart> carts=(ArrayList<Cart>)session.getAttribute("carts");
   Customer customer=(Customer)session.getAttribute("customer");
   Map<String,Double>cartPrice=(Map<String,Double>)session.getAttribute("cartPrice");
   session.setAttribute("customer",customer);
   %>
<!DOCTYPE html>
<html>
   <head>
      <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
      <link rel="stylesheet" href="OrderReceiptStyle.css" />
      <!-- Plugins CSS File -->
      <link rel="stylesheet" href="assets/css/bootstrap.min.css">
      <!-- Main CSS File -->
      <link rel="stylesheet" href="assets/css/style.css">
      <title>Order Receipt - Fash&Fashion</title>
   </head>
   <body>
      <div class="page-header text-center" style="background-image: url('assets/images/page-header-bg.jpg')">
         <div class="container">
            <h1 class="page-title">Order Receipt<span>Thanks For Supporting Us !</span></h1>
         </div>
         <!-- End .container -->
      </div>
      <!-- End .page-header -->
      <br><br>
      <div class="container">
      <div class="info" style="padding-left:100px;">
         <span class="d-block name">Hi <%=customer.getUsername()%>, </span><br>
         <h8>This is the receipt for the Order ID : <%=order.getOrderId()%> </h8>
         <br>
         <div class="detail"style="padding-left:38px;padding-top:5%;">
            <img src="https://i.imgur.com/NiAVkEw.png" width="40"  />
            <span class="d-block summery" style="padding-bottom: 35px;"><br>We are preparing your order. Please kindly waiting for our update. Once the packaging is completed , the Tracking ID will be generated.</span>
         </div>
         <div class="card-body">
            <article class="card">
               <div class="card-body row">
                  <div class="col" style="padding-top:20px;"> <strong>Receiver Name :</strong><br><%=address.getFullName()%></div>
                  <div class="col" style="padding-top:20px;"> <strong>Email : </strong><br><%=customer.getEmail()%><br></div>
                  <div class="col" style="padding-top:20px;"> <strong>Order Status :</strong> <br><%=order.getOrderStatus()%></div>
                  <div class="col" style="padding-top:20px;"> <strong>Delivery Address :</strong> <br><%=address.getAddressLine()%></div>
               </div>
            </article>
         </div>
         <div class="reply">
            <div class="heading">
               <span style="font-size: 17px;"><strong>&nbsp;&nbsp;&nbsp;Your Order Details</strong></span>
            </div>
            <!-- End .heading -->
            <form action="Product_SelectCategory-customerView.jsp" method="post">
               <table class="table table-summary" style="width: 90%;margin-left: 5%;padding-top: 5%;font-size: 13px;">
                  <thead >
                     <tr>
                        <th style="font-size: 14px;"><strong>Product</strong></th>
                        <th style="font-size: 14px;"><strong>Total</strong></th>
                     </tr>
                  </thead>
                  <% for (int j=0; j < carts.size() ;j++) { %>
                  <tbody >
                     <tr>
                        <td>
                           <%=carts.get(j).getSKU().getProduct().getProdName()%> *<%=carts.get(j).getQty()%> (<%=carts.get(j).getSKU().getColour()%>)
                        </td>
                        <td>RM <%=String.format("%.2f", cartPrice.get(carts.get(j).getCartItemID())) %></td>
                     </tr>
                     <% } %>		  
                     <tr class="summary-subtotal" >
                        <td style="font-size: 13px;">Subtotal </td>
                        <td>RM <%=String.format("%.2f", order.getSubtotal(order.getOrderId()))%></td>
                     </tr>
                     <tr>
                        <td>Tax Fee</td>
                        <td>RM <%=String.format("%.2f",order.getSubtotal(order.getOrderId())*0.03) %></td>
                     </tr>
                     <tr>
                        <td>Shipping:</td>
                        <td>Free shipping</td>
                     </tr>
                     <tr class="summary-total">
                       <strong><td style="font-size: 15px;font-weight: bold;">Total Payment</td></strong>
                       <strong><td style="font-size: 15px;font-weight: bold;">RM <%=String.format("%.2f", order.getTotalPayment(order.getOrderId())) %></td></strong>
                     </tr>
                     <!-- End .summary-total -->
                  </tbody>
               </table>
               <br>
               <span><strong>&nbsp;&nbsp;&nbsp;Extra Notes</strong></span><br>
               <textarea disabled class="form-control" cols="20"rows="2" ><%=order.getOrderRemark()%></textarea>
                     <input type="submit" value="Back To HomePage" class="btn btn-outline-primary-2 btn-order btn-block" style="margin-left:800px;width:20%;">
            </form>
         </div>
         <!-- End .reply -->
      </div>
   </body>
</html>