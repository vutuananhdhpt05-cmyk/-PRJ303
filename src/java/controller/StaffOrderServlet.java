package controller;

import dal.OrderDAO;
import dal.OrderDetailDAO;
import dal.OrderInfoDAO;
import model.Order;
import model.OrderDetail;
import model.OrderInfo;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/staff/orders")
public class StaffOrderServlet extends HttpServlet {
    private final OrderDAO      orderDao  = new OrderDAO();
    private final OrderDetailDAO detailDao = new OrderDetailDAO();
    private final OrderInfoDAO   infoDao   = new OrderInfoDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        try {
            if (action == null || action.equals("list")) {
                // Đọc tham số tìm kiếm
                String searchId = req.getParameter("searchId");
                String fromDate = req.getParameter("fromDate");
                String toDate = req.getParameter("toDate");
                String status = req.getParameter("status");

                List<Order> orders;
                if ((searchId != null && !searchId.isEmpty()) || 
                    (fromDate != null && !fromDate.isEmpty()) || 
                    (toDate != null && !toDate.isEmpty()) || 
                    (status != null && !status.isEmpty())) {
                    orders = orderDao.advancedSearchOrders(searchId, fromDate, toDate, status);
                } else {
                    orders = orderDao.getAllOrders();
                }

                req.setAttribute("orders", orders);
                req.setAttribute("searchId", searchId);
                req.setAttribute("fromDate", fromDate);
                req.setAttribute("toDate", toDate);
                req.setAttribute("status", status);

                req.getRequestDispatcher("/jsp/staff_orders.jsp")
                   .forward(req, resp);

            } else if (action.equals("view")) {
                // Chi tiết đơn
                int id = Integer.parseInt(req.getParameter("id"));
                Order o = orderDao.getOrderById(id);
                List<OrderDetail> details = detailDao.getOrderDetailsByOrderId(id);
                OrderInfo info = infoDao.getByOrderId(id);

                req.setAttribute("order", o);
                req.setAttribute("details", details);
                req.setAttribute("info", info);
                req.getRequestDispatcher("/jsp/staff_orderDetails.jsp")
                   .forward(req, resp);
            }
        } catch (SQLException e) {
            throw new ServletException("Lỗi khi xử lý đơn hàng", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        try {
            if ("updateStatus".equals(action)) {
                int orderId = Integer.parseInt(req.getParameter("orderId"));
                String newStatus = req.getParameter("status");
                orderDao.updateOrderStatus(orderId, newStatus);
                req.getSession().setAttribute("successMessage", "Cập nhật trạng thái đơn hàng thành công!");
                resp.sendRedirect(req.getContextPath() + "/staff/orders?action=view&id=" + orderId);
            }
        } catch (SQLException e) {
            throw new ServletException("Lỗi khi cập nhật trạng thái đơn hàng", e);
        }
    }
}

