package controller;

import dal.OrderDAO;
import dal.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet(name = "MgmtDashboardServlet", urlPatterns = {"/dashboard"})
public class MgmtDashboardServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();
    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            int totalUsers = userDAO.countTotalUsers();
            int totalOrders = orderDAO.countTotalOrders();
            double totalRevenue = orderDAO.sumTotalRevenue();

            String keyword = req.getParameter("kw");
            java.util.List<model.User> allUsers;
            if (keyword != null && !keyword.trim().isEmpty()) {
                allUsers = userDAO.searchByName(keyword.trim());
            } else {
                allUsers = userDAO.getAll();
            }

            java.util.List<model.Order> recentOrders = orderDAO.getAllOrders();
            if (recentOrders.size() > 5) {
                recentOrders = recentOrders.subList(0, 5);
            }
            req.setAttribute("recentOrders", recentOrders);

            req.setAttribute("totalUsers", totalUsers);
            req.setAttribute("totalOrders", totalOrders);
            req.setAttribute("totalRevenue", totalRevenue);
            req.setAttribute("allUsers", allUsers);

            model.User currentUser = (model.User) req.getSession().getAttribute("user");
            if (currentUser != null && "ADMIN".equalsIgnoreCase(currentUser.getRole())) {
                req.getRequestDispatcher("/jsp/admin_dashboard.jsp").forward(req, resp);
            } else {
                req.getRequestDispatcher("/jsp/staff_dashboard.jsp").forward(req, resp);
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}

