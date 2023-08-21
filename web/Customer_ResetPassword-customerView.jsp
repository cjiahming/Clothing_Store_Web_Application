<%-- 
    Document   : Admin_editProfile-adminView
    Author     : Choong Jiah Ming
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page errorPage="Customer_LoginPage_customerView.jsp"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>Reset Password Customer - Fast&Fashion</title>
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
        <link rel="stylesheet" href="assets/css/forgotpassword.css">
    </head>
    <body>
        <%@ include file="header-customerView.jsp"%>

        <div class="overlay">
            <div class="forgotpassword-container">
                <div class="header-forgotpassword">
                    <a href="#" class="previous round" onclick="history.back()">&lt;</a>
                    <h4>Reset Password</h4>
                </div>
                <div class="body-address">
                    <form action="ResetCustomerPasswordController" method="post" class="form">

                        <div class="sameline">
                            <input id="otpnumber" name="newpassword" type="password" placeholder="Enter New Password" />
                            <small style="color: red">${newPasswordErrMsg}</small>
                        </div>

                        <div class="sameline">
                            <input id="otpnumber" name="confirmnewpassword" type="password" placeholder="Re-Type New Password" />
                            <small style="color: red">${confirmNewPasswordErrMsg}</small>
                        </div>

                        <div class="footer">
                            <button type="submit" class="savebtn" style="padding: 5px 10px 5px 10px">Reset</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        <%@ include file="footer-customerView.jsp"%> 
    </body>
</html>
