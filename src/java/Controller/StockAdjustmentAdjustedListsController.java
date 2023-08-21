package Controller;

import Exceptions.DuplicatedRecordException;
import Exceptions.EmptyInputException;
import Model.DA.DAAdmin;
import Model.DA.DAProduct;
import Model.DA.DASKU;
import Model.DA.DAStockAdjustment;
import Model.Domain.AdjustedItem;
import Model.Domain.Admin;
import Model.Domain.Product;
import Model.Domain.SKU;
import Model.Domain.StockAdjustment;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "StockAdjustmentAdjustedListsController", urlPatterns = {"/StockAdjustmentAdjustedListsController"})
public class StockAdjustmentAdjustedListsController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        PrintWriter out = response.getWriter();
        HttpSession session = request.getSession();
        DateTimeFormatter formatToID = DateTimeFormatter.ofPattern("yyyyMMdd");
        String currentDate = LocalDateTime.now().format(formatToID);

        //process data get from stockAdjustment_AddNewDetails Page
        String actionOnItem = request.getParameter("actionOnItem");
        String stockAction = (String) session.getAttribute("stockAction");
        Product selectedProd = (Product) session.getAttribute("SA-selectedProd");
        SKU selectedSKU = (SKU) session.getAttribute("SA-selectedSKU");
        String adjQty = request.getParameter("adjustQty");
        String remark = request.getParameter("remark");
        //declare variable
        int adjustQty = 0, currentQty, adjustedQty, diff_from_StockTake;
        ArrayList<AdjustedItem> adItemList = (ArrayList<AdjustedItem>) session.getAttribute("adItemList");
        AdjustedItem editItem;
        try {
            DAStockAdjustment stockAdDA = new DAStockAdjustment();
            //input validation

            if (actionOnItem.equalsIgnoreCase("new")) {
                //check null -> if not null will proceed
                notNullInput(selectedProd, selectedSKU, adjQty);
                //check whether the new added sku is duplicated
                notDuplicatedSKU(adItemList, selectedSKU);
                //check whether it's a valid integer
                adjustQty = isValidNumber(adjQty);

                //get current qty
                currentQty = selectedSKU.getSkuQty();
                adjustedQty = 0;

                //add the adjusted Item to an array list 
                selectedSKU.setProduct(selectedProd);
                adItemList.add(new AdjustedItem(selectedSKU, adjustQty, adjustedQty, currentQty, remark));
                session.setAttribute("adItemList", adItemList);
                session.setAttribute("action1", "new");
                session.setAttribute("action2", "new");
                session.setAttribute("action3", "new");
                response.sendRedirect("StockAdjustment_AddNewDetails-adminView.jsp");

            } else if (actionOnItem.equalsIgnoreCase("edit")) {
                int lineNo = Integer.parseInt(request.getParameter("no"));
                editItem = adItemList.get(lineNo);

                session.setAttribute("action1", "selectProduct");
                session.setAttribute("action2", "selectedSKU");
                session.setAttribute("SA-selectedProd", editItem.getSku().getProduct());
                session.setAttribute("SA-selectedSKU", editItem.getSku());
                session.setAttribute("action3", "edit");
                session.setAttribute("editItem", editItem);
                session.setAttribute("lineNo", lineNo);
                session.setAttribute("adItemList", adItemList);
                response.sendRedirect("StockAdjustment_EditItem-adminView.jsp");

            } else if (actionOnItem.equalsIgnoreCase("update")) {
                //check whether it's a valid integer
                adjustQty = isValidNumber(adjQty);
                editItem = (AdjustedItem) session.getAttribute("editItem");
                int lineNo = (Integer) session.getAttribute("lineNo");
                editItem.setRemark(remark);
                editItem.setAdjustQty(adjustQty);
                adItemList.set(lineNo, editItem);
                session.setAttribute("adItemList", adItemList);
                session.setAttribute("action1", "new");
                session.setAttribute("action2", "new");
                session.setAttribute("action3", "new");
                response.sendRedirect("StockAdjustment_AddNewDetails-adminView.jsp");

            } else if (actionOnItem.equalsIgnoreCase("remove")) {
                int lineNo = Integer.parseInt(request.getParameter("no"));
                adItemList.remove(lineNo);
                session.setAttribute("adItemList", adItemList);
                session.setAttribute("action1", "new");
                session.setAttribute("action2", "new");
                session.setAttribute("action3", "new");
                response.sendRedirect("StockAdjustment_AddNewDetails-adminView.jsp");

            } else if (actionOnItem.equalsIgnoreCase("eraseAll")) {
                session.setAttribute("adItemList", adItemList);
                session.setAttribute("action1", "new");
                session.setAttribute("action2", "new");
                session.setAttribute("action3", "new");
                response.sendRedirect("StockAdjustment_AddNewDetails-adminView.jsp");

            } else if (actionOnItem.equalsIgnoreCase("save") || actionOnItem.equalsIgnoreCase("submit")) {
                String status = "CLOSED"; 
                //check whether it's a edit
                String editMode = (String) session.getAttribute("ac");
                String stockAdRemark = (String) session.getAttribute("stockAdRemark");

                //update each adjusted qty and save to database
                AdjustedItem[] itemArray = new AdjustedItem[adItemList.size()];
                for (int a = 0; a < itemArray.length; a++) {
                    itemArray[a] = adItemList.get(a);

                    switch (stockAction) {
                        case "stockIn":
                            itemArray[a].setAdjustedQty(itemArray[a].getInitialQty() + itemArray[a].getAdjustQty());
                            break;
                        case "stockOut":
                            itemArray[a].setAdjustedQty(itemArray[a].getInitialQty() - itemArray[a].getAdjustQty());
                            break;
                        case "stockTake":
                                 itemArray[a].setAdjustedQty(itemArray[a].getAdjustQty());
                                itemArray[a].setAdjustQty( itemArray[a].getAdjustQty() -itemArray[a].getInitialQty());
                            //updated latest qty
                            
                            break;
                    }
                }
                //get admin user ID
                DAAdmin adminDA = new DAAdmin();
                Admin admin = adminDA.getRecord("A0001");
                //create stock adjustment -> prepare to store record into database
                StockAdjustment stockAd;

                //----[Update Record]-------------------------------------------------------------------------------------------------------------
                if (editMode.equalsIgnoreCase("edit2")) { //edit record
                    //check it's a save or submit
                    if (actionOnItem.equalsIgnoreCase("save")) {
                        status = "EDITED";
                    }
                    StockAdjustment edit_stockAd = (StockAdjustment) session.getAttribute("stockAdEdit");
                    stockAd = new StockAdjustment(edit_stockAd.getAdjustmentNo(), itemArray, stockAction, edit_stockAd.getRemark(), status, edit_stockAd.getCreated_by(), edit_stockAd.getCreated_at(), admin, LocalDateTime.now());
                    stockAdDA.updateRecord(stockAd);//RUN SQL -> update record
                    endOfProcess("edit2", stockAd, out, request, response);

                    //----[Add New Record]-------------------------------------------------------------------------------------------------------------
                } else {
                    if (actionOnItem.equalsIgnoreCase("save")) {
                        status = "DRAFT";
                    }
                    //set stock adjustment ID
                    String lastID = "000";
                    ArrayList<StockAdjustment> list = stockAdDA.getRecords();
                    if (list.size() > 0) { //got record(s)
                        stockAd = list.get(list.size() - 1);
                        String lastRecordDate = stockAd.getAdjustmentNo().substring(2, 10); //obtain the date
                        if (lastRecordDate.equalsIgnoreCase(currentDate)) { //same date -> get last 3 number
                            lastID = stockAd.getAdjustmentNo().substring(10);
                        }
                    }
                    stockAd = new StockAdjustment(String.format("SA%s%03d", currentDate, Integer.parseInt(lastID) + 1), itemArray, stockAction, stockAdRemark, status, admin, LocalDateTime.now(), null, null);
                    //add record to database
                    stockAdDA.addRecord(stockAd);
                    endOfProcess("add", stockAd, out, request, response);
                }

            } else { //delete
                StockAdjustment edit_stockAd = (StockAdjustment) session.getAttribute("stockAdEdit");
                stockAdDA.deleteRecord(edit_stockAd);
                endOfProcess("delete", edit_stockAd, out, request, response);
            }

        } catch (EmptyInputException | NumberFormatException ex) { //duplicated SKU or null value
            session.setAttribute("action3", "error");
            session.setAttribute("errMsg", ex.getMessage());
            session.setAttribute("duplicatedSKU", null);
            response.sendRedirect("StockAdjustment_AddNewDetails-adminView.jsp");

        } catch (DuplicatedRecordException ex) {
            session.setAttribute("adItemList", adItemList);
            session.setAttribute("action2", "new");
            session.setAttribute("action3", "new");
            session.setAttribute("action3", "error");
            session.setAttribute("duplicatedSKU", ex.getMessage());
            response.sendRedirect("StockAdjustment_AddNewDetails-adminView.jsp");
        } catch (Exception ex) {
            out.println("Error: " + ex.getMessage() + "Class: " + ex.getClass().getCanonicalName());
        }

    }

    protected int isValidNumber(String adjQty) throws NumberFormatException {
        int adjustQty = 0;
        try {
            adjustQty = Integer.parseInt(adjQty);
        } catch (NumberFormatException ex) {
            throw new NumberFormatException("⚠ Quantity must be digits only.");
        }
        return adjustQty;
    }

    protected void notNullInput(Product p, SKU s, String qty) throws EmptyInputException {
        //check null
        if (p == null || s == null || qty == "") {
            throw new EmptyInputException(EmptyInputException.NULL_INPUT);
        }
    }

    protected void notDuplicatedSKU(ArrayList<AdjustedItem> adItemList, SKU s) throws DuplicatedRecordException {
        for (int a = 0; a < adItemList.size(); a++) {
            if (adItemList.get(a).getSku().getSkuNo().equalsIgnoreCase(s.getSkuNo())) {
                throw new DuplicatedRecordException("Duplicated SKU !");
            }
        }
    }

    protected void endOfProcess(String actionPerformed, StockAdjustment stockAd, PrintWriter out, HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String msg = "";
        switch (actionPerformed) { //add record to
            case "add":
                msg = "New Stock Adjustement " + stockAd.getAdjustmentNo() + " [" + stockAd.getStockActionInFormal() + "] has been added successfully.";
                break;

            case "edit2":
                msg = "Stock Adjustement " + stockAd.getAdjustmentNo() + " [" + stockAd.getStockActionInFormal() + "] has been updated successfully.";
                break;

            case "delete":
                msg = "Stock Adjustement " + stockAd.getAdjustmentNo() + " [" + stockAd.getStockActionInFormal() + "] has been deleted successfully.";
                break;
        }

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
        StockAdjustmentController refresh = new StockAdjustmentController();
        refresh.refreshTable(request, response);
        RequestDispatcher rd = request.getRequestDispatcher("/StockAdjustment_Summary-adminView.jsp");
        rd.include(request, response);

    }

}
