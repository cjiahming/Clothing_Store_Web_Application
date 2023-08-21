<%-- 
    Document   : header-customerView
    Created on : Apr 11, 2022, 5:57:07 PM
    Author     : Ashley
--%>

<%@page import="Model.Domain.Address"%>
<%@page import="Model.DA.DAAddress"%>
<%@page import="Model.DA.DACustomer"%>
<%@page import="Model.Domain.Customer"%>
<%@page import="Model.Domain.Product"%>
<%@page import="Model.Domain.SKU"%>
<%@page import="java.util.ArrayList"%>
<%@page import="Model.Domain.Cart"%>
<%@page import="Model.DA.DACart"%>
<%@page import="Model.DA.DASKU"%>
<%@page import="Model.DA.DAProduct"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page errorPage="Customer_LoginPage_customerView.jsp"%>
<link rel="stylesheet" href="assets/css/popup.css">

<style>
    .logoBarCode {
        background: url(barcode-solid.svg);
    }
</style>
<!DOCTYPE html>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">





<%
    HttpSession httpSession = request.getSession();
    Customer customer = (Customer) (httpSession.getAttribute("customer"));
%>



<html>
    <body>
        <div class="customers-address-overlay">
            <div class="customers-address">
                <div class="address-div-header">
                    <h3>New Address</h3>
                </div>
                <div class="address-div-body">
                    <form action="AddNewAddressController" method="post" class="customers-address-form">

                        <div class="sameline">
                            <input id="fullname" name="newaddress-fullname" type="text" required placeholder="Full Name" />
                            <input id="phonenum" name="newaddress-phonenumber" maxlength="12" required onKeyup='addDashes(this)' type="tel" placeholder="Phone Number" />
                        </div>

                        <div>
                            <select id="stateSelect" name="stateSelect" size="1" required onchange="makeSubmenu(this.value)">
                                <option value="" disabled selected>Choose State</option>
                                <option>Penang</option>
                                <option>Ipoh</option>
                                <option>Kuala Lumpur</option>
                                <option>Pahang</option>
                                <option>Negeri Sembilan</option>
                                <option>Selangor</option>
                                <option>Perlis</option>
                                <option>Kedah</option>
                                <option>Terengganu</option>
                                <option>Melaka</option>
                                <option>Johor</option>
                                <option>Sabah</option>
                                <option>Sarawak</option>
                            </select>
                        </div>

                        <div>
                            <select id="areaSelect" name="areaSelect" required size="1" >
                                <option value="" disabled selected>Area</option>
                                <option></option>
                            </select>
                        </div>

                        <div>
                            <input id="poscode" name="newaddress-poscode" type="text" required maxlength="5" placeholder="Postal Code" />
                        </div>

                        <input id="addressline" name="newaddress-addressline" type="text" required placeholder="House Number, Street Name, etc." />

                        <div class="address-add-footer">
                            <button type="button" class="cancelbtn" onClick="toggleLogin()">Cancel</button>
                            <button type="submit" class="savebtn">Save</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        <header class="header">
            <div class="header-top">
                <div class="container">
                    <div class="header-left">
                        <div class="header-dropdown">
                            <a href="#">MYR</a>
                            <div class="header-menu">
                                <ul>
                                    <li><a href="Product_SelectCategory-customerView.jsp">MYR</a></li>
                                </ul>
                            </div><!-- End .header-menu -->
                        </div><!-- End .header-dropdown -->

                        <div class="header-dropdown">
                            <a href="#">Eng</a>
                            <div class="header-menu">
                                <ul>
                                    <li><a href="Product_SelectCategory-customerView.jsp">English</a></li>
                                </ul>
                            </div><!-- End .header-menu -->
                        </div><!-- End .header-dropdown -->
                    </div><!-- End .header-left -->

                    <div class="header-right">
                        <ul class="top-menu">
                            <li>
                                <a href="#">Links</a>
                                <ul>
                                    <li><a href="tel:#"><i class="icon-phone"></i>Call: +0123 456 789</a></li>

                                    <li><i class="fa-solid fa-shirt"></i></li>
                                        <%                                            if (session.getAttribute("customer") != null) {
                                        %>
                                    <li><a href="LogoutConfirmation.html"><i class="icon-user"></i>Log Out</a></li>
                                        <%
                                        } else {
                                        %>
                                    <li><a href="Customer_LoginPage_customerView.jsp"><i class="icon-user"></i>Login</a></li>
                                        <%
                                            }
                                        %>
                                </ul>
                            </li>
                        </ul><!-- End .top-menu -->
                    </div><!-- End .header-right -->
                </div><!-- End .container -->
            </div><!-- End .header-top -->

            <div class="header-middle sticky-header">
                <div class="container">
                    <div class="header-left">
                        <button class="mobile-menu-toggler">
                            <span class="sr-only">Toggle mobile menu</span>
                            <i class="icon-bars"></i>
                        </button>

                        <a href="Product_SelectCategory-customerView.jsp" class="logo">
                            <img src="assets/logo_whtbg.png" alt="F&F Logo" width="260" height="80">
                        </a>

                        <nav class="main-nav">
                            <ul class="menu sf-arrows">
                                <li class="megamenu-container active">
                                    <a href="Product_SelectCategory-customerView.jsp" class="sf-with-ul">Home</a>
                                </li>
                                <li>
                                    <a href="#" class="sf-with-ul">Product</a>
                                    <ul>
                                        <li><a href="ProductController_Customer_Category?prodCategory=WomenTops">Women Tops Gallery</a></li>
                                        <li><a href="ProductController_Customer_Category?prodCategory=WomenDresses">Women Dresses Gallery</a></li>
                                        <li><a href="ProductController_Customer_Category?prodCategory=WomenBottoms">Women Bottoms Gallery</a></li>
                                        <li><a href="ProductController_Customer_Category?prodCategory=WomenSweatshirts">Women Sweatshirts Gallery</a></li>
                                        <li><a href="ProductController_Customer_Category?prodCategory=MenTops">Men Tops Gallery</a></li>
                                        <li><a href="ProductController_Customer_Category?prodCategory=MenBottoms">Men Bottoms Gallery</a></li>
                                        <li><a href="ProductController_Customer_Category?prodCategory=MenSweatshirts">Men Sweatshirts Gallery</a></li>
                                    </ul>

                                </li>


                            </ul><!-- End .menu -->
                        </nav><!-- End .main-nav -->
                    </div><!-- End .header-left -->

                    <div class="header-right">
                        <div class="dropdown compare-dropdown">
                            <% //prompt orderHistory button
                                if (customer != null) {%>
                            <%
                                DACustomer daCustomer = new DACustomer();

                                DACart daCart = new DACart();

                                System.out.print(customer.getUserID());
                                session.setAttribute("customer", customer);

                                DAAddress daAddress = new DAAddress();
                                ArrayList<Address> address = daAddress.displayAllAddressRecords(customer.getUserID());
                                session.setAttribute("address", address);

                                DACart cart = new DACart();
                                ArrayList<Cart> cartItems = cart.getAllCartData(customer);
                                session.setAttribute("cart", cartItems);

                                DASKU daSKU = new DASKU();
                                DAProduct daProduct = new DAProduct();
                                int i = 0;
                                ArrayList<Cart> carts = new ArrayList<Cart>();
                                for (Cart c : cartItems) {
                                    //Only retrieve those records with != null order 

                                    cartItems.get(i).setSKU(daSKU.getSKU(c.getSKU().getSkuNo()));
                                    cartItems.get(i).getSKU().setProduct(daProduct.getRecord(c.getSKU().getProduct().getProdID()));
                                    carts.add(c);

                                    i++;
                                }
                                session.setAttribute("carts", carts);

                            %>    






                            <form action="OrderCustomerController" method="post" >
                                <button type="submit" style="visibility:hidden" name="orderHistory">
                                    <a  name="orderHistory" style="visibility:visible" href="Order_OrderHistory-customerView.jsp" class="dropdown-toggle" role="button" title="order" aria-label="ordrr">
                                        <i class="fa-solid fa-barcode"></i>
                                    </a>

                                    <%}%>
                                    </div><!-- End .compare-dropdown -->
                                    <div class="dropdown compare-dropdown">
                                        <% if (customer != null) {%>
                                        <a href="Customer_ManageProfile_customerView.jsp" class="dropdown-toggle" role="button" title="Login" aria-label="Login">
                                            <i class="icon-user"></i>
                                        </a>
                                        <%}%>
                                    </div><!-- End .compare-dropdown -->

                                    <% if (customer != null) {%>
                                    <div class="dropdown cart-dropdown">
                                        <%  DACart cartDA1 = new DACart();
                                            ArrayList<Cart> cartArrListCount = new ArrayList<Cart>();
                                            cartArrListCount = cartDA1.getAllCartDataNoOrd(customer);

                                        %>

                                        <a href="Cart_displayCart-customerView.jsp" class="dropdown-toggle" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" data-display="static">

                                            <i class="icon-shopping-cart"></i>

                                            <span class="cart-count"><%=cartArrListCount.size()%></span>
                                        </a>
                                        `                           
                                        <%  if (cartArrListCount.size() != 0) {
                                                double totalcount = 0; //count for total how much
                                                for (int i = 0; i < cartArrListCount.size(); i++) {
                                                    DASKU daSKUcount = new DASKU();
                                                    DAProduct daProdcount = new DAProduct();

                                                    SKU sku = daSKUcount.getSKU(cartArrListCount.get(i).getSKU().getSkuNo());
                                                    Product prodcount = daProdcount.getRecord(sku.getProduct().getProdID());

                                        %>
                                        <div class="dropdown-menu dropdown-menu-right">
                                            <div class="dropdown-cart-products">
                                                <div class="product">
                                                    <div class="product-cart-details">
                                                        <h4 class="product-title">
                                                            <a href="ProductController_Customer_Details?prodID=<%=prodcount.getProdID()%>"><%=prodcount.getProdName()%></a>
                                                        </h4>

                                                        <span class="cart-product-info">
                                                            <span class="cart-product-qty">Variation : <%=sku.getProdSize()%></span>
                                                            <%= sku.getColour()%>
                                                        </span><br>

                                                        <span class="cart-product-info">
                                                            <span class="cart-product-qty"><%=cartArrListCount.get(i).getQty()%></span>
                                                            x RM<%= String.format("%.2f", prodcount.getProdPrice())%>
                                                        </span>
                                                    </div><!-- End .product-cart-details -->

                                                    <figure class="product-image-container">
                                                        <a class="product-image"> 
                                                            <img src="<%= prodcount.getProdImage()%>" alt="product">
                                                        </a>
                                                    </figure>
                                                        </form>
                                                    <form method = "post" action="CartController_Customer_DeleteFromCart">
                                                        <input name="cartItemID" type ="hidden" value ="<%= cartArrListCount.get(i).getCartItemID()%>"/>
                                                        <input name="page" type ="hidden" value ="Product_Details-customerView"/>
                                                        <button type="submit" style="visibility: hidden;">
                                                            <a type = "submit" style = "visibility: visible;" class="btn-remove" title="Remove Product"><i class="icon-close"></i></a>
                                                        </button> 
                                                    </form>
                                                </div><!-- End .product -->
                                                <%totalcount += cartArrListCount.get(i).getQty() * prodcount.getProdPrice(); %>
                                                <% }%>

                                            </div><!-- End .cart-product -->

                                            <div class="dropdown-cart-total">
                                                <span>Total</span>

                                                <span class="cart-total-price">RM<%=String.format("%.2f", totalcount)%></span>
                                            </div><!-- End .dropdown-cart-total -->

                                            <div class="dropdown-cart-action">
                                                <a href="Cart_displayCart-customerView.jsp" class="btn btn-primary">View Cart</a>

                                            </div><!-- End .dropdown-cart-total -->
                                        </div><!-- End .dropdown-menu -->
                                        <%}%>
                                    </div><!-- End .cart-dropdown -->
                                    <%}%>
                                    </div><!-- End .header-right -->
                                    </div><!-- End .container -->
                                    </div><!-- End .header-middle -->
                                    </header><!-- End .header -->
                                    </body>
                                    </html>
