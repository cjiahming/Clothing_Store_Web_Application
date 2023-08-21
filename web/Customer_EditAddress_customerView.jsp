<%-- 
    Document   : Customer_EditAddress_customerView
    Author     : Choong Jiah Ming
--%>

<%@page import="Model.DA.DAAddress"%>
<%@page import="java.util.ArrayList"%>
<%@page import="Model.Domain.Address"%>
<%@page import="Model.Domain.Customer"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page errorPage="Customer_LoginPage_customerView.jsp"%>
<jsp:useBean id="addressDA" scope="application" class="Model.DA.DAAddress"/>
<%
    response.setHeader("Cache-Control", "no-cache");
    response.setHeader("Cache-Control", "no-store");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    if (session.getAttribute("customer") == null) {
        response.sendRedirect("Customer_LoginPage_customerView.jsp");
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>Manage Address Customer - Fast&Fashion</title>
        <meta name="keywords" content="HTML5 Template">
        <meta name="description" content="Molla - Bootstrap eCommerce Template">
        <meta name="author" content="p-themes">
        <!-- Favicon -->
        <link rel="apple-touch-icon" sizes="180x180" href="assets/images/icons/apple-touch-icon.png">
        <link rel="icon" type="image/png" sizes="32x32" href="assets/images/icons/favicon-32x32.png">
        <link rel="icon" type="image/png" sizes="16x16" href="assets/images/icons/favicon-16x16.png">
        <link rel="manifest" href="assets/images/icons/site.html">
        <link rel="mask-icon" href="assets/images/icons/safari-pinned-tab.svg" color="#666666">
        <link rel="shortcut icon" href="assets/images/icons/favicon.ico">
        <link rel="shortcut icon" type="image/x-icon" href="assets/siteIcon.png" />
        <meta name="apple-mobile-web-app-title" content="Molla">
        <meta name="application-name" content="Molla">
        <meta name="msapplication-TileColor" content="#cc9966">
        <meta name="msapplication-config" content="assets/images/icons/browserconfig.xml">
        <meta name="theme-color" content="#ffffff">
        <!-- Plugins CSS File -->
        <link rel="stylesheet" href="assets/css/bootstrap.min.css">
        <!-- Main CSS File -->
        <link rel="stylesheet" href="assets/css/style.css">
        <link rel="stylesheet" href="assets/css/manageaddress.css">
    </head>
    <body>

        <%
            HttpSession httpSession = request.getSession();
            Customer customer = (Customer) (httpSession.getAttribute("customer"));
            Address adr = (Address) (httpSession.getAttribute("editAddress"));
            ArrayList<Address> a = addressDA.displayAllAddressRecords(customer.getUserID());
        %>
        <div class="page-header text-center" style="background-image: url('assets/images/page-header-bg.jpg')">
            <div class="container">
                <h1 class="page-title">My Account<span>Edit Address</span></h1>
            </div><!-- End .container -->
        </div><!-- End .page-header -->
        <nav aria-label="breadcrumb" class="breadcrumb-nav mb-3">
            <div class="container">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item"><a href="Product_SelectCategory-customerView.jsp">Home</a></li>
                    <li class="breadcrumb-item"><a href="Product_SelectCategory-customerView.jsp">Shop</a></li>
                    <li class="breadcrumb-item active" aria-current="page">My Account</li>
                </ol>
            </div><!-- End .container -->
        </nav><!-- End .breadcrumb-nav -->


        <div class="overlay">
            <div class="editaddress-container">
                <div class="header-address">
                    <h3>Edit Address</h3>
                </div>
                <div class="body">
                    <form action="UpdateCustomerAddressController" method="post" class="form">

                        <div class="sameline">
                            <input id="fullname" name="updateaddress-fullname" type="text" value="<%=adr.getFullName()%>" required placeholder="Full Name" />
                            <input id="phonenum" name="updateaddress-phonenumber" type="tel" maxlength="12" onKeyup='addDashes(this)' value="<%=adr.getAdrPhoneNum()%>" required placeholder="Phone Number" />
                        </div>

                        <div>
                            <select id="stateSelect" name="stateSelect" size="1" required onchange="makeSubmenu(this.value)">
                                <%=adr.getStates()%>
                                <option value="" disabled selected>Choose State</option>
                                <option value="Penang" <% if (adr.getStates().equals("Penang")) {
                                        %>selected<% }
                                        %>>Penang</option>

                                <option <% if (adr.getStates().equals("Ipoh")) {
                                    %>selected<% }
                                    %>>Ipoh</option>

                                <option <% if (adr.getStates().equals("Kuala Lumpur")) {
                                    %>selected<% }
                                    %>>Kuala Lumpur</option>

                                <option <% if (adr.getStates().equals("Pahang")) {
                                    %>selected<% }
                                    %>>Pahang</option>

                                <option <% if (adr.getStates().equals("Negeri Sembilan")) {
                                    %>selected<% }
                                    %>>Negeri Sembilan</option>

                                <option <% if (adr.getStates().equals("Selangor")) {
                                    %>selected<% }
                                    %>>Selangor</option>

                                <option <% if (adr.getStates().equals("Perlis")) {
                                    %>selected<% }
                                    %>>Perlis</option>

                                <option <% if (adr.getStates().equals("Kedah")) {
                                    %>selected<% }
                                    %>>Kedah</option>

                                <option <% if (adr.getStates().equals("Terengganu")) {
                                    %>selected<% }
                                    %>>Terengganu</option>

                                <option <% if (adr.getStates().equals("Melaka")) {
                                    %>selected<% }
                                    %>>Melaka</option>

                                <option <% if (adr.getStates().equals("Johor")) {
                                    %>selected<% }
                                    %>>Johor</option>

                                <option <% if (adr.getStates().equals("Sabah")) {
                                    %>selected<% }
                                    %>>Sabah</option>

                                <option <% if (adr.getStates().equals("Sarawak")) {
                                    %>selected<% }
                                    %>>Sarawak</option>
                            </select>
                        </div>



                        <div>
                            <select id="areaSelect" name="areaSelect" required size="1" >
                                <%
                                    ArrayList<String> cities = addressDA.getArea(adr.getStates());
                                %><option value="<%=adr.getArea()%>"><%=adr.getArea()%></option>;<%
                                    for (int i = 0; i < cities.size(); i++) {
                                        if (!adr.getArea().equals(cities.get(i))) {
                                %>
                                <option value="<%=cities.get(i)%>"><%=cities.get(i)%></option>
                                <%
                                        }
                                    }
                                %>

                            </select>
                        </div>

                        <div>
                            <input id="poscode" name="updateaddress-poscode" type="text" maxlength="5" value="<%=adr.getPosCode()%>" required placeholder="Postal Code" />
                        </div>

                        <input id="addressline" name="updateaddress-addressline" type="text" value="<%=adr.getAddressLine()%>" required placeholder="House Number, Street Name, etc." />

                        <input id="addressid" name="updateaddress-addressid" type="hidden" value="<%=adr.getAddressID()%>" />

                        <div class="footer">
                            <div class="inner"><button type="button" class="cancelbtn" onClick="history.back()">Cancel</button></div>
                            <div class="inner"><button type="submit" class="savebtn">Save</button></div>
                        </div>
                    </form>
                </div>

            </div>
            <%@ include file="footer-customerView.jsp"%> 
        </div>

        <script>
            function toggleLogin() {
                document.getElementById('fullname').value = "";
                document.getElementById('phonenum').value = "";
                document.getElementById('stateSelect').value = "";
                document.getElementById('areaSelect').value = "";
                document.getElementById('poscode').value = "";
                document.getElementById('addressline').value = "";
            }


            var citiesByState = {
                Penang: ["Bayan Lepas", "Bukit Mertajam", "Air Itam", "Balik Pulau", "Perai", "Air Itam", "Nibong Tebal", "Batu Ferringhi", "Kepala Batas", "Gelugor", "Batu Maung", "Tasek Gelugor"],
                Ipoh: ["Ampang", "Anjung Tawas", "Bandar Seri Botani", "Bercham", "Canning Garden", "Greentown", "Meru Raya", "Pasir Puteh", "Kampung Simee"],
                "Kuala Lumpur": ["Petaling Jaya", "Subang Jaya", "Shah Alam", "Klang", "Port Klang", "Ampang", "Puchong", "Rawang", "Kajang", "Sepang"],
                Pahang: ["Balok", "Bandar Bera", "Bentong", "Damak", "Kuala Rompin", "Sungai Koyan", "Sungai Lembing", "Kuantan", "Kuala Lipis"],
                "Negeri Sembilan": ["Bahau", "Bandar Enstek", "Batu Kikir", "Kuala Pilah", "Nilai", "Pusat Bandar Palong", "Rompin", "Seremban", "Simpang Pertang"],
                Selangor: ["Balakong", "Bangi", "Banting", "Batang Berjuntai", "Batu Arang", "Cyberjaya", "Klang", "Kuala Selangor", "Petaling Jaya"],
                Perlis: ["Kaki Bukit", "Padang Besar", "Simpang Empat", "Wang Kelian", "Chuping", "Jejawi", "Kaki Bukit", "Sanglang", "Beseri"],
                Kedah: ["Alor Setar", "Ayer Hitam", "Baling", "Kodiang", "Kuala Ketil", "Kota Kuala Muda", "Langkawi", "Kupang", "Lunas"],
                Terengganu: ["Ceneh", "Dungun", "Kerteh", "Kuala Terengganu", "Marang", "Paka", "Permaisuri", "Sungai Tong", "Ayer Puteh"],
                Melaka: ["Alor Gajah", "Asahan", "Ayer Keroh", "Bemban", "Durian Tunggal", "Jasin", "Durian Tunggal", "Melaka", "Sungai Rambai"],
                Johor: ["Ayer Baloi", "Ayer Hitam", "Bandar Penawar", "Batu Pahat", "Gelang Patah", "Kota Tinggi", "Kulai", "Layang-Layang", "Nusajaya"],
                Sabah: ["Bongawan", "Kota Marudu", "Lahad Datu", "Membakut", "Menumbok", "Penampang", "Tenghilan", "Tuaran", "Tenom"],
                Sarawak: ["Asajaya", "Balingian", "Dalat", "Engkilili", "Long Lama", "Mukah", "Sebuyau", "Sri Aman", "Tatau"]
            }

            function makeSubmenu(value) {
                if (value.length == 0) {
                    document.getElementById("areaSelect").innerHTML = "<option></option>";
                } else {
                    var citiesOptions = "";
                    for (cityId in citiesByState[value]) {
                        citiesOptions += "<option>" + citiesByState[value][cityId] + "</option>";
                    }
                    document.getElementById("areaSelect").innerHTML = citiesOptions;
                }
            }

            // Restricts input for the given textbox to the given inputFilter function.
            function setInputFilter(textbox, inputFilter, errMsg) {
                ["input", "keydown", "keyup", "mousedown", "mouseup", "select", "contextmenu", "drop", "focusout"].forEach(function (event) {
                    textbox.addEventListener(event, function (e) {
                        if (inputFilter(this.value)) {
                            // Accepted value
                            if (["keydown", "mousedown", "focusout"].indexOf(e.type) >= 0) {
                                this.classList.remove("input-error");
                                this.setCustomValidity("");
                            }
                            this.oldValue = this.value;
                            this.oldSelectionStart = this.selectionStart;
                            this.oldSelectionEnd = this.selectionEnd;
                        } else if (this.hasOwnProperty("oldValue")) {
                            // Rejected value - restore the previous one
                            this.classList.add("input-error");
                            this.setCustomValidity(errMsg);
                            this.reportValidity();
                            this.value = this.oldValue;
                            this.setSelectionRange(this.oldSelectionStart, this.oldSelectionEnd);
                        } else {
                            // Rejected value - nothing to restore
                            this.value = "";
                        }
                    });
                });
            }

            setInputFilter(document.getElementById("fullname"), function (value) {
                return /^[a-z, ]*$/i.test(value);
            }, "Must contains letters only");

            setInputFilter(document.getElementById("phonenum"), function (value) {
                return /^[0-9\-]*$/i.test(value);
            }, "");

            setInputFilter(document.getElementById("poscode"), function (value) {
                return /^-?\d*$/.test(value);
            }, "Must be a number");
        </script>

        <script>
            window.addDashes = function addDashes(f) {
                var r = /(\D+)/g,
                        npa = '',
                        nxx = '',
                        last4 = '';
                f.value = f.value.replace(r, '');
                npa = f.value.substr(0, 3);
                nxx = f.value.substr(3, 8);
                f.value = npa + (nxx.length > 0 ? '-' : '') + nxx + (last4.length > 0 ? '-' : '') + last4;
            }
        </script>
    </body>
</html>


