<%-- 
    Document   : UserGroup_Confirmation-adminView
    Created on : Mar 12, 2022, 11:23:55 AM
    Author     : jiyeo
--%>
<%@ page errorPage="404Error.jsp" %>  
<%@page import="Model.Domain.Admin"%>
<% 
    Admin admin = (Admin) session.getAttribute("admin");
%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Model.Domain.UserGroup" %>
<%@page import="Model.Domain.Customer" %>
<jsp:useBean id="customerDA" scope="application" class="Model.DA.DACustomer"/>
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
        <script src="components/Customer_header.js" type="text/javascript" defer></script>
        <title>UserGroup Confirmation - Fast&Fashion</title>
    </head>
    
    <% Customer c = customerDA.displaySpecificCustomer(request.getParameter("value")); %>
    
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
                        <h1 class="mt-4"><cust-header></cust-header></h1>
                        <div class="card mb-4" id="innerPart">
                            <div class="card-header">
                                <i class="fa fa-info-circle" class="sb-nav-link-icon" style="font-size:28px; color: #353535;"></i>
                                <!--Table Title, action perform ?-->
                                View   
                            </div>
                            <div class="card-body">
                                <form id="userGroup">
                                <table id="datatablesSimple">
                                    <!--Data Fields-->
                                    <thead id="view-thead">
                                        <tr>
                                                <th style="padding-right: 2px;">Line No. </th>
                                                <th>Customer ID</th>
                                                <th>Username</th>
                                                <th>Phone Number</th>
                                                <th>Email</th>
                                                <th>Password</th>
                                                <th>Gender</th>
                                        </tr>
                                    </thead>
                                    
                                        <!--Table Records-->
                                        <tbody>
                                            <tr>
                                                <td>1</td>
                                                <td><%=c.getUserID() %></td>
                                                <td><%=c.getUsername() %></td>
                                                <td><%=c.getPhoneNum() %></td>
                                                <td><%=c.getEmail() %></td>
                                                <td><%=c.getPassword() %></td>
                                                <td><%=c.getGender() %></td>
                                            </tr>
                                        </tbody>
                                </table>
                                </form>
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
                                            title: 'Save New User Group',
                                            message: 'Are you confirm to save the user group ?',
                                            onok: () => {
                                                // Submit the form using javascript
                                                var form = document.getElementById("userGroup");
                                                form.submit();
                                            }
                                        })
                                    });
    </script>
</body>
</html>
