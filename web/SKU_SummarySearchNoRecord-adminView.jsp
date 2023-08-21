<%-- 
    Document   : SKU_SummarySearchNoRecord-adminView
    Created on : Apr 4, 2022, 9:44:51 AM
    Author     : Cheng Cai Yuan
--%>
<%@ page errorPage="404Error.jsp" %>  
<%@page import="Model.Domain.Admin"%>
<%
    Admin admin = (Admin) session.getAttribute("admin");
%>
<%@page import="Model.DA.DASKU"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Model.Domain.SKU" %>
<%
    SKU sku = (SKU)session.getAttribute("sku");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
        <link rel="shortcut icon" type="image/x-icon" href="assets2/siteIcon.png" />
        <link href="css/styles.css" rel="stylesheet" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
        <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/js/all.min.js" crossorigin="anonymous"></script>
        <script src="components/topNavBar.js" type="text/javascript" defer></script>
        <script src="components/middleNavBar.js" type="text/javascript" defer></script>
        <script src="components/footer.js" type="text/javascript" defer></script>
        <script src="components/SKU_header.js" type="text/javascript" defer></script>
        <title>SKU Summary - Fast&Fashion</title>
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
                <!-------------------------------------------------------->
                <main>
                    <!--Content Page-->
                    <div class="container-fluid px-4">
                        <!--Page Title-->
                        <h1 class="mt-4"><sku-header></sku-header></h1>
                        <div class="card mb-4" id="innerPart">
                            <div class="card-header">
                                <i class="fa fa-info-circle" class="sb-nav-link-icon" style="font-size:28px; color: #353535;"></i>
                                <!--Table Title, action perform ?-->
                                Summary   
                                <!--Action link to link back to summary page-->
                                <a href='SKU_Summary-adminView.jsp' title="Summary"><i class="fa fa-filter" id="tableHeader-link-icon" ></i></a>
                                <!--Action link to add new record page-->
                                <a href='SKU_AddNew-adminView.jsp' title="Add New"><i class="fa fa-sticky-note" id="tableHeader-link-icon" ></i></a>
                            </div>
                            <div class="card-body">
                                <div class="card-body">
                                    <!--Form that will collect & pass data-->
                                    <form method="post" action="SKUController">
                                        <!--User can select all the 3 columns to search the sku record-->
                                        <table id="table-skuEnquiry">
                                            <tr>
                                                <td><label for="prodId">Product ID</label> <br/>
                                                     <input type="text" id="prodId" name="prodId" placeholder="Product ID">
                                                </td>
                                                <td>
                                                    <label for="colour">Colour</label><br/>
                                                    <select id="colour" name="colour">
                                                        <option value="White">White</option>
                                                        <option value="Black">Black</option>
                                                        <option value="Blue">Blue</option>
                                                        <option value="Red">Red</option>
                                                        <option value="Yellow">Yellow</option>
                                                        <option value="Green">Green</option>
                                                        <option value="Grey">Grey</option>
                                                        <option value="Orange">Orange</option>
                                                        <option value="Purple">Purple</option>
                                                        <option value="Pink">Pink</option>
                                                        <option value="Brown">Brown</option>
                                                        <option value="Maroon">Maroon</option>
                                                        <option value="Beige">Beige</option>
                                                    </select>
                                                </td>
                                                <td>
                                                    <label for="prodSize">Size</label><br/>
                                                    <select id="prodSize" name="prodSize">
                                                        <option value="S">S</option>
                                                        <option value="M">M</option>
                                                        <option value="L">L</option>
                                                        <option value="XL">XL</option>
                                                        <option value="XXL">XXL</option>
                                                        <option value="XXXL">XXXL</option>
                                                    </select>
                                                </td>
                                            </tr>
                                        </table>
                                        <!--search button that will call the action-->
                                        <button id="action-button" type="submit" name="action" value="search" style="margin-top: 5px;height: 40px;width: 40px;font-size: 18px;margin-right: 25px;"><i class="fa fa-search"></i></button><br/><br/><br/>
                                    </form>
                                
                                    <!--Form that will collect & pass data-->
                                    <form id="userGroup" method="post" action="SKUController">                     
                                        <table id="datatablesSimple">
                                            <!--Data Fields-->
                                            <thead id="view-thead">
                                                <tr>
                                                    <th>Action</th>
                                                    <th style="padding-right: 2px;">Line No. </th>
                                                    <th>SKU No</th>
                                                    <th>Product ID</th>
                                                    <th>Colour</th>
                                                    <th>Quantity</th>
                                                </tr>
                                            </thead>

                                            <!--Table Records-->
                                            <tbody>
                                                <tr>
                                                    <td></td>
                                                    <td></td>
                                                    <td style="text-align: right">No Records Found</td>
                                                    <td></td>   
                                                    <td></td>
                                                    <td></td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </form>
                                </div>
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
