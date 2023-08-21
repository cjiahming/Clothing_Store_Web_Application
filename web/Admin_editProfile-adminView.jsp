<%-- 
    Document   : Admin_editProfile-adminView
    Author     : Choong Jiah Ming
--%>
<%@page import="java.util.ArrayList"%>
<%@page import="Model.Domain.Admin"%>
<%@page import="Model.Domain.Address"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
            if (session.getAttribute("admin") == null) {
                response.sendRedirect("Customer_LoginPage_customerView.jsp");
            }
            else{
                %>
                    <!DOCTYPE html>

<html>
    <head>
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>Admin Edit Details - Fast&Fashion</title>
        <meta name="keywords" content="HTML5 Template">
        <meta name="description" content="Molla - Bootstrap eCommerce Template">
        <meta name="author" content="p-themes">
        <link rel="apple-touch-icon" sizes="180x180" href="assets/images/icons/apple-touch-icon.png">
        <link rel="icon" type="image/png" sizes="32x32" href="assets/images/icons/favicon-32x32.png">
        <link rel="icon" type="image/png" sizes="16x16" href="assets/images/icons/favicon-16x16.png">
        <link rel="manifest" href="assets/images/icons/site.html">
        <link rel="mask-icon" href="assets/images/icons/safari-pinned-tab.svg" color="#666666">
        <link rel="shortcut icon" type="image/x-icon" href="assets/siteIcon.png" />
        <meta name="apple-mobile-web-app-title" content="Molla">
        <meta name="application-name" content="Molla">
        <meta name="msapplication-TileColor" content="#cc9966">
        <meta name="msapplication-config" content="assets/images/icons/browserconfig.xml">
        <link href="css/styles.css" rel="stylesheet" />
        <link rel="stylesheet" href="css/adminEditProfile.css">
        <link rel="stylesheet" href="assets/css/popup.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
        <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/js/all.min.js" crossorigin="anonymous"></script>
        <script src="components/topNavBar.js" type="text/javascript" defer></script>
        <script src="components/middleNavBar.js" type="text/javascript" defer></script>
        <script src="components/footer.js" type="text/javascript" defer></script>
        <script src="components/Profile_header.js" type="text/javascript" defer></script>
        <jsp:useBean id="adminDA" scope="application" class="Model.DA.DAAdmin"/>
    </head>
    
    <%
        HttpSession httpSession = request.getSession(); 
        Admin a = (Admin) (httpSession.getAttribute("admin"));
    %>
    
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
                        <%= a.getUsername() %>
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
                        <h1 class="mt-4"><profile-header></profile-header></h1>
                        <div class="card mb-4" id="innerPart">
                            <div class="card-header">
                                <i class="fa fa-info-circle" class="sb-nav-link-icon" style="font-size:28px; color: #353535;"></i>
                                <!--Table Title, action perform ?-->
                                My Profile   
                            </div>
                            <div class="card-body">
                                <div class="page-content">
            	<div class="dashboard">
	                <div class="container">
	                	<div class="row">
	                		<aside class="col-md-4 col-lg-3">
	                			<ul class="nav nav-dashboard flex-column mb-3 mb-md-0" role="tablist">
								    
                                                                    <li class="nav-item">
								        <a class="nav-link" id="tab-account-link" data-toggle="tab" href="#tab-account" role="tab" aria-controls="tab-account" aria-selected="true">Account Details</a>
								    </li>
                                                                    
                                                                    <li class="nav-item">
								        <a class="nav-link" id="tab-password-link" data-toggle="tab" href="#tab-password" role="tab" aria-controls="tab-password" aria-selected="false">Change Password</a>
								    </li>
								</ul>
	                		</aside><!-- End .col-lg-3 -->

	                		<div class="col-md-8 col-lg-9" style="height: 465px">
	                			<div class="tab-content">

								    <div class="tab-pane fade" id="tab-password" role="tabpanel" aria-labelledby="tab-password-link">
                                                                        <div class=tab-pane fade id=signin-2 role=tabpanel aria-labelledby=signin-tab-2>
                                                                            <form action="EditAdminPasswordController" method="post">

                                                                                <div class="form-group">
                                                                                    <label class="label-admin-edit">Current Password</label>
                                                                                    <input type=password class="passwordfield-edit-admin" id="admin-currentpassword" name="admin-currentpassword">
                                                                                    <small style="color: red">${currentPasswordErrMsg}</small>
                                                                                </div>
                                                                                <br>

                                                                                <div class="form-group">
                                                                                    <label class="label-admin-edit">New Password</label>
                                                                                    <input type=password class="passwordfield-edit-admin" id="admin-edit-newpassword" name="admin-edit-newpassword">
                                                                                    <small style="color: red">${newPasswordErrMsg}</small>
                                                                                </div>
                                                                                <br>

                                                                                <div class="form-group">
                                                                                    <label class="label-admin-edit">Confirm New Password</label>
                                                                                    <input type=password class="passwordfield-edit-admin" id="admin-edit-confirmnewpassword" name="admin-edit-confirmnewpassword">
                                                                                    <small style="color: red">${confirmNewPasswordErrMsg}</small>
                                                                                </div>
                                                                                <br>

                                                                                <button type="submit" class="save-changes-edit-profile">
			                					<span>SAVE CHANGES</span>
                                                                                </button>

                                                                            </form>
                                                                        </div>
								    </div><!-- .End .tab-pane -->
                                                                    
                                                                    
                                                                    <% Admin a2 = adminDA.getRecord(a.getUserID()); %>
								    <div class="tab-pane fade show active" id="tab-account" role="tabpanel" aria-labelledby="tab-account-link">
								    	<form action="UpdateAdminController" method="post">
                                                                            <div class="form-group">
                                                                                <label class="label-admin-edit">Username</label>
                                                                                <br>
                                                                                <input type="text" class="textfield-edit-admin" name="admin-edit-username" value=<%= a2.getUsername() %> disabled style="color: #B3B3B3">
                                                                                <small style="color: red">${editUsernameErrMsg}</small>
                                                                            </div><br>
                                                                            
                                                                            <div class="form-group">
                                                                                <label class="label-admin-edit">Full Name</label>
                                                                                <br>
                                                                                <input type="text" class="textfield-edit-admin" name="admin-edit-fullname" value="<%=a2.getFirstName() + " " + a2.getLastName() %>" disabled style="color: #B3B3B3">
                                                                                <small style="color: red">${editUsernameErrMsg}</small>
                                                                            </div><br>

                                                                        <div class="form-group">
                                                                            <label class="label-admin-edit">Phone Number</label>
                                                                            <br>
                                                                            <input type="text" class="textfield-edit-admin" name="admin-edit-phonenumber" value=<%= a2.getPhoneNum() %>>        						
                                                                            <small style="color: red">${editPhoneNumErrMsg}</small>
                                                                        </div><br>
                                                                        
                                                                        <div class="form-group">
                                                                            <label class="label-admin-edit">Email Address</label>
                                                                            <br>
                                                                            <input type="text" class="textfield-edit-admin" name="admin-edit-email" value=<%= a2.getEmail() %>>
                                                                            <small style="color: red">${editEmailErrMsg}</small>
                                                                        </div><br>
                                                                        
                                                                        <div class="form-group">
                                                                            <label class="label-admin-edit">Gender</label>

                                                                            <input class="userprofile-radiobox" type=radio id="male" name="admin-edit-gender" value="male" <% if(a2.getGender().equals("male")){
                                                                               %>checked="checked"<% }
                                                                               %>>
                                                                            <label for="male">Male</label>

                                                                            <input class="userprofile-radiobox" type=radio id="female" name="admin-edit-gender" value="female" <% if(a2.getGender().equals("female")){
                                                                               %>checked="checked"<% }
                                                                               %>>
                                                                            <label for="female">Female</label>

                                                                            <input class="userprofile-radiobox" type=radio id="others" name="admin-edit-gender" value="others" <% if(a2.getGender().equals("others")){
                                                                               %>checked="checked"<% }
                                                                               %>>
                                                                            <label for="others">Others</label>
                                                                        </div><br>

		                					<button type="submit" class="save-changes-edit-profile">
			                					<span>SAVE CHANGES</span>
			                				</button>
			                			</form>
								    </div><!-- .End .tab-pane -->
								</div>
	                		</div><!-- End .col-lg-9 -->
	                	</div><!-- End .row -->
	                </div><!-- End .container -->
                </div><!-- End .dashboard -->
            </div><!-- End .page-content -->

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
        
        <script src="assets/js/jquery.min.js"></script>
        <script src="assets/js/bootstrap.bundle.min.js"></script>
        <script src="assets/js/jquery.hoverIntent.min.js"></script>
        <script src="assets/js/jquery.waypoints.min.js"></script>
        <script src="assets/js/superfish.min.js"></script>
        <script src="assets/js/owl.carousel.min.js"></script>
        <!-- Main JS File -->
        <script src="assets/js/main.js"></script>

        <script>
            function toggleLogin() {
                document.querySelector(".customers-address-overlay").classList.toggle("open");
                document.getElementById('fullname').value = "";
                document.getElementById('phonenum').value = "";
                document.getElementById('state').value = "";
                document.getElementById('area').value = "";
                document.getElementById('poscode').value = "";
                document.getElementById('addressline').value = "";
            }
      </script>
    </body>
</html>
                <%
            }
%>

