//Author : Cheng Cai Yuan

package Controller;

import Model.DA.DASKU;
import Model.Domain.SKU;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


@WebServlet(name = "SkuDBAddController", urlPatterns = {"/SkuDBAddController"})
public class SkuDBAddController extends HttpServlet {

    private DASKU daSku = new DASKU();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        
        String msg = "SKU successfully added into database.";
        
        try{
            HttpSession session = request.getSession();
            SKU sku = (SKU) session.getAttribute("sku");
            daSku.addSKU(sku);  //add the new sku records into the database
            

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
            RequestDispatcher rd = request.getRequestDispatcher("SKU_Summary-adminView.jsp");
            rd.include(request, response);
           
        //<-------------------Error msg (red background)---------------------------------->
        } catch (Exception ex) {
            out.println("<html>");
            out.println("<style>");
            out.println("body{background-color:lightgreen;}"
                    + "#infoLog{\n"
                    + "	background-color: #FF8F8F;\n"
                    + "    height:25px;\n"
                    + "}");
            out.println("</style>");
            out.println(" <body> <div id=\"infoLog\"> ERROR: " + ex.getMessage() + "</div></body>");
            out.println("</html>");
            RequestDispatcher rd = request.getRequestDispatcher("SKU_Summary-adminView.jsp");
            rd.include(request, response);
        }
        
        out.close();
    }
    
    
}




