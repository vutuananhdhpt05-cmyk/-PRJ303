package controller;

import dal.UserDAO;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // Bảo vệ: chỉ cho phép khi đã login
        HttpSession session = req.getSession(false);
        User user = session != null ? (User) session.getAttribute("user") : null;
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/jsp/login.jsp?returnUrl=/profile");
            return;
        }
        // Forward sang jsp phù hợp
        req.setAttribute("user", user);
        
        String role = user.getRole();
        if ("ADMIN".equalsIgnoreCase(role) || "STAFF".equalsIgnoreCase(role) || "MANAGER".equalsIgnoreCase(role)) {
            req.getRequestDispatcher("/jsp/mgmt_profile.jsp").forward(req, resp);
        } else {
            req.getRequestDispatcher("/jsp/profile.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession(false);
        User user = session != null ? (User) session.getAttribute("user") : null;
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/jsp/login.jsp");
            return;
        }

        String fullName = req.getParameter("fullName");
        String phone = req.getParameter("phone");
        String address = req.getParameter("address");

        user.setFullName(fullName);
        user.setPhone(phone);
        user.setAddress(address);

        try {
            UserDAO dao = new UserDAO();
            dao.update(user);
            session.setAttribute("user", user); // update session
            session.setAttribute("profileSuccess", "Cập nhật hồ sơ thành công!");
        } catch (SQLException e) {
            session.setAttribute("profileError", "Lỗi khi cập nhật hồ sơ!");
        }

        resp.sendRedirect(req.getContextPath() + "/profile");
    }
}

