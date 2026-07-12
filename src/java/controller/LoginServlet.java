package controller;

import dal.UserDAO;
import dal.CartDAO;
import model.User;
import model.CartItem;
import model.VerifyCaptcha;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();
    private final CartDAO cartDAO = new CartDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // 1) Verify Captcha
        String captchaToken = req.getParameter("g-recaptcha-response");
        if (!VerifyCaptcha.verify(captchaToken)) {
            req.setAttribute("error", "Vui lòng xác nhận Captcha.");
            req.getRequestDispatcher("/jsp/login.jsp").forward(req, resp);
            return;
        }

        // 2) Lấy dữ liệu từ form
        String username = req.getParameter("username");
        String password = req.getParameter("password");

        // 3) Xác thực người dùng
        User user;
        try {
            user = userDAO.getUserByLoginId(username, password);
        } catch (SQLException e) {
            req.setAttribute("error", "Lỗi khi kết nối đến cơ sở dữ liệu: " + e.getMessage());
            req.getRequestDispatcher("/jsp/login.jsp").forward(req, resp);
            return;
        }

        if (user != null) {
            // 4) Tạo session và lưu user
            HttpSession session = req.getSession(true);
            session.setAttribute("user", user);

            // 5) Load giỏ hàng từ DB vào session
            try {
                List<CartItem> cart = cartDAO.getCartByUser(user.getUserID());
                if (cart == null) {
                    cart = new ArrayList<>();
                }
                session.setAttribute("cartItems", cart);
                int totalQty = cart.stream().mapToInt(CartItem::getQuantity).sum();
                session.setAttribute("cartSize", totalQty);
            } catch (SQLException e) {
                session.setAttribute("cartItems", new ArrayList<>());
                session.setAttribute("cartSize", 0);
                req.setAttribute("error", "Lỗi khi tải giỏ hàng: " + e.getMessage());
            }

            // 6) Phân quyền: nếu admin thì về admin dashboard, ngược lại về returnUrl hoặc
            // home
            if ("ADMIN".equalsIgnoreCase(user.getRole()) || "STAFF".equalsIgnoreCase(user.getRole())) {
                // Chuyển sang trang admin (bạn có thể đổi URL tuỳ cấu trúc)
                // mới:
                resp.sendRedirect(req.getContextPath() + "/dashboard");

            } else {
                // User thường
                String returnUrl = req.getParameter("returnUrl");
                if (returnUrl != null && !returnUrl.isBlank() && returnUrl.startsWith("/")) {
                    resp.sendRedirect(req.getContextPath() + returnUrl);
                } else {
                    resp.sendRedirect(req.getContextPath() + "/home");
                }
            }
        } else {
            // 7) Xác thực thất bại
            req.setAttribute("error", "Tên đăng nhập hoặc mật khẩu không đúng");
            req.getRequestDispatcher("/jsp/login.jsp").forward(req, resp);
        }
    }
}

