class Middle extends HTMLElement {
    constructor() {
        super();
    }
    connectedCallback() {
        this.innerHTML = `
        <head>
		<link href="css/styles.css" rel="stylesheet" />
        <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/js/all.min.js" crossorigin="anonymous"></script>
        </head>
                
                    
                        <div class="nav">

                        <!--This is the menu heading-->
                        <p id="companyFullName">&copy; Fast and Fashion.Sdn.Bhd. </p>
                            <div class="sb-sidenav-menu-heading">PROFILE</div>
                            <a class="nav-link" href="Admin_editProfile-adminView.jsp">
                                <div class="sb-nav-link-icon"><i class="fas fa-user-alt"></i></div>
                                My Profile
                            </a>
                            <div class="sb-sidenav-menu-heading">CORE</div>
                            <a class="nav-link" href="Dashboard-adminView.jsp">
                                <div class="sb-nav-link-icon"><i class="fas fa-tachometer-alt"></i></div>
                                Dashboard
                            </a>

                            <a class="nav-link collapsed" href="#" data-bs-toggle="collapse" data-bs-target="#collapseLayouts" aria-expanded="false" aria-controls="collapseLayouts">
                                <div class="sb-nav-link-icon"><i class="fas fa-tshirt"></i></div>
                                Product Management
                                <div class="sb-sidenav-collapse-arrow"><i class="fas fa-angle-down"></i></div>
                            </a>
                            <div class="collapse" id="collapseLayouts" aria-labelledby="headingOne" data-bs-parent="#sidenavAccordion">
                                <nav class="sb-sidenav-menu-nested nav">
                                    <a class="nav-link" href="Product_Summary-adminView.jsp">Product</a>
                                    <a class="nav-link" href="SKU_Summary-adminView.jsp">SKU</a>
                                    <a class="nav-link" href="StockAdjustment_Summary-adminView.jsp">Stock Adjustment</a>
                                    <a class="nav-link" href="SKUEnquiry_Summary-adminView.jsp">SKU Enquiry</a>
                                </nav>
                            </div>



                            <a class="nav-link collapsed" href="#" data-bs-toggle="collapse" data-bs-target="#collapseLayout" aria-expanded="false" aria-controls="collapseLayouts">
                            <div class="sb-nav-link-icon"><i class="fas fa-cog"></i></div>
                            Operations
                            <div class="sb-sidenav-collapse-arrow"><i class="fas fa-angle-down"></i></div>
                            </a>

                        <div class="collapse" id="collapseLayout" aria-labelledby="headingTwo" data-bs-parent="#sidenavAccordion">
                            <nav class="sb-sidenav-menu-nested nav">
                                <a class="nav-link" href="Sales_Summary-adminView.jsp">Sales</a>
                                <a class="nav-link" href="Sales_UpdateStatus-adminView.jsp">Sales Status</a>
                                <a class="nav-link" href="Review_Summary-adminView.jsp">Review</a>
                                <a class="nav-link" href="Refund_Summary-adminView.jsp">Refund</a>
                            </nav>
                        </div>
                            
                            <a class="nav-link" href="ReportSales_Summary-adminView.jsp">
                                <div class="sb-nav-link-icon"><i class="fas fa-chart-area"></i></div>
                                Report
                            </a>
                          
                            <a class="nav-link collapsed" href="#" data-bs-toggle="collapse" data-bs-target="#collapsePages" aria-expanded="false" aria-controls="collapsePages">
                                <div class="sb-nav-link-icon"><i class="fas fa-users"></i></div>
                                User
                                <div class="sb-sidenav-collapse-arrow"><i class="fas fa-angle-down"></i></div>
                            </a>
                            <div class="collapse" id="collapsePages" aria-labelledby="headingThree" data-bs-parent="#sidenavAccordion">
                                <nav class="sb-sidenav-menu-nested nav accordion" id="sidenavAccordionPages">
                                    <a class="nav-link collapsed" href="User_Summary-adminView.jsp" >
                                        Internal User
                                    </a>
                                    <a class="nav-link collapsed" href="UserGroup_Summary-adminView.jsp" >
                                        User Group
                                    </a>
                                    <a class="nav-link collapsed" href="Customer_Summary-adminView.jsp" >
                                    Customer
                                    </a>
                                  
                                </nav>
                            </div>



                           
                        </div>
                    
                    
                    

           
        `;
    }
}
customElements.define('middle-component', Middle);