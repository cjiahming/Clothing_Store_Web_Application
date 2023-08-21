<%-- 
    Document   : Refund_ConfirmationUpdate-adminView
    Created on : Apr 4, 2022, 6:41:21 PM
    Author     : Cheng Cai Yuan
--%>
<%@ page errorPage="404Error.jsp" %>  
<%@page import="Model.Domain.Admin"%>
<%
    Admin admin = (Admin) session.getAttribute("admin");
    if(admin.getUserGroup().getAccessRights().charAt(8)=='0'){ 
%>  <jsp:forward page="401Error.jsp" /> <%}%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Model.Domain.Refund" %>
<%
    Refund refund = (Refund) session.getAttribute("refund");
    HttpSession session1 = request.getSession();
    session1.setAttribute("refund", refund);
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
        <script src="components/Return_header.js" type="text/javascript" defer></script>
        <title>Refund Update Status Confirmation - Fast&Fashion</title>
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
                        <h1 class="mt-4"><return-header></return-header></h1>
                        <div class="card mb-4" id="innerPart">
                            <div class="card-header">
                                <i class="fa fa-info-circle" class="sb-nav-link-icon" style="font-size:28px; color: #353535;"></i>
                                <!--Table Title, action perform ?-->
                                Confirmation   
                                <!--Action link to link back to summary page-->
                                <a href="Refund_Summary-adminView.jsp" ><i class="fa fa-filter" id="tableHeader-link-icon" ></i></a>
                                
                            </div>
                            <div class="card-body">
                                <!--Form that will collect & pass data-->
                                <form id="refund" method="post" action="RefundController">
                                    <table id="datatablesSimple">
                                        <!--Data Fields-->
                                        <thead id="view-thead">
                                            <tr>
                                                <th style="padding-right: 2px;">Line No. </th>
                                                <th>Refund ID</th>
                                                <th>Order ID</th>
                                                <th>Created Time</th>
                                                <th>Reason</th>
                                                <th>Remark</th>
                                                <th>Status</th>
                                            </tr>
                                        </thead>
                                    
                                        <!--Table Records-->
                                        <tbody>
                                            <tr>
                                                <td>1</td>
                                                <td><%= refund.getRefundId()%></td>
                                                <td><%= refund.getOrder().getOrderId()%></td>
                                                <td><%= refund.getRefundCreatedTime()%></td>
                                                <td><%= refund.getRefundReason()%></td>
                                                <td><%= refund.getRefundRemark()%></td>
                                                <td><%= refund.getRefundStatus()%></td>
                                            </tr>
                                        </tbody>
                                </table>
                                       <input type="hidden" name="action" value="updateStatus"/>   
                                       <input type="hidden" name="order" value="<%= refund.getOrder().getOrderId()%>"/>   
                                </form>
                                            <!--next button that will call the action to update the record-->
                                <button id="action-button" name="order" value="<%= refund.getOrder().getOrderId()%>"><i class="fas fa-pen"></i></button>
                                <!--back button that will back to the previous page-->
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
                                            title: 'Update Refund Status',
                                            message: 'Are you confirm to approve the refund ?',
                                            onok: () => {
                                                // Submit the form using javascript
                                                var form = document.getElementById("refund");
                                                form.submit();
                                            }
                                        })
                                    });
    </script>
</body>
</html>
