<%-- 
    Document   : Dashboard-adminView
    Created on : Apr 12, 2022, 10:29:32 PM
    Author     : jiyeo
--%>
<%@ page errorPage="404Error.jsp" %>  
<%@page import="Model.Domain.Admin"%>
<%
    Admin admin = (Admin) session.getAttribute("admin");
%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
        <link rel="shortcut icon" type="image/x-icon" href="assets/siteIcon.png" />
        <title> Stock Adjustment - Fast&Fashion </title>
        <link href="css/styles.css" rel="stylesheet" />
        <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/js/all.min.js" crossorigin="anonymous"></script>
        <script src="components/topNavBar.js" type="text/javascript" defer></script>
        <script src="components/middleNavBar.js" type="text/javascript" defer></script>
        <script src="components/footer.js" type="text/javascript" defer></script>
        <script src="components/StockAd_header.js" type="text/javascript" defer></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
        <style>
            main{background-color: #F2F2F2;}
            *, *:before, *:after {
                box-sizing: inherit;
            }

            .column {
                float: left;
                width: 30%;
                margin-bottom: 16px;
                padding: 0 8px;
                margin-top: -200px;
                margin-left: 30px;
            }

            .column2 {
                float: left;
                width: 30%;
                margin-bottom: 16px;
                padding: 0 8px;
                margin-left: 30px;
            }

            .card {
                box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);
                margin: 8px;
            }

            .card:hover {
                box-shadow: 0 4px 8px 0 rgba(0, 0, 0);
                margin: 8px;
            }

            .about-section {
                padding-top: 20px;
                text-align: center;
                background-color: #474e5d;
                color: black;
                height: 450px;
                background-image: url('assets/dashImg.jpg');
            }

            .container {
                padding: 0 16px;
            }

            .container img{
                display: block;
                margin-left: auto;
                margin-right: auto;
            }


            .container::after, .row::after {
                content: "";
                clear: both;
                display: table;
            }

            .title {
                color: black;
                text-align: center;
            }

            .button:hover {
                background-color: #555;
            }


        </style>
    </head>
    <body>
        <nav class="sb-topnav navbar navbar-expand navbar-dark bg-dark">
            <header-component></header-component>
        </nav>
        <div id="layoutSidenav">
            <div id="layoutSidenav_nav">
                <nav class="sb-sidenav accordion sb-sidenav-dark" id="sidenavAccordion">
                    <div class="sb-sidenav-menu"><middle-component></middle-component></div>
                    <div class="sb-sidenav-footer">
                        <!--pass in logged in user details-->
                        <div class="small">Logged in as:</div>
                        <%= admin.getUsername()%>
                        <a href="LogoutConfirmation.html"><i class="fas fa-sign-out-alt" id="sideBarIcon" style="float:right;margin-right:10px;"></i></a>
                    </div>
                </nav>
            </div>
            <div id="layoutSidenav_content">
                <main>
                        <div class="about-section">
                            <% if (admin.getGender().equalsIgnoreCase("male")) { %>
                            <img src="assets/maleProfile.png" alt="Profile" style="height: 110px;">
                            <% } else { %>
                            <img src="assets/femaleProfile.png" alt="Profile" style="height: 110px;">
                            <% }%>
                            <p><span style="font-size: 32px;letter-spacing: 1.5px;">Welcome back,<b> <%= admin.getFirstName()%> </b> !</span></p>
                            <p style="font-size: 15px;letter-spacing: 0.5px;">What would you like to start with today ?</p>                    
                            <svg viewBox="0 0 1440 319" >
                            <path fill="#F2F2F2" fill-opacity="1" d="M0,32L48,80C96,128,192,224,288,224C384,224,480,128,576,90.7C672,53,768,75,864,96C960,117,1056,139,1152,149.3C1248,160,1344,160,1392,160L1440,160L1440,320L1392,320C1344,320,1248,320,1152,320C1056,320,960,320,864,320C768,320,672,320,576,320C480,320,384,320,288,320C192,320,96,320,48,320L0,320Z"></path>
                            </svg>
                        </div>

                    <a href="Product_Summary-adminView.jsp">
                        <div class="column">
                            <div class="card" style="background-color: #E9CCB1;">
                                <div class="container">
                                    <p class="title">Product Information</p>
                                    <img src="assets/dashProduct.svg" alt="Profile" style="height: 220px;margin-top: -20px;">
                                </div>
                            </div>
                        </div>
                    </a>

                    <a href="Sales_Summary-adminView.jsp">
                        <div class="column" >
                            <div class="card" style="background-color: #C4BDAC;">
                                <div class="container">
                                    <p class="title">Sales Order</p>
                                    <img src="assets/dashSales.svg" alt="Profile" style="height: 220px;margin-top: -20px;">
                                </div>
                            </div>
                        </div>
                    </a>

                    <a href="Customer_Summary-adminView.jsp">
                        <div class="column">
                            <div class="card" style="background-color: #999999;">
                                <div class="container">
                                    <p class="title">Customer Information</p>
                                    <img src="assets/dashCustomer.svg" alt="Profile" style="height: 220px;margin-top: -20px;">
                                </div>
                            </div>
                        </div>
                    </a>

                    <a href="SKU_Summary-adminView.jsp">
                        <div class="column2">
                            <div class="card" style="background-color: #EBCFC4;">
                                <div class="container">
                                    <p class="title">SKU Information</p>
                                    <img src="assets/dashSKU.svg" alt="Profile" style="height: 220px;margin-top: -20px;">
                                </div>
                            </div>
                        </div>
                    </a>

                    <a href="Sales_UpdateStatus-adminView.jsp">
                        <div class="column2">
                            <div class="card" style="background-color: #EAE2CE;">
                                <div class="container">
                                    <p class="title">Sales Status</p>
                                    <img src="assets/dashSalesStatus.svg" alt="Profile" style="height: 220px;margin-top: -20px;">
                                </div>
                            </div>
                        </div>
                    </a>

                    <a href="Review_Summary-adminView.jsp">
                        <div class="column2">
                            <div class="card" style="background-color: #D3C4BE;">
                                <div class="container">
                                    <p class="title">Reviews</p>
                                    <img src="assets/dashReview.svg" alt="Profile" style="height: 220px;margin-top: -20px;">
                                </div>
                            </div>
                        </div>
                    </a>
                    <a href="StockAdjustment_Summary-adminView.jsp">
                        <div class="column2">
                            <div class="card" style="background-color: #F0E6E0;">
                                <div class="container">
                                    <p class="title">Stock Adjustment</p>
                                    <img src="assets/dashStockAdjustment.svg" alt="Profile" style="height: 220px;margin-top: -20px;">
                                </div>
                            </div>
                        </div>
                    </a>

                    <a href="SKUEnquiry_Summary-adminView.jsp">
                        <div class="column2">
                            <div class="card" style="background-color: #F4EEE1;">
                                <div class="container">
                                    <p class="title">SKU Enquiry</p>
                                    <img src="assets/dashReport.svg" alt="Profile" style="height: 220px;margin-top: -20px;">
                                </div>
                            </div>
                        </div>
                    </a>

                    <a href="Refund_Summary-adminView.jsp">
                        <div class="column2">
                            <div class="card" style="background-color: #EFEEEE;">
                                <div class="container">
                                    <p class="title">Refund</p>
                                    <img src="assets/dashRefund.svg" alt="Profile" style="height: 220px;margin-top: -20px;">
                                </div>
                            </div>
                        </div>
                    </a>

                </main>
                <!--footer-->
                <footer class="py-4 bg-light mt-auto">
                    <footer-component></footer-component>
                </footer>
            </div>


        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
        <script src="js/scripts.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/simple-datatables@latest" crossorigin="anonymous"></script>
        <script src="js/datatables-simple-demo.js"></script>
    </body>
</html>

