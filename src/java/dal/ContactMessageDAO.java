package dal;

import java.sql.*;
import java.util.*;
import model.ChatItem;
import model.ContactMessage;

public class ContactMessageDAO extends DBContext {
    // Lưu message mới
// trong ContactMessageDAO.java
public int save(ContactMessage msg) throws SQLException {
    String sql = "INSERT INTO contact_messages(name,email,phone,message) VALUES(?,?,?,?)";
    try (PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
        ps.setString(1, msg.getName());
        ps.setString(2, msg.getEmail());
        ps.setString(3, msg.getPhone());
        ps.setString(4, msg.getMessage());
        ps.executeUpdate();
        try (ResultSet keys = ps.getGeneratedKeys()) {
            if (keys.next()) {
                return keys.getInt(1);   // trả về id vừa chèn
            } else {
                throw new SQLException("Không lấy được generated key.");
            }
        }
    }
}
// Trong file ContactMessageDAO.java
public List<ContactMessage> getByEmail(String email) throws SQLException {
    String sql = "SELECT * FROM contact_messages WHERE email=? ORDER BY created_at ASC";
    List<ContactMessage> list = new ArrayList<>();
    try (PreparedStatement ps = c.prepareStatement(sql)) {
        ps.setString(1, email);
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new ContactMessage(
                    rs.getInt("id"),
                    rs.getString("name"),
                    rs.getString("email"),
                    rs.getString("phone"),
                    rs.getString("message"),
                    rs.getTimestamp("created_at"),
                    rs.getString("reply"),
                    rs.getTimestamp("reply_at")
                ));
            }
        }
    }
    return list;
}

    // Cập nhật reply
    public void updateReply(int id, String reply) throws SQLException {
        String sql = "UPDATE contact_messages SET reply=?, reply_at=GETDATE() WHERE id=?";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, reply);
            ps.setInt(2, id);
            ps.executeUpdate();
        }
    }

    // Lấy tất cả (message + reply) theo created_at DESC
    public List<ContactMessage> getAll() throws SQLException {
        String sql = "SELECT * FROM contact_messages ORDER BY created_at DESC";
        List<ContactMessage> list = new ArrayList<>();
        try (PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new ContactMessage(
                  rs.getInt("id"),
                  rs.getString("name"),
                  rs.getString("email"),
                  rs.getString("phone"),
                  rs.getString("message"),
                  rs.getTimestamp("created_at"),
                  rs.getString("reply"),
                  rs.getTimestamp("reply_at")
));
            }
        }
        return list;
    }

    // Lấy conversations distinct theo email (bản mới nhất)
    public List<ContactMessage> getConversations() throws SQLException {
        List<ContactMessage> all = getAll();
        LinkedHashMap<String,ContactMessage> map = new LinkedHashMap<>();
        for (ContactMessage m : all) {
            if (!map.containsKey(m.getEmail())) {
                map.put(m.getEmail(), m);
            }
        }
        return new ArrayList<>(map.values());
    }

    // Lấy toàn bộ history chat của 1 email (ASC)
// Trong ContactMessageDAO.java
public List<ChatItem> getChatItemsByEmail(String email) throws SQLException {
    List<ContactMessage> messages = getByEmail(email);
    List<ChatItem> items = new ArrayList<>();
    
    for (ContactMessage msg : messages) {
        // Thêm tin nhắn từ user
        items.add(new ChatItem("USER", msg.getMessage(), msg.getCreatedAt()));
        
        // Thêm phản hồi từ admin (nếu có)
        if (msg.getReply() != null && !msg.getReply().isEmpty()) {
            items.add(new ChatItem("ADMIN", msg.getReply(), 
                msg.getReplyAt() != null ? msg.getReplyAt() : msg.getCreatedAt()));
        }
    }
    
    return items;
}

    public void closeConnection() {
        try { if (c!=null && !c.isClosed()) c.close(); }
        catch (SQLException ignored) {}
    }
}