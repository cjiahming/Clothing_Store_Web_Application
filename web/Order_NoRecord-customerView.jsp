<%-- 
    Document   : OrderErrorPage
    Created on : Mar 20, 2022, 9:02:48 AM
    Author     : User
--%>
<%@page import="Model.Domain.Cart"%>
<%@page import="java.util.ArrayList"%>
<%@page import="Model.Domain.Customer"%>
<%
     response.setHeader("Cache-Control", "no-cache");
     response.setHeader("Cache-Control", "no-store");
     response.setHeader("Pragma", "no-cache");
     response.setDateHeader("Expires", 0);

     if (session.getAttribute("customer") == null) {
            response.sendRedirect("Customer_LoginPage_customerView.jsp");
      }
     
      Customer customer=(Customer)session.getAttribute("customer");
      ArrayList<Cart> carts=(ArrayList<Cart>)session.getAttribute("carts");
      
  
      session.setAttribute("carts",carts);
%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
     <!-- Plugins CSS File -->
     <link rel="stylesheet" href="assets/css/bootstrap.min.css">
     <!-- Main CSS File -->
     <link rel="stylesheet" href="assets/css/style.css">
        <title>JSP Page</title>
    </head>
    <body>
        <body>
         
    
    <main class="main">
        <div class="page-header text-center" style="background-image: url('assets/images/page-header-bg.jpg')">
            <div class="container">
                <h1 class="page-title">My Purchase<span>All orders records</span></h1>
            </div><!-- End .container -->
        </div><!-- End .page-header -->
      
    </div><!-- End .toolbox -->

<form method="post" action="Order_OrderHistory-customerView.jsp">
    <div class="header-center" style="padding-left:30%;padding-top:3%;">
        <div class="header-search header-search-extended header-search-visible header-search-no-radius d-none d-lg-block">
            <a href="#" class="search-toggle" role="button"><i class="icon-search"></i></a>
         
                <div class="header-search-wrapper search-wrapper-wide" >
                    <div class="select-custom">
                        <select id="cat" name="cat">
                            <option value="1" name="keywords">Related Keywords</option>
                            <option value="2" name="orderId">Order ID</option>
                            <option value="3" name="productName">Product Name</option>
                        </select>
                    </div><!-- End .select-custom -->
                    <label for="q" class="sr-only">Search</label>
                    <input type="search" class="form-control" name="searchInput" placeholder="Search by .. " >
                    <button class="btn btn-primary" type="submit" value="searchOrders" name="searchOrders"><i class="icon-search"></i></button>
                </div><!-- End .header-search-wrapper -->
        </div><!-- End .header-search -->
    </div>

    <div class="page-content" style="margin-top:-50px;">
        <div class="container-fluid">
            <div class="toolbox">
                <div class="toolbox-left">
                    <a href="Product_SelectCategory-customerView.jsp">Back To Product Page</a>
              
                </div><!-- End .toolbox-left -->
                <div class="toolbox-right">
                    <div class="toolbox-sort">
                        <label for="sortby">Sort by:</label>
                        <div class="select-custom">
                            <select name="sortby" id="sortby" class="form-control">
                                <option value="latest" selected="selected" name="latest" >Latest</option>
                                <option value="oldest"  name="oldest">Oldest</option>
                            </select>
                        </div>
                  
                    </div><!-- End .toolbox-sort -->
                </div><!-- End .toolbox-right -->
            </div><!-- End .toolbox -->
    </div><!-- End .page-content -->
    <div class="datebetween" style="padding-left:610px;padding-top:40px;">
    Between&nbsp;&nbsp;&nbsp;<input type="date" id="since" name="from" >&nbsp;&nbsp;&nbsp;
    and&nbsp;&nbsp;&nbsp;<input type="date" id="until" name="to">  
    <br><div class="errorDate"  style="padding-left:100px;padding-top:20px;color:red;font-style: italic;font-weight: bold;">${invalidDate}</div>
    </div>

    <br><div class="errorDate"  style="padding-left:100px;padding-top:20px;color:red;font-style: italic;font-weight: bold;">${searchMessage}</div>

    <div class="tab" style="margin-top: 5%;">
        <ul class="nav nav-pills nav-border-anim nav-big justify-content-center mb-3" role="tablist">
            <li class="nav-item">
                <button class="nav-link"  data-toggle="tab"  role="tab" aria-controls="products-featured-tab" aria-selected="true" style="padding-right:50px;" onclick="openStatus(event, 'all')">All Orders</a>
            </li>
            <li class="nav-item">
                <button class="nav-link"  data-toggle="tab" role="tab" aria-controls="products-sale-tab" aria-selected="false" style="padding-right:50px;" onclick="openStatus(event, 'packaging')">Packaging</a>
            </li>
            <li class="nav-item">
                <button class="nav-link" data-toggle="tab"  role="tab" aria-controls="products-top-tab" aria-selected="false" style="padding-right:50px;" onclick="openStatus(event, 'shipping')">Shipping</a>
            </li>
            <li class="nav-item">
                <button class="nav-link"  data-toggle="tab" role="tab" aria-controls="products-top-tab" aria-selected="false" style="padding-right:50px;" onclick="openStatus(event, 'cancelled')">Refunded</a>
            </li>
            <li class="nav-item">
                <button class="nav-link"  data-toggle="tab" role="tab" aria-controls="products-top-tab" aria-selected="false" style="padding-right:50px;" onclick="openStatus(event, 'completed')">Completed</a>
            </li>
        </ul>
    </div><!-- End .container -->
    </div>
</form>

<!--Only display this if no record found-->  
<div id="noRecord" >
<section>
    <div class="error-content text-center" 
    style="background-image: url(assets/images/backgrounds/error-bg.jpg)">
        <div class="container">
            <h1 class="error-title">No orders record found</h1><!-- End .error-title -->
            <p>We are sorry, the order record not found . Please ensure that your <strong>*ORDER ID/PRODUCT NAME/DATE*</strong> are input correctly</p>
           
        </div><!-- End .container -->
        <span class="circle big"></span>
        <span class="circle med"></span>
        <span class="circle small"></span>
</section>
</div>


</div>
</main><!-- End .main -->
</html>
