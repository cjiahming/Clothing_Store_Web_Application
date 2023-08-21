<%-- 
    Document   : SKU_ConfirmationUpdate-adminView
    Created on : Mar 30, 2022, 1:19:00 PM
    Author     : Cheng Cai Yuan
--%>
<%@ page errorPage="404Error.jsp" %>  
<%@page import="Model.Domain.Admin"%>
<%
    Admin admin = (Admin) session.getAttribute("admin");
%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Model.Domain.SKU" %>
<%
    SKU sku1 = (SKU) session.getAttribute("sku1");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
        <link rel="shortcut icon" type="image/x-icon" href="assets2/siteIcon.png" />
        <link href="css/styles.css" rel="stylesheet" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
        <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/js/all.min.js" crossorigin="anonymous"></script>
        <script src="components/topNavBar.js" type="text/javascript" defer></script>
        <script src="components/middleNavBar.js" type="text/javascript" defer></script>
        <script src="components/footer.js" type="text/javascript" defer></script>
        <script src="components/SKU_header.js" type="text/javascript" defer></script>
        <title>SKU Update Confirmation - Fast&Fashion</title>
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
                        <h1 class="mt-4"><sku-header></sku-header></h1>
                        <div class="card mb-4" id="innerPart">
                            <div class="card-header">
                                <i class="fa fa-info-circle" class="sb-nav-link-icon" style="font-size:28px; color: #353535;"></i>
                                <!--Table Title, action perform ?-->
                                Confirmation   
                                <!--Action link to link back to summary page-->
                                <a href='SKU_Summary-adminView.jsp' title="Summary"><i class="fa fa-filter" id="tableHeader-link-icon" ></i></a>
                                <!--Action link to add new record page-->
                                <a href='SKU_AddNew-adminView.jsp' title="Add New"><i class="fa fa-sticky-note" id="tableHeader-link-icon" ></i></a>
                            </div>
                            <div class="card-body">
                                <!--Form that will collect & pass data-->
                                <form id="sku" method="post" action="SkuDBUpdateController">
                                    <table id="datatablesSimple">
                                        <!--Data Fields-->
                                        <thead id="view-thead">
                                            <tr>
                                                <th style="padding-right: 2px;">Line No. </th>
                                                <th>SKU No</th>
                                                <th>Product ID</th>
                                                <th>Colour</th>
                                                <th>Size</th>
                                                <th>Width (cm)</th>
                                                <th>Length (cm)</th>
                                                <th>Quantity</th>
                                            </tr>
                                        </thead>
                                    
                                        <!--Table Records-->
                                        <tbody>
                                            <tr>
                                                <td>1</td>
                                                <td><%= sku1.getSkuNo()%></td>
                                                <td><%= sku1.getProduct().getProdID()%></td>
                                                <td><%= sku1.getColour()%></td>
                                                <td><%= sku1.getProdSize()%></td>
                                                <td><%= sku1.getProdWidth()%></td>
                                                <td><%= sku1.getProdLength()%></td>
                                                <td><%= sku1.getSkuQty()%></td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </form>
                                            
                                <!--next button that will call the action to update the record-->
                                <button id="action-button" name="next" value="update"><i class="fas fa-pen"></i></button>
                                <!--back button that will back to the previous page-->
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
                                            title: 'Update SKU',
                                            message: 'Are you confirm to update the SKU ?',
                                            onok: () => {
                                                // Submit the form using javascript
                                                var form = document.getElementById("sku");
                                                form.submit();
                                            }
                                        })
                                    });
    </script>
</body>
</html>