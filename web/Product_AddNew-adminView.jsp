<%-- 
    Document   : Product_AddNew-adminView
    Created on : Apr 3, 2022, 10:16:01 PM
    Author     : Ashley
--%>
<%@ page errorPage="404Error.jsp" %>  
<%@page import="Model.Domain.Admin"%>
<%
    Admin admin = (Admin) session.getAttribute("admin");
%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page errorPage="404Error.jsp" %>

<!DOCTYPE html>
<html>
    <style>
        input[type=number]{
            padding: 12px 20px;
            margin: 8px 0;
            display: inline-block;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box;
            width: 90%;
        }
        input[type="file"] {
            margin: 8px 0;
        }

    </style>
    <head>
        <meta charset="utf-8" />
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
        <link rel="shortcut icon" type="image/x-icon" href="assets/siteIcon.png" />
        <title> New Product - Fast&Fashion</title>
        <link href="css/styles.css" rel="stylesheet" />
        <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/js/all.min.js" crossorigin="anonymous"></script>
        <script src="components/topNavBar.js" type="text/javascript" defer></script>
        <script src="components/middleNavBar.js" type="text/javascript" defer></script>
        <script src="components/footer.js" type="text/javascript" defer></script>
        <script src="components/Product_header.js" type="text/javascript" defer></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
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
                    <!--Content Page-->
                    <div class="container-fluid px-4">
                        <!--Page Title-->
                        <h1 class="mt-4"><product-header></product-header></h1>
                        <div class="card mb-4" id="innerPart">
                            <div class="card-header">
                                <i class="fa fa-info-circle" class="sb-nav-link-icon" style="font-size:28px; color: #353535;"></i>
                                <!--Table Title, action perform ?-->
                                New   
                                <!--Action link to search record, link back to summary page-->
                                <a href="Product_Summary-adminView.jsp" ><i class="fa fa-filter" id="tableHeader-link-icon" ></i></a>
                                <!--Action link to add new record page-->
                                <a href="Product_AddNew-adminView.jsp" ><i class="fa fa-sticky-note" id="tableHeader-link-icon" ></i></a>
                            </div>
                            <div class="card-body">                
                                <!--Form that will collect & pass data-->
                                <form method="post" action="ProductController_Admin_AddNew" enctype="multipart/form-data">
                                    <!--input field, note: max 2 col per row only-->
                                    <table class="contentPage-table">
                                        <tr>
                                            <td>
                                                <label for="prodID">Product ID</label><br/>
                                                <input type="text" id="prodID" name="prodID" disabled="disabled" style="background-color:lightgray; opacity:0.5;" />
                                            </td>
                                            <td>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <label for="prodName">Product Name*</label><br/>
                                                <input type="text" id="prodName" name="prodName" maxlength = "100" required />
                                            </td>
                                            <td>
                                                <label for="prodDesc">Product Description*</label><br/>
                                                <input type="text" id="prodDesc" name="prodDesc" maxlength = "500" required />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <label for="prodPrice">Product Price*</label><br/>
                                                <input type="number" min="1.00" max="99999999.99" step="0.01" id="prodPrice" name="prodPrice" required="required" />
                                            </td>
                                            <td>
                                                <label for="prodCategory">Product Category*</label><br/>
                                                <select name="prodCategory" required>
                                                    <option value= "" hidden>Select your option...</option>
                                                    <option value = "WomenTops">Women Tops</option>
                                                    <option value = "WomenSweatshirts">Women Sweatshirts</option>
                                                    <option value = "WomenBottoms">Women Bottoms</option>
                                                    <option value = "WomenDresses">Women Dresses</option>
                                                    <option value = "MenTops">Men Tops</option>
                                                    <option value = "MenSweatshirts">Men Sweatshirts</option>
                                                    <option value = "MenBottoms">Men Bottoms</option>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <label for="prodImage">Product Image*</label><br/>
                                                <input type="file" id="prodImage" name="prodImage" required />
                                            </td>
                                            <td>
                                            </td>
                                        </tr>
                                    </table>
                                    <br/><br/>

                                    <!--next button that will call the action-->
                                    <br/><br/><button id="action-button" type="submit" name="next"><i class="fa fa-chevron-right"></i></button><br/><br/><br/><br/>
                            </div>
                        </div>
                    </div>
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
