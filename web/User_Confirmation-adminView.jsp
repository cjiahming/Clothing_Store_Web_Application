<%-- 
    Document   : User_Confirmation-adminView
    Created on : Apr 4, 2022, 12:49:47 PM
    Author     : jiyeo
--%>
<%@ page errorPage="404Error.jsp" %>  
<%@page import="Model.Domain.Admin"%>
<% 
    Admin adminLogin = (Admin) session.getAttribute("admin");
%>
<%@page import="Model.Domain.Admin"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Model.Domain.UserGroup" %>
<%
    Admin admin = (Admin) session.getAttribute("adminUser");
    String actionPerformed = (String) session.getAttribute("actionPerformed");
%>
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
        <title>UserGroup Confirmation - Fast&Fashion</title>
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
                                Confirmation   
                                <!--Action link to search record, link back to summary page-->
                                <a href="User_Summary-adminView.jsp" title="Summary"><i class="fa fa-filter" id="tableHeader-link-icon" ></i></a>
                                <!--Action link to add new record page-->
                                <a href="AdminUserController?toAddNew=true" title="Add New"><i class="fa fa-sticky-note" id="tableHeader-link-icon" ></i></a>
                            </div>
                            <div class="card-body">
                                <form id="admin" method="post" action="AdminUserProcessRequestController">
                                <table id="datatablesSimple">
                                    <!--Data Fields-->
                                    <thead id="view-thead">
                                        <tr>
                                            <th>User ID</th>
                                            <th>Username</th>
                                            <th>First Name</th>
                                            <th>Last Name</th>
                                            <th>Email</th>
                                             <th>Phone Number</th>
                                              <th>Gender</th>
                                              <th>User Group ID</th>
                                        </tr>
                                    </thead>
                                    
                                        <!--Table Records-->
                                        <tbody>
                                            <tr>
                                            <td><%= admin.getUserID()%></td>
                                            <td><%= admin.getUsername() %></td>
                                            <td><%= admin.getFirstName() %></td>
                                            <td><%= admin.getLastName() %></td>
                                            <td><%= admin.getEmail() %></td>
                                            <td><%= admin.getPhoneNum() %></td>
                                            <td><%= admin.getGender() %></td>
                                            <td><%= admin.getUserGroup().getName() %></td>
                                            </tr>
                                        </tbody>
                                </table>
                                </form>
                                <% if(actionPerformed.equalsIgnoreCase("delete")){ %>
                                    <button id="action-button" name="delete"><i class="fas fa-trash-alt"></i></button>
                                <% }else{ %>
                                    <button id="action-button" name="next"><i class="fa fa-save"></i></button>
                                <% } %>
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
                                            <% if(actionPerformed.equalsIgnoreCase("delete")){ %>
                                            title: 'Delete User ',
                                            message: 'Are you confirm to delete the user <%= admin.getUsername() %>?',
                                            <% }else if (actionPerformed.equalsIgnoreCase("edit2")){ %>
                                            title: 'Update User ',
                                            message: 'Are you confirm to update the user <%= admin.getUsername() %>?',    
                                            <% }else{ %>
                                            title: 'Save New User ',
                                            message: 'Are you confirm to save the user <%= admin.getUsername() %>?',
                                            <% } %>    
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

