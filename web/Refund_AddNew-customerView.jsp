<%-- 
    Document   : Refund_AddNew-customerView
    Created on : Mar 31, 2022, 1:11:40 PM
    Author     : Cheng Cai Yuan
--%>

<%@page import="Model.DA.DACart"%>
<%@page import="Model.DA.DAProduct"%>
<%@page import="Model.DA.DASKU"%>
<%@page import="Model.Domain.SKU"%>
<%@page import="Model.Domain.Product"%>
<%@page import="Model.Domain.Cart"%>
<%@page import="java.util.ArrayList"%>
<%@page import="Model.Domain.Customer"%>
<%@page import="Model.DA.DAOrder"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Model.Domain.Order" %>
<%@page import="Model.Domain.Refund" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Molla - Bootstrap eCommerce Template</title>
    <meta name="keywords" content="HTML5 Template">
    <meta name="description" content="Molla - Bootstrap eCommerce Template">
    <meta name="author" content="p-themes">
    <!-- Favicon -->
    <link rel="apple-touch-icon" sizes="180x180" href="assets/images/icons/apple-touch-icon.png">
    <link rel="icon" type="image/png" sizes="32x32" href="assets/images/icons/favicon-32x32.png">
    <link rel="icon" type="image/png" sizes="16x16" href="assets/images/icons/favicon-16x16.png">
    <link rel="manifest" href="assets/images/icons/site.html">
    <link rel="mask-icon" href="assets/images/icons/safari-pinned-tab.svg" color="#666666">
    <link rel="shortcut icon" href="assets/images/icons/favicon.ico">
    <meta name="apple-mobile-web-app-title" content="Molla">
    <meta name="application-name" content="Molla">
    <meta name="msapplication-TileColor" content="#cc9966">
    <meta name="msapplication-config" content="assets/images/icons/browserconfig.xml">
    <meta name="theme-color" content="#ffffff">
    <!-- Plugins CSS File -->
    <link rel="stylesheet" href="assets/css/bootstrap.min.css">
    <!-- Main CSS File -->
    <link rel="stylesheet" href="assets/css/style.css">
</head>

<body>
    
    
    <%
        response.setHeader("Cache-Control", "no-cache");
        response.setHeader("Cache-Control", "no-store");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        if (session.getAttribute("customer") == null) {
           response.sendRedirect("Customer_LoginPage_customerView.jsp");
        }
        DAOrder daOrder = new DAOrder();
        DACart daCart = new DACart();
        String orderID = "";
        orderID = request.getParameter("submit");
        if(orderID == null){
        orderID = (String)session.getAttribute("duplicateSubmitOrderID");
        }
        Customer customer = (Customer) (session.getAttribute("customer"));
 
        Order order = daOrder.getOrderRecord(orderID);
        ArrayList<Cart> cartList = new ArrayList<Cart>();
        cartList = daCart.getSpecificCartSameOrd(new Order(orderID), customer);
        session.setAttribute("refundCart",cartList);
        
%>
        <main class="main">
            <nav aria-label="breadcrumb" class="breadcrumb-nav border-0 mb-0">
                <div class="container">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="Product_SelectCategory-customerView.jsp">Home</a></li>
                        <li class="breadcrumb-item"><a href="Product_SelectCategory-customerView.jsp">My Account</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Refund</li>
                    </ol>
                </div><!-- End .container -->
            </nav><!-- End .breadcrumb-nav -->
            <div class="container">
	    <div class="page-header page-header-big text-center" style="background-image: url('assets/images/contact-header-bg.jpg')">
        	<h1 class="page-title text-white">Refund</h1>   
	    </div><!-- End .page-header -->
            </div><!-- End .container -->

            <div class="page-content pb-0">
                <div class="container">
                	<div class="row">
                            <div>
                                <!--Form that will collect & pass data-->
                                <form class="contact-form mb-3" method="post" action="RefundController">
                                    <h2 class="title mb-1">Refund Information</h2>
                			<p class="mb-3">About the refund,you are directly refund the whole order.You should apply refund within 2 weeks time after you make the payment for an order.
                                            After applying,you maybe wait for a few days to get the approval from seller.</p>

                                        <div class="col-sm-6">
                                            <!--Retrieve the order details for the selected order id-->
                                                Order ID           : <%=order.getOrderId() %> <br/><br/>
                                                Order Status       : <%=order.getOrderStatus() %> <br/><br/>
                                                Order Created Time : <%=order.getOrderCreatedTime() %> <br/><br/>
                                                Order Total        : RM<%=String.format("%.2f",order.getSubtotal(order.getOrderId())) %> <br/><br/>
                                                Your Order :<br/>
                                                
                                                <table style="width:100%; background-color:light-red;float:left;margin-bottom: 25px;">
                                                    <tr>
                                                        <th style="text-align: center;" align="center">Product</th>
                                                        <th style="text-align: center;" align="center">Size</th>
                                                        <th style="text-align: center;" align="center">Colour</th>
                                                        <th style="text-align: center;" align="center">Quantity</th>
                                                    </tr>
                                                    <% 
                                                        DASKU daSku = new DASKU();
                                                        DAProduct daProd = new DAProduct();
                                                                      
                                                        for(int i = 0; i < cartList.size(); i++){
                                                            SKU sku = daSku.getSKU(cartList.get(i).getSKU().getSkuNo());
                                                            Product product = daProd.getRecord(sku.getProduct().getProdID()); 
                                                            
                                                    %>
                                                    <tr>
                                                        <td align="center"><%= product.getProdID() %></td>
                                                        <td align="center"><%= sku.getProdSize() %></td>
                                                        <td align="center"><%= sku.getColour() %></td>
                                                        <td align="center"><%= cartList.get(i).getQty() %></td>
                                                    </tr>
                                                    <% } %>
                                                   
                                                    
                                                </table>
                                                
                                            <p>Reason</p>
                				<div class="row">
                                                    <div>
                                                        <input type="radio" id="reason" name="reason" value="Select wrong product">
                                                        <label for="reason">Select wrong product</label><br>
                                                        <input type="radio" id="reason" name="reason" value="Duplicate select on the same product">
                                                        <label for="reason">Duplicate select on the same product</label><br>
                                                        <input type="radio" id="reason" name="reason" value="Don't want this product anymore">
                                                        <label for="reason">Don't want this product anymore</label><br>
                                                        <input type="radio" id="reason" name="reason" value="Package is overweight">
                                                        <label for="reason">Package is overweight</label><br>
                                                        <input type="radio" id="reason" name="reason" value="Size does not match product description">
                                                        <label for="reason">Size does not match product description</label><br>
                                                        <input type="radio" id="reason" name="reason" value="Material fabric does not match the product description">
                                                        <label for="reason">Material fabric does not match the product description</label><br>
                                                        <input type="radio" id="reason" name="reason" value="Color style does not match the product description">
                                                        <label for="reason">Color style does not match the product description</label><br>
                                                        <input type="radio" id="reason" name="reason" value="Quality issues">
                                                        <label for="reason">Quality issues</label><br>
                                                        <input type="radio" id="reason" name="reason" value="Product received was few or damaged">
                                                        <label for="reason">Product received was few or damaged</label><br>
                                                        <input type="radio" id="reason" name="reason" value="Others">
                                                        <label for="reason">Others</label><br><br>
                                                    </div>
                				</div><!-- End .row -->

                                                <label for="remark">Remark (optional)</label>
                				<textarea class="form-control" cols="30" rows="4" id="remark" name="remark" placeholder="Leave a message to seller"></textarea>
                                                <!--submit button that will call the action to add the record-->
                				<button type="submit" class="btn btn-outline-primary-2 btn-minwidth-sm" name="action" value="add">
                                                    <span>SUBMIT</span>
                                                    <i class="icon-long-arrow-right"></i>
                				</button>
                		        </div><!-- End .col-lg-6 -->
                                </form><!-- End .contact-form -->
                            </div>
                	<hr class="mt-4 mb-5">
                        </div><!-- End .row -->
                </div><!-- End .container -->
            </div><!-- End .page-content -->
        </main><!-- End .main -->

    <!--button to back to the top of the page-->
    <button id="scroll-top" title="Back to Top"><i class="icon-arrow-up"></i></button>

 
    <script src="assets/js/jquery.min.js"></script>
    <script src="assets/js/bootstrap.bundle.min.js"></script>
    <script src="assets/js/jquery.hoverIntent.min.js"></script>
    <script src="assets/js/jquery.waypoints.min.js"></script>
    <script src="assets/js/superfish.min.js"></script>
    <script src="assets/js/owl.carousel.min.js"></script>
    <script src="assets/js/main.js"></script>
</body>
</html>
