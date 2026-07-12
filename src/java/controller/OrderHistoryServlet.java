package controller;

import dal.OrderDAO;
import dal.OrderHistoryDAO;
import model.OrderHistoryEntry;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/ordersHistory")
public class OrderHistoryServlet extends HttpServlet {
    private final OrderHistoryDAO historyDAO = new OrderHistoryDAO();

    private final OrderDAO orderDao = new OrderDAO();
    private final dal.OrderDetailDAO detailDao = new dal.OrderDetailDAO();
    private final dal.OrderInfoDAO infoDao = new dal.OrderInfoDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = session != null ? (User) session.getAttribute("user") : null;
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/jsp/login.jsp?returnUrl=/ordersHistory");
            return;
        }

        String action = req.getParameter("action");
        try {
            if ("view".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                model.Order o = orderDao.getOrderById(id);
                // Security check: ensure this order belongs to the user
                if (o == null || o.getUserID() != user.getUserID()) {
                    resp.sendRedirect(req.getContextPath() + "/ordersHistory");
                    return;
                }
                List<model.OrderDetail> details = detailDao.getOrderDetailsByOrderId(id);
                model.OrderInfo info = infoDao.getByOrderId(id);

                req.setAttribute("order", o);
                req.setAttribute("details", details);
                req.setAttribute("info", info);
                req.getRequestDispatcher("/jsp/userOrderDetails.jsp").forward(req, resp);
            } else {
                List<OrderHistoryEntry> history = historyDAO.getHistoryByUsername(user.getUsername());
                
                // Group by unique OrderID
                List<OrderHistoryEntry> uniqueOrders = new java.util.ArrayList<>();
                Integer currentOrderId = null;
                for (OrderHistoryEntry e : history) {
                    if (currentOrderId == null || !currentOrderId.equals(e.getOrderID())) {
                        uniqueOrders.add(e);
                        currentOrderId = e.getOrderID();
                    }
                }
                
                // Pagination logic
                int page = 1;
                try {
                    page = Integer.parseInt(req.getParameter("page"));
                } catch (NumberFormatException ignored) {}
                
                int pageSize = 5;
                int totalRecords = uniqueOrders.size();
                int totalPages = (int) Math.ceil((double) totalRecords / pageSize);
                
                if (page < 1) page = 1;
                if (page > totalPages && totalPages > 0) page = totalPages;
                
                int start = 0;
                int end = 0;
                List<OrderHistoryEntry> paginatedOrders = new java.util.ArrayList<>();
                if (totalRecords > 0) {
                    start = (page - 1) * pageSize;
                    end = Math.min(start + pageSize, totalRecords);
                    paginatedOrders = uniqueOrders.subList(start, end);
                }
                
                req.setAttribute("orders", paginatedOrders);
                req.setAttribute("currentPage", page);
                req.setAttribute("totalPages", totalPages);
                req.getRequestDispatcher("/jsp/ordersHistory.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            throw new ServletException("Lỗi xử lý lịch sử mua hàng", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = session != null ? (User) session.getAttribute("user") : null;
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/jsp/login.jsp?returnUrl=/ordersHistory");
            return;
        }

        String action = req.getParameter("action");
        if ("cancel".equals(action)) {
            try {
                int id = Integer.parseInt(req.getParameter("id"));
                model.Order o = orderDao.getOrderById(id);
                
                // Security check: ensure this order belongs to the user and is Pending
                if (o != null && o.getUserID() == user.getUserID() && "Pending".equals(o.getStatus())) {
                    orderDao.cancelOrder(id);
                    session.setAttribute("successMessage", "Đã hủy đơn hàng #" + id + " thành công.");
                } else {
                    session.setAttribute("errorMessage", "Không thể hủy đơn hàng này.");
                }
            } catch (Exception e) {
                session.setAttribute("errorMessage", "Lỗi khi hủy đơn hàng: " + e.getMessage());
            }
            resp.sendRedirect(req.getContextPath() + "/ordersHistory");
        }
    }
}

