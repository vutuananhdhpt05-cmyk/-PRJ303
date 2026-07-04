package controller;

import dal.ContactMessageDAO;
import model.ContactMessage;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/ContactServlet")
public class ContactServlet extends HttpServlet {
    private ContactMessageDAO dao;

    @Override
    public void init() throws ServletException {
        dao = new ContactMessageDAO();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // đảm bảo UTF-8
        req.setCharacterEncoding("UTF-8");

        // Lấy dữ liệu từ form
        String name    = req.getParameter("name");
        String email   = req.getParameter("email");
        String phone   = req.getParameter("phone");
        String message = req.getParameter("message");

        HttpSession session = req.getSession();
        String feedback;
        String status; // "success" hoặc "error"

        // Validate bắt buộc
        if (isEmpty(name) || isEmpty(email) || isEmpty(message)) {
            feedback = "Vui lòng nhập họ tên, email và nội dung.";
            status   = "error";
        } else {
            ContactMessage cm = new ContactMessage(
                name.trim(),
                email.trim(),
                phone   == null ? "" : phone.trim(),
                message.trim()
            );
            try {
                dao.save(cm);
                feedback = String.format(
                  "Cảm ơn %s! Chúng tôi đã nhận tin nhắn của bạn và sẽ liên hệ qua %s.",
                  cm.getName(), cm.getEmail()
                );
                status = "success";
            } catch (SQLException e) {
                e.printStackTrace();
                feedback = "Đã xảy ra lỗi khi lưu thông tin. Vui lòng thử lại sau.";
                status   = "error";
            }
        }

        // Đặt flash-message lên session
        session.setAttribute("formMessage", feedback);
        session.setAttribute("formStatus",  status);

        // Redirect để JSP tự hiển thị dựa trên session
        resp.sendRedirect(req.getContextPath() + "/jsp/contact.jsp");
    }

    // Helper
    private boolean isEmpty(String s) {
        return s == null || s.trim().isEmpty();
    }
}
