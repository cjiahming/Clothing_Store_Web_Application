<%-- 
   Document   : Order_OrderForm-customerView
   Created on : April
   Author     : Jenny
   Purpose    : This page will be displayed after the customer select the cart items to check out
--%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.util.*" %>
<%@page import="Model.DA.DAAddress" %>
<%@page import="Model.DA.DASKU" %>
<%@page import="Model.DA.DAProduct" %>
<%@page import="Model.Domain.Cart" %>
<%@page import="Model.Domain.SKU" %>
<%@page import="Model.Domain.Product" %>
<%@page import="Model.Domain.User" %>
<%@page import="Model.Domain.Address" %>
<%@page import="Model.Domain.Customer" %>
<%@page errorPage="Customer_LoginPage_customerView.jsp"%>
<%@page contentType="text/html" pageEncoding="UTF-8" %>

<%             
    response.setHeader("Cache-Control", "no-cache");
    response.setHeader("Cache-Control", "no-store");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    if (session.getAttribute("customer") == null) {
        response.sendRedirect("Customer_LoginPage_customerView.jsp");
    }
                                     
   Customer customer=(Customer)session.getAttribute("customer");
   ArrayList<Address> address =(ArrayList<Address>)session.getAttribute("deliveryAddress");
   ArrayList<Cart> carts=(ArrayList<Cart>)session.getAttribute("summariseCartItem");
   Map<String,Double>cartPrice=(Map<String,Double>)session.getAttribute("cartPrice");
   Double subtotal=(Double)session.getAttribute("subtotal");
   
   session.setAttribute("deliveryAddress", address);
   session.setAttribute("carts", carts);
   session.setAttribute("cartPrice",cartPrice);
   session.setAttribute("subtotal", subtotal); 
   
   %>
<!DOCTYPE html>
<html lang="en">
   <head>
      <meta charset="UTF-8">
      <meta http-equiv="X-UA-Compatible" content="IE=edge">
      <title>Order Page - Fash&Fashion</title>
      <!-- Plugins CSS File -->
      <link rel="stylesheet" href="assets/css/bootstrap.min.css">
      <!-- Main CSS File -->
      <link rel="stylesheet" href="assets/css/style.css">
   </head>
   <body>
      <!-- Order Details -->
      <div class="page-wrapper">
      <main class="main">
         <div class="page-header text-center"
            style="background-image: url('assets/images/page-header-bg.jpg')">
            <div class="container">
               <h1 class="page-title">Check Out<span></span></h1>
            </div>
            <!-- End .container -->
         </div>
         <!-- End .page-header -->
         <nav aria-label="breadcrumb" class="breadcrumb-nav">
            <div class="container">
               <ol class="breadcrumb">
                  <li class="breadcrumb-item"><a
                     href="Product_SelectCategory-customerView.jsp">Home</a></li>
                  <li class="breadcrumb-item"><a href="Product_SelectCategory-customerView.jsp">Shop</a></li>
                  <li class="breadcrumb-item active">Checkout</li>
               </ol>
            </div>
            <!-- End .container -->
         </nav>
         <!-- End .breadcrumb-nav -->
         <div class="page-content">
            <div class="checkout">
               <div class="container">
                  
                  <!-- End .checkout-discount -->
                  <script>
                     function checker(){
                     	var result=confirm('Are you confirm your order and proceed to payment ?');
                     	if(result==false){
                     		event.preventDefault();
                     	}
                     }
                  </script>Fast&Fashion
                  <form onsubmit="checker();" action="Payment_MakePurchase-customerView.jsp" method="post" >
                     <div class="row" style="margin-left: 8%;width: 120%;">
                        <div class="col-lg-9">
                           <h2 class="checkout-title">Billing Details</h2>
                           <!-- End .checkout-title -->
                           Customer : <span><%=customer.getUserID()%> (<%=customer.getUsername()%>)</span><br><br>
                           <div class="row">
                              <div class="col-sm-6">
                                 <label>Receiver Name </label>
                                 <input type="text" id="name"
                                    class="form-control"
                                    value=<%=address.get(0).getFullName()%> readonly>
                              </div>
                              <!-- End .col-sm-6 -->
                              <div class="col-sm-6">
                                 <label>Receiver Phone No</label>
                                 <input type="text" id="phone"
                                    class="form-control"
                                    value=<%=address.get(0).getAdrPhoneNum()%> readonly>
                              </div>
                              <!-- End .col-sm-6 -->
                           </div>
                           <!-- End .row -->
                           <br>
                           <div class="row">
                              <div class="col-sm-6">
                                 <label>Area</label>
                                 <input type="text"
                                    class="form-control" id="area"
                                    value=<%=address.get(0).getArea() %>
                                    readonly>
                              </div>
                              <!-- End .col-sm-6 -->
                              <div class="col-sm-6">
                                 <label>States </label>
                                 <input type="text"
                                    class="form-control" id="state"
                                    value=<%=address.get(0).getStates() %>
                                    readonly>
                              </div>
                              <!-- End .col-sm-6 -->
                           </div>
                           <!-- End .row -->
                           <br>
                           <div class="row">
                              <div class="col-sm-6">
                                 <label>Postcode / ZIP </label>
                                 <input type="text" id="postcode"
                                    class="form-control" value=<%=address.get(0).getPosCode()%>
                                    readonly>
                              </div>
                              <!-- End .col-sm-6 -->
                           </div>
                           <!-- End .row -->
                           <br>
                           <label>Email address</label>
                           <input type="email" class="form-control" id="email" value=<%=customer.getEmail()%> readonly>
                           <br>
                           <label>Delivery address</label><br><br><br>
                           <div class="delivery"
                              style="margin-top:-50px;">
                              <select name="addressSelected" id="addressSelected" class="form-control">
                                 <option value="1"><%=address.get(0).getAddressLine()%></option>
                                 <%
                                   if(!address.get(1).getAddressID().equals("")){
                                    %>    
                                 <option value="2"><%=address.get(1).getAddressLine()%></option>
                                 <% } %>
                                 <%
                                    if(!address.get(2).getAddressID().equals("")){
                                    %>    
                                 <option value="3"><%=address.get(2).getAddressLine()%></option>
                                 <% } %>
                              </select>
                           </div>
                              
                              <script type="text/javascript">
                              (function (){
                              	var dd = document.getElementById('addressSelected');
                              
                              //Get the text inputs into an array
                              var inputs = ['name','phone','area','state','postcode','email'].map(function(a){
                              return document.getElementById(a);
                              });

                              var addressSize=document.getElementById('addressSize');

                              //Use an object to map the select values to the input values based on the address selected  
                              var inputValues = {'1':['<%=address.get(0).getFullName()%>','<%=address.get(0).getAdrPhoneNum()%>','<%=address.get(0).getArea()%>','<%=address.get(0).getStates()%>','<%=address.get(0).getPosCode()%>','<%=customer.getEmail()%>'],
                                                 '2':['<%=address.get(1).getFullName()%>','<%=address.get(1).getAdrPhoneNum()%>','<%=address.get(1).getArea()%>','<%=address.get(1).getStates()%>','<%=address.get(1).getPosCode()%>','<%=address.get(1).getAddressLine()%>'],
                              				   '3':['<%=address.get(2).getFullName()%>','<%=address.get(2).getAdrPhoneNum()%>','<%=address.get(2).getArea()%>','<%=address.get(2).getStates()%>','<%=address.get(2).getPosCode()%>','<%=address.get(2).getAddressLine()%>']};
                              
                              //Bind the change event to the select 
                              dd.onchange=function(e){
                              
                              //Get the selected value of the drop down
                              var selectedValue = dd.children[dd.selectedIndex].value;
                              
                              //Change the values of the inputs
                              for(var i = 0,j=inputs.length;i < j;i++){
                              	inputs[parseInt(i,10)].value = inputValues[selectedValue][i];
                              }
                              };
                              })();
                              	
                           </script>
                        </div>
                        <!-- End .col-lg-9 -->
                     </div>
                     <!-- End .row -->
               </div>
               <!-- End .container -->
            </div>
            <!-- End .checkout -->
         </div>
         <!-- End .page-content -->
      </main>
      <!-- End .main -->
      <div class="below">
      <br><br>
      <div class="page-content">
      <div class="container">
      <table class="table table-wishlist table-mobile">
      <thead>
      <tr>
      <th>Product</th>    
      <th style="padding-left:15px;">Color</th>
      <th>Size</th>
      <th>Unit Price</th>
      <th>Quantity</th>
      <th>Order Total</th>
      </tr>
      </thead>
      <% for (int j=0; j < carts.size() ;j++) { %>
      <tbody>
      <tr>
      <td class="product-col">
      <div class="product">
      <figure class="product-media">    
          <a href="ProductController_Customer_Details?prodID=<%=carts.get(j).getSKU().getProduct().getProdID()%>">
             <img src="<%=carts.get(j).getSKU().getProduct().getProdImage()%>" alt="Product image" class="product-image"></a>
      </figure>
      <h3 class="product-title">
      <%=carts.get(j).getSKU().getProduct().getProdName()%></a>
      </h3><!-- End .product-title -->
      </div><!-- End .product -->
      </td>
      <td class="price-col" style="padding-left:10px;"><%=carts.get(j).getSKU().getColour()%></td>
      <td class="price-col"> <%=carts.get(j).getSKU().getProdSize()%> </td>
      <td class="price-col" >RM <%=String.format("%.2f", carts.get(j).getSKU().getProduct().getProdPrice())%></td>        
      <td class="price-col" style="padding-left:20px;"> <%=carts.get(j).getQty()%></td>
      <td class="price-col" style="padding-left:10px;">RM <%=String.format("%.2f", cartPrice.get(carts.get(j).getCartItemID())) %></td>  
      </td>
      </tr>
      </tbody>
      <% } %>
      </table><!-- End .table table-wishlist -->
      <label>Order Remark (optional)</label>
      <textarea class="form-control" cols="20"rows="2" name="orderRemark" placeholder="Leave a message to seller"></textarea>
      <!-- Order Checkout Progress -->
      <div class="order-checkout-process col-lg-4 col-md-6 col-12 mb-30" style="margin-left:58%;">
      <p><span>Merchandise Subtotal</span><span>RM <%=String.format("%.2f", subtotal)%></span></p>
      <p><span>Tax Fee</span><span>RM <%=String.format("%.2f", (subtotal*0.03))%></span></p>
      <p><span>Shipping Total</span><span>RM 0.00 (Free Shipping)</span></p>
      <h5><span>Total Payment</span><span>RM <%=String.format("%.2f", subtotal+(subtotal*0.03))%></span></h5>
      </div><!-- End .card -->
      <br>
      <input type="submit" value="Proceed To Payment" class="btn btn-outline-primary-2 btn-order btn-block" style="margin-left:830px;width:20%;">
      </div>
      <style>
      .order-checkout-process .title {
      font-size: 18px;
      font-weight: 700;
      margin-bottom: 20px;
      margin-top: 0;
      text-align: right; }
      .order-checkout-process p {
      margin-bottom: 15px;
      overflow: hidden;
      text-transform: uppercase;
      text-align: right; }
      .order-checkout-process p span {
      display: block;
      float: left;
      width: 42%; }
      .order-checkout-process p span:last-child {
      width: 58%; }
      .order-checkout-process h5 {
      font-size: 14px;
      font-weight: 700;
      line-height: 14px;
      overflow: hidden;
      text-transform: uppercase;
      text-align: right;
      margin: 0 0 30px; }
      .order-checkout-process h5 span {
      display: block;
      float: left;
      width: 42%; }
      .order-checkout-process h5 span:last-child {
      width: 58%; }
      </style>
      </div><!-- End .container -->
      </div><!-- End .page-content -->
      </form>	  
      </main><!-- End .main -->
      <button id="scroll-top" title="Back to Top"><i
         class="icon-arrow-up"></i></button>
      <!-- Plugins JS File -->
      <script src="assets/js/jquery.min.js"></script>
      <script src="assets/js/bootstrap.bundle.min.js"></script>
      <script src="assets/js/jquery.hoverIntent.min.js"></script>
      <script src="assets/js/jquery.waypoints.min.js"></script>
      <script src="assets/js/superfish.min.js"></script>
      <script src="assets/js/owl.carousel.min.js"></script>
      <!-- Main JS File -->
      <script src="assets/js/main.js"></script>
   </body>
</html>