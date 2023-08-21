<%-- 
    Document   : SKUEnquiryReport-adminView
    Created on : Apr 14, 2022, 11:52:42 PM
    Author     : jiyeo
--%>

<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="Model.Domain.AdjustedItem"%>
<%@page import="Model.Domain.SKU"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>SKU | Inventory Report</title>
        <link rel='stylesheet' href='css/StockReport.css'>
    </head>
    <body>
        <div class="container">
            <div class="card">
                <div class="card-header">
                    <strong>Stock Keeping Unit (SKU) | Inventory Report</strong>
                    <span class="float-right"><b> Printed at: </b><%= LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")) %></span>

                </div>
                <div class="card-body">
                    <div class="row mb-4">
                        <div class="col-sm-6">
                            <img src="assets/logo_whtbg.png" style="height:100px;"/>
                            <div style="padding-left: 25px;">
                                <strong>Fash & Fashion Sdn. Bhd.</strong>
                                <div>Madalinskiego 8</div>
                            <div>71-101 Szczecin, Poland</div>
                            <div>Email: info@dotnettec.com | Phone: +91 9800000000</div>
                            </div>
                            
                        </div>

                      
                    </div>

                    <div class="table-responsive-sm">
                        <table class="table table-striped">
                            <thead>
                                <tr>
                                    <th class="center" style="text-align: center;">#</th>
                                    <th class="left">SKU</th>
                                    <th class="left">Color </th>
                                    <th class="center" style="text-align: center;">Size  </th>
                                    <th class="center" style="text-align: center;">Length (cm) </th>
                                    <th class="center" style="text-align: center;">Width (cm)  </th>
                                    <th class="center" style="text-align: center;">Product ID </th>
                                    <th class="center" style="text-align: center;">On Hand Quantity </th>
                                    <th class="center" style="text-align: center;">Available Quantity </th>
                                    <th class="center" style="text-align: center;">Sales Order (pcs) </th>
                                    <th class="center" style="text-align: center;">Stock In (pcs)  </th>
                                    <th class="center" style="text-align: center;">Stock Out (pcs) </th>
                                    <th class="center" style="text-align: center;">Last Stock Take Amount</th>
                                    <th class="center" style="text-align: center;">Disparity</th>
                                    <th class="center" style="text-align: center;">Stock Take At </th>
                                    <th class="center" style="text-align: center;">In Transit (pcs)</th>
                                    <th class="center" style="text-align: center;">Refunded (pcs)</th>
                                </tr>
                            </thead>
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
                                            DateTimeFormatter dateFormat = DateTimeFormatter.ofPattern("yyyy-MM-dd");
                                            DateTimeFormatter timeFormat = DateTimeFormatter.ofPattern("HH:mm:ss");
                                            for (int i = 0; i < skuArr.length; i++) {
                                        %>
                                        <tr>
                                            <td><%= (i+1) %></td>
                                            <td style="white-space: nowrap;"><%= skuArr[i].getSkuNo() %></td>
                                            <td style="text-align: center;"><%= skuArr[i].getColour() %></td>
                                            <td style="text-align: center;"><%= skuArr[i].getProdSize() %></td>
                                            <td style="text-align: center;"><%= skuArr[i].getProdLength() %></td>
                                            <td style="text-align: center;"><%= skuArr[i].getProdWidth() %></td>
                                            <td style="text-align: center;"><%= skuArr[i].getProduct().getProdID() %></td>
                                            <td style="text-align: center;"><%= packagingQty[i] + skuArr[i].getSkuQty() %></td>
                                            <td style="text-align: center;"><%= skuArr[i].getSkuQty() %></td>
                                            <td style="text-align: center;"><%= totalSales[i] %></td>
                                            <td style="text-align: center;"><%= totalStockIn[i] %></td>
                                            <td style="text-align: center;"><%= totalStockOut[i] %></td>
                                            <% if(lastStockTake[i] != null){ %>
                                            <td style="text-align: center;"><%= lastStockTake[i].getAdjustedQty() %></td>
                                            <td style="text-align: center;"><%= lastStockTake[i].getAdjustQty() %></td>
                                            <td style="white-space: nowrap;"><%= lastStockTakeDate[i].format(dateFormat) %> <br/><%= lastStockTakeDate[i].format(timeFormat) %></td>
                                            <% }else{ %>
                                            <td style="text-align: center;"> Never </td>
                                            <td style="text-align: center;"> Unknown </td>
                                            <td style="text-align: center;"> </td>
                                            <% } %>
                                            <td style="text-align: center;"><%= inTransit[i] %></td>
                                            <td style="text-align: center;"><%= refundQty[i] %></td>
                                            
                                        </tr>
                                        <% }%>


                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>