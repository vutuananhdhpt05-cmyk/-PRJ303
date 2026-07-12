package controller;

import dal.ContactMessageDAO;
import model.ContactMessage;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;
import java.net.URLEncoder;

@WebServlet("/staff/reply")
public class StaffReplyServlet extends HttpServlet {
    private ContactMessageDAO dao;
    @Override public void init() { dao = new ContactMessageDAO(); }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
          throws ServletException, IOException {
        // xác thực admin…
        req.setCharacterEncoding("UTF-8");
        String email = req.getParameter("email");
        String reply = req.getParameter("reply");
        User me = (User) req.getSession(false).getAttribute("user");

           // Tạo object
    ContactMessage cm = new ContactMessage(
        me.getFullName(),
        email,
        "",       // phone để trống
        reply
    );

    // BẮT SQLException khi save
    try {
        dao.save(cm);
    } catch (SQLException e) {
        throw new ServletException("Không lưu được tin nhắn", e);
    }

    // Redirect…
    String target = req.getContextPath() + "/staff/messages?email="
                  + URLEncoder.encode(email, "UTF-8");
    resp.sendRedirect(target);
}
}
