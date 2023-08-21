<%-- 
    Document   : User_ResetPasswd-adminView
    Created on : Apr 4, 2022, 9:39:49 PM
    Author     : jiyeo
--%>
<%@ page errorPage="404Error.jsp" %>  
<%@page import="Model.Domain.Admin"%>
<% 
    Admin adminLogin = (Admin) session.getAttribute("admin");
    if(adminLogin.getUserGroup().getAccessRights().charAt(14)=='0'){ 
%>  <jsp:forward page="401Error.jsp" /> <%}%>
<%@page import="Model.Domain.UserGroup"%>
<%@page import="Model.Domain.Admin"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Admin admin = (Admin) session.getAttribute("adminUser");
    String errMsg = (String) session.getAttribute("resetErr-AU");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
        <link rel="shortcut icon" type="image/x-icon" href="assets/siteIcon.png" />
        <title> Reset User Password - Fast&Fashion </title>
        <link href="css/styles.css" rel="stylesheet" />
        <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/js/all.min.js" crossorigin="anonymous"></script>
        <script src="components/topNavBar.js" type="text/javascript" defer></script>
        <script src="components/middleNavBar.js" type="text/javascript" defer></script>
        <script src="components/footer.js" type="text/javascript" defer></script>
        <script src="components/User_header.js" type="text/javascript" defer></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
        <style>
            input[type=password] {
                padding: 12px 20px;
                margin: 8px 0;
                display: inline-block;
                border: 1px solid #ccc;
                border-radius: 4px;
                box-sizing: border-box;
                width: 35%;
            }
        </style>
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
                                Reset Password   
                                <!--Action link to search record, link back to summary page-->
                                <a href="User_Summary-adminView.jsp" title="Summary"><i class="fa fa-filter" id="tableHeader-link-icon" ></i></a>
                                <!--Action link to add new record page-->
                                <a href="AdminUserController?toAddNew=true" title="Add New"><i class="fa fa-sticky-note" id="tableHeader-link-icon" ></i></a>
                            </div>
                            <div class="card-body">
                                <!--Form that will collect & pass data-->
                                <form id="admin" method="post" action="AdminUserProcessRequestController">
                                    <input type="hidden" name="p" value="<%= admin.getUserID()%>"/>
                                    <!--input field, note: max 2 col per row only-->
                                    <h4>Username: <%= admin.getUsername()%></h4>
                                    First Name: <%= admin.getFirstName()%> <br/>
                                    Last Name: <%= admin.getLastName()%><br/><br/>
                                    <fieldset>
                                        <legend>Reset New Password</legend><br/>

                                        New Password &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <input type="password" value="FnF#IUP@ssw0rd!" id="password" name="password" <% if (errMsg != null) {%>style="border-color:red;"<% }%>><br/>


                                        Confirm Password &nbsp;<input type="password" value="FnF#IUP@ssw0rd!" id="conPasswd" name="conPasswd" <% if (errMsg != null) {%>style="border-color:red;"<% }%>><br/>
                                        <% if (errMsg != null) {%><p style="color:red;"><%= errMsg%> </p><% } %><br/><br/>
                                    </fieldset>
                                </form>
                                <br/><br/><button id="action-button" name="next"><i class="fa fa-save"></i></button>
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

                    title: 'Reset User Password',
                    message: 'Are you confirm to reset user password for <%= admin.getUsername()%> ?',

                    onok: () => {
                        // Submit the form using javascript
                        var form = document.getElementById("admin");
                        form.submit();
                    }
                })
            });
        </script>
    </body>
</html>