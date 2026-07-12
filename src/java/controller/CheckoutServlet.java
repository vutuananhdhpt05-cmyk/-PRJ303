package controller;

import dal.CartDAO;
import dal.OrderDAO;
import dal.OrderInfoDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;
import model.CartItem;
import model.OrderInfo;
import model.User;

@WebServlet("/CheckoutServlet")
public class CheckoutServlet extends HttpServlet {
    private final OrderDAO      orderDAO     = new OrderDAO();
    private final OrderInfoDAO  orderInfoDAO = new OrderInfoDAO();
    private final CartDAO       cartDAO      = new CartDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // 1) Lấy session và user
        HttpSession session = req.getSession(false);
        User user = (User) session.getAttribute("user");
        
        boolean isBuyNow = "true".equals(req.getParameter("buyNow"));
        @SuppressWarnings("unchecked")
        List<CartItem> cartItems = isBuyNow 
            ? (List<CartItem>) session.getAttribute("buyNowItems") 
            : (List<CartItem>) session.getAttribute("cartItems");

        // 2) Kiểm tra điều kiện thanh toán
        if (user == null || cartItems == null || cartItems.isEmpty()) {
            session.setAttribute("errorMessage", 
                "Vui lòng đăng nhập và thêm sản phẩm trước khi thanh toán.");
            resp.sendRedirect(req.getContextPath() + "/jsp/checkout.jsp");
            return;
        }

        // 3) Lấy thông tin giao hàng từ form và validate
        String fullName      = req.getParameter("fullName");
        String address       = req.getParameter("address");
        String phone         = req.getParameter("phone");
        String paymentMethod = req.getParameter("paymentMethod");
        
        if (fullName == null || fullName.trim().isEmpty() || 
            address == null || address.trim().isEmpty() || 
            phone == null || phone.trim().isEmpty() || 
            paymentMethod == null || paymentMethod.trim().isEmpty()) {
            
            session.setAttribute("errorMessage", "Vui lòng nhập đầy đủ thông tin giao hàng.");
            resp.sendRedirect(req.getContextPath() + "/jsp/checkout.jsp");
            return;
        }
        
        fullName = fullName.trim();
        address = address.trim();
        phone = phone.trim();
        paymentMethod = paymentMethod.trim();

        try {
            // 4) Tạo order (Order + OrderDetail), trả về orderId
            int orderId = orderDAO.createOrder(user.getUserID(), cartItems);
            if (orderId <= 0) {
                throw new RuntimeException("Không tạo được đơn hàng");
            }

            // 5) Lưu thông tin giao hàng vào OrderInfo
            OrderInfo info = new OrderInfo();
            info.setOrderID(orderId);
            info.setShippingName(fullName);
            info.setShippingAddress(address);
            info.setPhone(phone);
            info.setPaymentMethod(paymentMethod);
            orderInfoDAO.insert(info);

            // 6) Xoá giỏ hàng trên DB (nếu lưu) và session
            if (isBuyNow) {
                session.removeAttribute("buyNowItems");
            } else {
                cartDAO.saveCart(user.getUserID(), List.of());
                session.removeAttribute("cartItems");
                session.setAttribute("cartSize", 0);
            }

            // 7) Thiết lập message thành công
            session.setAttribute("successMessage", 
                "Thanh toán thành công! Mã đơn hàng của bạn là #" + orderId);
        } catch (Exception e) {
            session.setAttribute("errorMessage", 
                "Lỗi khi tạo đơn hàng: " + e.getMessage());
        }

        // 8) Chuyển về trang checkout để hiển thị kết quả
        resp.sendRedirect(req.getContextPath() + "/jsp/checkout.jsp");
    }
}
