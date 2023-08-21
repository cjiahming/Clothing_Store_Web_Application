<%-- 
    Document   : User_Confirmation-adminView
    Created on : Apr 4, 2022, 12:49:47 PM
    Author     : jiyeo
--%>
<%@ page errorPage="404Error.jsp" %>  
<%@page import="Model.Domain.Admin"%>
<%
    Admin admin = (Admin) session.getAttribute("admin");
%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Model.Domain.Product" %>
<%
    String action3 = (String) session.getAttribute("action3");
    String nullSelectedProd = null;
    if (action3.equalsIgnoreCase("nullProd")) {
        nullSelectedProd = (String) session.getAttribute("nullSelectedProd");
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
        <title>Select Product - Fast&Fashion</title>
    </head>
    <body>
        <% if(nullSelectedProd != null){ %><button id="nullSelectedProd" hidden="hidden"></button><%}%>
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
                        <div class="card mb-4" id="innerPart" style="margin-top: 15px;">
                            <div class="card-header" style="background-color: #DCBA7D;">
                                Select Product  
                            </div>
                            <div class="card-body">
                                <form id="prodForm" action="StockAdjustmentDetailsProcessRequestController">
                                    <input type="hidden" name="ac" value="selectProduct"/>
                                    <table id="datatablesSimple">
                                        <!--Data Fields-->
                                        <thead id="view-thead">
                                            <tr>
                                                <th style="border-top:1px solid black;"></th>
                                                <th>Product ID</th>
                                                <th>Product Name</th>
                                            </tr>
                                        </thead>

                                        <!--Table Records-->
                                        <tbody>
                                            <%
                                                Product[] prodList = (Product[]) session.getAttribute("productList");
                                                for (int a = 0; a < prodList.length; a++) {
                                            %>
                                            <tr>
                                                <td><input  type="radio" name="prodID" value="<%= prodList[a].getProdID()%>"/></td>
                                                <td><%= prodList[a].getProdID()%></td>
                                                <td><%= prodList[a].getProdName()%></td>
                                            </tr>
                                            <% }%>
                                        </tbody>
                                    </table>

                                </form>
                                <a href="StockAdjustmentProcessRequestController?ac=add&stockAction=<%= (String) session.getAttribute("stockAction") %>&remark=<%= (String) session.getAttribute("stockAdRemark") %>&back=previous"><button id="action-button" title="Cancel" name="next" style="background-color: lightpink;margin-top: 2px;"><i class="fa fa-times" style="color: darkred;"></i></button></a>
                                <button id="action-button2" name="next" title="Confirm" style="background-color: lightgreen;margin-right: 10px;margin-top: 2px;"><i class="fa fa-check" style="color: darkgreen;"></i></button>
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
                                        var form = document.getElementById("prodForm");
                                        form.submit();
                                    });
        </script>
                <script>
            document.querySelector('#nullSelectedProd').addEventListener('click', () => {
                Confirm.open({
                    title: 'Empty Product',
                    message: '<%= nullSelectedProd %>',
                    onok: () => {
                    }})
            });
		document.getElementById("nullSelectedProd").click();
	</script>
    </body>
</html>

