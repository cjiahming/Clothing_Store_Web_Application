<%-- 
    Document   : Product_SpecificDetails-customerView
    Created on : Mar 24, 2022, 10:19:18 PM
    Author     : Ashley
--%>

<%@page import="Model.DA.DACustomer"%>
<%@page import="Model.DA.DAReview"%>
<%@page import="java.util.ArrayList"%>
<%@page import="Model.DA.DAProduct"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import = "Model.Domain.Product"%>
<%@page import = "Model.Domain.Customer"%>
<%@page import = "Model.Domain.SKU"%>
<%@page import = "Model.DA.DASKU"%>
<%@page import = "Model.Domain.Cart"%>
<%@page import = "Model.DA.DACart"%>
<%@page errorPage="Customer_LoginPage_customerView.jsp"%>
                                                

<%
    Product prod = (Product) request.getSession().getAttribute("product");
    
%>

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
    <link rel="stylesheet" href="assets/css/plugins/owl-carousel/owl.carousel.css">
    <link rel="stylesheet" href="assets/css/plugins/magnific-popup/magnific-popup.css">
    <!-- Main CSS File -->
    <link rel="stylesheet" href="assets/css/style.css">
    <link rel="stylesheet" href="assets/css/plugins/nouislider/nouislider.css">
</head>

<body>
    <div class="page-wrapper">
        <!--Header-->
            <%@ include file="header-customerView.jsp"%>

        <main class="main">
            <nav aria-label="breadcrumb" class="breadcrumb-nav border-0 mb-0">
                <div class="container d-flex align-items-center">
                  
                    
                </div><!-- End .container -->
            </nav><!-- End .breadcrumb-nav -->

        
            <div class="page-content">
                <div class="container">
                    <div class="product-details-top ">
                        <div class="row">
                            
                            
                            
                            <div class="col-md-6">
                                <div class="product-gallery">
                                        <figure class="product-main-image">
                                            <img id="product-zoom" src="<%= prod.getProdImage()%>" data-zoom-image="<%= prod.getProdImage()%>" alt="product image">

                                            <a href="#" id="btn-product-gallery" class="btn-product-gallery">
                                                <i class="icon-arrows"></i>
                                            </a>
                                        </figure><!-- End .product-main-image -->
                                </div><!-- End .product-gallery -->
                            </div><!-- End .col-md-6 -->
                            
                            <%
                            DAReview reviewDA = new DAReview();
                            ArrayList<Cart> cartForReview = reviewDA.getAllReviewDataSameProductID(prod);
                            
                            int totalReviewRating = 0 ;
                            double percentageTotalRating = 0 ;
                            
                            for(int i = 0 ; i<cartForReview.size();i++){
                                totalReviewRating+=cartForReview.get(i).getReview().getReviewRating();
                            }
                            
                            percentageTotalRating = (double)totalReviewRating/(cartForReview.size()*5)*100;
                            

                            %>
                            <div class="col-md-6">
                                <div class="product-details">
                                    <h1 class="product-title"><%= prod.getProdName()%></h1><!-- End .product-title -->

                                    <div class="ratings-container">
                                        <div class="ratings">
                                            <%if(cartForReview.size()==0){%>
                                            <div class="ratings-val" style="width: 0%;"></div><!-- End .ratings-val -->
                                            <%}else{%>
                                            <div class="ratings-val" style="width: <%=percentageTotalRating%>%;"></div><!-- End .ratings-val -->
                                            <%}%>
                                        </div><!-- End .ratings -->
                                        <a class="ratings-text" href="#product-review-link" id="review-link">( <%=cartForReview.size()%> Reviews )</a>
                                    </div><!-- End .rating-container -->

                                    <div class="product-price">
                                        RM <%= String.format("%.2f",prod.getProdPrice())%>
                                    </div><!-- End .product-price -->

                                    <div class="product-content">
                                        <p><%= prod.getProdDesc()%></p>
                                    </div><!-- End .product-content -->
                                
                                    <form method = "post" action="CartController_Customer_AddToCart">
                                    <div class="details-filter-row details-row-size">
                                        <label for="color">Color:</label>
                                        
                                        <% DASKU skuda = new DASKU();
                                           ArrayList<String> colorList = skuda.getAllColour(prod);
                                           ArrayList<SKU> sizeList = skuda.getAllSizeUnderColour(prod,colorList.get(0));
                                           
                                        %>
                                        <div class="select-custom">
                                            <select name="color" id="color" class="form-control" onchange="switchSize()" required>
                                                <%for(int i = 0 ; i < colorList.size() ; i++){ %>
                                                <option value="<%=colorList.get(i)%>"><%=colorList.get(i)%></option>
                                                <%}
                                                %>
                                            </select>
                                        </div><!-- End .product-nav -->
                                    </div><!-- End .details-filter-row -->

                                    <div class="details-filter-row details-row-size">
                                        <label for="size">Size:</label>
                                        <div class="select-custom">
                                            <select name="size" id="size" class="form-control" required>
                                                <% for(int j = 0 ; j < sizeList.size() ; j++){%>
                                                <option value="<%=sizeList.get(j).getProdSize()%>"><%=sizeList.get(j).getProdSize()%></option>
                                                <%} %>
                                            </select>
                                        </div><!-- End .select-custom -->

                                    </div><!-- End .details-filter-row -->
                                    
                                    <%
                                    //use for changing the variation after user have choose the variation 
                                    //dummy data
                                     ArrayList<SKU> skuForUsed = skuda.getAllSKUbyProductID(prod);
                                    for(int i = 0 ; i < skuForUsed.size();i++){
                                    %>
                                    <input type="hidden" id="colourNU<%=i%>" value="<%=skuForUsed.get(i).getColour()%>" >
                                    <input type="hidden"id="sizeNU<%=i%>" value="<%=skuForUsed.get(i).getProdSize()%>">  
                                    <%}%>

                                    <div class="details-filter-row details-row-size">
                                        <label for="qty">Qty:</label>
                                        <div class="product-details-quantity">
                                            <input type="number" name="qty" id="qty" class="form-control" value="1" min="1" max="10" step="1" data-decimals="0" required>
                                        </div><!-- End .product-details-quantity -->
                                    </div><!-- End .details-filter-row -->

                                    <div class="product-details-action">
                                        <input name="productID" type ="hidden" value ="<%= prod.getProdID()%>"/>
                                        <input type="submit" value="Add To Cart" class="btn-product btn-cart"/>
                                    </div><!-- End .product-details-action -->
                                </form> 
                                    <div class="product-details-footer">
                                        <div class="product-cat">
                                            <span>Category:</span>
                                            <a href="Product_Category-customerView.jsp"><%= prod.getProdCategory()%></a>
                                        </div><!-- End .product-cat -->
                                    </div><!-- End .product-details-footer -->
                                    
                                </div><!-- End .product-details -->
                            </div><!-- End .col-md-6 -->
                            
                            
                        </div><!-- End .row -->
                    </div><!-- End .product-details-top -->

                    <div class="product-details-tab">
                        <ul class="nav nav-pills justify-content-center" role="tablist">
                          <a class="nav-link" id="product-review-link" data-toggle="tab" href="#product-review-tab" role="tab"  >Reviews</a>
                        </ul>
                      
                        <div class="tab-pane fade show active" id="product-review-tab" role="tabpanel">
                                <div class="reviews">
                                    <h3><%=cartForReview.size()%> Reviews </h3>
                                    
                                    <%for(int i = 0 ; i < cartForReview.size() ; i++){
                                        DACustomer customerDA = new DACustomer();
                                        Customer localCustomer = customerDA.displaySpecificCustomer(cartForReview.get(i).getCustomer().getUserID());
                                        DASKU skuDA = new DASKU();
                                        
                                        SKU localSKU = skuDA.getSKU(cartForReview.get(i).getSKU().getSkuNo());
                                    %>
                                    
                                    <div class="review">
                                        <div class="row no-gutters">
                                            <div class="col-auto">
                                                <h4><a href="#"><%=localCustomer.getUsername()%></a></h4>
                                                <div class="ratings-container">
                                                    <div class="ratings">
                                                        <div class="ratings-val" style="width: <%=cartForReview.get(i).getReview().getReviewRating()*2*10 %>%;"></div><!-- End .ratings-val -->
                                                    </div><!-- End .ratings -->
                                                </div><!-- End .rating-container -->
                                                <span class="review-date"><%= cartForReview.get(i).getReview().getFormatDate() %></span>
                                            </div><!-- End .col -->
                                            <div class="col">
                                                <h3>Size : <%=localSKU.getProdSize()%> Colour : <%=localSKU.getColour()%></h3>

                                                <div class="review-content">
                                                    <p><%=cartForReview.get(i).getReview().getReviewDesc()%></p>
                                                </div><!-- End .review-content -->
                                            </div><!-- End .col-auto -->
                                        </div><!-- End .row -->
                                    </div><!-- End .review -->
                                    <% } %>
                                    
                                </div><!-- End .reviews -->
                            </div><!-- .End .tab-pane -->
                        </div><!-- End .tab-content -->
                    </div><!-- End .product-details-tab -->
                </div><!-- End .container -->
            </div><!-- End .page-content -->
            
        
        </main><!-- End .main -->

       <!--Footer--> 
                        <%@ include file="footer-customerView.jsp"%> 
    </div><!-- End .page-wrapper -->
    <button id="scroll-top" title="Back to Top"><i class="icon-arrow-up"></i></button>

    
    <!-- Mobile Menu -->
    <div class="mobile-menu-overlay"></div><!-- End .mobile-menu-overlay -->

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
    <script src="assets/js/bootstrap-input-spinner.js"></script>
    <script src="assets/js/jquery.elevateZoom.min.js"></script>
    <script src="assets/js/bootstrap-input-spinner.js"></script>
    <script src="assets/js/jquery.magnific-popup.min.js"></script>
    <!-- Main JS File -->
    <script src="assets/js/main.js"></script>
    
    <script>
        
    function switchSize(){
        var colorSelected = document.getElementById("color").value;
        let sizeStr = "sizeNU";
        let colourStr = "colourNU";
        console.log(colorSelected);
        //console.log(document.getElementById("sizeNU0").value);
        //console.log(document.getElementById("colourNU0").value);
        
        //change the option value
        var x = document.getElementById("size");
        
        for(let i = 0 ; i < <%=skuForUsed.size()%>;i++){
            var size = document.getElementById(sizeStr.concat(i)).value;
            var colour = document.getElementById(colourStr.concat(i)).value;
        
        
        //if the colour selected is the same color under the sku
            if(colorSelected.localeCompare(colour)===0){
                var newoption = document.createElement("option");
                newoption.text = size;
                x.add(newoption);
            }
            else{
                x.remove(size);
            }
            
        }
    }
        
        
        
        
    </script>
</body>


<!-- molla/product.html  22 Nov 2019 09:55:05 GMT -->
</html>