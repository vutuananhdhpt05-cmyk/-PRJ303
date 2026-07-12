package controller;

import dal.UserDAO;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet(name="RegisterServlet", urlPatterns={"/register"})
public class RegisterServlet extends HttpServlet {
    private final UserDAO dao = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // Chuyển đến register.jsp
        req.getRequestDispatcher("/jsp/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // 1. Lấy param từ form
        String fullname = req.getParameter("fullname");
        String email    = req.getParameter("email");
        String pwd      = req.getParameter("password");
        String confirm  = req.getParameter("confirm");

        String error = null, success = null;

        // 2. Kiểm tra null trước khi trim
        if (fullname == null || fullname.trim().isEmpty() || 
            email == null || email.trim().isEmpty() || 
            pwd == null || pwd.trim().isEmpty() || 
            confirm == null || confirm.trim().isEmpty()) {
            error = "Vui lòng điền đầy đủ thông tin.";
        } else {
            fullname = fullname.trim();
            email    = email.trim();
            
            // Validate email format
            if (!email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
                error = "Email không hợp lệ.";
            } else if (pwd.length() < 6) {
                error = "Mật khẩu phải có ít nhất 6 ký tự.";
            } else if (!pwd.equals(confirm)) {
                error = "Password và Confirm Password không khớp.";
            } else {
                try {
                    // 4. Kiểm tra username/email tồn tại
                    if (dao.existsByUsernameOrEmail(fullname, email)) {
                        error = "Tên hoặc Email đã được sử dụng.";
                    } else {
                        // 5. Tạo User và lưu
                        User u = new User();
                        u.setUsername(fullname);    // fullname dùng làm username
                        u.setEmail(email);
                        
                        // Set plain password
                        u.setPassword(pwd);
                        
                        u.setFullName(fullname);    
                        u.setAddress("");
                        u.setPhone("");
                        u.setRole("user");

                        boolean inserted = dao.insert(u);
                        if (inserted) {
                            req.getSession().setAttribute("success", "Đăng ký thành công! Bạn có thể đăng nhập ngay.");
                            resp.sendRedirect(req.getContextPath() + "/jsp/login.jsp");
                            return;
                        } else {
                            error = "Có lỗi khi lưu dữ liệu, vui lòng thử lại.";
                        }
                    }
                } catch (SQLException ex) {
                    ex.printStackTrace();
                    error = "Lỗi hệ thống, vui lòng thử lại sau.";
                }
            }
        }

        // 6. Trả về JSP với thông báo
        req.setAttribute("error", error);
        req.getRequestDispatcher("/jsp/register.jsp").forward(req, resp);
    }
}