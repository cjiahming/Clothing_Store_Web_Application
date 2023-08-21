<%-- 
    Document   : StockAdjustment_Summary-adminView
    Created on : Apr 8, 2022, 1:49:52 PM
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
                                Summary   
                                <!--Action link to search record, link back to summary page-->
                                <a href="StockAdjustment_Summary-adminView.jsp" title="Summary"><i class="fa fa-filter" id="tableHeader-link-icon" ></i></a>
                                <!--Action link to add new record page-->
                                <a href="StockAdjustmentProcessRequestController?ac=new" title="Add New"><i class="fa fa-sticky-note" id="tableHeader-link-icon" ></i></a>
                            </div>
                            <div class="card-body">
                                <form method="get" action="StockAdjustmentSearchController">
                                    <table id="table-skuEnquiry">
                                        <tr>
                                            <td><label for="fromDate">From Date</label><br/>
                                                <input type="date" id="fromDate" name="fromDate" >
                                            </td>
                                            <td>
                                                <label for="toDate">To Date</label><br/>
                                                <input type="date" id="toDate" name="toDate">
                                            </td>
                                            <td><label for="stockAction">Stock Action</label> <br/>
                                                <select id="status" name="stockAction">
                                                    <option value=""></option>
                                                    <option value="stockIn">Stock In</option>
                                                    <option value="stockOut">Stock Out</option>
                                                    <option value="stockTake">Stock Take</option>
                                                </select>
                                            </td>
                                            <td><label for="status">Status</label> <br/>
                                                <select id="status" name="status">
                                                    <option value=""></option>
                                                    <option value="DRAFT">DRAFT</option>
                                                    <option value="EDITED">EDITED</option>
                                                    <option value="CLOSED">CLOSED</option>
                                                </select>
                                            </td>
                                        </tr>
                                    </table> 
                                    <button id="action-button" type="submit" name="Search" style="margin-top: 5px;height: 40px;width: 40px;font-size: 18px;margin-right: 25px;"><i class="fa fa-search"></i></button><br/><br/><br/>
                                </form>
                                <table id="datatablesSimple">
                                    <!--Data Fields-->
                                    <thead id="view-thead">
                                        <tr>
                                            <th >Action</th>
                                            <th >Line No. </th>
                                            <th >Stock Adjustment No <i class="fa fa-sort" id="sortIcon2"></i></th>
                                            <th >Stock Action <i class="fa fa-sort" id="sortIcon2"></i></th>
                                            <th >Remark</th>
                                            <th >Status<i class="fa fa-sort" id="sortIcon2"></i></th>
                                            <th >Created By<i class="fa fa-sort" id="sortIcon2"></i></th>
                                            <th >Created at<i class="fa fa-sort" id="sortIcon2"></i></th>
                                            <th >Updated By<i class="fa fa-sort" id="sortIcon2"></i></th>
                                            <th >Updated at<i class="fa fa-sort" id="sortIcon2"></i></th>
                                        </tr>
                                    </thead>

                                    <!--Table Records-->
                                    <tbody>
                                        <%
                                            StockAdjustment[] stockAdList = (StockAdjustment[]) session.getAttribute("stockAdList");
                                            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
                                            for (int i = 0; i < stockAdList.length; i++) {
                                        %>
                                        <tr>
                                            <td>
                                                <!--Button to view the record-->
                                                <a href="StockAdjustmentProcessRequestController?no=<%= stockAdList[i].getAdjustmentNo() %>&ac=view" title="View"><i class="fas fa-book" id="tableBody-link-icon"></i></a>
                                                <% if(stockAdList[i].getStatus().equalsIgnoreCase("CLOSED")) { %>
                                                <i class="fas fa-pen" id="tableBody-link-icon" style="background-color:darkgrey;color:black;border-color: darkgray;"></i>
                                                <!--Cancel the record-->
                                                <i class="fas fa-trash-alt" id="tableBody-link-icon" style="background-color:darkgrey;color:black;border-color: darkgray;"></i>
                                                <% }else{ %>
                                                <a href="StockAdjustmentProcessRequestController?no=<%= stockAdList[i].getAdjustmentNo()%>&ac=edit" title="Edit"><i class="fas fa-pen" id="tableBody-link-icon"></i></a>
                                                <!--Cancel the record-->
                                                <a href="StockAdjustmentProcessRequestController?no=<%= stockAdList[i].getAdjustmentNo()%>&ac=delete" title="Delete"><i class="fas fa-trash-alt" id="tableBody-link-icon"></i></a>
                                                <% } %>
                                            </td>
                                            <td><%= (i + 1)%></td>
                                            <td ><%= stockAdList[i].getAdjustmentNo() %></td>
                                            <td ><%= stockAdList[i].getStockActionInFormal() %></td>
                                            <td ><%= stockAdList[i].getRemark() %></td>
                                            <td ><%= stockAdList[i].getStatus() %></td>
                                            <td ><%= stockAdList[i].getCreated_by().getUsername() %></td>
                                            <td ><%= stockAdList[i].getCreated_at().format(formatter) %></td>
                                            <% if(stockAdList[i].getUpdated_by()==null){ %>
                                            <td> </td>
                                            <td> </td>
                                            <% }else{ %>
                                            <td ><%= stockAdList[i].getUpdated_by().getUsername() %></td>
                                            <td ><%= stockAdList[i].getUpdated_at().format(formatter) %></td>
                                            <% } %>
                                        </tr>
                                        <% }%>


                                    </tbody>
                                </table>

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

