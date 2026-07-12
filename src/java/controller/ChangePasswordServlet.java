package controller;

import dal.UserDAO;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/changePassword")
public class ChangePasswordServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = session != null ? (User) session.getAttribute("user") : null;
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/jsp/login.jsp");
            return;
        }

        String oldPass = req.getParameter("oldPassword");
        String newPass = req.getParameter("newPassword");
        String confirm = req.getParameter("confirmPassword");

        if (!newPass.equals(confirm)) {
            req.setAttribute("pwdError", "Mật khẩu mới và xác nhận không khớp.");
            req.getRequestDispatcher("/jsp/profile.jsp").forward(req, resp);
            return;
        }

        try {
            // Xác thực old password
            User auth = userDAO.authenticate(user.getUsername(), oldPass);
            if (auth == null) {
                req.setAttribute("pwdError", "Mật khẩu cũ không đúng.");
                req.getRequestDispatcher("/jsp/profile.jsp").forward(req, resp);
                return;
            }
            // Cập nhật mật khẩu
            userDAO.updatePassword(user.getUserID(), newPass);
            // Cập nhật session
            user.setPassword(newPass);
            session.setAttribute("user", user);
            req.setAttribute("pwdSuccess", "Đổi mật khẩu thành công.");
        } catch (SQLException e) {
            throw new ServletException(e);
        }

        req.getRequestDispatcher("/jsp/profile.jsp").forward(req, resp);
    }
}
