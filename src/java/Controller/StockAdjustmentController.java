package Controller;

import Model.DA.DAStockAdjustment;
import Model.DA.DAUserGroup;
import Model.Domain.StockAdjustment;
import Model.Domain.UserGroup;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


@WebServlet(name = "StockAdjustmentController", urlPatterns = {"/StockAdjustmentController"})
public class StockAdjustmentController extends HttpServlet {

   protected void refreshTable(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        //display records
        try {
             DAStockAdjustment stockAdDA = new DAStockAdjustment();
            ArrayList<StockAdjustment> list = stockAdDA.getRecords();
            StockAdjustment[] stockAdList = new StockAdjustment[list.size()];
            for (int i = 0; i < list.size(); i++) {
                stockAdList[i] = list.get(i);
            }
            HttpSession s = request.getSession();
            s.setAttribute("stockAdList", stockAdList);

        } catch (Exception ex) {
            out.println("Error: " + ex.getMessage());
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        refreshTable(request, response);
        response.sendRedirect("StockAdjustment_Summary-adminView.jsp");
    }

}
