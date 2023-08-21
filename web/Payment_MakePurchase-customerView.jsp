<%-- 
   Document   : Payment_MakePurchase-customerView
   Created on : April
   Author     : Jenny
   Purpose    : This page will be displayed after the customer confirm the orders
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
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
                response.setHeader("Cache-Control", "no-cache");
                response.setHeader("Cache-Control", "no-store");
                response.setHeader("Pragma", "no-cache");
                response.setDateHeader("Expires", 0);

                if (session.getAttribute("customer") == null) {
                       response.sendRedirect("Customer_LoginPage_customerView.jsp");
                   }
          
             String selected=(String)request.getParameter("addressSelected");
             ArrayList<Address> address=(ArrayList<Address>)session.getAttribute("deliveryAddress");
             Address delivery;
             //If delivery address selected is 1 then take the address details , if 2nd selected then takes then 2nd address details 
             delivery=selected.equals("1")?address.get(0):selected.equals("2")?address.get(1):address.get(2);
      
            Customer customer=(Customer)session.getAttribute("customer");
            ArrayList<Cart> carts=(ArrayList<Cart>)session.getAttribute("carts");
            Map<String,Double>cartPrice=(Map<String,Double>)session.getAttribute("cartPrice");
            Double subtotal=(Double)session.getAttribute("subtotal");
            session.setAttribute("deliveryAddress", delivery);
            session.setAttribute("carts", carts);
            session.setAttribute("cartPrice",cartPrice);
            session.setAttribute("subtotal", subtotal);
            
 %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Payment - Fash&Fashion</title>
        <meta name="theme-color" content="#ffffff">
        <!-- Plugins CSS File -->
        <link rel="stylesheet" href="assets/css/bootstrap.min.css">
        <link rel="stylesheet" href="assets/css/plugins/owl-carousel/owl.carousel.css">
        <!-- Main CSS File -->
        <link rel="stylesheet" href="assets/css/style.css">
    </head>
    <body>
        
        <input type="hidden" value="<%=(String)request.getParameter("orderRemark")%>" >
        <div class="container">
            <div class="page-header page-header-big text-center" style="background-image: url('assets/images/about-header-bg.jpg')">
                <h1 class="page-title text-white">Thank You For Shopping With Us<span class="text-white">Please kindly proceed your payment now</span></h1>
            </div><!-- End .page-header -->
        </div><!-- End .container -->

    
        <form action="OrderCustomerController" id="form" method="post" onsubmit="checker();" >
         <div class="page-content pb-0">
                <div class="container">
                    <div class="row">
                        <div class="col-lg-6 mb-3 mb-lg-0">
                            <h2 class="title">Orders</h2><!-- End .title -->
                            <br>
                            <table class="table table-summary">
                                <thead>
                                    <tr>
                                        <th>Product</th>
                                        <th>Total</th>
                                    </tr>
                                </thead>
                                
                                <% for (int j=0; j < carts.size() ;j++) { %>
                                <tbody>
                                    <tr>
                                        <td>
                                              <%=carts.get(j).getSKU().getProduct().getProdName()%> *<%=carts.get(j).getQty()%> (<%=carts.get(j).getSKU().getColour()%>)
                                        </td>
                                        <td>RM <%=String.format("%.2f", cartPrice.get(carts.get(j).getCartItemID())) %></td>
                                    </tr>
                                      <% } %>
                                      
                                    <tr class="summary-subtotal" >
                                        <td>Subtotal:</td>
                                        <td>RM <%=String.format("%.2f", subtotal)%></td>
                                    </tr>
                                  
                                    <tr>
                                        <td>Tax Fee</td>
                                        <td>RM <%=String.format("%.2f", (subtotal*0.03))%></td>
                                    </tr>
                                    <tr>
                                        <td>Shipping:</td>
                                        <td>Free shipping</td>
                                    </tr>
                                    <tr class="summary-total">
                                        <td>Total Payment</td>
                                        <td>RM <%=String.format("%.2f", subtotal+(subtotal*0.03))%></td>
                                    </tr><!-- End .summary-total -->
                                </tbody>
                             
                            </table>
                        </div><!-- End .col-lg-6 -->
                        
                        <div class="col-lg-6"  style="padding-left: 10%;">
                            <h2 class="title">Payment</h2><!-- End .title -->
                            <br>
                            <br>
                                <span >Please Select Your Payment Options</span><br><br>
                            <input type="radio"value="Debit Card"name="paymentMethod" required ><span style="margin-left: 3%;" class="btn btn-outline-dark btn-rounded">Debit Card</span><br><br>
                            <input type="radio"value="Credit Card" name="paymentMethod" required ><span style="margin-left: 3%;"class="btn btn-outline-dark btn-rounded">Credit Card</span><br><br>
                        
                            
                            <div id="cardMethod" >
                                <br>
                                <div class="row">
                                    <div class="col-sm-6">
                                        <label>Card Number</label>
                                        <input type="text" class="form-control" id="cardNo" required placeholder="Valid Card Number">
                                    </div><!-- End .col-sm-6 -->
                                    <div class="col-sm-6">
                                        <label>Expiration Date</label>
                                        <input type="text" class="form-control" id="expiredDate" required placeholder="MM/YY">
                                    </div><!-- End .col-sm-6 -->
                                </div><!-- End .row -->
                               
                                <div class="row">
                                    <div class="col-sm-6">
                                        <label>CV Code</label>
                                        <input type="text" class="form-control" id="code" required placeholder="CVC">
                                    </div><!-- End .col-sm-6 -->
                                    <div class="col-sm-6">
                                        <label>Card Holder</label>
                                        <input type="tel" class="form-control" id="cardHolder" required placeholder="Card Owner Name">
                                    </div><!-- End .col-sm-6 -->
                                </div><!-- End .row -->
                                </div>

                                <span><div id="error" style="color: red;font-style: italic;"></div></span>
            

                                <div class="card" style="margin: bottom 10px;">
                                    <div class="card-header"
                                        id="heading-5">
                                        <h2 class="card-title">

                                            <br><img
                                                src="assets/images/payments-summary.png"
                                                alt="payments cards"
                                                style="padding-left:50px;"><br><br><br>

                                        </h2>
                                    </div>

                                </div><!-- End .card --> 
                       
                       
                        </div><!-- End .col-lg-6 -->

                    </div><!-- End .row -->

            </div><!-- End .page-content -->
            <input type="submit" value="Confirm Payment" name="confirmPayment" method="post" class="btn btn-outline-primary-2 btn-order btn-block" style="margin-left:60%;width:20%;">
   
            
<script>  
            const form = document.getElementById('form')
            const errorElement = document.getElementById('error')

            form.addEventListener('submit', (e) => {
              let messages = [];
              let expiredDate=document.getElementById('expiredDate')
              let cardNo=document.getElementById('cardNo')
              let code=document.getElementById('code')
              let cardHolder=document.getElementById('cardHolder')

              //Card number length and digit validation
              if(cardNo.value.length!=16||isNaN(cardNo.value)){
                  messages.push('Card number must be consisting of 16 digits')
              }
              
            if(expiredDate.value.substring(0,2) <= 0 || expiredDate.value.substring(0,2) > 31 ){
              messages.push('Please ensure the date month is within the valid range')
            }

            if(expiredDate.value.length!=5 || expiredDate.value.substring(2,3) != "/"){
                messages.push('Invalid date format. Please ensure that the format is MM/YY ')
            }

            if(code.value.length< 3 || code.value.length> 4 ||isNaN(code.value) ){
              messages.push('CV code must be consisting 3 or 4 digits')
            }

            if(cardHolder.value.length < 2 || cardHolder.value.length > 26 || !cardHolder.value.match(/[a-z]/i)){
              messages.push('Card holder must be consisting 2 to 26 alphabets')
            }

            if (messages.length > 0) {
              e.preventDefault()//Prevent from submitting if got error inside 
              errorElement.innerText = messages.join('\n')
            }           
})

                function checker(){
                    var result=confirm('Are you confirm your payment ?');
                    if(result==false){
                        event.preventDefault();
                    }
                }


                function checker(){													
                // On clicking submit do following
                $("input[type=submit]").click(function () {

                    var atLeastOneChecked = false;
                    $("input[type=radio]").each(function () {

                        // If radio button not checked
                        // display alert message
                        if ($(this).attr("checked") != "checked") {

                            // Alert message by displaying
                            // error message
                            $("#msg").html(
                                "<span class='alert alert-danger' id='error'>"
                                + "Please Choose at least one</span>");
                        }
                    
                    });
                });}
            </script>
            </form>
    </body>
</html>
