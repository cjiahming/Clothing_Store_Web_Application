<%-- 
    Document   : StockAdjustment_SelectSKU-adminView
    Created on : Apr 6, 2022, 2:44:54 PM
    Author     : jiyeo
--%>
<%@ page errorPage="404Error.jsp" %>  
<%@page import="Model.Domain.Admin"%>
<%
    Admin admin = (Admin) session.getAttribute("admin");
%>
<%@page import="Model.Domain.Product"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Model.Domain.SKU" %>
<%
    ArrayList<SKU> skuList = (ArrayList) session.getAttribute("SA-SKUList");
    Product prodSelected = (Product) session.getAttribute("SA-selectedProd");
    String action3 = (String) session.getAttribute("action3");
    String nullSelectedSKU = null;
    if (action3.equalsIgnoreCase("nullSKU")) {
        nullSelectedSKU = (String) session.getAttribute("nullSelectedSKU");
    }
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
        <title>Select SKU - Fast&Fashion</title>
    </head>
    <body>
        <% if (nullSelectedSKU != null) { %><button id="nullSelectedSKU" hidden="hidden"></button><%}%>
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
                        <br/>
                        <div class="card mb-4" id="innerPart">
                            <div class="card-header" style="background-color: #DCBA7D;">
                                Select SKU  |  Product ID = <b><%= prodSelected.getProdID()%></b>
                            </div>
                            <div class="card-body">
                                <form id="skuForm" method="get" action="StockAdjustmentDetailsProcessRequestController">
                                    <input type="hidden" name="ac" value="selectedSKU"/>
                                    <table id="datatablesSimple">
                                        <!--Data Fields-->
                                        <thead id="view-thead">
                                            <tr>
                                                <th style="border-top:1px solid black;"></th>
                                                <th>SKU No</th>
                                                <th>SKU Color</th>
                                                <th>SKU Size</th>
                                            </tr>
                                        </thead>

                                        <!--Table Records-->
                                        <tbody>
                                            <% if (skuList.size() > 0) { %>
                                            <%
                                                for (int a = 0; a < skuList.size(); a++) {
                                            %>
                                            <tr>
                                                <td><input  type="radio" name="SAD-SKU" value="<%= skuList.get(a).getSkuNo()%>"/></td>
                                                <td><%= skuList.get(a).getSkuNo()%></td>
                                                <td><%= skuList.get(a).getColour()%></td>
                                                <td><%= skuList.get(a).getProdSize()%></td>
                                            </tr>
                                            <% }%>
                                            <% }  %>
                                        </tbody>

                                    </table>
                                </form>
                                        
                                <a href="StockAdjustmentDetailsProcessRequestController?ac=selectProduct&prodID=<%= prodSelected.getProdID()%>"><button id="action-button"  name="next" style="background-color: lightpink;margin-top: 2px;"><i class="fa fa-times" style="color: darkred;"></i></button></a>
                                <button id="action-button2"  name="next"  style="background-color: lightgreen;margin-right: 10px;margin-top: 2px;"><i class="fa fa-check" style="color: darkgreen;"></i></button>
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
            document.querySelector('#action-button2').addEventListener('click', () => {
                // Submit the form using javascript
                var form = document.getElementById("skuForm");
                form.submit();
            });
        </script>
        <script>
            document.querySelector('#nullSelectedSKU').addEventListener('click', () => {
                Confirm.open({
                    title: 'Empty SKU',
                                    message: '<%= nullSelectedSKU%>',
                    onok: () => {
                    }})
            });
            document.getElementById("nullSelectedSKU").click();
        </script>
    </body>
</html>

