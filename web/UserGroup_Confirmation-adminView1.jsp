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
<%
    UserGroup uGrp = (UserGroup) session.getAttribute("userGroup");
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
        <script src="components/UserGroup_header.js" type="text/javascript" defer></script>
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
                        <h1 class="mt-4"><group-header></group-header></h1>
                        <div class="card mb-4" id="innerPart">
                            <div class="card-header">
                                <i class="fa fa-info-circle" class="sb-nav-link-icon" style="font-size:28px; color: #353535;"></i>
                                <!--Table Title, action perform ?-->
                                Confirmation   
                                <!--Action link to search record, link back to summary page-->
                                <a href="UserGroup_Summary-adminView.jsp" title="Summary"><i class="fa fa-filter" id="tableHeader-link-icon" ></i></a>
                                <!--Action link to add new record page-->
                                <a href="UserGroupController?toAddNew=true" title="Add New"><i class="fa fa-sticky-note" id="tableHeader-link-icon" ></i></a>
                            </div>
                            <div class="card-body">
                                <form id="userGroup" method="post" action="UserGroupProcessRequestController">
                                    <table id="datatablesSimple">
                                        <!--Data Fields-->
                                        <thead id="view-thead">
                                            <tr>
                                                <th style="padding-right: 2px;">User Group ID </th>
                                                <th>User Group Name</th>
                                                <th>Description</th>
                                                <th>Status</th>
                                            </tr>
                                        </thead>

                                        <!--Table Records-->
                                        <tbody>
                                            <tr>
                                                <td><%= uGrp.getID()%></td>
                                                <td><%= uGrp.getName()%></td>
                                                <td><%= uGrp.getDesc()%></td>
                                                <td><% if(uGrp.getAccessRights().charAt(0)=='1'){ %>Active<% } else{ %> Deactivated<% } %></td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </form>
                                <%
                                    String[] pageTitle = {"Product", "SKU", "Stock Adjustment", "SKU Enquiry", "Sales", "Sales Status", "Review", "Approve Refund Request", "Refund", "Report", "Internal User", "User Group", "Customer", "*Reset Password"};
                                    String[] value = {"Product", "SKU", "StockAd", "SKUEnquiry", "Sales", "SalesStatus", "Review", "ReturnReq", "Return", "Report", "User", "UserGrp", "Customer", "resetPasswd"};
                                %>
                                <br/>
                                <fieldset>
                                    <legend> Access Rights for <b><%= uGrp.getName()%></b> </legend><br/>
                                    <table id="accessRightLists">
                                        <tr>
                                            <th>Page</th>
                                            <th>Access Rights</th>
                                            <th>Page</th>
                                            <th>Access Rights</th>
                                        </tr>
                                        <% for (int i = 0; i < 7; i++) {%>
                                        <tr>
                                            <td><%= pageTitle[i]%></td>
                                            <td><% if (uGrp.getAccessRights().charAt(i + 1) == '1') { %>
                                                <p class="acStatus">✅ Active  </p>
                                                <% } else { %>
                                                <p class="nonAcStatus">⛔ Denied  </p>
                                                <% }%>
                                            </td>
                                            <td><%= pageTitle[i + 7]%></td>
                                            <td><% if (uGrp.getAccessRights().charAt((i + 7) + 1) == '1') { %>
                                                <p class="acStatus">✅ Active  </p>
                                                <% } else { %>
                                                <p class="nonAcStatus">⛔ Denied  </p>
                                                <% } %>
                                            </td>
                                        </tr>
                                        <% }%>
                                    </table>
                                </fieldset>
                                <br/><br/>
                                <% if (actionPerformed.equalsIgnoreCase("delete")) { %>
                                <button id="action-button" name="delete"><i class="fas fa-trash-alt"></i></button>
                                    <% } else { %>
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
            <% if (actionPerformed.equalsIgnoreCase("delete")) { %>
                                        title: 'Delete User Group',
                                                message: 'Are you confirm to delete the user group ?',
            <% } else if (actionPerformed.equalsIgnoreCase("edit2")) { %>
                                        title: 'Update User Group',
                                                message: 'Are you confirm to update the user group ?',
            <% } else { %>
                                        title: 'Save New User Group',
                                                message: 'Are you confirm to save the user group ?',
            <% }%>
                                        onok: () => {
                                        // Submit the form using javascript
                                        var form = document.getElementById("userGroup");
                                                form.submit();
                                        }
                                        })
                                        }
                                        );
        </script>
    </body>
</html>
