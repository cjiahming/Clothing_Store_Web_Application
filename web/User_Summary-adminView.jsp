
<%@ page errorPage="404Error.jsp" %>  
<%@page import="Model.Domain.Admin"%>
<% 
    Admin adminLogin = (Admin) session.getAttribute("admin");
    if(adminLogin.getUserGroup().getAccessRights().charAt(11)=='0'){ 
%>  <jsp:forward page="401Error.jsp" /> <%}%>
<%@page import="Controller.AdminUserController"%>
<%@page import="Controller.AdminUserProcessRequestController"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Model.Domain.Admin" %>
<jsp:include page="/AdminUserController?toAddNew=false"/>
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
        <script src="components/User_header.js" type="text/javascript" defer></script>
        <title>Internal User Summary - Fast&Fashion</title>
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
                        <%= adminLogin.getUsername()%>
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
                        <h1 class="mt-4"><user-header></user-header></h1>
                        <div class="card mb-4" id="innerPart">
                            <div class="card-header">
                                <i class="fa fa-info-circle" class="sb-nav-link-icon" style="font-size:28px; color: #353535;"></i>
                                <!--Table Title, action perform ?-->
                                Summary   
                                <!--Action link to search record, link back to summary page-->
                                <a href="User_Summary-adminView.jsp" title="Summary"><i class="fa fa-filter" id="tableHeader-link-icon" ></i></a>
                                <!--Action link to add new record page-->
                                <a href="AdminUserController?toAddNew=true" title="Add New"><i class="fa fa-sticky-note" id="tableHeader-link-icon" ></i></a>
                            </div>
                            <div class="card-body">
                                <table id="datatablesSimple">
                                    <!--Data Fields-->
                                    <thead id="view-thead">
                                        <tr>
                                            <th>Action</th>
                                            <th style="padding-right: 5px;">Line No. </th>
                                            <th style="padding-right:0px;">User ID</th>
                                            <th style="padding-right:0px;">Username  <i class="fa fa-sort" id="sortIcon"></i></th>
                                            <th style="padding-right:0px;">First Name  <i class="fa fa-sort" id="sortIcon"></i></th>
                                            <th style="padding-right:0px;">Last Name  <i class="fa fa-sort" id="sortIcon"></i></th>
                                            <th style="padding-right:0px;">User Group ID  <i class="fa fa-sort" id="sortIcon"></i></th>
                                            <th style="padding-right:0px;">User Group Name  <i class="fa fa-sort" id="sortIcon"></i></th>
                                            <th style="padding-right:0px;">Gender  <i class="fa fa-sort" id="sortIcon"></i></th>
                                            <th>Contact No</th>
                                            <th>Email</th>
                                        </tr>
                                    </thead>

                                    <!--Table Records-->
                                    <tbody>
                                        <%
                                            Admin[] admins = (Admin[]) session.getAttribute("adminUsers");
                                            for (int i = 0; i < admins.length; i++) {
                                        %>
                                        <tr>
                                            <td>
                                                  <% if(i==0) { %>
                                                   <!--Button to view the record-->
                                                <a href="AdminUserProcessRequestController?p=<%= admins[i].getUserID() %>&ac=view" title="View"><i class="fas fa-book" id="tableBody-link-icon"></i></a>
                                                <i class="fas fa-pen" id="tableBody-link-icon" style="background-color:darkgrey;color:black;border-color: darkgray;"></i>
                                                <!--Cancel the record-->
                                                <i class="fas fa-trash-alt" id="tableBody-link-icon" style="background-color:darkgrey;color:black;border-color: darkgray;"></i>
                                                <a href="AdminUserProcessRequestController?p=<%= admins[i].getUserID()%>&ac=reset" title="Reset Password"><i class="fa fa-random" id="tableBody-link-icon"></i></a>
                                                <% }else{ %>
                                                 <!--Button to view the record-->
                                                <a href="AdminUserProcessRequestController?p=<%= admins[i].getUserID() %>&ac=view" title="View"><i class="fas fa-book" id="tableBody-link-icon"></i></a>
                                                <a href="AdminUserProcessRequestController?p=<%= admins[i].getUserID()%>&ac=edit" title="Edit"><i class="fas fa-pen" id="tableBody-link-icon"></i></a>
                                                <!--Cancel the record-->
                                                <a href="AdminUserProcessRequestController?p=<%= admins[i].getUserID()%>&ac=delete" title="Delete"><i class="fas fa-trash-alt" id="tableBody-link-icon"></i></a>
                                                <a href="AdminUserProcessRequestController?p=<%= admins[i].getUserID()%>&ac=reset" title="Reset Password"><i class="fa fa-random" id="tableBody-link-icon"></i></a>
                                                <% } %>
                                               
                                            </td>
                                            <td><%= (i + 1)%></td>
                                            <td><%= admins[i].getUserID()%></td>
                                            <td><%= admins[i].getUsername() %></td>
                                            <td><%= admins[i].getFirstName() %></td>
                                            <td><%= admins[i].getLastName() %></td>
                                            <td><%= admins[i].getUserGroup().getID() %></td>
                                            <td><%= admins[i].getUserGroup().getName() %></td>
                                            <td><%= admins[i].getGender()%></td>
                                            <td><%= admins[i].getPhoneNum() %></td>
                                            <td><%= admins[i].getEmail() %></td>
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

