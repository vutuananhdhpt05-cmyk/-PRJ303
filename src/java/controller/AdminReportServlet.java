package controller;

import dal.ReportDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;



@WebServlet(name = "AdminReportServlet", urlPatterns = {"/admin/reports"})
public class AdminReportServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        ReportDAO reportDAO = new ReportDAO();
        
        request.setAttribute("monthlyRevenue", reportDAO.getMonthlyRevenue());
        request.setAttribute("topProducts", reportDAO.getTopSellingProducts(5));
        request.setAttribute("inventory", reportDAO.getInventoryReport());
        request.setAttribute("vipCustomers", reportDAO.getVIPCustomers(5));
        request.setAttribute("ordersByStatus", reportDAO.getOrdersByStatus());
        
        request.getRequestDispatcher("/jsp/admin_reports.jsp").forward(request, response);
    }
}

