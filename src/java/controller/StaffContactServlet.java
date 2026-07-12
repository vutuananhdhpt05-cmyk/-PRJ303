package controller;

import dal.ContactMessageDAO;
import model.ChatItem;
import model.ContactMessage;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.net.URLEncoder;
import java.sql.SQLException;
import java.util.*;

@WebServlet("/staff/messages")
public class StaffContactServlet extends HttpServlet {

    private ContactMessageDAO dao;

    @Override
    public void init() {
        dao = new ContactMessageDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // 1) Xác thực staff
        HttpSession session = req.getSession(false);
        User me = session != null ? (User) session.getAttribute("user") : null;
        if (me == null || !"STAFF".equalsIgnoreCase(me.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/jsp/login.jsp");
            return;
        }

        try {
            // 2) Load danh sách conversations
            List<ContactMessage> convos = dao.getConversations();

            // 3) Chọn email (param ?email=…), hoặc default cuộc đầu
            String email = req.getParameter("email");
            if (email == null && !convos.isEmpty()) {
                email = convos.get(0).getEmail();
            }

            // 4) Load toàn bộ history cho email đó
            List<ContactMessage> history = email != null
                    ? dao.getByEmail(email)
                    : Collections.emptyList();
            for (ContactMessage convo : convos) {
                // nếu snippet cuối là Admin (tức name == admin full name)
                if (convo.getName().equalsIgnoreCase(me.getFullName())) {
                    // tìm trong history của email đó tin nhắn đầu tiên không phải Admin
                    List<ContactMessage> hist = dao.getByEmail(convo.getEmail());
                    for (ContactMessage m : hist) {
                        if (!m.getName().equalsIgnoreCase(me.getFullName())) {
                            convo.setName(m.getName());
                            break;
                        }
                    }
                }
            }
            // **Expose history** xuống JSP để lấy id cuối
            req.setAttribute("messages", history);

            // 5) Tạo List<ChatItem> để render bong bóng
            // trong AdminContactServlet#doGet, xóa hẳn phần thêm ChatItem theo cm.getReply()
            List<ChatItem> chatItems = new ArrayList<>();
            for (ContactMessage cm : history) {
                // nếu chính admin (tên trùng với me.getFullName()), thì sender=ADMIN
                if (cm.getName().equalsIgnoreCase(me.getFullName())) {
                    chatItems.add(new ChatItem(
                            "ADMIN",
                            cm.getMessage(),
                            cm.getCreatedAt()
                    ));
                } else {
                    // ngược lại là user
                    chatItems.add(new ChatItem(
                            "USER",
                            cm.getMessage(),
                            cm.getCreatedAt()
                    ));
                }
            }

            // 6) Set attributes và forward
            req.setAttribute("conversations", convos);
            req.setAttribute("chatItems", chatItems);
            req.setAttribute("selectedEmail", email);
            req.getRequestDispatcher("/jsp/staff_messages.jsp")
                    .forward(req, resp);

        } catch (SQLException e) {
            throw new ServletException("Lỗi khi load chat", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // 1) Xác thực staff
        HttpSession session = req.getSession(false);
        User me = session != null ? (User) session.getAttribute("user") : null;
        if (me == null || !"STAFF".equalsIgnoreCase(me.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/jsp/login.jsp");
            return;
        }

        req.setCharacterEncoding("UTF-8");
        String email = req.getParameter("email");
        String reply = req.getParameter("reply");

        // 2) Tạo bản ghi mới, name=Admin, message=reply
        ContactMessage cm = new ContactMessage(
                me.getFullName(), // name của admin
                email, // email khách
                "", // phone để trống
                reply // nội dung reply
        );

        try {
            dao.save(cm);     // chèn mới, không update
        } catch (SQLException e) {
            throw new ServletException("Lỗi khi lưu reply", e);
        }

        // 3) Redirect trở lại GET để load toàn bộ lịch sử
        String target = req.getContextPath() + "/staff/messages";
        if (email != null) {
            target += "?email=" + URLEncoder.encode(email, "UTF-8");
        }
        resp.sendRedirect(target);
    }
}

