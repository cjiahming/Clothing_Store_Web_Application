package Controller;

import Model.DA.DAStockAdjustment;
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

@WebServlet(name = "StockAdjustmentSearchController", urlPatterns = {"/StockAdjustmentSearchController"})
public class StockAdjustmentSearchController extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        // Obtain data from the form
        String fromDate = "";
        String toDate = "";
        String stockAction = "";
        String status = "";
        fromDate = request.getParameter("fromDate");
        toDate = request.getParameter("toDate");
        stockAction = request.getParameter("stockAction");
        status = request.getParameter("status");
        ArrayList<StockAdjustment> recordList = null;
        HttpSession s = request.getSession();
        try {
            DAStockAdjustment stockAdDA = new DAStockAdjustment();
            if (!(fromDate.isEmpty() || toDate.isEmpty() || stockAction.isEmpty() || status.isEmpty())) { //search by all criteria if all not null
                recordList = stockAdDA.searchByAll(fromDate, toDate, stockAction, status);

            } else if (!(fromDate.isEmpty() || toDate.isEmpty() || stockAction.isEmpty())) { 
                recordList = stockAdDA.searchByDateAndAction(fromDate, toDate, stockAction);

            } else if (!(fromDate.isEmpty() || toDate.isEmpty() || status.isEmpty())) { 
                recordList = stockAdDA.searchByDateAndStatus(fromDate, toDate, status);

            } else if (!(fromDate.isEmpty() || toDate.isEmpty())) { 
                recordList = stockAdDA.searchByDate(fromDate, toDate);
                
            } else if (!(stockAction.isEmpty())) { 
                recordList = stockAdDA.searchByAction(stockAction);
                
            } else if (!(status.isEmpty())) { 
                recordList = stockAdDA.searchByStatus(status);
                
            } else { //nothing entered
                response.sendRedirect("StockAdjustment_Summary-adminView.jsp");
            }
            StockAdjustment[] stockAdList = new StockAdjustment[recordList.size()];
            for (int a = 0; a < recordList.size(); a++) {
                stockAdList[a] = recordList.get(a);
            }
            s.setAttribute("stockAdList", stockAdList);
            response.sendRedirect("StockAdjustment_Search-adminView.jsp");
        } catch (Exception ex) {
            out.println("Error2: " + ex.getMessage());
        }

    }
}
