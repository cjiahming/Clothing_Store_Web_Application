<%-- 
    Document   : Admin_editProfile-adminView
    Author     : Choong Jiah Ming
--%>

<%@page import="Model.Domain.Product"%>
<%@page import="Model.Domain.SKU"%>
<%@page import="Model.Domain.Cart"%>
<%@page import="Model.Domain.Payment"%>
<%@page import="Model.DA.DAPayment"%>
<%@page import="Model.Domain.Order"%>
<%@page import="Model.DA.DASKU"%>
<%@page import="Model.DA.DAOrder"%>
<%@page import="Model.DA.DAProduct"%>
<%@page import="Model.DA.DACart"%>
<%@page import="java.util.ArrayList"%>
<%@page import="Model.Domain.Address"%>
<%@page import="Model.Domain.Customer"%>
<%@page errorPage="Customer_LoginPage_customerView.jsp"%>

<%
    response.setHeader("Cache-Control", "no-cache");
    response.setHeader("Cache-Control", "no-store");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    if (session.getAttribute("customer") == null) {
        response.sendRedirect("Customer_LoginPage_customerView.jsp");
    }
%>

<!DOCTYPE html>
<html lang="en">


    <!-- molla/dashboard.html  22 Nov 2019 10:03:13 GMT -->
    <head>
        <meta charset="UTF-8" content="width=device-width, initial-scale=1.0">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>Manage Profile Customer - Fast&Fashion</title>
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
        <link rel="shortcut icon" type="image/x-icon" href="assets/siteIcon.png" />
        <meta name="apple-mobile-web-app-title" content="Molla">
        <meta name="application-name" content="Molla">
        <meta name="msapplication-TileColor" content="#cc9966">
        <meta name="msapplication-config" content="assets/images/icons/browserconfig.xml">
        <meta name="theme-color" content="#ffffff">
        <!-- Plugins CSS File -->
        <link rel="stylesheet" href="assets/css/bootstrap.min.css">
        <!-- Main CSS File -->
        <link rel="stylesheet" href="assets/css/style.css">
        <link rel="stylesheet" href="assets/css/popup.css">
        <link rel="stylesheet" href="assets/css/userprofile.css">
        <jsp:useBean id="customerDA" scope="application" class="Model.DA.DACustomer"/>
        <jsp:useBean id="addressDA" scope="application" class="Model.DA.DAAddress"/>
    </head>



    <body>
        <div class="page-wrapper">
            <!--Header-->
            <%@ include file="header-customerView.jsp"%>

            <%
                ArrayList<Address> a = addressDA.displayAllAddressRecords(customer.getUserID());
            %>

            <main class="main">
                <div class="page-header text-center" style="background-image: url('assets/images/page-header-bg.jpg')">
                    <div class="container">
                        <h1 class="page-title">My Account<span>Shop</span></h1>
                    </div><!-- End .container -->
                </div><!-- End .page-header -->
                <nav aria-label="breadcrumb" class="breadcrumb-nav mb-3">
                    <div class="container">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item"><a href="Product_SelectCategory-customerView.jsp">Home</a></li>
                            <li class="breadcrumb-item"><a href="Product_SelectCategory-customerView.jsp">Shop</a></li>
                            <li class="breadcrumb-item active" aria-current="page">My Account</li>
                        </ol>
                    </div><!-- End .container -->
                </nav><!-- End .breadcrumb-nav -->



                <div class="page-content">

                    <div class="dashboard">
                        <div class="container">
                            <div class="row">              
                                <aside class="col-md-4 col-lg-3">
                                    <ul class="nav nav-dashboard flex-column mb-3 mb-md-0" role="tablist">
                                        <li class="nav-item">
                                            <a class="nav-link active" id="tab-account-link" data-toggle="tab" href="#tab-account" role="tab" aria-controls="tab-account" aria-selected="true">Account Details</a>
                                        </li>
                                        <li class="nav-item">
                                            <a class="nav-link" id="tab-address-link" data-toggle="tab" href="#tab-address" role="tab" aria-controls="tab-address" aria-selected="false">Adresses</a>
                                        </li>
                                        <li class="nav-item">
                                            <a class="nav-link" id="tab-password-link" data-toggle="tab" href="#tab-password" role="tab" aria-controls="tab-password" aria-selected="false">Change Password</a>
                                        </li>
                                        <li class="nav-item">
                                            <a class="nav-link" id="tab-orders-link" data-toggle="tab" href="#tab-orders" role="tab" aria-controls="tab-orders" aria-selected="false">Review and Refund</a>
                                        </li>


                                        <li class="nav-item">
                                            <a class="nav-link" href="LogoutConfirmation.html">Sign Out</a>
                                        </li>
                                    </ul>
                                </aside><!-- End .col-lg-3 -->

                                <div class="col-md-8 col-lg-9">
                                    <div class="tab-content">
                                        <div class="tab-pane fade" id="tab-orders" role="tabpanel" aria-labelledby="tab-orders-link">

                                            <%
                                                //Data Access
                                                DACart cartDA = new DACart();
                                                DAOrder orderda = new DAOrder();
                                                DAProduct productDA = new DAProduct();
                                                DASKU skuDA = new DASKU();
                                                ArrayList<Order> ordList = cartDA.getAllOrdersUnderCust(customer);
                                                DAPayment paymentDA = new DAPayment();

                                            %>

                                            <div>
                                                <div>

                                                    <%for (int i = 0; i < ordList.size(); i++) {
                                                            Payment payment = paymentDA.getPaymentRecordbyOrdID(ordList.get(i).getOrderId());
                                                    %>   
                                                    <div class="card card-dashboard">
                                                        <div class="card-body">

                                                            <table style="  width:100%; background-color:light-red ; float:left; ">

                                                                <h3 class="card-title">Orders ID: <%=ordList.get(i).getOrderId()%></h3><!-- End .card-title -->
                                                                OrderStatus : <%= ordList.get(i).getOrderStatus()%><br>
                                                                OrderCreatedTime : <%= ordList.get(i).getOrderCreatedTime()%><br>
                                                                OrderRemark : <%= ordList.get(i).getOrderRemark()%><br>
                                                                TotalPayment :<%=String.format("RM%.2f", payment.getPaymentAmount())%>

                                                                <form action="Refund_AddNew-customerView.jsp" method="post">
                                                                    <button type="submit" class="add-address-btn" name="submit" value="<%=ordList.get(i).getOrderId()%>" >Refund</button>                          
                                                                </form>

                                                                <tr>

                                                                    <th width=25% style="padding-left: 50px;" >Product</th>
                                                                    <th align="center"></th>
                                                                    <th align="center">Size</th>
                                                                    <th align="center">Colour</th>
                                                                    <th align="center">Quantity</th>
                                                                    <th align="center">Review</th>

                                                                </tr>
                                                                <form action="Review_AddReview-customerView.jsp"> 
                                                                    <%
                                                                        ArrayList<Cart> cartArrListHaveSameOrder = cartDA.getSpecificCartSameOrd(ordList.get(i), customer);
                                                                        for (int j = 0; j < cartArrListHaveSameOrder.size(); j++) {

                                                                            SKU sku = skuDA.getSKU(cartArrListHaveSameOrder.get(j).getSKU().getSkuNo());
                                                                            Product product = productDA.getRecord(sku.getProduct().getProdID());

                                                                    %>
                                                                    <tr style="padding-bottom:30px">



                                                                        <td align="center" >
                                                                            <img display="block" margin="auto" width="40%" height="40%" src="<%=product.getProdImage()%>" alt="Product image">
                                                                        </td>
                                                                        <td style="text-align: center; padding-left:-50px">
                                                                            <%=product.getProdName()%>
                                                                        </td>

                                                                        <td align="center"><%=sku.getProdSize()%></td>
                                                                        <td align="center"><%=sku.getColour()%></td>
                                                                        <td align="center"><%=cartArrListHaveSameOrder.get(j).getQty()%></td>
                                                                        <td align="center">
                                                                            <%
                                                                                if ((orderda.getOrderRecord(cartArrListHaveSameOrder.get(j).getOrder().getOrderId())).getOrderStatus().equals("COMPLETED") && cartArrListHaveSameOrder.get(j).getReview().getReviewID() == null) {
                                                                            %>



                                                                            <p><button type="submit" class="add-address-btn" name="submit" value="<%=cartArrListHaveSameOrder.get(j).getCartItemID()%>">Review</button></p>
                                                                            <%} else if (cartArrListHaveSameOrder.get(j).getReview().getReviewID() != null) {%>
                                                                            <p><button type="submit" class="add-address-btn" name="submit" value="<%=cartArrListHaveSameOrder.get(j).getCartItemID()%>">Edit Review</button></p>

                                                                        </td>


                                                                        <%}%>

                                                                    </tr>

                                                                    <% } %>
                                                                </form>

                                                            </table>

                                                        </div><!-- End .card-body -->
                                                    </div><!-- End .card-dashboard -->

                                                    <%}%>

                                                </div><!-- End .col-lg-6 -->
                                            </div><!-- End .row -->
                                        </div><!-- .End .tab-pane -->

                                        <div class="tab-pane fade" id="tab-password" role="tabpanel" aria-labelledby="tab-password-link">
                                            <div class=tab-pane fade id=signin-2 role=tabpanel aria-labelledby=signin-tab-2>
                                                <form action="EditPasswordController" method="post">

                                                    <div class="form-group">
                                                        <label>Current Password</label>
                                                        <input type=password class="form-control" id="profile-currentpassword" name="profile-currentpassword">
                                                        <small style="color: red">${currentPasswordErrMsg}</small>
                                                    </div>

                                                    <div class="form-group">
                                                        <label>New Password</label>
                                                        <input type=password class="form-control" id="profile-newpassword" name="profile-newpassword">
                                                        <small style="color: red">${newPasswordErrMsg}</small>
                                                    </div>

                                                    <div class="form-group">
                                                        <label>Confirm New Password</label>
                                                        <input type=password class="form-control" id="profile-confirmnewpassword" name="profile-confirmnewpassword">
                                                        <small style="color: red">${confirmNewPasswordErrMsg}</small>
                                                    </div>

                                                    <button type=submit class="customer-save-password">SAVE</button>

                                                </form>
                                            </div>
                                        </div><!-- .End .tab-pane -->                                 

                                        <div class="tab-pane fade" id="tab-address" role="tabpanel" aria-labelledby="tab-address-link">
                                            
                                            <p><button class="add-address-btn" onclick="toggleLogin()">+ Add New Address</button></p>

                                            <%
                                                if (a.size() < 1) {
                                                    out.println("No Address Yet. Please add a new address to have it display here.");
                                                } else if (a != null) {
                                                    for (int i = 0; i < a.size(); i++) {
                                            %>
                                            <div>
                                                <div>
                                                    <div class="card card-dashboard">
                                                        <div class="card-body">
                                                            <h3 class="card-title">Address <%= i + 1%></h3><!-- End .card-title -->
                                                            Full Name : <b><%= a.get(i).getFullName()%></b>
                                                            <br>

                                                            Phone Number : <%= a.get(i).getAdrPhoneNum()%>
                                                            <br>

                                                            Address : <%= a.get(i).getAddressLine()%>, <%= a.get(i).getArea()%>, <%= a.get(i).getPosCode()%>, <%= a.get(i).getStates()%>
                                                            <br>
                                                            <div class="address-editdelete-btn">
                                                                <div class="address-editdelete-btn-inner">
                                                                    <form action="UpdateCustomerAddressController" method="get">
                                                                        <button class="editAddressBtn" value="<%= a.get(i).getAddressID()%>" name="<%= a.get(i).getAddressID()%>">Edit</button>
                                                                    </form>
                                                                </div>

                                                                <div class="address-editdelete-btn-inner">
                                                                    <form action="DeleteCustomerAddressController" method="post">
                                                                        <button type="submit" class="deleteAddressBtn" value="<%= a.get(i).getAddressID()%>" name="<%= a.get(i).getAddressID()%>" >Delete</button>
                                                                    </form>
                                                                </div>
                                                            </div>
                                                        </div><!-- End .card-body -->
                                                    </div><!-- End .card-dashboard -->
                                                </div><!-- End .col-lg-6 -->
                                            </div><!-- End .row -->
                                            <%
                                                    }
                                                }
                                            %>
                                        </div><!-- .End .tab-pane -->


                                        <% Customer c2 = customerDA.displaySpecificCustomer(customer.getUserID());%>
                                        <div class="tab-pane fade show active" id="tab-account" role="tabpanel" aria-labelledby="tab-account-link">
                                            <form action="UpdateCustomerController" method="post">
                                                <div class="form-group">
                                                    <label>Username</label>
                                                    <input type="text" class="form-control" name="profile-username" value=<%= c2.getUsername()%> disabled disabled style="color: #B3B3B3">
                                                    <small style="color: red">${editUsernameErrMsg}</small>
                                                </div>

                                                <div class="form-group">
                                                    <label>Phone Number</label>
                                                    <input type="text" class="form-control" name="profile-phonenumber" value=<%= c2.getPhoneNum()%>>        						
                                                    <small style="color: red">${editPhoneNumErrMsg}</small>
                                                </div>

                                                <div class="form-group">
                                                    <label>Email Address</label>
                                                    <input type="text" class="form-control" name="profile-email" value=<%= c2.getEmail()%>>
                                                    <small style="color: red">${editEmailErrMsg}</small>
                                                </div>

                                                <div class="form-group">
                                                    <label>Gender</label>

                                                    <input class="userprofile-radiobox" type=radio id="male" name="profile-gender" value="male"  <% if (c2.getGender().equals("male")) {
                                                           %>checked="checked"<% }
                                                           %>>
                                                    <label for="male">Male</label>

                                                    <input class="userprofile-radiobox" type=radio id="female" name="profile-gender" value="female"  <% if (c2.getGender().equals("female")) {
                                                           %>checked="checked"<% }
                                                           %>>
                                                    <label for="female">Female</label>

                                                    <input class="userprofile-radiobox" type=radio id="others" name="profile-gender" value="others"  <% if (c2.getGender().equals("others")) {
                                                           %>checked="checked"<% }
                                                           %>>
                                                    <label for="others">Others</label>
                                                </div>

                                                <button type="submit" class="btn btn-outline-primary-2">
                                                    <span>SAVE CHANGES</span>
                                                    <i class="icon-long-arrow-right"></i>
                                                </button>
                                            </form>
                                        </div><!-- .End .tab-pane -->
                                    </div>
                                </div><!-- End .col-lg-9 -->
                            </div><!-- End .row -->
                        </div><!-- End .container -->
                    </div><!-- End .dashboard -->
                </div><!-- End .page-content -->
            </main><!-- End .main -->

            <%@ include file="footer-customerView.jsp"%> 
        </div><!-- End .page-wrapper -->
        <button id="scroll-top" title="Back to Top"><i class="icon-arrow-up"></i></button>

        <!-- Mobile Menu -->
        <div class="mobile-menu-overlay"></div><!-- End .mobil-menu-overlay -->

        <div class="mobile-menu-container">
            <div class="mobile-menu-wrapper">
                <span class="mobile-menu-close"><i class="icon-close"></i></span>

                <form action="#" method="get" class="mobile-search">
                    <label for="mobile-search" class="sr-only">Search</label>
                    <input type="search" class="form-control" name="mobile-search" id="mobile-search" placeholder="Search in..." required>
                    <button class="btn btn-primary" type="submit"><i class="icon-search"></i></button>
                </form>

                <nav class="mobile-nav">
                    <ul class="mobile-menu">
                        <li class="active">
                            <a href="index.html">Home</a>

                            <ul>
                                <li><a href="index-1.html">01 - furniture store</a></li>
                                <li><a href="index-2.html">02 - furniture store</a></li>
                                <li><a href="index-3.html">03 - electronic store</a></li>
                                <li><a href="index-4.html">04 - electronic store</a></li>
                                <li><a href="index-5.html">05 - fashion store</a></li>
                                <li><a href="index-6.html">06 - fashion store</a></li>
                                <li><a href="index-7.html">07 - fashion store</a></li>
                                <li><a href="index-8.html">08 - fashion store</a></li>
                                <li><a href="index-9.html">09 - fashion store</a></li>
                                <li><a href="index-10.html">10 - shoes store</a></li>
                                <li><a href="index-11.html">11 - furniture simple store</a></li>
                                <li><a href="index-12.html">12 - fashion simple store</a></li>
                                <li><a href="index-13.html">13 - market</a></li>
                                <li><a href="index-14.html">14 - market fullwidth</a></li>
                                <li><a href="index-15.html">15 - lookbook 1</a></li>
                                <li><a href="index-16.html">16 - lookbook 2</a></li>
                                <li><a href="index-17.html">17 - fashion store</a></li>
                                <li><a href="index-18.html">18 - fashion store (with sidebar)</a></li>
                                <li><a href="index-19.html">19 - games store</a></li>
                                <li><a href="index-20.html">20 - book store</a></li>
                                <li><a href="index-21.html">21 - sport store</a></li>
                                <li><a href="index-22.html">22 - tools store</a></li>
                                <li><a href="index-23.html">23 - fashion left navigation store</a></li>
                                <li><a href="index-24.html">24 - extreme sport store</a></li>
                            </ul>
                        </li>
                        <li>
                            <a href="category.html">Shop</a>
                            <ul>
                                <li><a href="category-list.html">Shop List</a></li>
                                <li><a href="category-2cols.html">Shop Grid 2 Columns</a></li>
                                <li><a href="category.html">Shop Grid 3 Columns</a></li>
                                <li><a href="category-4cols.html">Shop Grid 4 Columns</a></li>
                                <li><a href="category-boxed.html"><span>Shop Boxed No Sidebar<span class="tip tip-hot">Hot</span></span></a></li>
                                <li><a href="category-fullwidth.html">Shop Fullwidth No Sidebar</a></li>
                                <li><a href="product-category-boxed.html">Product Category Boxed</a></li>
                                <li><a href="product-category-fullwidth.html"><span>Product Category Fullwidth<span class="tip tip-new">New</span></span></a></li>
                                <li><a href="cart.html">Cart</a></li>
                                <li><a href="checkout.html">Checkout</a></li>
                                <li><a href="wishlist.html">Wishlist</a></li>
                                <li><a href="#">Lookbook</a></li>
                            </ul>
                        </li>
                        <li>
                            <a href="product.html" class="sf-with-ul">Product</a>
                            <ul>
                                <li><a href="product.html">Default</a></li>
                                <li><a href="product-centered.html">Centered</a></li>
                                <li><a href="product-extended.html"><span>Extended Info<span class="tip tip-new">New</span></span></a></li>
                                <li><a href="product-gallery.html">Gallery</a></li>
                                <li><a href="product-sticky.html">Sticky Info</a></li>
                                <li><a href="product-sidebar.html">Boxed With Sidebar</a></li>
                                <li><a href="product-fullwidth.html">Full Width</a></li>
                                <li><a href="product-masonry.html">Masonry Sticky Info</a></li>
                            </ul>
                        </li>
                        <li>
                            <a href="#">Pages</a>
                            <ul>
                                <li>
                                    <a href="about.html">About</a>

                                    <ul>
                                        <li><a href="about.html">About 01</a></li>
                                        <li><a href="about-2.html">About 02</a></li>
                                    </ul>
                                </li>
                                <li>
                                    <a href="contact.html">Contact</a>

                                    <ul>
                                        <li><a href="contact.html">Contact 01</a></li>
                                        <li><a href="contact-2.html">Contact 02</a></li>
                                    </ul>
                                </li>
                                <li><a href="login.html">Login</a></li>
                                <li><a href="faq.html">FAQs</a></li>
                                <li><a href="404.html">Error 404</a></li>
                                <li><a href="coming-soon.html">Coming Soon</a></li>
                            </ul>
                        </li>
                        <li>
                            <a href="blog.html">Blog</a>

                            <ul>
                                <li><a href="blog.html">Classic</a></li>
                                <li><a href="blog-listing.html">Listing</a></li>
                                <li>
                                    <a href="#">Grid</a>
                                    <ul>
                                        <li><a href="blog-grid-2cols.html">Grid 2 columns</a></li>
                                        <li><a href="blog-grid-3cols.html">Grid 3 columns</a></li>
                                        <li><a href="blog-grid-4cols.html">Grid 4 columns</a></li>
                                        <li><a href="blog-grid-sidebar.html">Grid sidebar</a></li>
                                    </ul>
                                </li>
                                <li>
                                    <a href="#">Masonry</a>
                                    <ul>
                                        <li><a href="blog-masonry-2cols.html">Masonry 2 columns</a></li>
                                        <li><a href="blog-masonry-3cols.html">Masonry 3 columns</a></li>
                                        <li><a href="blog-masonry-4cols.html">Masonry 4 columns</a></li>
                                        <li><a href="blog-masonry-sidebar.html">Masonry sidebar</a></li>
                                    </ul>
                                </li>
                                <li>
                                    <a href="#">Mask</a>
                                    <ul>
                                        <li><a href="blog-mask-grid.html">Blog mask grid</a></li>
                                        <li><a href="blog-mask-masonry.html">Blog mask masonry</a></li>
                                    </ul>
                                </li>
                                <li>
                                    <a href="#">Single Post</a>
                                    <ul>
                                        <li><a href="single.html">Default with sidebar</a></li>
                                        <li><a href="single-fullwidth.html">Fullwidth no sidebar</a></li>
                                        <li><a href="single-fullwidth-sidebar.html">Fullwidth with sidebar</a></li>
                                    </ul>
                                </li>
                            </ul>
                        </li>
                        <li>
                            <a href="elements-list.html">Elements</a>
                            <ul>
                                <li><a href="elements-products.html">Products</a></li>
                                <li><a href="elements-typography.html">Typography</a></li>
                                <li><a href="elements-titles.html">Titles</a></li>
                                <li><a href="elements-banners.html">Banners</a></li>
                                <li><a href="elements-product-category.html">Product Category</a></li>
                                <li><a href="elements-video-banners.html">Video Banners</a></li>
                                <li><a href="elements-buttons.html">Buttons</a></li>
                                <li><a href="elements-accordions.html">Accordions</a></li>
                                <li><a href="elements-tabs.html">Tabs</a></li>
                                <li><a href="elements-testimonials.html">Testimonials</a></li>
                                <li><a href="elements-blog-posts.html">Blog Posts</a></li>
                                <li><a href="elements-portfolio.html">Portfolio</a></li>
                                <li><a href="elements-cta.html">Call to Action</a></li>
                                <li><a href="elements-icon-boxes.html">Icon Boxes</a></li>
                            </ul>
                        </li>
                    </ul>
                </nav><!-- End .mobile-nav -->

                <div class="social-icons">
                    <a href="#" class="social-icon" target="_blank" title="Facebook"><i class="icon-facebook-f"></i></a>
                    <a href="#" class="social-icon" target="_blank" title="Twitter"><i class="icon-twitter"></i></a>
                    <a href="#" class="social-icon" target="_blank" title="Instagram"><i class="icon-instagram"></i></a>
                    <a href="#" class="social-icon" target="_blank" title="Youtube"><i class="icon-youtube"></i></a>
                </div><!-- End .social-icons -->
            </div><!-- End .mobile-menu-wrapper -->
        </div><!-- End .mobile-menu-container -->

        <!-- Sign in / Register Modal -->
        <div class="modal fade" id="signin-modal" tabindex="-1" role="dialog" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered" role="document">
                <div class="modal-content">
                    <div class="modal-body">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true"><i class="icon-close"></i></span>
                        </button>

                        <div class="form-box">
                            <div class="form-tab">
                                <ul class="nav nav-pills nav-fill" role="tablist">
                                    <li class="nav-item">
                                        <a class="nav-link active" id="signin-tab" data-toggle="tab" href="#signin" role="tab" aria-controls="signin" aria-selected="true">Sign In</a>
                                    </li>
                                    <li class="nav-item">
                                        <a class="nav-link" id="register-tab" data-toggle="tab" href="#register" role="tab" aria-controls="register" aria-selected="false">Register</a>
                                    </li>
                                </ul>
                                <div class="tab-content" id="tab-content-5">
                                    <div class="tab-pane fade show active" id="signin" role="tabpanel" aria-labelledby="signin-tab">
                                        <form action="#">
                                            <div class="form-group">
                                                <label for="singin-email">Username or email address *</label>
                                                <input type="text" class="form-control" id="singin-email" name="singin-email" required>
                                            </div><!-- End .form-group -->

                                            <div class="form-group">
                                                <label for="singin-password">Password *</label>
                                                <input type="password" class="form-control" id="singin-password" name="singin-password" required>
                                            </div><!-- End .form-group -->

                                            <div class="form-footer">
                                                <button type="submit" class="btn btn-outline-primary-2">
                                                    <span>LOG IN</span>
                                                    <i class="icon-long-arrow-right"></i>
                                                </button>

                                                <div class="custom-control custom-checkbox">
                                                    <input type="checkbox" class="custom-control-input" id="signin-remember">
                                                    <label class="custom-control-label" for="signin-remember">Remember Me</label>
                                                </div><!-- End .custom-checkbox -->

                                                <a href="#" class="forgot-link">Forgot Your Password?</a>
                                            </div><!-- End .form-footer -->
                                        </form>
                                        <div class="form-choice">
                                            <p class="text-center">or sign in with</p>
                                            <div class="row">
                                                <div class="col-sm-6">
                                                    <a href="#" class="btn btn-login btn-g">
                                                        <i class="icon-google"></i>
                                                        Login With Google
                                                    </a>
                                                </div><!-- End .col-6 -->
                                                <div class="col-sm-6">
                                                    <a href="#" class="btn btn-login btn-f">
                                                        <i class="icon-facebook-f"></i>
                                                        Login With Facebook
                                                    </a>
                                                </div><!-- End .col-6 -->
                                            </div><!-- End .row -->
                                        </div><!-- End .form-choice -->
                                    </div><!-- .End .tab-pane -->
                                    <div class="tab-pane fade" id="register" role="tabpanel" aria-labelledby="register-tab">
                                        <form action="#">
                                            <div class="form-group">
                                                <label for="register-email">Your email address *</label>
                                                <input type="email" class="form-control" id="register-email" name="register-email" required>
                                            </div><!-- End .form-group -->

                                            <div class="form-group">
                                                <label for="register-password">Password *</label>
                                                <input type="password" class="form-control" id="register-password" name="register-password" required>
                                            </div><!-- End .form-group -->

                                            <div class="form-footer">
                                                <button type="submit" class="btn btn-outline-primary-2">
                                                    <span>SIGN UP</span>
                                                    <i class="icon-long-arrow-right"></i>
                                                </button>

                                                <div class="custom-control custom-checkbox">
                                                    <input type="checkbox" class="custom-control-input" id="register-policy" required>
                                                    <label class="custom-control-label" for="register-policy">I agree to the <a href="#">privacy policy</a> *</label>
                                                </div><!-- End .custom-checkbox -->
                                            </div><!-- End .form-footer -->
                                        </form>
                                        <div class="form-choice">
                                            <p class="text-center">or sign in with</p>
                                            <div class="row">
                                                <div class="col-sm-6">
                                                    <a href="#" class="btn btn-login btn-g">
                                                        <i class="icon-google"></i>
                                                        Login With Google
                                                    </a>
                                                </div><!-- End .col-6 -->
                                                <div class="col-sm-6">
                                                    <a href="#" class="btn btn-login  btn-f">
                                                        <i class="icon-facebook-f"></i>
                                                        Login With Facebook
                                                    </a>
                                                </div><!-- End .col-6 -->
                                            </div><!-- End .row -->
                                        </div><!-- End .form-choice -->
                                    </div><!-- .End .tab-pane -->
                                </div><!-- End .tab-content -->
                            </div><!-- End .form-tab -->
                        </div><!-- End .form-box -->
                    </div><!-- End .modal-body -->
                </div><!-- End .modal-content -->
            </div><!-- End .modal-dialog -->
        </div><!-- End .modal -->

        <!-- Plugins JS File -->
        <script src="assets/js/jquery.min.js"></script>
        <script src="assets/js/bootstrap.bundle.min.js"></script>
        <script src="assets/js/jquery.hoverIntent.min.js"></script>
        <script src="assets/js/jquery.waypoints.min.js"></script>
        <script src="assets/js/superfish.min.js"></script>
        <script src="assets/js/owl.carousel.min.js"></script>
        <!-- Main JS File -->
        <script src="assets/js/main.js"></script>

        <script>
                                                function toggleLogin() {
                                                    document.querySelector(".customers-address-overlay").classList.toggle("open");
                                                    document.getElementById('fullname').value = "";
                                                    document.getElementById('phonenum').value = "";
                                                    document.getElementById('stateSelect').value = "";
                                                    document.getElementById('areaSelect').value = "";
                                                    document.getElementById('poscode').value = "";
                                                    document.getElementById('addressline').value = "";
                                                }

                                                var citiesByState = {
                                                    Penang: ["Bayan Lepas", "Bukit Mertajam", "Air Itam", "Balik Pulau", "Perai", "Air Itam", "Nibong Tebal", "Batu Ferringhi", "Kepala Batas", "Gelugor", "Batu Maung", "Tasek Gelugor"],
                                                    Ipoh: ["Ampang", "Anjung Tawas", "Bandar Seri Botani", "Bercham", "Canning Garden", "Greentown", "Meru Raya", "Pasir Puteh", "Kampung Simee"],
                                                    "Kuala Lumpur": ["Petaling Jaya", "Subang Jaya", "Shah Alam", "Klang", "Port Klang", "Ampang", "Puchong", "Rawang", "Kajang", "Sepang"],
                                                    Pahang: ["Balok", "Bandar Bera", "Bentong", "Damak", "Kuala Rompin", "Sungai Koyan", "Sungai Lembing", "Kuantan", "Kuala Lipis"],
                                                    "Negeri Sembilan": ["Bahau", "Bandar Enstek", "Batu Kikir", "Kuala Pilah", "Nilai", "Pusat Bandar Palong", "Rompin", "Seremban", "Simpang Pertang"],
                                                    Selangor: ["Balakong", "Bangi", "Banting", "Batang Berjuntai", "Batu Arang", "Cyberjaya", "Klang", "Kuala Selangor", "Petaling Jaya"],
                                                    Perlis: ["Kaki Bukit", "Padang Besar", "Simpang Empat", "Wang Kelian", "Chuping", "Jejawi", "Kaki Bukit", "Sanglang", "Beseri"],
                                                    Kedah: ["Alor Setar", "Ayer Hitam", "Baling", "Kodiang", "Kuala Ketil", "Kota Kuala Muda", "Langkawi", "Kupang", "Lunas"],
                                                    Terengganu: ["Ceneh", "Dungun", "Kerteh", "Kuala Terengganu", "Marang", "Paka", "Permaisuri", "Sungai Tong", "Ayer Puteh"],
                                                    Melaka: ["Alor Gajah", "Asahan", "Ayer Keroh", "Bemban", "Durian Tunggal", "Jasin", "Durian Tunggal", "Melaka", "Sungai Rambai"],
                                                    Johor: ["Ayer Baloi", "Ayer Hitam", "Bandar Penawar", "Batu Pahat", "Gelang Patah", "Kota Tinggi", "Kulai", "Layang-Layang", "Nusajaya"],
                                                    Sabah: ["Bongawan", "Kota Marudu", "Lahad Datu", "Membakut", "Menumbok", "Penampang", "Tenghilan", "Tuaran", "Tenom"],
                                                    Sarawak: ["Asajaya", "Balingian", "Dalat", "Engkilili", "Long Lama", "Mukah", "Sebuyau", "Sri Aman", "Tatau"]
                                                }

                                                function makeSubmenu(value) {
                                                    if (value.length == 0)
                                                        document.getElementById("areaSelect").innerHTML = "<option></option>";
                                                    else {
                                                        var citiesOptions = "";
                                                        for (cityId in citiesByState[value]) {
                                                            citiesOptions += "<option>" + citiesByState[value][cityId] + "</option>";
                                                        }
                                                        document.getElementById("areaSelect").innerHTML = citiesOptions;
                                                    }
                                                }

                                                function displaySelected() {
                                                    var country = document.getElementById("stateSelect").value;

                                                    var city = document.getElementById("areaSelect").value;
                                                    alert(country + "\n" + city);
                                                }

                                                function resetSelection() {
                                                    document.getElementById("stateSelect").selectedIndex = 0;
                                                    document.getElementById("areaSelect").selectedIndex = 0;
                                                }

                                                // Restricts input for the given textbox to the given inputFilter function.
                                                function setInputFilter(textbox, inputFilter, errMsg) {
                                                    ["input", "keydown", "keyup", "mousedown", "mouseup", "select", "contextmenu", "drop", "focusout"].forEach(function (event) {
                                                        textbox.addEventListener(event, function (e) {
                                                            if (inputFilter(this.value)) {
                                                                // Accepted value
                                                                if (["keydown", "mousedown", "focusout"].indexOf(e.type) >= 0) {
                                                                    this.classList.remove("input-error");
                                                                    this.setCustomValidity("");
                                                                }
                                                                this.oldValue = this.value;
                                                                this.oldSelectionStart = this.selectionStart;
                                                                this.oldSelectionEnd = this.selectionEnd;
                                                            } else if (this.hasOwnProperty("oldValue")) {
                                                                // Rejected value - restore the previous one
                                                                this.classList.add("input-error");
                                                                this.setCustomValidity(errMsg);
                                                                this.reportValidity();
                                                                this.value = this.oldValue;
                                                                this.setSelectionRange(this.oldSelectionStart, this.oldSelectionEnd);
                                                            } else {
                                                                // Rejected value - nothing to restore
                                                                this.value = "";
                                                            }
                                                        });
                                                    });
                                                }

                                                setInputFilter(document.getElementById("fullname"), function (value) {
                                                    return /^[a-z, ]*$/i.test(value);
                                                }, "Must contains letters only");

                                                setInputFilter(document.getElementById("phonenum"), function (value) {
                                                    return /^[0-9\-]*$/i.test(value);
                                                }, "");

                                                setInputFilter(document.getElementById("poscode"), function (value) {
                                                    return /^-?\d*$/.test(value);
                                                }, "Must be a number");
        </script>

        <script>
            window.addDashes = function addDashes(f) {
                var r = /(\D+)/g,
                        npa = '',
                        nxx = '',
                        last4 = '';
                f.value = f.value.replace(r, '');
                npa = f.value.substr(0, 3);
                nxx = f.value.substr(3, 8);
                f.value = npa + (nxx.length > 0 ? '-' : '') + nxx + (last4.length > 0 ? '-' : '') + last4;
            }
        </script>
    </body>


    <!-- molla/dashboard.html  22 Nov 2019 10:03:13 GMT -->
</html>

