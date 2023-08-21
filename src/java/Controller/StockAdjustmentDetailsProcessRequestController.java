/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Controller;

import Exceptions.EmptyInputException;
import Model.DA.DAProduct;
import Model.DA.DASKU;
import Model.DA.DAStockAdjustment;
import Model.Domain.Product;
import Model.Domain.SKU;
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

/**
 *
 * @author jiyeo
 */
@WebServlet(name = "StockAdjustmentDetailsProcessRequestController", urlPatterns = {"/StockAdjustmentDetailsProcessRequestController"})
public class StockAdjustmentDetailsProcessRequestController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        //get stock action and remark
        StockAdjustment stockAd;

        //String remark = request.getParameter("remark");
        //String id = request.getParameter("p");
        String action = request.getParameter("ac");
        PrintWriter out = response.getWriter();
        HttpSession session = request.getSession();
        String prodID = request.getParameter("prodID");

        // String stockAction = (String) session.getAttribute("stockAction");
        String SKUNo;
        Product prod;
        SKU sku;

        try {
            DAProduct prodDA = new DAProduct();
            DAStockAdjustment stockAdDA = new DAStockAdjustment();
            DASKU skuDA = new DASKU();
            //session.setAttribute("stockAction", stockAction);
            switch (action) {
                case "selectProduct":
                    notNullProd(prodID);
                    prod = prodDA.getRecord(prodID);
                    session.setAttribute("SA-selectedProd", prod);
                    session.setAttribute("action1", action);
                    response.sendRedirect("StockAdjustment_AddNewDetails-adminView.jsp");
                    break;
                case "selectSKU": //first time 
                case "selectedSKU": //come back from select SKU jsp page
                    String skuID = request.getParameter("SAD-SKU");
                    prod = (Product) session.getAttribute("SA-selectedProd");
                    if (action.equalsIgnoreCase("selectSKU")) {
                        ArrayList<SKU> skuList = skuDA.getSKUs(prod.getProdID());       //1. get sku list based on selected prod ID
                        session.setAttribute("SA-SKUList", skuList);                    //2. after having the list, set it to session attribute
                        session.setAttribute("SA-selectedProd", prod);
                        session.setAttribute("action3", "null");
                        response.sendRedirect("StockAdjustment_SelectSKU-adminView.jsp");

                    } else { //action = selectedSKU (come back from select SKU jsp page)
                        notNullSKU(skuID);
                        sku = skuDA.getSKU(skuID);
                        out.println(sku.getProdLength());
                        session.setAttribute("SA-selectedSKU", sku);
                        session.setAttribute("action1", "selectProduct");
                        session.setAttribute("action2", action);
                        session.setAttribute("action3", "null");
                        session.setAttribute("duplicatedSKU", null);
                        response.sendRedirect("StockAdjustment_AddNewDetails-adminView.jsp");
                    }

                    //s
                    break;
                default:
                    out.print("no action");
                    break;
            }
        } catch (EmptyInputException ex) {
            if (ex.getMessage().equals(EmptyInputException.NULL_PRODUCT)) {
                session.setAttribute("action3", "nullProd");
                session.setAttribute("nullSelectedProd", ex.getMessage());
                session.setAttribute("duplicatedSKU", null);
                response.sendRedirect("StockAdjustment_SelectProduct-adminView.jsp");
            }else{
                session.setAttribute("action3", "nullSKU");
                session.setAttribute("nullSelectedSKU", ex.getMessage());
                session.setAttribute("duplicatedSKU", null);
                response.sendRedirect("StockAdjustment_SelectSKU-adminView.jsp");
            }

        } catch (Exception ex) {

            out.println("Error: " + ex.getMessage());
        }
    }

    protected void notNullProd(String prodID) throws EmptyInputException {
        if (prodID == null) {
            throw new EmptyInputException(EmptyInputException.NULL_PRODUCT);
        }
    }

    protected void notNullSKU(String skuID) throws EmptyInputException {
        if (skuID == null) {
            throw new EmptyInputException(EmptyInputException.NULL_SKU);
        }
    }

}
