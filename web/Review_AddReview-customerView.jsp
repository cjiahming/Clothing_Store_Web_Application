<%@page import="Model.Domain.Review"%>
<%@page import="Model.DA.DAReview"%>

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
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.ArrayList"%>


<%@page import = "Model.Domain.SKU"%>
<%@page import = "Model.Domain.Cart"%>
<%@page import = "Model.DA.DACart"%>
<%@page import = "Model.DA.DAProduct"%>
<%@page import = "Model.DA.DASKU"%>
<%@page import = "Model.Domain.Order"%>
<%@page import = "Model.DA.DAOrder"%>
<%@page import = "Model.Domain.Product"%>
<%@page import = "Model.DA.DAProduct"%>



<!-- molla/dashboard.html  22 Nov 2019 10:03:13 GMT -->
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
    <link rel="stylesheet" href="assets/css/popupGabriel.css">
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
            
            
</script>

<style>

                .star-cb-group {
                    /* remove inline-block whitespace */
                    font-size: 0;
                    /* flip the order so we can use the + and ~ combinators */
                    unicode-bidi: bidi-override;
                    direction: rtl;
                    /* the hidden clearer */
                }
                .star-cb-group * {
                    font-size: 1rem;
                }
                .star-cb-group > input {
                    display: none;
                }
                .star-cb-group > input + label {
                    /* only enough room for the star */
                    display: inline-block;
                    overflow: hidden;
                    text-indent: 9999px;
                    width: 1em;
                    white-space: nowrap;
                    cursor: pointer;
                }
                .star-cb-group > input + label:before {
                    display: inline-block;
                    text-indent: -9999px;
                    content: "☆";
                    color: #888;
                }
                .star-cb-group > input:checked ~ label:before, .star-cb-group > input + label:hover ~ label:before, .star-cb-group > input + label:hover:before {
                    content: "★";
                    color: #e52;
                    text-shadow: 0 0 1px #333;
                }
                .star-cb-group > .star-cb-clear + label {
                    text-indent: -9999px;
                    width: .5em;
                    margin-left: -.5em;
                }
                .star-cb-group > .star-cb-clear + label:before {
                    width: .5em;
                }
                .star-cb-group:hover > input + label:before {
                    content: "☆";
                    color: #888;
                    text-shadow: none;
                }
                .star-cb-group:hover > input + label:hover ~ label:before, .star-cb-group:hover > input + label:hover:before {
                    content: "★";
                    color: #e52;
                    text-shadow: 0 0 1px #333;
                }
                
                .reviewContainer{
                    margin: 0 auto;
                    width: 45%;
                    top: 50%;
                    text-align:center;
                }
                
                .img-container {
                text-align: center;
                }

                .tab-content{
                    padding: 50px 25px;
                    margin: auto;
                    width: 100%;
                    background: white;
                    box-shadow: 0 0 20px lightgrey;
                }

                .sameline{
                    width: 100%;
                }

                .sameline input{
                    display: block;
                    padding: 10px;
                    margin-bottom: 18px;
                    outline: none;
                    color: black;
                    transition: 0.4s;
                    width: 100%;
                    height: 38px;
                    border-radius: 2px;
                    border: 1px solid #ccc;
                }

                .review-h3{
                    color: #4A4A4A; 
                    margin-top: 5px;
                    border-bottom: 1px solid darkgrey;
                    padding-bottom: 7px;
                }

                .address-div-body button{
                    padding: 10px;
                    min-width: 120px;
                    border: none;
                    color: white;
                    cursor: pointer;
                    transition: 0.4s;
                    width: 100%;  
                }

                .inner
                {
                    display: inline-block;
                }

                .footer .cancelbtn{
                    display: inline-block;
                    color: #161616;
                    background-color: white;
                }

                .footer .addReviewBtn{
                    display: inline-block;
                    background-color: #c96;
                }

                .footer .cancelbtn:hover {
                    background: lightgrey;
                }

                .footer .addReviewBtn:hover {
                    background: goldenrod;
                }
            </style>
</head>

<body>
    <div class="page-wrapper">
        <!--Header-->
            
            
            
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
	                		

	                		<div  class="reviewContainer">
	                			<div class="tab-content">
								    <div class="tab-pane fade show active" id="tab-dashboard" role="tabpanel" aria-labelledby="tab-dashboard-link" >
                                                                                <form action="ReviewController_Customer_AddReview" method="get" class="customers-address-form">    
                                                                                                                    <%DACart cartDA = new DACart();
                                                                                                                          DAProduct productDA = new DAProduct();
                                                                                                                          DASKU skuDA = new DASKU();
                                                                                                                          DAReview reviewDA = new DAReview();
                                                                                                                          
                                                                                                                          Cart cartLocal = cartDA.getRecord(request.getParameter("submit"));
                                                                                                                          SKU skuLocal = skuDA.getSKU(cartLocal.getSKU().getSkuNo());
                                                                                                                          Product product = productDA.getRecord(skuLocal.getProduct().getProdID());
                                                                                                                          Review review = reviewDA.getReview(cartLocal.getReview().getReviewID());
                                                                                                                          
                                                                                                                          if(cartLocal.getReview().getReviewID()==null){
                                                                                                                          %>
                                                                                                                        
                                                                                                                        <h3>Add New Review </h3>
                                                                                                                        <%}else{%>
                                                                                                                        <h3>Edit Review </h3>
                                                                                                                        
                                                                                                                        <%}%>
                                                                                                                      </div>
                                                                                                                
                                                                                                                      <div class="address-div-body">
                                                                                                                          
                                                                                                                        
                                                                                                                          <label>Product : <%=product.getProdName()%></label><br>
                                                                                                                         <img src="<%=product.getProdImage() %>" alt="Product image" width="30%" length="30%" style="margin-left:auto ; margin-right: auto">
                                                                                                                          <label>Size :<%=skuLocal.getProdSize()%></label><br>
                                                                                                                          <label>Colour :<%=skuLocal.getColour()%></label><br>
                                                                                                                          <label>Quantity :<%=cartLocal.getQty()%></label><br>
                                                                                                                          <div class="sameline">
                                                                                                                              <label>Review Description</label>
                                                                                                                              <%if(review.getReviewDesc()!=null){%>
                                                                                                                              <!--<textarea name="reviewDesc" cols="50" rows="3" style="background-color: white;word-break:break-all" ><%=review.getReviewDesc()%></textarea>-->
                                                                                                                               <input name="reviewDesc" cols="50" rows="3" style="background-color: white;word-break:break-all">
                                                                                                                              <%}else{%>
                                                                                                                              <!--<textarea name="reviewDesc" cols="50" rows="3" style="background-color: white;word-break:break-all" ></textarea>-->
                                                                                                                              <input name="reviewDesc" cols="50" rows="3" style="background-color: white;word-break:break-all">
                                                                                                                              <%}%>
                                                                                                                              <br><small style="color: red">${ReviewdescErrMsg}</small><br>
                                                                                                                              
                                                                                                                              
                                                                                                                              
                                                                                                                              <label>Rating</label>
                                                                                                                              
                                                                                                                          </div>
                                                                                                                              
                                                                                                                            <select name="rate">
                                                                                                                            <%if(review.getReviewRating()==5){
                                                                                                                            %>
                                                                                                                            <option value="5" selected>5 Star</option>
                                                                                                                            <%}else{%>
                                                                                                                            <option value="5" >5 Star</option>
                                                                                                                            <%}%>
                                                                                                                            
                                                                                                                            <%if(review.getReviewRating()==4){
                                                                                                                            %>
                                                                                                                            <option value="4" selected>4 Star</option>
                                                                                                                            <%}else{%>
                                                                                                                            <option value="4" >4 Star</option>
                                                                                                                            <%}%>
                                                                                                                            
                                                                                                                            <%if(review.getReviewRating()==3){
                                                                                                                            %>
                                                                                                                            <option value="3" selected>3 Star</option>
                                                                                                                            <%}else{%>
                                                                                                                            <option value="3" >3 Star</option>
                                                                                                                            <%}%>
                                                                                                                            
                                                                                                                            <%if(review.getReviewRating()==2){
                                                                                                                            %>
                                                                                                                            <option value="2" selected>2 Star</option>
                                                                                                                            <%}else{%>
                                                                                                                            <option value="2" >2 Star</option>
                                                                                                                            <%}%>
                                                                                                                            
                                                                                                                            <%if(review.getReviewRating()==1){
                                                                                                                            %>
                                                                                                                            <option value="1" selected>1 Star</option>
                                                                                                                            <%}else{%>
                                                                                                                            <option value="1" >1 Star</option>
                                                                                                                            <%}%>
                                                                                                                            
                                                                                                                          </select>
                                                                                                                          <br><small style="color: red">${ReviewrateErrMsg}</small>  
                                                                                                                          <br><br><br><br>
                                                                                                                          
                                                                                                                          
                                                                                                                              
                                                                                                                              <div class="footer" >
                                                                                                                                <div class="inner"><a href="Customer_ManageProfile_customerView.jsp"><button type="button" class="cancelbtn">Cancel</button></a></button></div>
                                                                                                                                <div class="inner"><button type="submit" class="addReviewBtn" name="submit" value="<%=cartLocal.getCartItemID()%>" >Add Review</button></div>
                                                                                                                      </div>
                                                                                                                     

								    </div><!-- .End .tab-pane -->
                                                                     </form>
                                                                    
								    
								    

								    <div class="tab-pane fade" id="tab-downloads" role="tabpanel" aria-labelledby="tab-downloads-link">
								    	<p>No downloads available yet.</p>
								    	<a href="category.html" class="btn btn-outline-primary-2"><span>GO SHOP</span><i class="icon-long-arrow-right"></i></a>
								    </div><!-- .End .tab-pane -->

								    <div class="tab-pane fade" id="tab-address" role="tabpanel" aria-labelledby="tab-address-link">
								    	<p>The following addresses will be used on the checkout page by default.</p>

								    	<div class="row">
								    		<div class="col-lg-6">
								    			<div class="card card-dashboard">
								    				<div class="card-body">
								    					<h3 class="card-title">Billing Address</h3><!-- End .card-title -->

														<p>User Name<br>
														User Company<br>
														John str<br>
														New York, NY 10001<br>
														1-234-987-6543<br>
														yourmail@mail.com<br>
														<a href="#">Edit <i class="icon-edit"></i></a></p>
								    				</div><!-- End .card-body -->
								    			</div><!-- End .card-dashboard -->
								    		</div><!-- End .col-lg-6 -->

								    		<div class="col-lg-6">
								    			<div class="card card-dashboard">
								    				<div class="card-body">
								    					<h3 class="card-title">Shipping Address</h3><!-- End .card-title -->

														<p>You have not set up this type of address yet.<br>
														<a href="#">Edit <i class="icon-edit"></i></a></p>
								    				</div><!-- End .card-body -->
								    			</div><!-- End .card-dashboard -->
								    		</div><!-- End .col-lg-6 -->
								    	</div><!-- End .row -->
								    </div><!-- .End .tab-pane -->

								    <div class="tab-pane fade" id="tab-account" role="tabpanel" aria-labelledby="tab-account-link">
								    	
			                				<div class="row">
			                					<div class="col-sm-6">
			                						<label>First Name *</label>
			                						<input type="text" class="form-control" required>
			                					</div><!-- End .col-sm-6 -->

			                					<div class="col-sm-6">
			                						<label>Last Name *</label>
			                						<input type="text" class="form-control" required>
			                					</div><!-- End .col-sm-6 -->
			                				</div><!-- End .row -->

		            						<label>Display Name *</label>
		            						<input type="text" class="form-control" required>
		            						<small class="form-text">This will be how your name will be displayed in the account section and in reviews</small>

		                					<label>Email address *</label>
		        							<input type="email" class="form-control" required>

		            						<label>Current password (leave blank to leave unchanged)</label>
		            						<input type="password" class="form-control">

		            						<label>New password (leave blank to leave unchanged)</label>
		            						<input type="password" class="form-control">

		            						<label>Confirm new password</label>
		            						<input type="password" class="form-control mb-2">

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

        <!--Footer--> 
                        <%@ include file="footer-customerView.jsp"%> 
    </div><!-- End .page-wrapper -->
    <button id="scroll-top" title="Back to Top"><i class="icon-arrow-up"></i></button>

    <!-- Mobile Menu -->
    <div class="mobile-menu-overlay"></div><!-- End .mobil-menu-overlay -->

    <div class="mobile-menu-container">
        <div class="mobile-menu-wrapper">
            <span class="mobile-menu-close"><i class="icon-close"></i></span>

            
            
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
</body>


<!-- molla/dashboard.html  22 Nov 2019 10:03:13 GMT -->
</html>