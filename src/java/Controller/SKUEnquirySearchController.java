/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Controller;

import Model.DA.DAProduct;
import Model.Domain.AdjustedItem;
import Model.Domain.Product;
import Model.Domain.SKU;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDateTime;
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
@WebServlet(name = "SKUEnquirySearchController", urlPatterns = {"/SKUEnquirySearchController"})
public class SKUEnquirySearchController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        HttpSession s = request.getSession();
        // Obtain data from the form
        String category = "";
        category = request.getParameter("prodCategory");
        String prodID = "";
        prodID = request.getParameter("prodID");

        try {
            if (category.isEmpty()==false || prodID.isEmpty()==false) { //sort by both criteria 
                SKUEnquiryController refresh = new SKUEnquiryController();
                refresh.refreshTable(request, response);
                SKU[] skuArr = (SKU[]) s.getAttribute("skuArr");
                int[] totalSales = (int[]) s.getAttribute("totalSalesQty");
                int[] packagingQty = (int[]) s.getAttribute("packagingQty");
                int[] totalStockOut = (int[]) s.getAttribute("totalStockOut");
                int[] totalStockIn = (int[]) s.getAttribute("totalStockIn");
                int[] inTransit = (int[]) s.getAttribute("inTransit");
                int[] refundQty = (int[]) s.getAttribute("refundQty");
                AdjustedItem[] lastStockTake = (AdjustedItem[]) s.getAttribute("lastStockTake");
                LocalDateTime[] lastStockTakeDate = (LocalDateTime[]) s.getAttribute("lastStockTakeDate");
                //get prod list
                DAProduct prodDA = new DAProduct();
                ArrayList<Product> prodList = prodDA.getRecords();
                for (int a = 0; a < prodList.size(); a++) {
                    for (int i = 0; i < skuArr.length; i++) {
                        if (skuArr[i].getProduct().getProdID().equalsIgnoreCase(prodList.get(a).getProdID())) {
                            skuArr[i].setProduct(prodList.get(a));
                        }
                    }
                }

                ArrayList<SKU> newSKUList = new ArrayList<SKU>();
                ArrayList<Integer> index = new ArrayList<Integer>();

                if (!(category.isEmpty() || prodID.isEmpty())) { //sort by both criteria at the same tme
                    for (int i = 0; i < skuArr.length; i++) {
                        if (skuArr[i].getProduct().getProdCategory().equalsIgnoreCase(category) && skuArr[i].getProduct().getProdID().equalsIgnoreCase(prodID)) {
                            newSKUList.add(skuArr[i]);
                            index.add(i);
                        }
                    }
                } else if (!(category.isEmpty())) { //sort by category only
                    for (int i = 0; i < skuArr.length; i++) {
                        if (skuArr[i].getProduct().getProdCategory().equalsIgnoreCase(category)) {
                            newSKUList.add(skuArr[i]);
                            index.add(i);
                        }
                    }
                } else { //sort by prodID
                    for (int i = 0; i < skuArr.length; i++) {
                        if (skuArr[i].getProduct().getProdID().equalsIgnoreCase(prodID)) {
                            newSKUList.add(skuArr[i]);
                            index.add(i);
                        }
                    }
                }

                SKU[] newlist = new SKU[newSKUList.size()];
                //prepare space for data needed (storage)
                int[] totalSales1 = new int[newSKUList.size()];
                int[] packagingQty1 = new int[newSKUList.size()];
                int[] totalStockOut1 = new int[newSKUList.size()];
                int[] totalStockIn1 = new int[newSKUList.size()];
                AdjustedItem[] lastStockTake1 = new AdjustedItem[newSKUList.size()];
                LocalDateTime[] lastStockTakeDate1 = new LocalDateTime[newSKUList.size()];
                int[] inTransit1 = new int[newSKUList.size()];
                int[] refundQty1 = new int[newSKUList.size()];
                //process the latest result
                for (int i = 0; i < newSKUList.size(); i++) {
                    newlist[i] = newSKUList.get(i);
                    totalSales1[i] = totalSales[index.get(i)];
                    packagingQty1[i] = packagingQty[index.get(i)];
                    totalStockOut1[i] = totalStockOut[index.get(i)];
                    totalStockIn1[i] = totalStockIn[index.get(i)];
                    inTransit1[i] = inTransit[index.get(i)];
                    refundQty1[i] = refundQty[index.get(i)];
                    lastStockTake1[i] = lastStockTake[index.get(i)];
                    lastStockTakeDate1[i] = lastStockTakeDate[index.get(i)];

                }

                //set attribute 
                s.setAttribute("skuArr", newlist);
                s.setAttribute("totalSalesQty", totalSales1);
                s.setAttribute("packagingQty", packagingQty1);
                s.setAttribute("totalStockOut", totalStockOut1);
                s.setAttribute("totalStockIn", totalStockIn1);
                s.setAttribute("lastStockTake", lastStockTake1);
                s.setAttribute("lastStockTakeDate", lastStockTakeDate1);
                s.setAttribute("inTransit", inTransit1);
                s.setAttribute("refundQty", refundQty1);

                response.sendRedirect("SKUEnquiry_Search-adminView.jsp");
                
            } else { //nothing entered
                response.sendRedirect("SKUEnquiry_Summary-adminView.jsp");
            }
        } catch (Exception ex) {
            out.println("Error: " + ex.getMessage());
        }

    }

}
