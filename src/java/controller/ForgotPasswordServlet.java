package controller;

import dal.UserDAO;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/forgotPassword")
public class ForgotPasswordServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // Reset all session parameters related to forgot password
        HttpSession session = req.getSession(true);
        session.removeAttribute("resetEmail");
        session.removeAttribute("resetOtp");
        session.removeAttribute("verifiedUser");
        req.getRequestDispatcher("/jsp/forgotPassword.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        HttpSession session = req.getSession(true);

        if ("send_otp".equals(action)) {
            String email = req.getParameter("email");

            if (email == null || email.trim().isEmpty()) {
                req.setAttribute("error", "Vui lòng nhập Email.");
                req.getRequestDispatcher("/jsp/forgotPassword.jsp").forward(req, resp);
                return;
            }

            try {
                User user = userDAO.getUserByEmail(email.trim());
                if (user != null) {
                    // Generate a 6-digit OTP
                    String otp = String.valueOf((int) ((Math.random() * 900000) + 100000));
                    
                    // Save to session
                    session.setAttribute("resetEmail", email.trim());
                    session.setAttribute("resetOtp", otp);
                    
                    req.setAttribute("success", "Mã OTP đã được tạo thành công!");
                    req.setAttribute("step", 2);
                } else {
                    req.setAttribute("error", "Email không khớp với bất kỳ tài khoản nào.");
                    req.setAttribute("step", 1);
                }
            } catch (SQLException e) {
                req.setAttribute("error", "Lỗi kết nối cơ sở dữ liệu: " + e.getMessage());
                req.setAttribute("step", 1);
            }
            req.getRequestDispatcher("/jsp/forgotPassword.jsp").forward(req, resp);

        } else if ("verify_otp".equals(action)) {
            String enteredOtp = req.getParameter("otp");
            String sessionOtp = (String) session.getAttribute("resetOtp");
            String email = (String) session.getAttribute("resetEmail");

            if (enteredOtp == null || enteredOtp.trim().isEmpty()) {
                req.setAttribute("error", "Vui lòng nhập mã OTP.");
                req.setAttribute("step", 2);
                req.getRequestDispatcher("/jsp/forgotPassword.jsp").forward(req, resp);
                return;
            }

            if (sessionOtp != null && sessionOtp.equals(enteredOtp.trim())) {
                try {
                    User user = userDAO.getUserByEmail(email);
                    if (user != null) {
                        session.setAttribute("verifiedUser", user);
                        session.removeAttribute("resetOtp"); // Clear OTP after verification
                        req.setAttribute("step", 3);
                    } else {
                        req.setAttribute("error", "Tài khoản không còn tồn tại.");
                        req.setAttribute("step", 1);
                    }
                } catch (SQLException e) {
                    req.setAttribute("error", "Lỗi cơ sở dữ liệu: " + e.getMessage());
                    req.setAttribute("step", 2);
                }
            } else {
                req.setAttribute("error", "Mã OTP không chính xác. Vui lòng kiểm tra lại.");
                req.setAttribute("step", 2);
            }
            req.getRequestDispatcher("/jsp/forgotPassword.jsp").forward(req, resp);

        } else if ("reset".equals(action)) {
            User verifiedUser = (User) session.getAttribute("verifiedUser");
            if (verifiedUser == null) {
                resp.sendRedirect(req.getContextPath() + "/forgotPassword");
                return;
            }

            String newPassword = req.getParameter("newPassword");
            String confirmPassword = req.getParameter("confirmPassword");

            if (newPassword == null || newPassword.trim().isEmpty() || confirmPassword == null || confirmPassword.trim().isEmpty()) {
                req.setAttribute("error", "Vui lòng nhập mật khẩu mới.");
                req.setAttribute("step", 3);
                req.getRequestDispatcher("/jsp/forgotPassword.jsp").forward(req, resp);
                return;
            }

            if (!newPassword.equals(confirmPassword)) {
                req.setAttribute("error", "Xác nhận mật khẩu không khớp.");
                req.setAttribute("step", 3);
                req.getRequestDispatcher("/jsp/forgotPassword.jsp").forward(req, resp);
                return;
            }

            try {
                boolean success = userDAO.updatePassword(verifiedUser.getUserID(), newPassword);
                if (success) {
                    session.removeAttribute("verifiedUser");
                    session.removeAttribute("resetEmail");
                    req.setAttribute("success", "Đặt lại mật khẩu thành công! Hãy đăng nhập lại.");
                    req.getRequestDispatcher("/jsp/login.jsp").forward(req, resp);
                    return;
                } else {
                    req.setAttribute("error", "Không thể cập nhật mật khẩu. Vui lòng thử lại.");
                    req.setAttribute("step", 3);
                }
            } catch (SQLException e) {
                req.setAttribute("error", "Lỗi khi cập nhật mật khẩu: " + e.getMessage());
                req.setAttribute("step", 3);
            }
            req.getRequestDispatcher("/jsp/forgotPassword.jsp").forward(req, resp);
        }
    }
}
