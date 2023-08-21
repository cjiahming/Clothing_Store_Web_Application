<%-- 
    Document   : UserGroup_Search-adminView
    Created on : Apr 5, 2022, 12:07:29 PM
    Author     : jiyeo
--%>
<%@ page errorPage="404Error.jsp" %> 
<%@page import="Model.Domain.Admin"%>
<% 
    Admin admin = (Admin) session.getAttribute("admin");
%>
<%@page import="Controller.UserGroupController"%>
<jsp:useBean id="userGroupView" scope="session" class="Model.Domain.UserGroup"></jsp:useBean>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Model.Domain.UserGroup" %>
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
        <title>UserGroup Summary - Fast&Fashion</title>
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
                        <h1 class="mt-4"><group-header></group-header></h1>
                        <div class="card mb-4" id="innerPart">
                            <div class="card-header">
                                <i class="fa fa-info-circle" class="sb-nav-link-icon" style="font-size:28px; color: #353535;"></i>
                                <!--Table Title, action perform ?-->
                                Summary   
                                <!--Action link to search record, link back to summary page-->
                                <a href="UserGroup_Summary-adminView.jsp" title="Summary"><i class="fa fa-filter" id="tableHeader-link-icon" ></i></a>
                                <!--Action link to add new record page-->
                                <a href="UserGroupController?toAddNew=true" title="Add New"><i class="fa fa-sticky-note" id="tableHeader-link-icon" ></i></a>
                            </div>
                            <div class="card-body">
                                <form method="post" action="UserGroupSearchController">
                                    <table id="table-skuEnquiry">
                                        <tr>
                                            <td> <label for="userGroupID">User Group ID</label><br/>
                                                <input type="text" id="userGroupID" name="userGroupID" >
                                            </td>
                                            <td>
                                                <label for="userGroupName">User Group Name</label><br/>
                                                <input type="text" id="userGroupName" name="userGroupName">
                                            </td>
                                            <td><label for="status">Status</label> <br/>
                                                <select id="status" name="status">
                                                    <option value=""></option>
                                                    <option value="active">Active</option>
                                                    <option value="deactivated">Deactivated</option>
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
                                            <th style="padding-right: 50px;white-space: nowrap;">Action</th>
                                            <th style="padding-right: 2px;">Line No. </th>
                                            <th style="padding-right: 0px;">User Group ID <i class="fa fa-sort" id="sortIcon2"></i></th>
                                            <th style="padding-right: 0px;">User Group Name <i class="fa fa-sort" id="sortIcon2"></i></th>
                                            <th style="padding-right: 0px;">Description</th>
                                            <th style="padding-right: 20px;">Status <i class="fa fa-sort" id="sortIcon2"></i></th>
                                        </tr>
                                    </thead>
                                    <!--Table Records-->
                                    <tbody>
                                        <%
                                            UserGroup[] uGrps = (UserGroup[]) session.getAttribute("userGroup");
                                            for (int i = 0; i < uGrps.length; i++) {
                                        %>
                                        <tr>
                                            <td >
                                                <!--last_name--Button to view the record-->
                                                <a href="UserGroupProcessRequestController?p=<%= uGrps[i].getID()%>&ac=view" title="View"><i class="fas fa-book" id="tableBody-link-icon"></i></a>
                                                <a href="UserGroupProcessRequestController?p=<%= uGrps[i].getID()%>&ac=edit" title="Edit"><i class="fas fa-pen" id="tableBody-link-icon"></i></a>
                                                <!--Cancel the record-->
                                                <a href="UserGroupProcessRequestController?p=<%= uGrps[i].getID()%>&ac=delete" title="Delete"><i class="fas fa-trash-alt" id="tableBody-link-icon"></i></a>
                                            </td>
                                            <td><%= (i + 1)%></td>
                                            <td style="padding-right: 0px;"><%= uGrps[i].getID()%></td>
                                            <td style="padding-right: 0px;"><%= uGrps[i].getName()%></td>
                                            <td style="padding-right: 50px;"><%= uGrps[i].getDesc()%></td>
                                            <% if (uGrps[i].getAccessRights().charAt(0) == '1') { %>
                                            <td style="color:green;font-weight: 500;">&#9679; Active</td>
                                            <% } else { %>
                                            <td style="color: red;font-weight: 500;">&#9679; Deactivated</td>
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

