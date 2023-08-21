<%-- 
    Document   : Sales_Summary-adminView
    Created on :
    Author     : 
--%>
<%@ page errorPage="404Error.jsp" %>  
<%@page import="Model.Domain.Admin"%>
<%
    Admin admin = (Admin) session.getAttribute("admin");
    if(admin.getUserGroup().getAccessRights().charAt(7)=='0'){ 
%>  <jsp:forward page="401Error.jsp" /> <%}%>
<%@page import="java.util.ArrayList"%>
<%@page import="Model.Domain.Cart"%>
<%@page import="Model.DA.DAReview"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
        <link rel="shortcut icon" type="image/x-icon" href="assets/siteIcon.png" />
        <link href="css/styles.css" rel="stylesheet" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
        <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/js/all.min.js" crossorigin="anonymous"></script>
        <script src="components/topNavBar.js" type="text/javascript" defer></script>
        <script src="components/middleNavBar.js" type="text/javascript" defer></script>
        <script src="components/footer.js" type="text/javascript" defer></script>
        <script src="components/Review_header.js" type="text/javascript" defer></script>
        <title>Review Summary - Fast&Fashion</title>
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
                        <h1 class="mt-4"><review-header></review-header></h1>
                        <div class="card mb-4" id="innerPart">
                            <div class="card-header">
                                <i class="fa fa-info-circle" class="sb-nav-link-icon" style="font-size:28px; color: #353535;"></i>
                                <!--Table Title, action perform ?-->
                                Summary   
                                <!--Action link to search record, link back to summary page-->
                            </div>
                            
                            <%
                                DAReview reviewDA = new DAReview();
                                ArrayList<Cart> cartArrList = reviewDA.getAllReviewCart();
                                System.out.print(cartArrList.size());
                            %>
                            <div class="card-body">
                                
                                    <form action="Review_SpecificView-adminView.jsp" method="post">

                                    <table id="datatablesSimple">
                                        <!--Data Fields-->
                                        <thead id="view-thead">
                                            <tr>
                                                <th>ReviewID</th>
                                                <th>Review Time</th>
                                                <th>Rating</th>
                                                <th>Order ID</th>
                                                <th>SKU</th>
                                                <th>Customer ID</th>
                                                <th>Hide</th>
                                                <th style="padding-right: 2px;">ReviewDesc</th>
                                                
                                            </tr>
                                        </thead>

                                        <!--Table Records-->
                                       
                                        <tbody>
                                            <%for(int i = 0 ; i < cartArrList.size();i++){
                                            %>
                                            <tr>
                                                <td>
                                                    <button type="submit" name="submit"  value="<%=cartArrList.get(i).getReview().getReviewID()%>" style="visibility:hidden"><a title="Edit" style="visibility:visible"><i class="fa fa-sticky-note" id="tableHeader-link-icon" style="float:left" ></i></a> </button>
                                                    
                                                    <%= cartArrList.get(i).getReview().getReviewID()%>
                                                </td>
                                                
                                                <td><%= cartArrList.get(i).getReview().getFormatDateOnly()%></td>
                                                <td><%= cartArrList.get(i).getReview().getReviewRating()%></td>
                                                <td><%= cartArrList.get(i).getOrder().getOrderId()%></td>
                                                <td><%= cartArrList.get(i).getSKU().getSkuNo()%></td>
                                                <td><%= cartArrList.get(i).getCustomer().getUserID()%></td>
                                                <td><%= cartArrList.get(i).getReview().getHide()%></td>
                                                <td style="padding-right: 2px;"><%= cartArrList.get(i).getReview().getReviewDesc() %></td>
                                            </tr>
                                            <%}%>
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

