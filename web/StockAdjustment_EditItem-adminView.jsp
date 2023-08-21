<%-- 
    Document   : StockAdjustment-ItemList
    Created on : Apr 7, 2022, 1:14:47 PM
    Author     : jiyeo
--%>
<%@ page errorPage="404Error.jsp" %>  
<%@page import="Model.Domain.Admin"%>
<%
    Admin admin = (Admin) session.getAttribute("admin");
%>
<%@page import="java.util.ArrayList"%>
<%@page import="Model.Domain.SKU"%>
<%@page import="Model.Domain.Product"%>
<%@page import="Model.Domain.AdjustedItem" %>
<jsp:useBean id="adjustItem" scope="session" class="Model.Domain.AdjustedItem"></jsp:useBean>
<jsp:setProperty name="adjustItem" property="*" />
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    ArrayList<AdjustedItem> adItemList = (ArrayList<AdjustedItem>) session.getAttribute("adItemList");
    String action3 = (String) session.getAttribute("action3");
    AdjustedItem editItem = null;
    if (action3.equalsIgnoreCase("edit")) {
        editItem = (AdjustedItem) session.getAttribute("editItem");
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
        <link rel="shortcut icon" type="image/x-icon" href="assets/siteIcon.png" />
        <title> New Stock Adjustment - Fast&Fashion </title>
        <link href="css/styles.css" rel="stylesheet" />
        <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/js/all.min.js" crossorigin="anonymous"></script>
        <script src="components/topNavBar.js" type="text/javascript" defer></script>
        <script src="components/middleNavBar.js" type="text/javascript" defer></script>
        <script src="components/footer.js" type="text/javascript" defer></script>
        <script src="components/StockAd_header.js" type="text/javascript" defer></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
        <style>
            table#accessRightLists th{
                padding-bottom: 5px;
                padding-top: 5px;
            }
            table#accessRightLists td{
                padding-bottom: 15px;
                padding-top: 5px;
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
                        <h1 class="mt-4"><stock-header></stock-header></h1>
                        <div class="card mb-4" id="innerPart">
                            <div class="card-header">
                                <i class="fa fa-info-circle" class="sb-nav-link-icon" style="font-size:28px; color: #353535;"></i>
                                <!--Table Title, action perform ?-->
                                Modify   
                                <!--Action link to search record, link back to summary page-->
                                <a href="StockAdjustment_Summary-adminView.jsp" title="Summary"><i class="fa fa-filter" id="tableHeader-link-icon" ></i></a>
                                <!--Action link to add new record page-->
                                <a href="StockAdjustmentProcessRequestController?ac=new" title="Add New"><i class="fa fa-sticky-note" id="tableHeader-link-icon" ></i></a>
                            </div>
                            <div class="card-body">
                                <!--Form that will collect & pass data-->
                                <form id="adjustedList" action="StockAdjustmentAdjustedListsController"><input type="hidden" name="actionOnItem" value="update"/>
                                    <!--input field, note: max 2 col per row only-->
                                    <table class="contentPage-table">
                                        <tr>
                                            <td><label for="lineNo">Line No.</label> <br/>
                                                <%
                                                    if (action3.equalsIgnoreCase("edit")) {
                                                %>
                                                <input type="text" id="lineNo" name="lineNo" value="<%= (Integer) session.getAttribute("lineNo") + 1%>" readonly>
                                                <% } else {%>
                                                <input type="text" id="lineNo" name="lineNo" value="<%= adItemList.size() + 1%>" readonly>
                                                <% } %>
                                            </td>
                                            <td></td>
                                        </tr>
                                        <%
                                            Product selectedProd = (Product) session.getAttribute("SA-selectedProd");
                                        %>
                                        <tr>
                                            <td><br/><label for="prodID">Product ID</label> <br/>
                                                <input type="text" id="prodID" name="prodID" value="<%= selectedProd.getProdID()%>" readonly style="background-color: lightyellow;">
                                            </td>
                                            <td><br/><label for="userName">Product Name</label> <br/><input type="text" readonly value="<%= selectedProd.getProdName()%>" readonly style="background-color: lightyellow;"></td>
                                        </tr>
                                        <!--To verify input of SKU is it matched with the selected prod ID-->
                                        <%
                                            SKU selectedSKU = (SKU) session.getAttribute("SA-selectedSKU");
                                        %>
                                        <tr>
                                            <td><label for="skuNo">SKU</label> <br/>
                                                <input type="text" id="skuNo" name="skuNo" value="<%= selectedSKU.getSkuNo()%>" readonly style="background-color: lightyellow;" >
                                            </td>
                                            <td><label for="skuName">Product Color</label> <br/>
                                                <input type="text" id="skuName" name="skuName" value="<%= selectedSKU.getColour()%>" readonly style="background-color: lightyellow;"></td>
                                        </tr>
                                        <tr>
                                            <td><label for="length">Length (cm)</label> <br/>
                                                <input type="text" id="length" name="length" value="<%= selectedSKU.getProdLength()%>" readonly style="background-color: lightyellow;">
                                            </td>
                                            <td><label for="width">Width (cm)</label> <br/>
                                                <input type="text" id="width" name="width" value="<%= selectedSKU.getProdWidth()%>" readonly style="background-color: lightyellow;"></td>
                                        </tr>
                                        <tr>
                                            <td><label>
                                                    <% //get the stock action and display the corresponding field name
                                                        String stockAction = (String) session.getAttribute("stockAction");
                                                        if (stockAction.equalsIgnoreCase("stockIn")) {                                                            %>
                                                    Stock In Quantity
                                                    <% } else if (stockAction.equalsIgnoreCase("stockOut")) { %>
                                                    Stock Out Quantity
                                                    <% } else { %>
                                                    Stock Take Quantity
                                                    <% } %>
                                                </label> <br/>
                                                <% if (action3.equalsIgnoreCase("edit")) {%>
                                                <input type="text" id="adjustQty" name="adjustQty" value="<%= editItem.getAdjustQty()%>">
                                                <% } else { %>
                                                <input type="text" id="adjustQty" name="adjustQty">
                                                <% } %>
                                            </td>
                                            <td><label for="userName">Adjusted Quantity</label> <br/>
                                                <input type="text" readonly>
                                        </tr>
                                        <tr>
                                            <td><label for="remark">Remark</label><br/> <!--Please always put remark at the bottom (last item)-->
                                                <% if (action3.equalsIgnoreCase("edit")) {%>
                                                <textarea id="remark" name="remark" rows="4" cols="50" ><%= editItem.getRemark()%></textarea>
                                                <% } else { %>
                                                <textarea id="remark" name="remark" rows="4" cols="50"></textarea>
                                                <% } %>

                                            </td>
                                            <td></td>
                                        </tr>
                                    </table>
                                </form>
                                <!----------------------------------------------->
                                <button id="action-button" name="eraseAll" title="Clear All" ><i class="fas fa-eraser"></i></button>
                                <button id="action-button2" name="next" title="Update" style="background-color: #CFE890;"><i class="far fa-edit" style="color:darkslategray"></i></button>
                                <br/><br/><br/>

                                <div style="overflow-x:auto;">
                                    <table id="accessRightLists" style="white-space: nowrap;">
                                        <thead style="padding-bottom: 100px;">
                                            <tr>
                                                <th style="padding-right:80px;">Action</th>
                                                <th style="padding-right:10px;">Line No.</th>
                                                <th >SKU</th>
                                                <th >Product ID</th>
                                                <th >Product Name</th>
                                                <th>Size</th>
                                                <th>Color</th>
                                                <th style="padding-right:50px;">Length(cm)</th>
                                                <th style="padding-right:50px;">Width(cm)</th>
                                                <th style="padding-right:50px;">Initial Quantity</th>
                                                <th style="padding-right:50px;">Adjust Quantity</th>
                                                <th style="padding-right:30px;">Adjusted Quantity</th>
                                                <th style="padding-right:300px;">Remark</th>
                                            </tr>
                                        </thead>
                                        <!------------------------------------------------------------------------------------------------------------------------------------------------->

                                        <%
                                            for (int i = 0; i < adItemList.size(); i++) {
                                                if (i == (Integer) session.getAttribute("lineNo")) {
                                        %>
                                        <tr>
                                            <td style="background-color: #E2F0D9;">
                                                <!--Button to Edit the record-->
                                                <a href="" title="Edit"><i class="fas fa-pen" id="tableBody-link-icon" style="background-color: #CFE890;color:darkslategray; border-color: darkslategray;"></i></a>
                                                <!--Cancel the record-->
                                                <a  title="Please complete the update before removing."><i class="fas fa-trash-alt" id="tableBody-link-icon" style="background-color:darkgrey;color:black;border-color: darkgray;"></i></a>
                                            </td>
                                            <td style="background-color: #E2F0D9;"><%= (i + 1)%></td>
                                            <td style="padding-right:50px;background-color: #E2F0D9;"><%= adItemList.get(i).getSku().getSkuNo()%></td>
                                            <td style="padding-right:50px;background-color: #E2F0D9;"><%= adItemList.get(i).getSku().getProduct().getProdID()%></td>
                                            <td style="padding-right:50px;background-color: #E2F0D9;"><%= adItemList.get(i).getSku().getProduct().getProdName()%></td>
                                            <td style="padding-right:50px;background-color: #E2F0D9;"><%= adItemList.get(i).getSku().getProdSize()%></td>
                                            <td style="padding-right:50px;background-color: #E2F0D9;"><%= adItemList.get(i).getSku().getColour()%></td>
                                            <td style="padding-right:50px;background-color: #E2F0D9;"><%= adItemList.get(i).getSku().getProdLength()%></td>
                                            <td style="padding-right:50px;background-color: #E2F0D9;"><%= adItemList.get(i).getSku().getProdWidth()%></td>
                                            <td style="padding-right:50px;background-color: #E2F0D9;"><%= adItemList.get(i).getInitialQty()%></td>
                                            <td style="padding-right:50px;background-color: #E2F0D9;"><%= adItemList.get(i).getAdjustQty()%></td>
                                            <td style="padding-right:50px;background-color: #E2F0D9;"> pending approval </td>
                                            <td style="padding-right:50px;background-color: #E2F0D9;"><%= adItemList.get(i).getRemark()%></td>
                                        </tr>
                                        <% } else {%>
                                        <tr>
                                            <td>
                                                <!--Button to Edit the record-->
                                                <a href="StockAdjustmentAdjustedListsController?no=<%= i%>&actionOnItem=edit" title="Edit"><i class="fas fa-pen" id="tableBody-link-icon"></i></a>
                                                <!--Cancel the record-->
                                                <a href="StockAdjustmentAdjustedListsController?no=<%= i%>&actionOnItem=delete" title="Delete"><i class="fas fa-trash-alt" id="tableBody-link-icon"></i></a>
                                            </td>
                                            <td><%= (i + 1)%></td>
                                            <td style="padding-right:50px;"><%= adItemList.get(i).getSku().getSkuNo()%></td>
                                            <td style="padding-right:50px;"><%= adItemList.get(i).getSku().getProduct().getProdID()%></td>
                                            <td style="padding-right:50px;"><%= adItemList.get(i).getSku().getProduct().getProdName()%></td>
                                            <td style="padding-right:50px;"><%= adItemList.get(i).getSku().getProdSize()%></td>
                                            <td style="padding-right:50px;"><%= adItemList.get(i).getSku().getColour()%></td>
                                            <td style="padding-right:50px;"><%= adItemList.get(i).getSku().getProdLength()%></td>
                                            <td style="padding-right:50px;"><%= adItemList.get(i).getSku().getProdWidth()%></td>
                                            <td style="padding-right:50px;"><%= adItemList.get(i).getInitialQty()%></td>
                                            <td style="padding-right:50px;"><%= adItemList.get(i).getAdjustQty()%></td>
                                            <td style="padding-right:50px;"><%= adItemList.get(i).getAdjustedQty()%></td>
                                            <td style="padding-right:50px;"><%= adItemList.get(i).getRemark()%></td>
                                        </tr>
                                        <% }
                                            }%>

                                    </table>
                                </div>
                                <br/><br/>
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
        <script>
            document.querySelector('#action-button2').addEventListener('click', () => {
                // Submit the form using javascript
                var form = document.getElementById("adjustedList");
                form.submit();
            });

            document.querySelector('#action-button').addEventListener('click', () => {
                Confirm.open({
                    title: 'Still In Update Mode',
                    message: 'Please complete the update before clear all the field.',
                    onok: () => {
                        var form = document.getElementById("adjustedList");
                    }
                })
            });
        </script>
        <script src="js/confirm.js"></script>
    </body>
</html>
