//Author : Cheng Cai Yuan

package Controller;

import Model.DA.DACart;
import Model.DA.DAOrder;
import Model.DA.DARefund;
import Model.DA.DASKU;
import Model.Domain.Cart;
import Model.Domain.Customer;
import Model.Domain.Order;
import Model.Domain.Product;
import Model.Domain.Refund;
import Model.Domain.SKU;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


@WebServlet(name = "RefundController", urlPatterns = {"/RefundController"})
public class RefundController extends HttpServlet {
   
    private DARefund daRefund = new DARefund();
    private DAOrder daOrder = new DAOrder();
    private DASKU daSku = new DASKU();
    private DACart daCart = new DACart();
    private DASKU dasku = new DASKU();
   
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int selected = Integer.parseInt(request.getParameter("selectedRow"));    // get value of the "selectedRow" from other page
        String action = request.getParameter("action");    // get value of the "action" from other page
        
        if(action.equals("getRefund")){   //go to view refund function 
            getRefund(request,response,selected);
        }
        else if(action.equals("updateRefundStatus")){  //pass in the selected refund index into the refund status function from summary page
            updateRefundStatus(request,response,selected);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        String action = request.getParameter("action");

        try{
            switch(action){
                case "add":   //go to add refund function
                    addRefund(request,response);
                    break;
                case "updateStatus":   //go to update refund status function
                    updateStatus(request,response);
                    break;
                case "search":    //go to search sku function
                    searchRefund(request,response);
                    break;
                default:
                    break;
            }
        }
        catch(Exception ex){
            ex.printStackTrace();
        }
    }
    
    public void getRefund(HttpServletRequest request, HttpServletResponse response,int selected)
            throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        Refund refund = new Refund();
      
        try {
            refund = daRefund.getAllRefund().get(selected);    //get all the details for the selected refund from the summary page
                
            HttpSession session = request.getSession();
            session.setAttribute("refund",refund);
                
            RequestDispatcher dispatcher = request.getRequestDispatcher("Refund_View-adminView.jsp");
            dispatcher.forward(request, response);
            
        }
        catch (IOException | SQLException ex) {
            out.println("Error:"+ex.toString()+"<br/>");
            StackTraceElement[] elements = ex.getStackTrace();

            for(StackTraceElement e: elements){
                out.println("File Name: "+e.getFileName() + "<br>");
                out.println("Class Name: "+e.getClassName()+ "<br>");
                out.println("Method Name: "+e.getMethodName()+ "<br>");
                out.println("Line Name: "+e.getLineNumber()+ "<br><br>");
            }
        }
        out.close();
    }
    
    public void updateRefundStatus(HttpServletRequest request, HttpServletResponse response,int selected)
            throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        
        Refund refund = new Refund();
        String refundAlreadyApprove = "This refund has been approval before.";
        try {
            //ArrayList<Refund> refundstatus = daRefund.getAllRefund();
 
            refund.setRefundStatus(daRefund.getAllRefund().get(selected).getRefundStatus());
            if(refund.getRefundStatus().equals("Approval")){
                out.println("<html>");
                out.println("<style>");
                out.println("body{background-color:lightgreen;}"
                        + "#infoLog{\n"
                        + "	background-color: #FF8F8F;\n"
                        + "    height:25px;\n"
                        + "}");
                out.println("</style>");
                out.println(" <body> <div id=\"infoLog\"> " + refundAlreadyApprove + "</div></body>");
                out.println("</html>");

                RequestDispatcher rd = request.getRequestDispatcher("Refund_Summary-adminView.jsp");
                rd.include(request, response);
            }
            else{
                refund = daRefund.getAllRefund().get(selected);    //get all the details for the selected refund from the summary page
                
                HttpSession session = request.getSession();
                session.setAttribute("refund",refund);

                RequestDispatcher dispatcher = request.getRequestDispatcher("Refund_ConfirmationUpdate-adminView.jsp");
                dispatcher.forward(request, response);
            }
            
            
                
        } 
        catch (IOException | SQLException ex) {
            out.println("Error:"+ex.toString()+"<br/>");
            StackTraceElement[] elements = ex.getStackTrace();

            for(StackTraceElement e: elements){
                out.println("File Name: "+e.getFileName() + "<br>");
                out.println("Class Name: "+e.getClassName()+ "<br>");
                out.println("Method Name: "+e.getMethodName()+ "<br>");
                out.println("Line Name: "+e.getLineNumber()+ "<br><br>");
            }
        }
            
        out.close();
    }

    public void addRefund(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        HttpSession session = request.getSession();
        ArrayList<Cart> cartList = (ArrayList<Cart>)session.getAttribute("refundCart");
        
        
        boolean duplicatedRefund = false;
        String orderID = "";
        String refundReason = request.getParameter("reason");
        String refundRemark = request.getParameter("remark");
        String refundStatus = "Disapproval";
        String succesMsg = "Refund form submit successfully.";
        String errorMsg = "Refund form fail to submit.Please try again.";
        String dupOrderIdMsg = "Refund form already submitted,you are not allowed to submit again.";
        
        for (int i=0; i < cartList.size() ;i++) {
                orderID = cartList.get(i).getOrder().getOrderId();   //get the order ID for refund add new page
                
        }
        
        if(refundReason!=null){

        try {
  
            ArrayList<Refund> refundList = daRefund.getAllRefund();    //get all the refund records from the datebase
                
            for(int i = 0; i < refundList.size(); i++){
                if(refundList.get(i).getOrder().getOrderId().equals(orderID)){    //if the order id in the refund table same with the order id in the carts,deplicate refund occur
                    duplicatedRefund = true;
                    break;
                }
            }
            
            //display an error message when the duplicate refund occur
            if(duplicatedRefund == true){
                out.println("<html>");
                out.println("<style>");
                out.println("body{background-color:lightgreen;}"
                        + "#infoLog{\n"
                        + "	background-color: #FF8F8F;\n"
                        + "    height:25px;\n"
                        + "}");
                out.println("</style>");
                out.println(" <body> <div id=\"infoLog\"> " + dupOrderIdMsg + "</div></body>");
                out.println("</html>");

                RequestDispatcher rd = request.getRequestDispatcher("Customer_ManageProfile_customerView.jsp");
                rd.include(request, response);
            }
            
            else {
                Refund refund = new Refund("",LocalDateTime.now(),refundReason,refundStatus,refundRemark,daOrder.getOrderRecord(orderID));
                refund.setRefundId(refund.generateRefundId());  //auto generate the new refund id

                boolean refundSubmit = daRefund.addRefund(refund);  //add the new refund intp database
            
                //display a success message
                if(refundSubmit == true){
                    out.println("<html><head><link rel=\"shortcut icon\" type=\"image/x-icon\" href=\"assets/siteIcon.png\" /></head>");
                    out.println("<style>");
                    out.println("body{background-color:lightgreen;}"
                            + "#infoIcon{\n"
                            + "	background-color:green;\n"
                            + "    color:white;\n"
                            + "    border-radius:100%;\n"
                            + "    text-align:center;\n"
                            + "    font-size:12px;"
                            + "    padding:5px;\n"
                            + "}"
                            + "#infoLog{\n"
                            + "	background-color: #AAD292;\n"
                            + "    height:25px;\n"
                            + "}");
                    out.println("</style>");

                    out.println("<body><div id=\"infoLog\">&nbsp;&nbsp;&nbsp;&nbsp;<span id=\"infoIcon\"><i class=\"fa fa-check\"></i></span> &nbsp;&nbsp; " + succesMsg + "</div></body>");
                    out.println("</html>");
                    
                    RequestDispatcher rd = request.getRequestDispatcher("Customer_ManageProfile_customerView.jsp");
                    rd.include(request, response);
                }
                else{
                    out.println("<html>");
                    out.println("<style>");
                    out.println("body{background-color:lightgreen;}"
                            + "#infoLog{\n"
                            + "	background-color: #FF8F8F;\n"
                            + "    height:25px;\n"
                            + "}");
                    out.println("</style>");
                    out.println(" <body> <div id=\"infoLog\"> " + errorMsg + "</div></body>");
                    out.println("</html>");

                    RequestDispatcher rd = request.getRequestDispatcher("Customer_ManageProfile_customerView.jsp");
                    rd.include(request, response);
                }
                
                session.setAttribute("refund",refund);
             
                }
            } 
            catch(IOException | SQLException ex){
                out.println("Error:"+ex.toString()+"<br/>");
                StackTraceElement[] elements = ex.getStackTrace();

                for(StackTraceElement e: elements){
                    out.println("File Name: "+e.getFileName() + "<br>");
                    out.println("Class Name: "+e.getClassName()+ "<br>");
                    out.println("Method Name: "+e.getMethodName()+ "<br>");
                    out.println("Line Name: "+e.getLineNumber()+ "<br><br>");
                }
            }
        }else{
            out.println("<html>");
                    out.println("<style>");
                    out.println("body{background-color:lightgreen;}"
                            + "#infoLog{\n"
                            + "	background-color: #FF8F8F;\n"
                            + "    height:25px;\n"
                            + "}");
                    out.println("</style>");
                    out.println(" <body> <div id=\"infoLog\"> " + "Option must be choose" + "</div></body>");
                    out.println("</html>");
                    
                     session.setAttribute("duplicateSubmitOrderID",orderID);

                    RequestDispatcher rd = request.getRequestDispatcher("Refund_AddNew-customerView.jsp");
                    rd.include(request, response);
   
        }
        out.close();
    }
    
    public void updateStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        
        try {
            HttpSession session = request.getSession();
            String orderID = request.getParameter("order");
            String msg = "Refund approve successfully.";
            Order order = daOrder.getOrderRecord(orderID);
            
            ArrayList<Cart> cartArrList = daCart.getSpecificCartAllCartItem(order);  //get the specific products in an order
            ArrayList<Refund> refundId = daRefund.getAllRefund();
            Refund refund = new Refund();
            for(int i = 0; i < refundId.size();i++){
                if(refundId.get(i).getOrder().getOrderId().equals(order.getOrderId())){
                    refund.setRefundId(refundId.get(i).getRefundId());   //get the refund id
                }
            }
            
            //if packaging + sku qty 
            if (order.getOrderStatus().equals("PACKAGING")) {
                //plus sku qty
                //change status to refunded
                for (int i = 0; i < cartArrList.size(); i++) {
                    //update the SKU(Cart Qty added back to the sku) 
                    SKU localsku = dasku.getSKU(cartArrList.get(i).getSKU().getSkuNo());
                    localsku.setSkuQty(localsku.getSkuQty() + cartArrList.get(i).getQty());
                    dasku.updateSKU(localsku);
                }

                //change to order status to REFUNDED
                daOrder.updateOrderStatus("REFUNDED",order.getOrderId() );
                daRefund.updateRefundStatus(refund.getRefundId());
            } else{
                daOrder.updateOrderStatus("REFUNDED",order.getOrderId() );
                daRefund.updateRefundStatus(refund.getRefundId());
            }
            
            //<-------------------Successfuly msg (green background)---------------------------------->
            out.println("<html><head><link rel=\"shortcut icon\" type=\"image/x-icon\" href=\"assets/siteIcon.png\" /></head>");
            out.println("<style>");
            out.println("body{background-color:lightgreen;}"
                    + "#infoIcon{\n"
                    + "	background-color:green;\n"
                    + "    color:white;\n"
                    + "    border-radius:100%;\n"
                    + "    text-align:center;\n"
                    + "    font-size:12px;"
                    + "    padding:5px;\n"
                    + "}"
                    + "#infoLog{\n"
                    + "	background-color: #AAD292;\n"
                    + "    height:25px;\n"
                    + "}");
            out.println("</style>");

            out.println("<body><div id=\"infoLog\">&nbsp;&nbsp;&nbsp;&nbsp;<span id=\"infoIcon\"><i class=\"fa fa-check\"></i></span> &nbsp;&nbsp; " + msg + "</div></body>");
            out.println("</html>");
            RequestDispatcher rd = request.getRequestDispatcher("Refund_Summary-adminView.jsp");
            rd.include(request, response);


////      //<-------------------Error msg (red background)---------------------------------->
        } catch (Exception ex) {
            out.println("<html>");
            out.println("<style>");
            out.println("body{background-color:lightgreen;}"
                    + "#infoLog{\n"
                    + "	background-color: #FF8F8F;\n"
                    + "    height:25px;\n"
                    + "}");
            out.println("</style>");
            out.println(" <body> <div id=\"infoLog\"> ERROR: " +ex.getMessage() + "</div></body>");
            out.println("</html>");

            RequestDispatcher rd = request.getRequestDispatcher("Refund_Summary-adminView.jsp");
            rd.include(request, response);
        }
        
//        out.close();
    }

    public void searchRefund(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        
        int days = Integer.parseInt(request.getParameter("days"));
        String refundStatus = request.getParameter("refundStatus");  
        LocalDateTime today = LocalDateTime.now();
        ArrayList<Refund> refundList = new ArrayList<Refund>();
        ArrayList<Refund> refundList2 = daRefund.getAllRefund();
        
        try {
            //take the dayOfYear of today date minus the dayOfYear of the refundCreatedTime of the refund records
            //according to the result and refund status select by the user to filter it.
            for(int i = 0;i < refundList2.size(); i++){
                if((today.getDayOfYear() - refundList2.get(i).getRefundCreatedTime().getDayOfYear()) <= days
                        && refundList2.get(i).getRefundStatus().equals(refundStatus)){
                    refundList.add(refundList2.get(i));
                }
            }

            HttpSession session = request.getSession();
            session.setAttribute("refundList",refundList);
                
            RequestDispatcher dispatcher = request.getRequestDispatcher("Refund_SummarySearch-adminView.jsp");
            dispatcher.forward(request, response);
            
        } 
        catch (Exception ex) {
            out.println("Error:"+ex.toString()+"<br/>");
            StackTraceElement[] elements = ex.getStackTrace();

            for(StackTraceElement e: elements){
                out.println("File Name: "+e.getFileName() + "<br>");
                out.println("Class Name: "+e.getClassName()+ "<br>");
                out.println("Method Name: "+e.getMethodName()+ "<br>");
                out.println("Line Name: "+e.getLineNumber()+ "<br><br>");
            }
        }
        out.close();
   }
}