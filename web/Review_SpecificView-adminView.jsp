<%@ page errorPage="404Error.jsp" %>  
<%@page import="Model.Domain.Admin"%>
<%
    Admin admin = (Admin) session.getAttribute("admin");
%>  
<%@page import="Model.DA.DAReview"%>
<%@page import="Model.Domain.Cart"%>
<%@page import="Model.Domain.Review"%>
<%@page import="Model.DA.DACart"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8" />
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
        <link rel="shortcut icon" type="image/x-icon" href="assets/siteIcon.png" />
        <title> Edit Review - Fast&Fashion</title>
        <link href="css/styles.css" rel="stylesheet" />
        <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/js/all.min.js" crossorigin="anonymous"></script>
        <script src="components/topNavBar.js" type="text/javascript" defer></script>
        <script src="components/middleNavBar.js" type="text/javascript" defer></script>
        <script src="components/footer.js" type="text/javascript" defer></script>
        <script src="components/Review_header.js" type="text/javascript" defer></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
        
        
        <style>
            .inner
                {
                    display: inline-block;
                    margin-left:auto;
                }

                .footer .cancelbtn{
                    display: inline-block;
                    color: #161616;
                    background-color: white;
                }

                .footer .editReviewBtn{
                    display: inline-block;
                    background-color: #c96;
                }

                .footer .cancelbtn:hover {
                    background: lightgrey;
                }

                .footer .editReviewBtn:hover {
                    background: goldenrod;
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
                        <h1 class="mt-4"><review-header></review-header></h1>
                        <div class="card mb-4" id="innerPart">
                            <div class="card-header">
                                <i class="fa fa-info-circle" class="sb-nav-link-icon" style="font-size:28px; color: #353535;"></i>
                                <!--Table Title, action perform ?-->
                                Edit Review   
                              
                            </div>
                            <div class="card-body">
                                <!--Form that will collect & pass data-->
                                <%  
                                    //get the review ID from the previous page and get full review DATA
                                    DAReview reviewDA = new DAReview();
                                    Review review = reviewDA.getReview(request.getParameter("submit"));
                                    
                                    DACart cartDA = new DACart();
                                    //get the cart object
                                    Cart cart = cartDA.getSpecificCartDataByReviewID(review);
                                    //get the full review record
                                    
                                    
                                        
                                %>
                                <form action="ReviewController_Admin_UpdateReview" method="post">
                                    <!--input field, note: max 2 col per row only-->
                                    <table class="contentPage-table">
                                        <tr>
                                            <td>
                                                <label for="ReviewID">ReviewID</label><br/>
                                                <input type="text" name="ReviewID" value="<%=review.getReviewID()%>" readonly>
                                            </td>
                                            <td>
                                                <label for="ReviewDesc" >Review Description</label><br/>
                                                <textarea name="ReviewDesc" cols="50" rows="3" style="background-color: white;word-break:break-all" readonly><%=review.getReviewDesc()%></textarea>
                                                
                                                
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <label for="ReviewTime">Review Time</label><br/>
                                                <input type="text" name="ReviewTime" value ="<%=review.getFormatDate()%>" readonly>
                                            </td>
                                            <td>
                                                <label for="OrderID">Order ID</label><br/>
                                                <input type="text" name="OrderID" value ="<%=cart.getOrder().getOrderId()%>" readonly>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <label for="Hide">ReviewRating</label><br/> <!--Please always put remark at the bottom (last item)-->
                                                <input type="text" name="Hide" value ="<%=review.getReviewRating()%>" readonly>
                                            </td>
                                            <td>
                                                <label for="Hide">Hide</label><br/> <!--Please always put remark at the bottom (last item)-->
                                                <input type="text" name="Hide" value ="<%=review.getHide()%>" readonly>
                                            </td>
                                            
                                        </tr>
                                        <tr> 
                                            <td>
                                                <label for="SKU">SKU</label><br/>
                                                <input type="text" name="SKU" value ="<%=cart.getSKU().getSkuNo()%>" readonly>
                                            </td>
                                            <td>
                                                <label for="CustomerID">Customer ID</label><br/>
                                                <input type="text" name="CustomerID" value ="<%=cart.getCustomer().getUserID()%>" readonly>
                                            </td>
                                        </tr>
                                    </table>
                                    <br/><br/>

                                    <!--next button that will call the action-->
                                    <div class="footer" style="margin:auto;text-align:center">
                                   <div class="inner" style="margin:auto"><a href="Review_Summary-adminView.jsp"><button style="margin:auto"  class="cancelbtn" type="button" class="add-address-btn" style="float:right; "name="submit" value="<%=review.getReviewID()%>">Cancel</button></a> 
                                      <%if(review.getHide().equals("yes")){%>
                                       <button style="margin:auto" class="editReviewBtn" type="submit" class="add-address-btn" style="float:right; " name="submit" value="<%=review.getReviewID()%>">Unhide Review</button>&nbsp;&nbsp;&nbsp;</div>
                                        <%}else if(review.getHide().equals("no")){%>
                                    <button style="margin:auto" class="editReviewBtn" type="submit" class="add-address-btn" style="float:right; " name="submit" value="<%=review.getReviewID()%>">Hide Review</button>&nbsp;&nbsp;&nbsp;</div>
                                        <%}%>
                                    </div>
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
