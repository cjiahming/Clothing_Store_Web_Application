<%-- 
    Document   : User_AddNew-adminView
    Created on : Apr 4, 2022, 1:12:29 PM
    Author     : jiyeo
--%>
<%@ page errorPage="404Error.jsp" %>  
<%@page import="Model.Domain.Admin"%>
<% 
    Admin adminLogin = (Admin) session.getAttribute("admin");
%>
<%@page import="Exceptions.DuplicatedRecordException"%>
<%@page import="Exceptions.InvalidInputFormatException"%>
<%@page import="Model.Domain.UserGroup"%>
<%@page import="Model.Domain.Admin"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    Admin admin = null;
    String errStatus = (String) session.getAttribute("errStatus");
    String errMsg = null, optDataErrMsg = null;
    if (errStatus.equalsIgnoreCase("error")) {
        admin = (Admin) session.getAttribute("tempAdmin");
        errMsg = (String) session.getAttribute("errMsg-AU");
        optDataErrMsg = (String) session.getAttribute("errMsg-AU-OPT");
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
        <link rel="shortcut icon" type="image/x-icon" href="assets/siteIcon.png" />
        <title> New user - Fast&Fashion </title>
        <link href="css/styles.css" rel="stylesheet" />
        <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/js/all.min.js" crossorigin="anonymous"></script>
        <script src="components/topNavBar.js" type="text/javascript" defer></script>
        <script src="components/middleNavBar.js" type="text/javascript" defer></script>
        <script src="components/footer.js" type="text/javascript" defer></script>
        <script src="components/User_header.js" type="text/javascript" defer></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">

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
                                New   
                                <!--Action link to search record, link back to summary page-->
                                <a href="User_Summary-adminView.jsp" title="Summary"><i class="fa fa-filter" id="tableHeader-link-icon" ></i></a>
                                <!--Action link to add new record page-->
                                <a href="AdminUserController?toAddNew=true" title="Add New"><i class="fa fa-sticky-note" id="tableHeader-link-icon" ></i></a>
                            </div>
                            <div class="card-body">
                                <!--Form that will collect & pass data-->
                                <form action="AdminUserProcessRequestController"><input type="hidden" name="ac" value="add"/>
                                    <!--input field, note: max 2 col per row only-->
                                    <table class="contentPage-table">
                                        <tr>
                                            <% if (errMsg != null) { %>
                                            <td><label for="username">Username*</label> <br/>
                                                <input type="text" id="username" name="username" <% if (admin != null && admin.getUsername().isEmpty() == false) {%> value="<%= admin.getUsername()%>" <% } else {%>placeholder="<%= errMsg%>" style="border-color:red;" <% } %>>
                                            </td>
                                            <% } else if (optDataErrMsg != null && optDataErrMsg.equals(DuplicatedRecordException.DUPLICATED_USERNAME)) {%>
                                            <td><label for="username">Username*</label> <br/>
                                                <input type="text" id="username" name="username" placeholder="<%= optDataErrMsg %>" style="border-color:red;" >
                                            </td>
                                            <% } else { %>
                                            <td><label for="username">Username*</label> <br/>
                                                <input type="text" id="username" name="username" >
                                            </td>
                                            <% } %>
                                            <td>
                                                <input type="radio" id="female" name="gender" value="Female" checked>
                                                  <label for="female">Female</label>
                                                  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                <input type="radio" id="male" name="gender" value="Male">
                                                  <label for="male">Male</label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <% if (errMsg != null) { %>
                                            <td>
                                                <label for="firstName">First Name*</label><br/>
                                                <input type="text" id="firstName" name="firstName" <% if (admin != null && admin.getFirstName().isEmpty() == false) {%> value="<%= admin.getFirstName()%>" <% } else {%>placeholder="<%= errMsg%>" style="border-color:red;" <% } %> >
                                            </td>
                                            <td><label for="lastName">Last Name*</label><br/>
                                                <input type="text" id="lastName" name="lastName"  <% if (admin != null && admin.getLastName().isEmpty() == false) {%> value="<%= admin.getLastName()%>" <% } else {%>placeholder="<%= errMsg%>" style="border-color:red;" <% } %>>
                                            </td>
                                            <% } else { %>
                                            <td>
                                                <label for="firstName">First Name*</label><br/>
                                                <input type="text" id="firstName" name="firstName" >
                                            </td>
                                            <td><label for="lastName">Last Name*</label><br/>
                                                <input type="text" id="lastName" name="lastName" >
                                            </td>
                                            <% } %>
                                        </tr>
                                        <tr> 
                                            <% if (admin != null && admin.getPhoneNum().isEmpty() == false) { %>
                                            <td>
                                                <label for="phoneNum">Mobile Number</label><br/>
                                                <input type="text" id="phoneNum" name="phoneNum" <% if (optDataErrMsg != null && optDataErrMsg.equals(InvalidInputFormatException.INVALID_PHONE_NUM)) {%> placeholder="<%= optDataErrMsg%>" style="border-color:red;" <% } else {%> value="<%= admin.getPhoneNum()%>" <% } %>>
                                            </td>
                                            <% } else { %>
                                            <td>
                                                <label for="phoneNum">Mobile Number</label><br/>
                                                <input type="text" id="phoneNum" name="phoneNum">
                                            </td>
                                            <% } %>
                                            <!---------------------------------------------------------------------------------------------------->
                                            <% if (admin != null && admin.getEmail().isEmpty() == false) { %>
                                            <td>
                                                <label for="email">Email</label><br/>
                                                <input type="text" id="email" name="email" <% if (optDataErrMsg != null && optDataErrMsg.equals(InvalidInputFormatException.INVALID_EMAIL)) {%> placeholder="<%= optDataErrMsg%>" style="border-color:red;" <% } else {%> value="<%= admin.getEmail()%>" <% } %>>
                                            </td>
                                            <% } else { %>
                                            <td>
                                                <label for="email">Email</label><br/>
                                                <input type="text" id="email" name="email" >
                                            </td>
                                            <% } %>
                                        </tr>
                                        <tr>
                                            <% if (admin != null && admin.getPassword().equals("FnF#IUP@ssw0rd!")==false && errMsg != null) { %>
                                            <td>
                                                <label for="password">Password*</label><br/>
                                                <input type="password" id="password" name="password" onkeyup='check();' <% if (errMsg != null) {%> placeholder="<%= errMsg%>" style="border-color:red;" <% } %>><br/>
                                                <input type="checkbox" onclick="showPasswd()"><span style="font-size: 12px;">  Show Password</span>
                                            </td>
                                            <td><label for="conPassword">Confirm Password*</label><br/>
                                                <input type="password" id="conPasswd" name="conPassword" onkeyup='check();' <% if (errMsg != null) {%> placeholder="<%= errMsg%>" style="border-color:red;" <% } %>><br/>
                                                <input type="checkbox" onclick="showConPasswd()"><span style="font-size: 12px;margin-right: 290px;">  Show Password </span>
                                                <span id='message'></span>
                                            </td>
                                            <% } else { %>
                                            <td>
                                                <label for="password">Password*</label><br/>
                                                <input type="password" value="FnF#IUP@ssw0rd!" id="password" name="password" onkeyup='check();'><br/>
                                                <input type="checkbox" onclick="showPasswd()"><span style="font-size: 12px;">  Show Password</span>
                                            </td>
                                            <td><label for="conPassword">Confirm Password*</label><br/>
                                                <input type="password" value="FnF#IUP@ssw0rd!" id="conPasswd" name="conPassword" onkeyup='check();'><br/>
                                                <input type="checkbox" onclick="showConPasswd()"><span style="font-size: 12px;margin-right: 290px;">  Show Password </span>
                                                <span id='message'></span>
                                            </td>
                                            <% } %>
                                        </tr>
                                        <tr> 
                                            <%
                                                UserGroup[] uGrps = (UserGroup[]) session.getAttribute("userGroupList");
                                            %>
                                            <td><br/><label for="userGroup">User Group*</label> <br/>
                                                <select id="prodID" name="userGroup">
                                                    <% for (int i = 0; i < uGrps.length; i++) {
                                                            if (uGrps!=null && uGrps[i].getAccessRights().charAt(0) == '1') {
                                                                if (admin != null && uGrps[i].getID().equalsIgnoreCase(admin.getUserGroup().getID())) {

                                                    %>
                                                    <option selected value="<%= uGrps[i].getID()%>"><%= uGrps[i].getName()%></option>
                                                    <% } else {%>
                                                    <option value="<%= uGrps[i].getID()%>"><%= uGrps[i].getName()%></option>
                                                    <% }
                                                            }
                                                        }%>
                                                </select>
                                            </td>
                                            <td>
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
        <script src="js/datatables-simple-demo.js"></script><script>
                                                    function showPasswd() {
                                                        var x = document.getElementById("password");
                                                        if (x.type === "password") {
                                                            x.type = "text";
                                                        } else {
                                                            x.type = "password";
                                                        }
                                                    }
                                                    function showConPasswd() {
                                                        var x = document.getElementById("conPasswd");
                                                        if (x.type === "password") {
                                                            x.type = "text";
                                                        } else {
                                                            x.type = "password";
                                                        }
                                                    }
                                                    var check = function () {
                                                        if (document.getElementById('password').value ==
                                                                document.getElementById('conPasswd').value) {
                                                            document.getElementById('message').style.color = 'green';
                                                            document.getElementById('message').innerHTML = '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;✔ Matching';
                                                        } else {
                                                            document.getElementById('message').style.color = 'red';
                                                            document.getElementById('message').innerHTML = '❌ Not matching';
                                                        }
                                                    }
        </script>

    </body>
</html>