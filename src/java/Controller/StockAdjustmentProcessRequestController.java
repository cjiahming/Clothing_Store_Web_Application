package Controller;

import Exceptions.EmptyInputException;
import Model.DA.DAProduct;
import Model.DA.DASKU;
import Model.DA.DAStockAdjustment;
import Model.Domain.AdjustedItem;
import Model.Domain.Product;
import Model.Domain.StockAdjustment;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "StockAdjustmentProcessRequestController", urlPatterns = {"/StockAdjustmentProcessRequestController"})
public class StockAdjustmentProcessRequestController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        //get stock action and remark
        PrintWriter out = response.getWriter();
        HttpSession session = request.getSession();

        String action = request.getParameter("ac");
        String adjustmentNo = request.getParameter("no");
        String stockAction = request.getParameter("stockAction");
        String remark = request.getParameter("remark");
        ArrayList<AdjustedItem> adItemList = new ArrayList<AdjustedItem>();
        StockAdjustment stockAd;

        try {
            DAProduct prodDA = new DAProduct();
            DAStockAdjustment stockAdDA = new DAStockAdjustment();
            DASKU skuDA = new DASKU();
            ArrayList<Product> prodList = prodDA.getRecords();
            Product[] prodArray = new Product[prodList.size()];
            for (int a = 0; a < prodList.size(); a++) {
                prodArray[a] = prodList.get(a);
            }
            
            session.setAttribute("stockAdRemark", remark);
            session.setAttribute("ac", action);
            switch (action) {
                case "new":
                    session.setAttribute("action3", "new");
                    response.sendRedirect("StockAdjustment_AddNew-adminView.jsp");
                    break;
                case "add":
                    if(stockAction==null){
                        throw new EmptyInputException(EmptyInputException.NULL_STOCK_ACTION);
                    }
                    if(stockAction.equalsIgnoreCase("stockOut") && remark.isEmpty() ){
                        throw new EmptyInputException(EmptyInputException.NULL_STOCKOUT_REASON);
                    }
                    session.setAttribute("productList", prodArray);
                    session.setAttribute("action1", "new");
                    session.setAttribute("action2", "new");
                    session.setAttribute("action3", "new");

                    session.setAttribute("stockAction", stockAction);
                    String back = request.getParameter("back");
                    if(back != null){
                        adItemList = (ArrayList<AdjustedItem>) session.getAttribute("adItemList");
                    }
                    session.setAttribute("adItemList", adItemList);
                    response.sendRedirect("StockAdjustment_AddNewDetails-adminView.jsp");
                    break;

                case "view":
                    stockAd = stockAdDA.getRecord(adjustmentNo);
                    String prodID;
                    for (int a = 0; a < stockAd.getAdjustedItems().length; a++) {
                        prodID = stockAd.getAdjustedItems()[a].getSku().getProduct().getProdID();
                        stockAd.getAdjustedItems()[a].getSku().setProduct(prodDA.getRecord(prodID));
                    }
                    session.setAttribute("stockAdView", stockAd);
                    response.sendRedirect("StockAdjustment_View-adminView.jsp");
                    break;

                case "edit":
                case "edit2":
                case "delete":
                    stockAd = stockAdDA.getRecord(adjustmentNo);
                    
                    if (action.equalsIgnoreCase("edit")) {
                        session.setAttribute("stockAdEdit", stockAd);
                        response.sendRedirect("StockAdjustment_Edit-adminView.jsp");
                    } else {
                        stockAd.setRemark(remark);
                        for (AdjustedItem adjustedItem : stockAd.getAdjustedItems()) {
                            prodID = adjustedItem.getSku().getProduct().getProdID();
                            adjustedItem.getSku().setProduct(prodDA.getRecord(prodID));
                            adItemList.add(adjustedItem);
                        }
                        session.setAttribute("productList", prodArray);
                        session.setAttribute("action1", "new");
                        session.setAttribute("action2", "new");
                        session.setAttribute("action3", "new");
                        session.setAttribute("adItemList", adItemList);
                        session.setAttribute("stockAction", stockAd.getStockAction());
                        session.setAttribute("stockAdEdit", stockAd);
                        if (action.equalsIgnoreCase("delete")) {
                            stockAd.setRemark(remark);
                            response.sendRedirect("StockAdjustment_Confirmation-adminView.jsp");
                        } else {
                            response.sendRedirect("StockAdjustment_AddNewDetails-adminView.jsp");
                        }

                    }

                    break;

            }

        } catch (EmptyInputException ex) { //not stock action given
            session.setAttribute("nullAction", ex.getMessage());
            session.setAttribute("action3", "nullAction");
            response.sendRedirect("StockAdjustment_AddNew-adminView.jsp");
        } catch (Exception ex) {

            out.println("Error: " + ex.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        //get stock action and remark
        PrintWriter out = response.getWriter();
        HttpSession session = request.getSession();

    }

}
