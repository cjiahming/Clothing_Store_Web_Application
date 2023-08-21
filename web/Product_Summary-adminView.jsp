<%-- 
    Document   : Product_Summary-adminView
    Created on : Mar 19, 2022, 9:05:05 PM
    Author     : Ashley
--%>
<%@ page errorPage="404Error.jsp" %>  
<%@page import="Model.Domain.Admin"%>
<%
    Admin admin = (Admin) session.getAttribute("admin");
    if(admin.getUserGroup().getAccessRights().charAt(1)=='0'){ 
%>  <jsp:forward page="401Error.jsp" /> <%}%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Model.Domain.Product" %>
<jsp:include page="/ProductController_Admin_Summary" />

<!DOCTYPE html>
<html>
    <style>
        #table-productEnquiry {
            font-family: arial, sans-serif;
            border-collapse: collapse;
            width: 100%;
        }

        #table-productEnquiry td { 
            width: 33%;
            padding-left: 2rem;
        }

        #table-productEnquiry input[type=text],#table-productEnquiry select {
            padding: 12px 20px;
            margin: 8px 0;
            display: inline-block;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box;
            width: 90%;
        }
        
        input[type=number]{
            padding: 12px 20px;
            margin: 8px 0;
            display: inline-block;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box;
            width: 90%;
        }

    </style>
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
        <script src="components/Product_header.js" type="text/javascript" defer></script>
        <title>Product Summary - Fast&Fashion</title>
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
                        <h1 class="mt-4"><product-header></product-header></h1>
                        <div class="card mb-4" id="innerPart">
                            <div class="card-header">
                                <i class="fa fa-info-circle" class="sb-nav-link-icon" style="font-size:28px; color: #353535;"></i>
                                <!--Table Title, action perform ?-->
                                Summary   
                                <!--Action link to search record, link back to summary page-->
                                <a href="Product_Summary-adminView.jsp" title="Summary"><i class="fa fa-filter" id="tableHeader-link-icon" ></i></a>
                                <!--Action link to add new record page-->
                                <a href="Product_AddNew-adminView.jsp" title="Add New"><i class="fa fa-sticky-note" id="tableHeader-link-icon" ></i></a>
                            </div>
                            <div class="card-body">
                                <form id="product" >
                                    <table id="table-productEnquiry">
                                        <tr>
                                            <td>
                                                <label for="prodPrice">Product Price Range*</label><br/>
                                                <input type="number" min="0.00" max="99999999.99" step="0.01" id="prodPriceMin" name="prodPriceMin" placeholder="Minimum" required />
                                            </td>
                                            <td>
                                                <label for="prodPrice">&nbsp;</label><br/>
                                                <input type="number" min="0.00" max="99999999.99" step="0.01" id="prodPriceMax" name="prodPriceMax" placeholder="Maximum" required />
                                            </td>
                                            <td>
                                                <label for="prodCategory">Product Category</label><br/>
                                                <select name="prodCategory" >
                                                    <option value= " " disabled selected hidden>Select your option...</option>
                                                    <option value = "WomenTops">Women Tops</option>
                                                    <option value = "WomenSweatshirts">Women Sweatshirts</option>
                                                    <option value = "WomenBottoms">Women Bottoms</option>
                                                    <option value = "WomenDresses">Women Dresses</option>
                                                    <option value = "MenTops">Men Tops</option>
                                                    <option value = "MenSweatshirts">Men Sweatshirts</option>
                                                    <option value = "MenBottoms">Men Bottoms</option>
                                                </select>
                                            </td>
                                        </tr>
                                    </table>
                                    <span style="color: red; font-size:13px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*Price Range is a required field</span>
                                    <button id="action-button" type="submit" name="Search" style="margin-top: 5px;height: 40px;width: 40px;font-size: 18px;margin-right: 25px;"><i class="fa fa-search"></i></button><br/><br/><br/>
                                </form>    

                                <table id="datatablesSimple">
                                    <!--Data Fields-->
                                    <thead id="view-thead">
                                        <tr>
                                            <th>Action</th>
                                            <th style="padding-right: 2px;">Line No. </th>
                                            <th>Product ID</th>
                                            <th>Product Name</th>
                                            <th>Product Desc</th>
                                            <th>Product Price</th>  
                                            <th>Product Category</th>
                                            <th>Product Image</th>
                                        </tr>
                                    </thead>

                                    <!--Table Records-->
                                    <tbody>
                                        <%
                                            Product[] prod = (Product[]) session.getAttribute("productList");
                                            for (int i = 0; i < prod.length; i++) {
                                                java.util.Formatter formatter = new java.util.Formatter();
                                                
                                                out.println("<tr>");
                                                out.println("<td>");
                                                //Button to view the record
                                                out.println("<a href=\"ProductController_Admin_View?prodID=" + prod[i].getProdID() + "\" title=\"View\"><i class=\'fas fa-book\' id=\"tableBody-link-icon\"></i></a>");
                                                //<!--Edit the record-->
                                                out.println("<a href=\"ProductController_Admin_Edit?prodID=" + prod[i].getProdID() + "\" title=\"Edit\"><i class=\'fas fa-pen\' id=\"tableBody-link-icon\"></i></a>");
                                                //<!--Cancel the record-->
                                                out.println("<a href=\"ProductController_Admin_Delete?prodID=" + prod[i].getProdID() + "\" title=\"Delete\"><i class=\'fas fa-trash-alt\' id=\"tableBody-link-icon\"></i></a>");
                                                out.println("</td>");
                                                out.println("<td>");
                                                out.println(i + 1);
                                                out.println("</td>");
                                                out.println("<td>");
                                                out.println(prod[i].getProdID());
                                                out.println("</td>");
                                                out.println("<td>");
                                                out.println(prod[i].getProdName());
                                                out.println("</td>");
                                                out.println("<td>");
                                                out.println(prod[i].getProdDesc());
                                                out.println("</td>");
                                                out.println("<td>");
                                                out.println(formatter.format("%.2f", prod[i].getProdPrice()));
                                                out.println("</td>");
                                                out.println("<td>");
                                                out.println(prod[i].getProdCategory());
                                                out.println("</td>");
                                                out.println("<td>");
                                                out.println(prod[i].getProdImage());
                                                out.println("</td>");
                                                out.println("</tr>");

                                            }%>

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

