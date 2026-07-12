package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.User;

public class UserDAO extends DBContext {
    /**
     * Lấy User theo loginId (có thể là username hoặc email) và password.
     */
    public User getUserByLoginId(String loginId, String password) throws SQLException {
        String sql = "SELECT * FROM Users "
                   + "WHERE (Username = ? OR Email = ?) "
                   + "  AND Password = ?";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, loginId);
            ps.setString(2, loginId);
            ps.setString(3, password);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new User(
                        rs.getInt("UserID"),
                        rs.getString("Username"),
                        rs.getString("Email"),
                        rs.getString("Password"),
                        rs.getString("FullName"),
                        rs.getString("Address"),
                        rs.getString("Phone"),
                        rs.getString("Role")
                    );
                }
            }
        }
        return null;
    }
     public User authenticate(String username, String password) throws SQLException {
        String sql = """
            SELECT userID, username, email, password, fullName, address, phone, role
            FROM Users
            WHERE username = ? AND password = ?
            """;

        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, password);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User u = new User();
                    u.setUserID(rs.getInt("userID"));
                    u.setUsername(rs.getString("username"));
                    u.setEmail(rs.getString("email"));
                    u.setPassword(rs.getString("password"));
                    u.setFullName(rs.getString("fullName"));
                    u.setAddress(rs.getString("address"));
                    u.setPhone(rs.getString("phone"));
                    u.setRole(rs.getString("role"));
                    return u;
                }
            }
        }

        return null;
    }
     public boolean updatePassword(int userId, String newPassword) throws SQLException {
    String sql = "UPDATE Users SET Password = ? WHERE UserID = ?";
    try (PreparedStatement ps = c.prepareStatement(sql)) {
        ps.setString(1, newPassword);
        ps.setInt(2, userId);
        return ps.executeUpdate() > 0;
    }
}
     public List<User> getAll() throws SQLException {
        String sql = "SELECT * FROM Users";
        List<User> list = new ArrayList<>();
        try (PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(map(rs));
            }
        }
        return list;
    }

    // Tìm theo tên (fullName)
    public List<User> searchByName(String keyword) throws SQLException {
        String sql = "SELECT * FROM Users WHERE FullName LIKE ?";
        List<User> list = new ArrayList<>();
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(map(rs));
                }
            }
        }
        return list;
    }

    // Thêm mới
    public boolean insert(User u) throws SQLException {
        String sql = "INSERT INTO Users (Username, Email, Password, FullName, Address, Phone, Role) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, u.getUsername());
            ps.setString(2, u.getEmail());
            ps.setString(3, u.getPassword());
            ps.setString(4, u.getFullName());
            ps.setString(5, u.getAddress());
            ps.setString(6, u.getPhone());
            ps.setString(7, u.getRole());
            return ps.executeUpdate() > 0;
        }
    }

    // Cập nhật
    public boolean update(User u) throws SQLException {
        String sql = "UPDATE Users SET Username=?, Email=?, FullName=?, Address=?, Phone=?, Role=? "
                   + "WHERE UserID = ?";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, u.getUsername());
            ps.setString(2, u.getEmail());
            ps.setString(3, u.getFullName());
            ps.setString(4, u.getAddress());
            ps.setString(5, u.getPhone());
            ps.setString(6, u.getRole());
            ps.setInt(7, u.getUserID());
            return ps.executeUpdate() > 0;
        }
    }

    // Xóa
    public boolean delete(int userId) throws SQLException {
        String sql = "DELETE FROM Users WHERE UserID = ?";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        }
    }

    // Map ResultSet → User
    private User map(ResultSet rs) throws SQLException {
        return new User(
            rs.getInt("UserID"),
            rs.getString("Username"),
            rs.getString("Email"),
            rs.getString("Password"),
            rs.getString("FullName"),
            rs.getString("Address"),
            rs.getString("Phone"),
            rs.getString("Role")
        );
    }
    public boolean existsByUsernameOrEmail(String username, String email) throws SQLException {
        String sql = "SELECT 1 FROM Users WHERE Username = ? OR Email = ?";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, email);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }
    public User getById(int id) throws SQLException {
    String sql = "SELECT * FROM Users WHERE UserID = ?";
    try (PreparedStatement ps = c.prepareStatement(sql)) {
        ps.setInt(1, id);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return map(rs);
            }
        }
    }
    return null;
}

    public User getUserByUsernameAndEmail(String username, String email) throws SQLException {
        String sql = "SELECT * FROM Users WHERE Username = ? AND Email = ?";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return map(rs);
                }
            }
        }
        return null;
    }

    public User getUserByEmail(String email) throws SQLException {
        String sql = "SELECT * FROM Users WHERE Email = ?";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return map(rs);
                }
            }
        }
        return null;
    }

    public int countTotalUsers() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Users";
        try (PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }
}
