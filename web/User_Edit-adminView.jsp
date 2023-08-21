<%-- 
    Document   : User_Edit-adminView
    Created on : Apr 4, 2022, 7:57:38 PM
    Author     : jiyeo
--%>
<%@ page errorPage="404Error.jsp" %>  
<%@page import="Model.Domain.Admin"%>
<% 
    Admin adminLogin = (Admin) session.getAttribute("admin");
%>
<%@page import="Model.Domain.UserGroup"%>
<%@page import="Model.Domain.Admin"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Admin admin = (Admin) session.getAttribute("adminView");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
        <link rel="shortcut icon" type="image/x-icon" href="assets/siteIcon.png" />
        <title> Edit user - Fast&Fashion </title>
        <link href="css/styles.css" rel="stylesheet" />
        <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/js/all.min.js" crossorigin="anonymous"></script>
        <script src="components/topNavBar.js" type="text/javascript" defer></script>
        <script src="components/middleNavBar.js" type="text/javascript" defer></script>
        <script src="components/footer.js" type="text/javascript" defer></script>
        <script src="components/User_header.js" type="text/javascript" defer></script>
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
                        <%= adminLogin.getUsername()%>
                        <a href="LogoutConfirmation.html"><i class="fas fa-sign-out-alt" id="sideBarIcon" style="float:right;margin-right:10px;"></i></a>
                    </div>
                </nav>
            </div>
            <div id="layoutSidenav_content">
                <main>
                    <!--Content Page-->
                    <div class="container-fluid px-4">
                        <!--Page Title-->
                        <h1 class="mt-4"><user-header></user-header></h1>
                        <div class="card mb-4" id="innerPart">
                            <div class="card-header">
                                <i class="fa fa-info-circle" class="sb-nav-link-icon" style="font-size:28px; color: #353535;"></i>
                                <!--Table Title, action perform ?-->
                                Edit   
                                <!--Action link to search record, link back to summary page-->
                                <a href="User_Summary-adminView.jsp" title="Summary"><i class="fa fa-filter" id="tableHeader-link-icon" ></i></a>
                                <!--Action link to add new record page-->
                                <a href="AdminUserController?toAddNew=true" title="Add New"><i class="fa fa-sticky-note" id="tableHeader-link-icon" ></i></a>
                            </div>
                            <div class="card-body">
                                <!--Form that will collect & pass data-->
                                <form action="AdminUserProcessRequestController">
                                    <input type="hidden" name="ac" value="edit2"/>
                                    <input type="hidden" name="p" value="<%= admin.getUserID() %>"/>
                                    <!--input field, note: max 2 col per row only-->
                                    <table class="contentPage-table">
                                        <tr>
                                            <td><label for="username">Username*</label> <br/>
                                                <input type="text" id="username" name="username" value="<%= admin.getUsername() %>" readonly style="background-color: lightyellow;">
                                            </td>
                                            <td>
                                                <% if(admin.getGender().equalsIgnoreCase("Female")){ %>
                                                <input type="radio" id="female" name="gender" value="Female" checked />
                                                  <label for="female">Female</label>
                                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                <input type="radio" id="male" name="gender" value="Male">
                                                  <label for="male">Male</label>
                                                <% }else{ %>
                                                <input type="radio" id="female" name="gender" value="Female" />
                                                  <label for="female">Female</label>
                                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                <input type="radio" id="male" name="gender" value="Male" checked>
                                                  <label for="male">Male</label>
                                                <% } %>
                                                  
                                            </td>
                                        </tr>
                                        <tr>            
                                            <td>
                                                <label for="firstName">First Name*</label><br/>
                                                <input type="text" id="firstName" name="firstName" value="<%= admin.getFirstName() %>" >
                                            </td>
                                            <td><label for="lastName">Last Name*</label><br/>
                                                <input type="text" id="lastName" name="lastName" value="<%= admin.getLastName() %>">
                                            </td>
                                        </tr>
                                        <tr>            
                                            <td>
                                                <label for="phoneNum">Mobile Number</label><br/>
                                                <input type="text" id="phoneNum" name="phoneNum" value="<%= admin.getPhoneNum() %>">
                                            </td>
                                            <td><label for="email">Email</label><br/>
                                                <input type="text" id="email" name="email" value="<%= admin.getEmail() %>">
                                            </td>
                                        </tr>
                                        <tr> 
                                             <%
                                            UserGroup[] uGrps = (UserGroup[]) session.getAttribute("userGroupList");
                                            %>
                                            <td><br/><label for="userGroup">User Group*</label> <br/>
                                                <select id="prodID" name="userGroup">
                                                    <% for (int i = 0; i < uGrps.length; i++) {
                                                        if(uGrps[i].getAccessRights().charAt(0)=='1'){
                                                            if(uGrps[i].getName().equalsIgnoreCase(admin.getUserGroup().getName())){
                                                    %>
                                                    <option value="<%= uGrps[i].getID() %>" selected><%= uGrps[i].getName()%></option>
                                                    <% }else{ %>
                                                    <option value="<%= uGrps[i].getID() %>"><%= uGrps[i].getName()%></option>
                                                    <% }}} %>
                                                </select>
                                            </td>
                                             <td><br/><label for="username">User Group Description</label> <br/>
                                                <input type="text" id="username" value="<%= admin.getUserGroup().getDesc() %>" readonly style="background-color: lightyellow;">
                                            </td>
                                        </tr>
                                             
                                    </table>
                                    <!--next button that will call the action-->
                                    <br/><br/><button id="action-button" type="submit" name="next"><i class="fa fa-chevron-right"></i></button><br/><br/><br/><br/>
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