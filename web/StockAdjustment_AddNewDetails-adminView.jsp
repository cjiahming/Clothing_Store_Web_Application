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
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    ArrayList<AdjustedItem> adItemList = (ArrayList<AdjustedItem>) session.getAttribute("adItemList");
    String action3 = (String) session.getAttribute("action3");
    String errMsg = null;
    String duplicatedSKU = null;
    if (action3.equalsIgnoreCase("error")) {
        errMsg = (String) session.getAttribute("errMsg");
        duplicatedSKU = (String) session.getAttribute("duplicatedSKU");
    }
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
        <% if(duplicatedSKU != null){ %><button id="duplicatedSKU" onclick="msg()" hidden="hidden"></button><%}%>
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
                                New   
                                <!--Action link to search record, link back to summary page-->
                                <a href="StockAdjustment_Summary-adminView.jsp" title="Summary"><i class="fa fa-filter" id="tableHeader-link-icon" ></i></a>
                                <!--Action link to add new record page-->
                                <a href="StockAdjustmentProcessRequestController?ac=new" title="Add New"><i class="fa fa-sticky-note" id="tableHeader-link-icon" ></i></a>
                            </div>
                            <div class="card-body">
                                <!--Form that will collect & pass data-->
                                <form id="adjustedList" action="StockAdjustmentAdjustedListsController"><input type="hidden" name="actionOnItem" value="new"/>
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
                                            String action1 = (String) session.getAttribute("action1");
                                            if (action1.equalsIgnoreCase("selectProduct")) {
                                                Product selectedProd = (Product) session.getAttribute("SA-selectedProd");
                                        %>
                                        <tr>
                                            <td><br/><label for="prodID">Product ID</label> <br/>
                                                <a href="StockAdjustment_SelectProduct-adminView.jsp"><input type="text" id="prodID" name="prodID" value="<%= selectedProd.getProdID()%>" readonly style="background-color: lightyellow;"></a>
                                            </td>
                                            <td><br/><label for="userName">Product Name</label> <br/><input type="text" readonly value="<%= selectedProd.getProdName()%>" readonly style="background-color: lightyellow;"></td>
                                        </tr>
                                        <% } else { %>
                                        <tr>
                                            <td><br/><label for="prodID">Product ID</label> <br/>
                                                <a href="StockAdjustment_SelectProduct-adminView.jsp">
                                                    <input type="text" readonly <% if (errMsg != null) {%> placeholder="<%= errMsg%>" style="border-color:red;"<% } %>></a>
                                            </td>
                                            <td><br/><label for="userName">Product Name</label> <br/><input type="text"  readonly ></td>
                                        </tr>
                                        <% } %>
                                        <!--To verify input of SKU is it matched with the selected prod ID-->
                                        <%
                                            String action2 = (String) session.getAttribute("action2");
                                            if (action2.equalsIgnoreCase("selectedSKU")) {
                                                Product selectedProd = (Product) session.getAttribute("SA-selectedProd");
                                                SKU selectedSKU = (SKU) session.getAttribute("SA-selectedSKU");
                                                if (selectedProd.getProdID().equalsIgnoreCase(selectedSKU.getProduct().getProdID())) {
                                        %>
                                        <tr>
                                            <td><label for="skuNo">SKU</label> <br/>
                                                <a href="StockAdjustmentDetailsProcessRequestController?ac=selectSKU"><input type="text" id="skuNo" name="skuNo" value="<%= selectedSKU.getSkuNo()%>" readonly style="background-color: lightyellow;" ></a>
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
                                        <% } else { %>
                                        <tr>
                                            <td><label for="skuNo">SKU</label> <br/>
                                                <a href="StockAdjustmentDetailsProcessRequestController?ac=selectSKU">
                                                    <input type="text" readonly <% if (errMsg != null) {%> placeholder="⚠ Input is required !" style="border-color:red;"<% } %>></a>
                                            </td>
                                            <td><label for="skuName">Product Color</label> <br/>
                                                <input type="text" id="skuName" name="skuName" readonly></td>
                                        </tr>
                                        <tr>
                                            <td><label for="length">Length (cm)</label> <br/>
                                                <input type="text" id="length" name="length" readonly>
                                            </td>
                                            <td><label for="userName">Width (cm)</label> <br/>
                                                <input type="text" id="userName" name="userName" readonly></td>
                                        </tr>
                                        <% }
                                        } else {%>
                                        <tr>
                                            <td><label for="skuNo">SKU</label> <br/>
                                                <a href="StockAdjustmentDetailsProcessRequestController?ac=selectSKU">
                                                    <input type="text" readonly <% if (errMsg != null) {%> placeholder="⚠ Input is required !" style="border-color:red;"<% } %>></a>
                                            </td>
                                            <td><label for="skuName">Product Color</label> <br/>
                                                <input type="text" id="skuName" name="skuName" readonly></td>
                                        </tr>
                                        <tr>
                                            <td><label for="length">Length (cm)</label> <br/>
                                                <input type="text" id="length" name="length" readonly>
                                            </td>
                                            <td><label for="userName">Width (cm)</label> <br/>
                                                <input type="text" id="userName" name="userName" readonly></td>
                                        </tr>
                                        <% } %>
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
                                                <input type="text" id="adjustQty" name="adjustQty" <% if (errMsg != null) {%> placeholder="<%= errMsg%>" style="border-color:red;"<% } %>>

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
                                <a href="StockAdjustmentAdjustedListsController?actionOnItem=eraseAll"><button id="action-button" name="eraseAll" title="Clear All" ><i class="fas fa-eraser"></i></button></a>
                                <button id="action-button2" name="next" title="Add"><i class="fa fa-plus"></i></button>
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
                                        %>
                                        <tr>
                                            <td>
                                                <!--Button to Edit the record-->
                                                <a href="StockAdjustmentAdjustedListsController?no=<%= i%>&actionOnItem=edit" title="Edit"><i class="fas fa-pen" id="tableBody-link-icon"></i></a>
                                                <!--Cancel the record-->
                                                <a href="StockAdjustmentAdjustedListsController?no=<%= i%>&actionOnItem=remove" title="Remove"><i class="fas fa-times" id="tableBody-link-icon"></i></a>
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
                                            <td style="padding-right:50px;"> pending approval </td>
                                            <td style="padding-right:50px;"><%= adItemList.get(i).getRemark()%></td>
                                        </tr>
                                        <% }%>
                                    </table>
                                </div>
                                <br/><br/><form id="saveItems" action="StockAdjustmentAdjustedListsController"><input type="hidden" name="actionOnItem" value="save"/></form>
                                <button id="SASaveButton"  title="Save" ><i class="fa fa-save"></i></button>
                                <form id="submitItems" action="StockAdjustmentAdjustedListsController"><input type="hidden" name="actionOnItem" value="submit"/></form>
                                <button id="SASubmitButton" title="Submit" ><i class="fa fa-upload" ></i></button><br/><br/><br/><br/>
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
           

            document.querySelector('#SASaveButton').addEventListener('click', () => {
                Confirm.open({
            <% if (adItemList.size() <= 0) {%>
                title: 'ERROR',
                        message: 'Please add at least one row of record to before submit.',
                        onok: () => {
                var form = document.getElementById("");}
            <% } else {%>
                title: 'Save New Stock Adjustment',
                        message: 'Confirm to save ?',
                        onok: () => {
                var form = document.getElementById("saveItems");
                        form.submit();}
            <% }%>

                })
                } );


                document.querySelector('#SASubmitButton').addEventListener('click', () => {
                    Confirm.open({
            <% if (adItemList.size() <= 0) {%>
                    title: 'ERROR',
                    message: 'Please add at least one row of record to before submit.',
                            onok: () => {
                    var form = document.getElementById("");
            <% } else {%>
                    title: 'Submit Stock Adjustment',
                            message: 'Confirm to submit ?',
                    onok: () => {
                        var form = document.getElementById("submitItems");
                        form.submit();
            <% }%>

                    }
                })
            });
        </script>
        <script>
            document.querySelector('#action-button2').addEventListener('click', () => {
                // Submit the form using javascript
                var form = document.getElementById("adjustedList");
                form.submit();
            });

            document.querySelector('#duplicatedSKU').addEventListener('click', () => {
                Confirm.open({
                    title: 'DUPLICATED SKU',
                    message: '<%= duplicatedSKU %>',
                    onok: () => {
                    }})
            });
		document.getElementById("duplicatedSKU").click();
	</script>


    </body>
</html>
