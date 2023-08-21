<%-- 
    Document   : StockAdjustment_Edit-adminView
    Created on : Apr 8, 2022, 3:38:30 PM
    Author     : jiyeo
--%>
<%@ page errorPage="404Error.jsp" %>  
<%@page import="Model.Domain.Admin"%>
<%
    Admin admin = (Admin) session.getAttribute("admin");
%>
<%@page import="Model.Domain.StockAdjustment"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    StockAdjustment stockAd = (StockAdjustment) session.getAttribute("stockAdEdit");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
        <link rel="shortcut icon" type="image/x-icon" href="assets/siteIcon.png" />
        <title> Edit Stock Adjustment - Fast&Fashion </title>
        <link href="css/styles.css" rel="stylesheet" />
        <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/js/all.min.js" crossorigin="anonymous"></script>
        <script src="components/topNavBar.js" type="text/javascript" defer></script>
        <script src="components/middleNavBar.js" type="text/javascript" defer></script>
        <script src="components/footer.js" type="text/javascript" defer></script>
        <script src="components/StockAd_header.js" type="text/javascript" defer></script>
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
                        <h1 class="mt-4"><stock-header></stock-header></h1>
                        <div class="card mb-4" id="innerPart">
                            <div class="card-header">
                                <i class="fa fa-info-circle" class="sb-nav-link-icon" style="font-size:28px; color: #353535;"></i>
                                <!--Table Title, action perform ?-->
                                Edit   
                                <!--Action link to search record, link back to summary page-->
                                <a href="StockAdjustment_Summary-adminView.jsp" title="Summary"><i class="fa fa-filter" id="tableHeader-link-icon" ></i></a>
                                <!--Action link to add new record page-->
                                <a href="StockAdjustmentProcessRequestController?ac=new" title="Add New"><i class="fa fa-sticky-note" id="tableHeader-link-icon" ></i></a>
                            </div>
                            <div class="card-body">
                                <!--Form that will collect & pass data-->
                                <form method="get" action="StockAdjustmentProcessRequestController">
                                    <input type="hidden" name="ac" value="edit2" />
                                    <!--input field, note: max 2 col per row only-->
                                    <table class="contentPage-table">
                                        <tr>
                                            <td><label for="no">Stock Adjustment No.</label> <br/>
                                                <input type="text" id="stockAdNo" name="no" readonly value="<%= stockAd.getAdjustmentNo() %>" style="background-color: lightyellow;">
                                            </td>
                                            <td>
                                                <label for="stockAction">Stock Action</label> <br/>
                                                <input type="text" id="stockAction" name="stockAction" readonly value="<%= stockAd.getStockAction() %>" style="background-color: lightyellow;">
                                            </td>
                                        </tr>
                                        <tr><td><label for="remark">Remark</label><br/> <!--Please always put remark at the bottom (last item)-->
                                                <textarea id="remark" name="remark" rows="4" cols="50"><%= stockAd.getRemark() %></textarea>
                                            </td>
                                            <td>
                                            </td>
                                        </tr>
                                    </table>
                                    <br/>



                                    <!--next button that will call the action-->
                                    <br/><button id="action-button" type="submit" name="next"><i class="fa fa-chevron-right"></i></button><br/><br/><br/><br/>
                                </form>
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
