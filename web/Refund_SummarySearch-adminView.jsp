<%-- 
    Document   : Refund_SummarySearch-adminView
    Created on : Apr 7, 2022, 12:08:32 AM
    Author     : Cheng Cai Yuan
--%>
<%@ page errorPage="404Error.jsp" %>  
<%@page import="Model.Domain.Admin"%>
<%
    Admin admin = (Admin) session.getAttribute("admin");
%>
<%@page import="Model.DA.DARefund"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Model.Domain.Refund" %>
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
        <script src="components/Return_header.js" type="text/javascript" defer></script>
        <title>Refund Summary - Fast&Fashion</title>
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
                        <h1 class="mt-4"><return-header></return-header></h1>
                        <div class="card mb-4" id="innerPart">
                            <div class="card-header">
                                <i class="fa fa-info-circle" class="sb-nav-link-icon" style="font-size:28px; color: #353535;"></i>
                                <!--Table Title, action perform ?-->
                                Summary   
                                <!--Action link to link back to summary page-->
                                <a href='Refund_Summary-adminView.jsp' title="Summary"><i class="fa fa-filter" id="tableHeader-link-icon" ></i></a>
                            </div>
                            <div class="card-body">
                                <!--Form that will collect & pass data-->
                                <form method="post" action="RefundController">
                                    <!--User can select select the refund created time and refund status to search the records-->
                                    <table id="table-skuEnquiry">
                                        <tr>
                                            <td>
                                                <label for="days">Created Time</label><br/>
                                                <select id="days" name="days">
                                                    <option value="0">Today</option>
                                                    <option value="3">Last 3 days</option>
                                                    <option value="7">Last 7 days</option>
                                                    <option value="14">Last 14 days</option>
                                                    <option value="30">Last 30 days</option>
                                                </select>
                                            </td>
                                            <td>
                                                <label for="refundStatus">Status</label><br/>
                                                <select id="refundStatus" name="refundStatus">
                                                    <option value="Approval">Approval</option>
                                                    <option value="Disapproval">Disapproval</option>
                                                </select>    
                                            </td>
                                        </tr>
                                    </table>
                                    <!--search button that will call the action-->
                                    <button id="action-button" type="submit" name="action" value="search" style="margin-top: 5px;height: 40px;width: 40px;font-size: 18px;margin-right: 25px;"><i class="fa fa-search"></i></button><br/><br/><br/>
                                    </form>
                                
                                    <!--Form that will collect & pass data-->
                                    <form id="userGroup" method="post" action="RefundController">
                                    <table id="datatablesSimple">
                                        <!--Data Fields-->
                                        <thead id="view-thead">
                                            <tr>
                                                <th>Action</th>
                                                <th style="padding-right: 2px;">Line No. </th>
                                                <th>Refund ID</th>
                                                <th>Order ID</th>
                                                <th>Created Time</th>
                                                <th>Status</th>
                                            </tr>
                                        </thead>

                                        <!--Table Records-->
                                        <tbody>
                                            <%
                                                DARefund daRefund = new DARefund();
                                                //retrive all the refund records after searching from the refund table
                                                ArrayList<Refund> refundList = (ArrayList<Refund>)session.getAttribute("refundList");
                                                for (int i = 0; i < refundList.size(); i++) {%>
                                                <tr>
                                                    <td>
                                                        <!--View button-->
                                                        <a href='${pageContext.request.contextPath}/RefundController?selectedRow=<%= i%>&action=getRefund'><i class='fas fa-book' id="tableBody-link-icon"></i></a>
                                                        <!--Edit button-->
                                                        <a href='${pageContext.request.contextPath}/RefundController?selectedRow=<%= i%>&action=updateRefundStatus' title="Edit"><i class='fas fa-pen' id="tableBody-link-icon"></i></a>
                                                    </td>
                                                    <td><%= (i+1)%></td>
                                                    <td><%= refundList.get(i).getRefundId()%></td>
                                                    <td><%= refundList.get(i).getOrder().getOrderId()%></td>
                                                    <td><%= refundList.get(i).getRefundCreatedTime()%></td>
                                                    <td><%= refundList.get(i).getRefundStatus()%></td>
                                                </tr>
                                                <% }%>
                                        </tbody>
                                    </table>
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
