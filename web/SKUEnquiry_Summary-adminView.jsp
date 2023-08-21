
<%@ page errorPage="404Error.jsp" %>  
<%@page import="Model.Domain.Admin"%>
<%
    Admin admin = (Admin) session.getAttribute("admin");
    if(admin.getUserGroup().getAccessRights().charAt(4)=='0'){ 
%>  <jsp:forward page="401Error.jsp" /> <%}%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="Model.Domain.Product"%>
<%@page import="Model.Domain.AdjustedItem"%>
<%@page import="Model.Domain.SKU"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Model.Domain.Admin" %>
<jsp:include page="/SKUEnquiryController"/>
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
        <script src="components/SKUEnquiry_header.js" type="text/javascript" defer></script>
        <title>SKU Enquiry - Fast&Fashion</title>
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
                        <h1 class="mt-4"><skuen-header></skuen-header></h1>
                        <div class="card mb-4" id="innerPart">
                            <div class="card-header">
                                <i class="fa fa-info-circle" class="sb-nav-link-icon" style="font-size:28px; color: #353535;"></i>
                                <!--Table Title, action perform ?-->
                                Summary   
                                <!--Action link to search record, link back to summary page-->
                                <a href="SKUEnquiry_Summary-adminView.jsp" title="Summary"><i class="fa fa-filter" id="tableHeader-link-icon" ></i></a>
                            </div>
                            <div class="card-body">
                                <form method="get" action="SKUEnquirySearchController">
                                    <table id="table-skuEnquiry">
                                        <tr>
                                            <td>
                                                <label for="prodCategory">Product Category</label>
                                                <select name="prodCategory" >
                                                    <option value= "" diasble></option>
                                                    <option value = "WomenTops">Women Tops</option>
                                                    <option value = "WomenSweatshirts">Women Sweatshirts</option>
                                                    <option value = "WomenBottoms">Women Bottoms</option>
                                                    <option value = "WomenDresses">Women Dresses</option>
                                                    <option value = "MenTops">Men Tops</option>
                                                    <option value = "MenSweatshirts">Men Sweatshirts</option>
                                                    <option value = "MenBottoms">Men Bottoms</option>
                                                </select>
                                            </td>
                                            <td><label for="prodID">Product ID</label>
                                                    <input type="text" name="prodID" >
                                            </td>
                                        </tr>
                                    </table> <br/>
                                    <button id="action-button" type="submit" name="Search" style="margin-top: 5px;height: 40px;width: 40px;font-size: 18px;margin-right: 25px;"><i class="fa fa-search"></i></button>
                                    <a href="SKUEnquiryReport-adminView.jsp" target="_blank"><button type="button" id="action-button" name="Print" style="margin-top: 5px;height: 40px;width: 40px;font-size: 18px;margin-right: 10px;"><i class="fa fa-print"></i></button></a><br/><br/><br/>
                                </form>
                                <table id="datatablesSimple">
                                    <!--Data Fields-->
                                    <thead id="view-thead">
                                        <tr>
                                            <th style="padding-right: 5px;">SKU</th>
                                            <th style="padding-right:0px;">Color </th>
                                            <th style="padding-right:0px;">Size  <i class="fa fa-sort" id="sortIcon"></i></th>
                                            <th style="padding-right:0px;">Length (cm) <i class="fa fa-sort" id="sortIcon"></i></th>
                                            <th style="padding-right:0px;">Width (cm)  <i class="fa fa-sort" id="sortIcon"></i></th>
                                            <th style="padding-right:0px;">Product ID <i class="fa fa-sort" id="sortIcon"></i></th>
                                            <th style="padding-right:0px;">On Hand Quantity <i class="fa fa-sort" id="sortIcon"></i></th>
                                            <th style="padding-right:0px;">Available Quantity <i class="fa fa-sort" id="sortIcon"></i></th>
                                            <th style="padding-right:0px;">Sales Order (pcs) <i class="fa fa-sort" id="sortIcon"></i></th>
                                            <th style="padding-right:0px;">Stock In (pcs)  <i class="fa fa-sort" id="sortIcon"></i></th>
                                            <th style="padding-right:0px;">Stock Out (pcs) <i class="fa fa-sort" id="sortIcon"></i></th>
                                            <th style="padding-right:0px;">Last Stock Take Amount<i class="fa fa-sort" id="sortIcon"></i></th>
                                            <th style="padding-right:0px;">Disparity<i class="fa fa-sort" id="sortIcon"></i></th>
                                            <th style="padding-right:0px;">Stock Take At <i class="fa fa-sort" id="sortIcon"></i></th>
                                            <th>In Transit (Pcs)</th>
                                            <th>Refunded (Pcs)</th>
                                        </tr>
                                    </thead>

                                    <!--Table Records-->
                                    <tbody>
                                        <%
                                            SKU[] skuArr = (SKU[]) session.getAttribute("skuArr");
                                            int[] totalSales = (int[]) session.getAttribute("totalSalesQty");
                                            int[] packagingQty = (int[]) session.getAttribute("packagingQty");
                                            int[] totalStockOut = (int[]) session.getAttribute("totalStockOut");
                                            int[] totalStockIn = (int[]) session.getAttribute("totalStockIn");
                                            int[] inTransit = (int[]) session.getAttribute("inTransit");
                                            int[] refundQty = (int[]) session.getAttribute("refundQty");
                                            AdjustedItem[] lastStockTake = (AdjustedItem[]) session.getAttribute("lastStockTake");
                                            LocalDateTime[] lastStockTakeDate = (LocalDateTime[]) session.getAttribute("lastStockTakeDate");
                                            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
                                            for (int i = 0; i < skuArr.length; i++) {
                                        %>
                                        <tr>
                                            <td style="padding-right: 50px;"><%= skuArr[i].getSkuNo() %></td>
                                            <td style="padding-right: 50px;text-align: left;"><%= skuArr[i].getColour() %></td>
                                            <td style="padding-right: 10px;text-align: left;"><%= skuArr[i].getProdSize() %></td>
                                            <td style="padding-right: 10px;text-align: left;"><%= skuArr[i].getProdLength() %></td>
                                            <td style="padding-right: 10px;text-align: left;"><%= skuArr[i].getProdWidth() %></td>
                                            <td style="padding-right: 10px;text-align: left;"><%= skuArr[i].getProduct().getProdID() %></td>
                                            <td style="padding-right: 10px;text-align: left;"><%= packagingQty[i] + skuArr[i].getSkuQty() %></td>
                                            <td style="padding-right: 10px;text-align: left;"><%= skuArr[i].getSkuQty() %></td>
                                            <td style="padding-right: 10px;text-align: left;"><%= totalSales[i] %></td>
                                            <td style="padding-right: 10px;text-align: left;"><%= totalStockIn[i] %></td>
                                            <td style="padding-right: 10px;text-align: left;"><%= totalStockOut[i] %></td>
                                            <% if(lastStockTake[i] != null){ %>
                                            <td style="padding-right: 10px;text-align: left;"><%= lastStockTake[i].getAdjustedQty() %></td>
                                            <td style="padding-right: 10px;text-align: left;"><%= lastStockTake[i].getAdjustQty() %></td>
                                            <td style="padding-right: 10px;text-align: left;"><%= lastStockTakeDate[i].format(formatter) %></td>
                                            <% }else{ %>
                                            <td style="padding-right: 10px;text-align: left;"> Never </td>
                                            <td style="padding-right: 10px;text-align: left;"> Unknown </td>
                                            <td style="padding-right: 10px;text-align: left;"> </td>
                                            <% } %>
                                            <td style="padding-right: 10px;text-align: left;"><%= inTransit[i] %></td>
                                            <td style="padding-right: 20px;text-align: left;"><%= refundQty[i] %></td>
                                            
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

