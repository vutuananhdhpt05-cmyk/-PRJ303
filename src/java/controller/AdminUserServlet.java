package controller;

import dal.UserDAO;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/admin/users")
public class AdminUserServlet extends HttpServlet {

    private final UserDAO dao = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        try {
            switch (action == null ? "" : action) {
                case "promote":
                    int promoteId = Integer.parseInt(req.getParameter("id"));
                    User userToPromote = dao.getById(promoteId);
                    if (userToPromote != null) {
                        userToPromote.setRole("admin");
                        dao.update(userToPromote);
                    }
                    resp.sendRedirect(req.getContextPath() + "/dashboard");
                    break;

                case "delete":
                    int delId = Integer.parseInt(req.getParameter("id"));
                    try {
                        dao.delete(delId);
                        req.getSession().setAttribute("successMessage", "Đã xóa người dùng thành công.");
                    } catch (Exception e) {
                        req.getSession().setAttribute("errorMessage", "Không thể xóa người dùng này vì dữ liệu đang được liên kết (đã mua hàng, v.v.).");
                    }
                    resp.sendRedirect(req.getContextPath() + "/dashboard");
                    break;
                default:
                    resp.sendRedirect(req.getContextPath() + "/dashboard");
                    break;
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String idStr = req.getParameter("userID");
        
        try {
            if (idStr != null && !idStr.isBlank()) {
                int id = Integer.parseInt(idStr);
                User existingUser = dao.getById(id);
                User currentUser = (User) req.getSession().getAttribute("user");
                
                if (existingUser != null) {
                    String pUsername = req.getParameter("username");
                    if (pUsername != null) existingUser.setUsername(pUsername);
                    
                    String pEmail = req.getParameter("email");
                    if (pEmail != null) existingUser.setEmail(pEmail);
                    
                    String pFullName = req.getParameter("fullName");
                    if (pFullName != null) existingUser.setFullName(pFullName);
                    
                    String pAddress = req.getParameter("address");
                    if (pAddress != null) existingUser.setAddress(pAddress);
                    
                    String pPhone = req.getParameter("phone");
                    if (pPhone != null) existingUser.setPhone(pPhone);
                    
                    String newPass = req.getParameter("password");
                    if (newPass != null && !newPass.isBlank()) {
                        existingUser.setPassword(newPass);
                    }
                    
                    String newRole = req.getParameter("role");
                    if (currentUser != null && currentUser.getUserID() == id && newRole != null && !currentUser.getRole().equalsIgnoreCase(newRole)) {
                        req.getSession().setAttribute("errorMessage", "Lỗi: Bạn không thể tự hạ cấp quyền (Role) của chính mình!");
                    } else if (newRole != null) {
                        existingUser.setRole(newRole);
                    }
                    
                    dao.update(existingUser);
                    if (req.getSession().getAttribute("errorMessage") == null) {
                        req.getSession().setAttribute("successMessage", "Đã cập nhật thông tin người dùng!");
                    }
                }
            }
            String referer = req.getHeader("Referer");
            if (referer != null && !referer.isEmpty()) {
                resp.sendRedirect(referer);
            } else {
                resp.sendRedirect(req.getContextPath() + "/admin/users");
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}

