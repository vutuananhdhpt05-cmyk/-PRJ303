package controller;

import dal.ContactMessageDAO;
import model.ContactMessage;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Collections;
import java.util.List;

@WebServlet("/simpleChat")
public class SimpleChatServlet extends HttpServlet {

    private ContactMessageDAO dao;

    @Override
    public void init() {
        dao = new ContactMessageDAO();
    }
@Override
protected void doGet(HttpServletRequest req, HttpServletResponse resp)
        throws ServletException, IOException {
    resp.setContentType("text/html;charset=UTF-8");
    HttpSession session = req.getSession(false);
    User user = session != null ? (User) session.getAttribute("user") : null;

    List<ContactMessage> chats;
    try {
        if (user != null) {
            chats = dao.getByEmail(user.getEmail());
        } else {
            chats = Collections.emptyList();
        }
    } catch (SQLException e) {
        throw new ServletException(e);
    }

    PrintWriter out = resp.getWriter();
    
    if (chats.isEmpty()) {
        out.println("<div class='text-center mt-5'><i class='fa-solid fa-headset fa-3x mb-3' style='color: #0ea5e9;'></i><p class='text-muted' style='font-size: 0.9rem;'>Chào " + (user != null ? escape(user.getFullName()) : "bạn") + ",<br>Bạn cần hỗ trợ gì từ ASUS Store ạ?</p></div>");
        return;
    }
    SimpleDateFormat fmt = new SimpleDateFormat("HH:mm");
    for (ContactMessage m : chats) {
        String sender = m.getName();  // có thể là FullName user hoặc tên Admin
        String text   = escape(m.getMessage());
        String time   = fmt.format(m.getCreatedAt());

        if ("Admin".equalsIgnoreCase(sender) || 
            (m.getEmail().equalsIgnoreCase(user.getEmail()) && !m.getName().equalsIgnoreCase(user.getFullName()))) {
            // In tin của admin (trắng, trái)
            out.printf(
              "<div class='chat-msg admin'>"
            + "  <div class='bubble'>%s<span class='ts'>%s</span></div>"
            + "</div>",
              text, time
            );
        } else {
            // In tin của user (xanh, phải)
            out.printf(
              "<div class='chat-msg user'>"
            + "  <div class='bubble'>%s<span class='ts'>%s</span></div>"
            + "</div>",
              text, time
            );
        }
    }
}


    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        User user = (User) req.getSession(false).getAttribute("user");
        String msg = req.getParameter("message");
        if (user != null && msg != null && !msg.isBlank()) {
            try {
                dao.save(new ContactMessage(
                        user.getFullName(),
                        user.getEmail(),
                        user.getPhone(),
                        msg.trim()
                ));
                
                // Auto-reply for the first message
                List<ContactMessage> history = dao.getByEmail(user.getEmail());
                if (history.size() == 1) {
                    dao.save(new ContactMessage(
                            "Staff",
                            user.getEmail(),
                            "",
                            "Cảm ơn bạn đã liên hệ! Tin nhắn của bạn đã được ghi nhận và sẽ được nhân viên hỗ trợ xử lý trong vòng 24h."
                    ));
                }
            } catch (SQLException e) {
                throw new ServletException(e);
            }
        }
        doGet(req, resp);
    }

    @Override
public void destroy() {
        dao.closeConnection();
    }

    // helper to escape HTML
    private String escape(String s) {
        return s.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;");
    }
}