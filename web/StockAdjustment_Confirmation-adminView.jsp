<%-- 
    Document   : StockAdjustment_Confirmation-adminView
    Created on : Apr 8, 2022, 5:19:21 PM
    Author     : jiyeo
--%>
<%@ page errorPage="404Error.jsp" %>  
<%@page import="Model.Domain.Admin"%>
<%
    Admin admin = (Admin) session.getAttribute("admin");
%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="Model.Domain.StockAdjustment"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    StockAdjustment stockAdList = (StockAdjustment) session.getAttribute("stockAdEdit");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
        <link rel="shortcut icon" type="image/x-icon" href="assets/siteIcon.png" />
        <title> Delete Stock Adjustment - Fast&Fashion </title>
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
                                Confirmation   
                                <!--Action link to search record, link back to summary page-->
                                <a href="StockAdjustment_Summary-adminView.jsp" title="Summary"><i class="fa fa-filter" id="tableHeader-link-icon" ></i></a>
                                <!--Action link to add new record page-->
                                <a href="StockAdjustmentProcessRequestController?ac=new" title="Add New"><i class="fa fa-sticky-note" id="tableHeader-link-icon" ></i></a>
                            </div>
                            <div class="card-body">
                               <!--Form that will collect & pass data-->
                                <form id="deleteStockAd" method="get" action="StockAdjustmentAdjustedListsController">
                                    <input type="hidden" name="actionOnItem" value="delete" />
                                    <!--input field, note: max 2 col per row only-->
                                    <table class="contentPage-table">
                                        <tr>
                                            <td><label for="no">Stock Adjustment No.</label> <br/>
                                                <input type="text" id="stockAdNo" name="no" readonly value="<%= stockAdList.getAdjustmentNo() %>" style="background-color: lightyellow;">
                                            </td>
                                            <td>
                                                <label for="stockAction">Stock Action</label> <br/>
                                                <input type="text" id="stockAction" name="stockAction" readonly value="<%= stockAdList.getStockAction() %>" style="background-color: lightyellow;">
                                            </td>
                                        </tr>
                                        <tr><td><label for="remark">Remark</label><br/> <!--Please always put remark at the bottom (last item)-->
                                                <textarea id="remark" name="remark" rows="4" cols="50"></textarea>
                                            </td>
                                            <td>
                                            </td>
                                        </tr>
                                    </table>
                                    <br/>
                                    <table id="datatablesSimple">
                                    <!--Data Fields-->
                                    <thead id="view-thead">
                                        <tr>
                                            <th >Line No. </th>
                                            <th >SKU <i class="fa fa-sort" id="sortIcon2"></i></th>
                                            <th >Product ID<i class="fa fa-sort" id="sortIcon2"></i></th>
                                            <th >Product Name</th>
                                            <th >Category</th>
                                            <th >Color<i class="fa fa-sort" id="sortIcon2"></i></th>
                                            <th >Size<i class="fa fa-sort" id="sortIcon2"></i></th>
                                            <th >Length (cm)<i class="fa fa-sort" id="sortIcon2"></i></th>
                                            <th >Width (cm)<i class="fa fa-sort" id="sortIcon2"></i></th>
                                            <th >Adjust Quantity (pcs)<i class="fa fa-sort" id="sortIcon2"></i></th>
                                            <th >Adjusted Quantity (pcs)<i class="fa fa-sort" id="sortIcon2"></i></th>
                                            <th >Remark<i class="fa fa-sort" id="sortIcon2"></i></th>
                                        </tr>
                                    </thead>

                                    <!--Table Records-->
                                    <tbody>
                                        <%
                                            for (int i = 0; i < stockAdList.getAdjustedItems().length; i++) {
                                        %>
                                        <tr>
                                            <td><%= (i + 1)%></td>
                                            <td ><%= stockAdList.getAdjustedItems()[i].getSku().getSkuNo() %></td>
                                             <td ><%= stockAdList.getAdjustedItems()[i].getSku().getProduct().getProdID() %></td>
                                             <td ><%= stockAdList.getAdjustedItems()[i].getSku().getProduct().getProdName() %></td>
                                             <td ><%= stockAdList.getAdjustedItems()[i].getSku().getProduct().getProdCategory() %></td>
                                             <td ><%= stockAdList.getAdjustedItems()[i].getSku().getColour() %></td>
                                             <td ><%= stockAdList.getAdjustedItems()[i].getSku().getProdSize() %></td>
                                             <td ><%= stockAdList.getAdjustedItems()[i].getSku().getProdLength() %></td>
                                             <td ><%= stockAdList.getAdjustedItems()[i].getSku().getProdWidth() %></td>
                                             <td ><%= stockAdList.getAdjustedItems()[i].getAdjustQty() %></td>
                                             <td > pending approval </td>
                                             <td ><%= stockAdList.getAdjustedItems()[i].getRemark() %></td>
                                        </tr>
                                        <% }%>


                                    </tbody>
                                </table>
                                </form>
                                    <button id="action-button" name="delete"><i class="fas fa-trash-alt"></i></button>
                                <button id="action-button2" type="button" name="back" onclick="history.back()"><i class="fa fa-chevron-left"></i></button>
                                
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
    <script src="js/confirm.js"></script>
    <script>
                                    document.querySelector('#action-button').addEventListener('click', () => {
                                        Confirm.open({
                                            title: 'Delete Stock Adjustment ',
                                            message: 'Are you confirm to delete the draft of stock adjustment <%= stockAdList.getAdjustmentNo() %>?',
                                            onok: () => {
                                                // Submit the form using javascript
                                                var form = document.getElementById("deleteStockAd");
                                                form.submit();
                                            }
                                        })
                                    });
    </script>
</body>
</html>

