<%-- 
   Document   : Order_OrderHistory-customerView
   Created on : April
   Author     : Jenny
   Purpose    : This page is used to display customer order history
--%>
<%@page import="Model.Domain.Tracking"%>
<%@page import="Model.DA.DAProduct"%>
<%@page import="Model.DA.DASKU"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Model.Domain.Cart" %>
<%@page import="Model.Domain.Order" %>
<%@page import="Model.Domain.Product" %>
<%@page import="Model.Domain.Customer" %>
<%@page import="Model.Domain.Address" %>
<%@page import="Model.Domain.SKU" %>
<%@page import="Model.DA.DAOrder" %>


        
<%
     response.setHeader("Cache-Control", "no-cache");
     response.setHeader("Cache-Control", "no-store");
     response.setHeader("Pragma", "no-cache");
     response.setDateHeader("Expires", 0);

      if (session.getAttribute("customer") == null) {
            response.sendRedirect("Customer_LoginPage_customerView.jsp");
      }
      
      
      ArrayList<Cart> carts=(ArrayList<Cart>)session.getAttribute("carts");
      ArrayList<Tracking> trackings = (ArrayList<Tracking>)session.getAttribute("trackings");
      
      
      session.setAttribute("trackings",trackings);
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>My Purchase History - Fast&Fashion </title>
    <!-- Plugins CSS File -->
    <link rel="stylesheet" href="assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="assets/css/plugins/owl-carousel/owl.carousel.css">
    <script src='https://kit.fontawesome.com/a076d05399.js' crossorigin='anonymous'></script>
    <!-- Main CSS File -->
    <link rel="stylesheet" href="assets/css/style.css">
    </head>
    <body>
        <main class="main">
        	<div class="page-header text-center" style="background-image: url('assets/images/page-header-bg.jpg')">
        		<div class="container">
        			<h1 class="page-title">My Purchase<span>All orders records</span></h1>
        		</div><!-- End .container -->
        	</div><!-- End .page-header -->
          
        </div><!-- End .toolbox -->
    
    <form method="post" action="OrderCustomerController">
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
        <div class="datebetween" style="padding-left:530px;padding-top:40px;border:#F5F5F5;">
        Between&nbsp;&nbsp;&nbsp;<input type="date" id="since" name="from" >&nbsp;&nbsp;&nbsp;
        and&nbsp;&nbsp;&nbsp;<input type="date" id="until" name="to">  
        <br><div class="errorDate"  style="padding-left:100px;padding-top:20px;color:red;font-style: italic;font-weight: bold;">${invalidDate}</div>
        </div>

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
        
    <form method="#" >
    <div id="all" class="tabcontent">
    <% for (int j=0; j < carts.size() ;j++) {  
    %>  
    
                <div class="page-content" style="padding-left: 25%">
                    <div class="container">
                <div class="row">
                    <div class="col-lg-9">
                <div class="toolbox">
                    <div class="toolbox-left">
                        <div class="toolbox-info">
                <div class="product product-list">
                    <div class="row">
                        <div class="col-6 col-lg-3">
                            <figure class="product-media">
                                <a href="ProductController_Customer_Details?prodID=<%=carts.get(j).getSKU().getProduct().getProdID()%>">
                <img src="<%=carts.get(j).getSKU().getProduct().getProdImage()%>" alt="Product image" class="product-image"></a>
                          
                            </figure><!-- End .product-media -->
                        </div><!-- End .col-sm-6 col-lg-3 -->
                        <div class="col-6 col-lg-3 order-lg-last">
                            <div class="product-list-action">
                                <span style="font-size: 15px;">RM <%=String.format("%.2f",carts.get(j).getSKU().getProduct().getProdPrice())%> </span> 
                                <br>
                                <br><br>
                                <strong><span style="font-size: 15px">Order Total</span></strong><div class="product-price" style="padding-top: 10px;">RM <%=String.format("%.2f",carts.get(j).getOrder().getCartPrice(carts.get(j).getCartItemID()))%></div>
                                <br>
                                <div class="col-6 col-lg-4 col-xl-2" style="margin-left:-30px;width: 5%;">      
                                </div><!-- End .col-md-4 col-lg-2 -->
                            </div><!-- End .product-list-action -->
                        </div><!-- End .col-sm-6 col-lg-3 -->

                        <div class="col-lg-6">
                            <div class="product-body product-action-inner">
                                <h3 class="product-title"><a href="ProductController_Customer_Details?prodID=<%=carts.get(j).getSKU().getProduct().getProdID()%>" style="color:#B8860B;font-weight: bold;"><%=carts.get(j).getSKU().getProduct().getProdName()%></a></h3>
                                <!-- End .product-title -->
                                <div class="product-cat" style="padding-top: 15px;">
                                    Variation [ Qty : <%=carts.get(j).getQty()%> , Color : <%=carts.get(j).getSKU().getColour()%> , Category : <%=carts.get(j).getSKU().getProduct().getProdCategory() %> ]
                                </div><!-- End .product-cat -->
                                <br>
                                <div class="product-content">
                                    <p>Product description : <%=carts.get(j).getSKU().getProduct().getProdDesc()%> </p>
                                </div><!-- End .product-content -->
                                <div class="product-action" style="font-size: 11px;color:#CD853F;">
                                    <span style="color:#8B4513;">Order Status</span> : <span style="color:#8B4513;"><%=carts.get(j).getOrder().getOrderStatus()%></span><br> &nbsp;&nbsp;&nbsp;      
                                    <span style="color:#8B4513;">Order ID </span> : <span style="color:#8B4513;;"><%=carts.get(j).getOrder().getOrderId() %></span>  
                                </div>
                                 <div class="product-action" style="font-size: 11px;color:#CD853F;">
                                  <span style="font-size: 10px;color:#8B4513;"><%=carts.get(j).getOrder().getOrderCreatedTime()%></span><br>
                                </div>
                                                               
                              <div style="color:red; background-color: transparent;">${errorMessage}</div>
                            </div><!-- End .product-body -->
                        </div><!-- End .col-lg-6 -->
                    </div><!-- End .row -->
                </div><!-- End .product -->
            </div><!-- End .products -->
            </div>
        </div>
    </div>
    </div>
    </div>
    </div>
    <% } %>
    </div>
    </form>
    
    <div id="packaging" class="tabcontent">
        <% for (int j=0; j < carts.size() ;j++) {
             if(carts.get(j).getOrder().getOrderStatus().equals("PACKAGING")){ 
        %>    
                    <div class="page-content" style="padding-left: 25%">
                        <div class="container">
                    <div class="row">
                        <div class="col-lg-9">
                    <div class="toolbox">
                        <div class="toolbox-left">
                            <div class="toolbox-info">

                    <div class="product product-list">
                        <div class="row">
                            <div class="col-6 col-lg-3">
                                <figure class="product-media">
                                    <a href="ProductController_Customer_Details?prodID=<%=carts.get(j).getSKU().getProduct().getProdID()%>">
                                        <img src="<%=carts.get(j).getSKU().getProduct().getProdImage()%>" alt="Product image" class="product-image"></a>
                                 
                                </figure><!-- End .product-media -->
                            </div><!-- End .col-sm-6 col-lg-3 -->
                            <div class="col-6 col-lg-3 order-lg-last">
                                <div class="product-list-action">
                                    <span style="font-size: 15px;">RM <%=String.format("%.2f",carts.get(j).getSKU().getProduct().getProdPrice())%> </span> 
                                    <br>
                                    <br><br>
                                    <strong><span style="font-size: 15px">Order Total</span></strong><div class="product-price" style="padding-top: 10px;">RM <%=String.format("%.2f",carts.get(j).getOrder().getCartPrice(carts.get(j).getCartItemID()))%></div>
                                    <br>
                                </div><!-- End .product-list-action -->
                            </div><!-- End .col-sm-6 col-lg-3 -->
    
                            <div class="col-lg-6">
                                <div class="product-body product-action-inner">
                                      <h3 class="product-title"><a href="ProductController_Customer_Details?prodID=<%=carts.get(j).getSKU().getProduct().getProdID()%>" style="color:#B8860B;font-weight: bold;"><%=carts.get(j).getSKU().getProduct().getProdName()%></a></h3>
                                    <div class="product-cat" style="padding-top: 15px;">
                                        <a href="#">Variation [ Qty : <%=carts.get(j).getQty()%> , Color : <%=carts.get(j).getSKU().getColour()%> , Category : <%=carts.get(j).getSKU().getProduct().getProdCategory() %> ]</a>
                                    </div><!-- End .product-cat -->
                                    <br>
                                    <div class="product-content">
                                        <p>Product description : <%=carts.get(j).getSKU().getProduct().getProdDesc()%> </p>
                                    </div><!-- End .product-content -->
                                    <div class="product-action" style="font-size: 11px;">
                                        <span style="font-size: 10px;color:#CD853F;">Order ID </span> : <span style="color:#CD853F;"><%=carts.get(j).getOrder().getOrderId() %></span>
                                        <span style="font-size: 10px;padding-left:20px;color:#CD853F;"><%=carts.get(j).getOrder().getOrderCreatedTime()%></span><br>
                                    </div><!-- End .product-action --> 
                                </div><!-- End .product-body -->
                            </div><!-- End .col-lg-6 -->
                        </div><!-- End .row -->
                    </div><!-- End .product -->
                </div><!-- End .products -->
                </div>
            </div>
        </div>
        </div>
        </div>
        </div>
        <% } }%>
    </div>

   <div id="shipping" class="tabcontent">
            <% for (int j=0; j < carts.size() ;j++) {
                 if(carts.get(j).getOrder().getOrderStatus().equals("SHIPPING")){ 
            %>    
                        <div class="page-content" style="padding-left: 25%">
                            <div class="container">
                        <div class="row">
                            <div class="col-lg-9">
                        <div class="toolbox">
                            <div class="toolbox-left">
                                <div class="toolbox-info">
    
                        <div class="product product-list">
                            <div class="row">
                                <div class="col-6 col-lg-3">
                                    <figure class="product-media">
                                        <a href="ProductController_Customer_Details?prodID=<%=carts.get(j).getSKU().getProduct().getProdID()%>">
                                            <img src="<%=carts.get(j).getSKU().getProduct().getProdImage()%>" alt="Product image" class="product-image"></a>
                                      
                                    </figure><!-- End .product-media -->
                                </div><!-- End .col-sm-6 col-lg-3 -->
                                <div class="col-6 col-lg-3 order-lg-last">
                                    <div class="product-list-action">
                                        <span style="font-size: 15px;">RM <%=String.format("%.2f",carts.get(j).getSKU().getProduct().getProdPrice())%> </span> 
                                        <br>
                                        <br><br>
                                        <strong><span style="font-size: 15px">Order Total</span></strong><div class="product-price" style="padding-top: 10px;">RM <%=String.format("%.2f",carts.get(j).getOrder().getCartPrice(carts.get(j).getCartItemID()))%></div>
                                        <br>
                                    </div><!-- End .product-list-action -->
                                </div><!-- End .col-sm-6 col-lg-3 -->
        
                                <div class="col-lg-6">
                                    <div class="product-body product-action-inner">
                                       <h3 class="product-title"><a href="ProductController_Customer_Details?prodID=<%=carts.get(j).getSKU().getProduct().getProdID()%>" style="color:#B8860B;font-weight: bold;"><%=carts.get(j).getSKU().getProduct().getProdName()%></a></h3>
                                        <div class="product-cat" style="padding-top: 15px;">
                                           Variation [ Qty : <%=carts.get(j).getQty()%> , Color : <%=carts.get(j).getSKU().getColour()%> , Category : <%=carts.get(j).getSKU().getProduct().getProdCategory() %> ]
                                        </div><!-- End .product-cat -->
                                        <br>
                                        <div class="product-content">
                                            <p>Product description : <%=carts.get(j).getSKU().getProduct().getProdDesc()%> </p>
                                        </div><!-- End .product-content -->
                                            <div class="product-action" style="font-size: 11px;">
                                             <span style="color:#8B4513;">Order ID </span> : <span style="color:#8B4513;"><%=carts.get(j).getOrder().getOrderId() %></span>
                                             <span style="padding-left:20px;color:#8B4513;"><%=carts.get(j).getOrder().getOrderCreatedTime()%></span><br>
                                             </div><!-- End .product-action --> 
                                        <div class="product-action" style="font-size: 11px;">
                                            <span style="color:#8B4513;">Tracking ID </span> : <span style="color:#8B4513;"><%=trackings.get(j).getTrackingId() %></span> 
                                        </div><!-- End .product-action --> 
                                    </div><!-- End .product-body -->
                                </div><!-- End .col-lg-6 -->
                            </div><!-- End .row -->
                        </div><!-- End .product -->
                    </div><!-- End .products -->
                    </div>
                </div>
            </div>
            </div>
            </div>
            </div>
            <% } }%>
    </div>

    <div id="cancelled" class="tabcontent">
        <% for (int j=0; j < carts.size() ;j++) {
             if(carts.get(j).getOrder().getOrderStatus().equals("REFUNDED")){ 
        %>    
                    <div class="page-content" style="padding-left: 25%">
                        <div class="container">
                    <div class="row">
                        <div class="col-lg-9">
                    <div class="toolbox">
                        <div class="toolbox-left">
                            <div class="toolbox-info">

                    <div class="product product-list">
                        <div class="row">
                            <div class="col-6 col-lg-3">
                                <figure class="product-media">
                                    <a href="ProductController_Customer_Details?prodID=<%=carts.get(j).getSKU().getProduct().getProdID()%>">
                                        <img src="<%=carts.get(j).getSKU().getProduct().getProdImage()%>" alt="Product image" class="product-image"></a>
                                  
                                </figure><!-- End .product-media -->
                            </div><!-- End .col-sm-6 col-lg-3 -->
                            <div class="col-6 col-lg-3 order-lg-last">
                                <div class="product-list-action">
                                    <span style="font-size: 15px;">RM <%=String.format("%.2f",carts.get(j).getSKU().getProduct().getProdPrice())%> </span> 
                                    <br>
                                    <br><br>
                                    <strong><span style="font-size: 15px">Order Total</span></strong><div class="product-price" style="padding-top: 10px;">RM <%=String.format("%.2f",carts.get(j).getOrder().getCartPrice(carts.get(j).getCartItemID()))%></div>
                                    <br>
                                    
                                </div><!-- End .product-list-action -->
                            </div><!-- End .col-sm-6 col-lg-3 -->
    
                            <div class="col-lg-6">
                                <div class="product-body product-action-inner">
                                   <h3 class="product-title"><a href="ProductController_Customer_Details?prodID=<%=carts.get(j).getSKU().getProduct().getProdID()%>" style="color:#B8860B;font-weight: bold;"><%=carts.get(j).getSKU().getProduct().getProdName()%></a></h3>
                                    <div class="product-cat" style="padding-top: 15px;">
                                       Variation [ Qty : <%=carts.get(j).getQty()%> , Color : <%=carts.get(j).getSKU().getColour()%> , Category : <%=carts.get(j).getSKU().getProduct().getProdCategory() %> ]
                                    </div><!-- End .product-cat -->
                                    <br>
                                    <div class="product-content">
                                        <p>Product description : <%=carts.get(j).getSKU().getProduct().getProdDesc()%> </p>
                                    </div><!-- End .product-content -->
                                    <div class="product-action" style="font-size: 11px;">
                                        <span>Order ID </span> : <span><%=carts.get(j).getOrder().getOrderId() %></span>                                     
                                    </div><!-- End .product-action --> 
                                    
                                </div><!-- End .product-body -->
                            </div><!-- End .col-lg-6 -->
                        </div><!-- End .row -->
                    </div><!-- End .product -->
                </div><!-- End .products -->
                </div>
            </div>
        </div>
        </div>
        </div>
        </div>
        <% } }%>
</div>

<div id="completed" class="tabcontent">
    <% for (int j=0; j < carts.size() ;j++) {
         if(carts.get(j).getOrder().getOrderStatus().equals("COMPLETED")){ 
    %>    
                <div class="page-content" style="padding-left: 25%">
                    <div class="container">
                <div class="row">
                    <div class="col-lg-9">
                <div class="toolbox">
                    <div class="toolbox-left">
                        <div class="toolbox-info">

                <div class="product product-list">
                    <div class="row">
                        <div class="col-6 col-lg-3">
                            <figure class="product-media">
                                <a href="ProductController_Customer_Details?prodID=<%=carts.get(j).getSKU().getProduct().getProdID()%>">
                                    <img src="<%=carts.get(j).getSKU().getProduct().getProdImage()%>" alt="Product image" class="product-image">
                                </a>
                          
                            </figure><!-- End .product-media -->
                        </div><!-- End .col-sm-6 col-lg-3 -->
                        <div class="col-6 col-lg-3 order-lg-last">
                            <div class="product-list-action">
                                <span style="font-size: 15px;">RM <%=String.format("%.2f",carts.get(j).getSKU().getProduct().getProdPrice())%> </span> 
                                <br>
                                <br><br>
                                <strong><span style="font-size: 15px">Order Total</span></strong><div class="product-price" style="padding-top: 10px;">RM <%=String.format("%.2f",carts.get(j).getOrder().getCartPrice(carts.get(j).getCartItemID()))%></div>
                                <br>
                            </div><!-- End .product-list-action -->
                        </div><!-- End .col-sm-6 col-lg-3 -->

                        <div class="col-lg-6">
                            <div class="product-body product-action-inner">
                               <h3 class="product-title"><a href="ProductController_Customer_Details?prodID=<%=carts.get(j).getSKU().getProduct().getProdID()%>" style="color:#B8860B;font-weight: bold;"><%=carts.get(j).getSKU().getProduct().getProdName()%></a></h3>
                                <div class="product-cat" style="padding-top: 15px;">
                                  Variation [ Qty : <%=carts.get(j).getQty()%> , Color : <%=carts.get(j).getSKU().getColour()%> , Category : <%=carts.get(j).getSKU().getProduct().getProdCategory() %> ]
                                </div><!-- End .product-cat -->
                                <br>
                                <div class="product-content">
                                    <p>Product description : <%=carts.get(j).getSKU().getProduct().getProdDesc()%> </p>
                                </div><!-- End .product-content -->
                                <div class="product-action" style="font-size: 11px;">
                                      <span style="font-size: 10px;color:#CD853F;">Order ID </span> : <span style="color:#CD853F;"><%=carts.get(j).getOrder().getOrderId() %></span>
                                      <span style="font-size: 10px;padding-left:20px;color:#CD853F;"><%=carts.get(j).getOrder().getOrderCreatedTime()%></span><br>                                   
                                </div><!-- End .product-action --> 
                            </div><!-- End .product-body -->
                        </div><!-- End .col-lg-6 -->
                    </div><!-- End .row -->
                </div><!-- End .product -->
            </div><!-- End .products -->
            </div>
        </div>
    </div>
    </div>
    </div>
    </div>
    <% } }%>
</div>



</div>
</main><!-- End .main -->


 <!-- Plugins JS File -->
 <script src="assets/js/jquery.min.js"></script>
 <script src="assets/js/bootstrap.bundle.min.js"></script>
 <script src="assets/js/jquery.hoverIntent.min.js"></script>
 <script src="assets/js/jquery.waypoints.min.js"></script>
 <script src="assets/js/superfish.min.js"></script>
 <script src="assets/js/owl.carousel.min.js"></script>
 <script src="assets/js/bootstrap-input-spinner.js"></script>
 <script src="assets/js/jquery.plugin.min.js"></script>
 <script src="assets/js/jquery.magnific-popup.min.js"></script>
 <script src="assets/js/jquery.countdown.min.js"></script>

            <!-- Main JS File -->
    <script src="assets/js/main.js"></script>
    <script src="assets/js/demos/demo-3.js"></script>
    </body>
</html>

<script>
  function openStatus(evt, statusName) {
  // Declare all variables
  var i, tabcontent, tablinks;

  // Get all elements with class="tabcontent" and hide them
  tabcontent = document.getElementsByClassName("tabcontent");
  for (i = 0; i < tabcontent.length; i++) {
    tabcontent[i].style.display = "none";
  }

  // Get all elements with class="tablinks" and remove the class "active"
  tablinks = document.getElementsByClassName("tablinks");
  for (i = 0; i < tablinks.length; i++) {
    tablinks[i].className = tablinks[i].className.replace(" active", "");
  }

  // Show the current tab, and add an "active" class to the button that opened the tab
  document.getElementById(statusName).style.display = "block";
  evt.currentTarget.className += " active";

}
</script>

<style>
/* Style the tab */
.tab {
  overflow: hidden;
}

/* Style the buttons that are used to open the tab content */
.tab button {
  background-color: inherit;
  float: left;
  border: none;
  outline: none;
  cursor: pointer;
  padding: 14px 16px;
  transition: 0.3s;
}

/* Style the tab content */
.tabcontent {
  display: none;
  padding: 6px 12px;
  border-top: none;
}

</style>

