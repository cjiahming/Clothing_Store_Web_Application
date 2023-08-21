<%-- 
    Document   : UserGroup_AddNew-adminView
    Created on : Apr 10, 2022, 5:38:01 PM
    Author     : jiyeo
--%>
<%@ page errorPage="404Error.jsp" %> 
<%@page import="Model.Domain.Admin"%>
<% 
    Admin admin = (Admin) session.getAttribute("admin");
%>
<%@page import="Model.Domain.UserGroup"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    UserGroup uGrp = null;
    String errStatus = (String) session.getAttribute("errStatus-UG");
    String errMsg = null;
    if (errStatus.equalsIgnoreCase("error")) {
        uGrp = (UserGroup) session.getAttribute("tempUG");
        errMsg = (String) session.getAttribute("errMsg-UG");
    }
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
        <link rel="shortcut icon" type="image/x-icon" href="assets/siteIcon.png" />
        <title> New User Group - Fast&Fashion</title>
        <link href="css/styles.css" rel="stylesheet" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
        <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/js/all.min.js" crossorigin="anonymous"></script>
        <script src="components/topNavBar.js" type="text/javascript" defer></script>
        <script src="components/middleNavBar.js" type="text/javascript" defer></script>
        <script src="components/footer.js" type="text/javascript" defer></script>
        <script src="components/UserGroup_header.js" type="text/javascript" defer></script>
        <style>

            ::placeholder {
                color: red;
                opacity: 1; /* Firefox */
                font-size: 13px;
            }

            :-ms-input-placeholder { /* Internet Explorer 10-11 */
                color: red;
                font-size: 13px;
            }

            ::-ms-input-placeholder { /* Microsoft Edge */
                color: red;
                font-size: 13px;
            }
            input[type="radio"]{
                appearance: none;
                border: 1px solid #d3d3d3;
                width: 16px;
                height: 16px;
                content: none;
                outline: none;
                margin: 0;
                box-shadow: rgba(0, 0, 0, 0.24) 0px 3px 8px;
            }

            input[type="radio"]:checked {
                appearance: none;
                outline: none;
                padding: 0;
                content: none;
                border: none;
                background-color: lightgoldenrodyellow;
            }

            input[type="radio"]:checked::before{
                position: absolute;
                color: black !important;
                content: "\00A0\2713\00A0" !important;
                border: 1px solid #d3d3d3;
                font-weight: bolder;
                font-size: 12px;
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
                                New   
                                <!--Action link to search record, link back to summary page-->
                                <a href="UserGroup_Summary-adminView.jsp" title="Summary"><i class="fa fa-filter" id="tableHeader-link-icon" ></i></a>
                                <!--Action link to add new record page-->
                                <a href="UserGroupController?toAddNew=true" title="Add New"><i class="fa fa-sticky-note" id="tableHeader-link-icon" ></i></a>
                            </div>
                            <div class="card-body">
                                <!--Form that will collect & pass data-->
                                <form method="get" action="UserGroupProcessRequestController"><input type="hidden" name="ac" value="add"/>
                                    <!--input field, note: max 2 col per row only-->
                                    <table class="contentPage-table">
                                        <tr>
                                            <% if (errMsg != null) { %>
                                            <td>
                                                <label for="userGroupName">User Group Name*</label><br/>
                                                <input type="text" id="userGroupName" name="userGroupName" <% if (uGrp != null && uGrp.getName().isEmpty() == false) {%> value="<%= uGrp.getName()%>" <% } else {%>placeholder="<%= errMsg%>" style="border-color:red;" <% } %>>
                                            </td>
                                            <td>
                                                <label for="userGroupDesc">Description*</label><br/>
                                                <input type="text" id="userGroupDesc" name="userGroupDesc" <% if (uGrp != null && uGrp.getDesc().isEmpty() == false) {%> value="<%= uGrp.getDesc()%>" <% } else {%>placeholder="<%= errMsg%>" style="border-color:red;" <% } %>>
                                            </td>
                                            <% } else { %>
                                            <td>
                                                <label for="userGroupName">User Group Name*</label><br/>
                                                <input type="text" id="userGroupName" name="userGroupName" >
                                            </td>
                                            <td>
                                                <label for="userGroupDesc">Description*</label><br/>
                                                <input type="text" id="userGroupDesc" name="userGroupDesc">
                                            </td>
                                            <% } %>
                                        </tr>
                                        <tr> 
                                            <td>
                                                <% if (uGrp!=null && uGrp.getAccessRights().charAt(0) == '1') { %>
                                                <input type="checkbox" id="activated" name="activated" value="activated" checked /> Activate
                                                <% } else { %>
                                                <input type="checkbox" id="activated" name="activated" value="activated" checked/> Activate
                                                <% } %>
                                            </td>
                                            <td></td>
                                        </tr>
                                    </table>
                                    <br/><br/>
                                    <table id="accessTable">
                                        <% if((String) session.getAttribute("accessErr-UG")!=null ) { %><span style="color:red;font-size:15px;margin-left: 30px;"><%= (String) session.getAttribute("accessErr-UG") %></span><% } %>
                                        <tr>
                                            <th>Page</th>
                                            <th>Access Rights</th>
                                        </tr>
                                    <%
                                        String[] pageTitle = {"Product", "SKU", "Stock Adjustment", "SKU Enquiry", "Sales", "Sales Status", "Review", "Approve Refund Request", "Refund", "Report", "Internal User", "User Group", "Customer", "*Reset Password"};
                                        String[] value = {"Product", "SKU", "StockAd", "SKUEnquiry", "Sales", "SalesStatus", "Review", "ReturnReq", "Return", "Report", "User", "UserGrp", "Customer", "resetPasswd"};
                                        for(int a=0; a<value.length;a++){
                                    %>

                                       <tr>
                                            <td><%= pageTitle[a]%></td>
                                            <td><% if (uGrp != null && uGrp.getAccessRights().charAt(a + 1) == '1') {%>
                                                <input type="radio" id="<%= value[a]%>" name="<%= value[a]%>" value="<%= value[a]%>" checked><label for="<%= value[a]%>">&nbsp; Enable</label>
                                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                <input type="radio" id="<%= value[a] + "Dis"%>" name="<%= value[a]%>" value="" ><label for="<%= value[a] + "Dis"%>">&nbsp; Disable</label>
                                                <% } else {%>
                                                <input type="radio" id="<%= value[a]%>" name="<%= value[a]%>" value="<%= value[a]%>" ><label for="<%= value[a]%>">&nbsp; Enable</label>
                                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                <input type="radio" id="<%= value[a] + "Dis"%>" name="<%= value[a]%>" value="" checked><label for="<%= value[a] + "Dis"%>">&nbsp; Disable</label>
                                                <% } %>

                                            </td>
                                        </tr>
                                        <% }%>
                                        
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
