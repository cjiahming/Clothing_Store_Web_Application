<%-- 
    Document   : SKU_Update-adminView
    Created on : 
    Author     : Cheng Cai Yuan
--%>
<%@ page errorPage="404Error.jsp" %>  
<%@page import="Model.Domain.Admin"%>
<%
    Admin admin = (Admin) session.getAttribute("admin");
%>
<%@page import="java.util.ArrayList"%>
<%@page import="Model.DA.DASKU"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Model.Domain.SKU" %>
<%
    DASKU daSku = new DASKU();
    int selected = 0;
    if(request.getParameter("selectedRow") != null){
        selected = Integer.parseInt(request.getParameter("selectedRow"));   // Get index of the selected record
        session.setAttribute("selected", selected);
    }
    else{
        selected = Integer.parseInt(session.getAttribute("selected").toString());
    }
    ArrayList<SKU> skuList = daSku.getAllSKU();
    
    session.setAttribute("skuList",skuList);
    session.setAttribute("skuObj", skuList.get(selected));
    
    String errorWidthMessage = "";
    errorWidthMessage = (String)session.getAttribute("errorWidthMessage");
    String errorLengthMessage = "";
    errorLengthMessage = (String)session.getAttribute("errorLengthMessage");
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8" />
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
        <link rel="shortcut icon" type="image/x-icon" href="assets2/siteIcon.png" />
        <title> Update SKU - Fast&Fashion</title>
        <link href="css/styles.css" rel="stylesheet" />
        <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/js/all.min.js" crossorigin="anonymous"></script>
        <script src="components/topNavBar.js" type="text/javascript" defer></script>
        <script src="components/middleNavBar.js" type="text/javascript" defer></script>
        <script src="components/footer.js" type="text/javascript" defer></script>
        <script src="components/SKU_header.js" type="text/javascript" defer></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
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
                                Update   
                                <!--Action link to link back to summary page-->
                                <a href='SKU_Summary-adminView.jsp' title="Summary"><i class="fa fa-filter" id="tableHeader-link-icon" ></i></a>
                                <!--Action link to add new record page-->
                                <a href='SKU_AddNew-adminView.jsp' title="Add New"><i class="fa fa-sticky-note" id="tableHeader-link-icon" ></i></a>
                            </div>
                            <div class="card-body">
                                <!--Form that will collect & pass data-->
                                <form method="post" action="SKUController">
                                    <!--input field, note: max 2 col per row only-->
                                    <table class="contentPage-table">
                                        <tr>            
                                            <td><label for="prodWidth">Width (cm)</label><br/>
                                                <input type="text" id="prodWidth" name="prodWidth" placeholder="Product Width" required>
                                                <!--error message for product width if the user input invalid data-->
                                                <% if(errorWidthMessage != null) { %>
                                                <div style="color:red; background-color: transparent;"><%= errorWidthMessage %></div>
                                                <% session.removeAttribute("errorWidthMessage");} %>
                                            </td>
                                        </tr>
                                        <tr>            
                                            <td><label for="prodLength">Length (cm)</label><br/>
                                                <input type="text" id="prodLength" name="prodLength" placeholder="Product Length" required>
                                                <!--error message for product length if the user input invalid data-->
                                                <% if(errorLengthMessage != null) { %>
                                                <div style="color:red; background-color: transparent;"><%= errorLengthMessage %></div>
                                                <% session.removeAttribute("errorLengthMessage");} %> 
                                                
                                            </td>
                                        </tr>      
                                    </table>

                                    <!--next button that will call the action-->
                                    <br/><br/><button id="action-button" type="submit" name="action" value="update"><i class="fa fa-chevron-right"></i></button><br/><br/><br/><br/>
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
        <script src="js/datatables-simple-demo.js"></script>
    </body>
</html>

