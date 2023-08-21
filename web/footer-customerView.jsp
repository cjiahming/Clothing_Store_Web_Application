<%-- 
    Document   : footer-custoemrView
    Created on : Apr 11, 2022, 5:57:17 PM
    Author     : Ashley
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <body>
        <footer class="footer">
            <div class="footer-middle">
                <div class="container">
                    <div class="row">
                        <div class="col-sm-6 col-lg-3">
                            <div class="widget widget-about">
                                <img src="assets/logo_whtbg.png" alt="F&F Logo" width="260" height="80">
                                <p>Award winning clothing brand, Fast&Fashion deliver clothing designs for any style or trend. Shop Now! </p>

                                <div class="social-icons">
                                    <a href="#" class="social-icon" target="_blank" title="Facebook"><i class="icon-facebook-f"></i></a>
                                    <a href="#" class="social-icon" target="_blank" title="Twitter"><i class="icon-twitter"></i></a>
                                    <a href="#" class="social-icon" target="_blank" title="Instagram"><i class="icon-instagram"></i></a>
                                    <a href="#" class="social-icon" target="_blank" title="Youtube"><i class="icon-youtube"></i></a>
                                    <a href="#" class="social-icon" target="_blank" title="Pinterest"><i class="icon-pinterest"></i></a>
                                </div><!-- End .soial-icons -->
                            </div><!-- End .widget about-widget -->
                        </div><!-- End .col-sm-6 col-lg-3 -->

                        <div class="col-sm-6 col-lg-3">
                            <div class="widget">
                                <h4 class="widget-title">Useful Links</h4><!-- End .widget-title -->

                                <ul class="widget-list">
                                    <li><a href="Product_SelectCategory-customerView.jsp">Back to Home Page</a></li>
                                </ul><!-- End .widget-list -->
                            </div><!-- End .widget -->
                        </div><!-- End .col-sm-6 col-lg-3 -->

                        <div class="col-sm-6 col-lg-3">
                            <div class="widget">
                                <h4 class="widget-title">Our Products</h4><!-- End .widget-title -->

                                <ul class="widget-list">
                                    <li><a href="ProductController_Customer_Category?prodCategory=WomenTops">Women Tops Gallery</a></li>
                                    <li><a href="ProductController_Customer_Category?prodCategory=WomenDresses">Women Dresses Gallery</a></li>
                                    <li><a href="ProductController_Customer_Category?prodCategory=WomenBottoms">Women Bottoms Gallery</a></li>
                                    <li><a href="ProductController_Customer_Category?prodCategory=WomenSweatshirts">Women Sweatshirts Gallery</a></li>
                                    <li><a href="ProductController_Customer_Category?prodCategory=MenTops">Men Tops Gallery</a></li>
                                    <li><a href="ProductController_Customer_Category?prodCategory=MenBottoms">Men Bottoms Gallery</a></li>
                                    <li><a href="ProductController_Customer_Category?prodCategory=MenSweatshirts">Men Sweatshirts Gallery</a></li>
                                </ul><!-- End .widget-list -->
                            </div><!-- End .widget -->
                        </div><!-- End .col-sm-6 col-lg-3 -->

                        <div class="col-sm-6 col-lg-3">
                            <div class="widget">
                                <h4 class="widget-title">My Account</h4><!-- End .widget-title -->

                                <ul class="widget-list">
                                    <li><a href="Cart_displayCart-customerView.jsp">View Cart</a></li>
                                    
                                </ul><!-- End .widget-list -->
                            </div><!-- End .widget -->
                        </div><!-- End .col-sm-6 col-lg-3 -->
                    </div><!-- End .row -->
                </div><!-- End .container -->
            </div><!-- End .footer-middle -->

            <div class="footer-bottom">
                <div class="container">
                    <p class="footer-copyright">Copyright © 2022 F&F Store. All Rights Reserved.</p><!-- End .footer-copyright -->
                    <figure class="footer-payments">
                        <img src="assets/images/payments.png" alt="Payment methods" width="272" height="20">
                    </figure><!-- End .footer-payments -->
                </div><!-- End .container -->
            </div><!-- End .footer-bottom -->
        </footer><!-- End .footer -->
    </body>
</html>
