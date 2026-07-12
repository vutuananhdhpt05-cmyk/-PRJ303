package dal;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.OrderHistoryEntry;

public class OrderHistoryDAO extends DBContext {
    private static final String SQL_HISTORY_BY_USERNAME = """
        SELECT 
          o.OrderID,
          u.Username,
          o.OrderDate,
          o.TotalAmount,
          oi.ShippingName,
          oi.Phone,
          oi.CreatedAt,
          p.ProductName,
          od.Quantity,
          od.UnitPrice,
          od.TotalPrice
        FROM Orders o
        JOIN Users u      ON o.UserID       = u.UserID
        JOIN OrderInfo oi ON o.OrderID      = oi.OrderID
        JOIN OrderDetails od ON o.OrderID    = od.OrderID
        JOIN Products p   ON od.ProductID    = p.ProductID
        WHERE u.Username = ?
        ORDER BY o.OrderDate DESC, od.OrderDetailID
        """;

    /**
     * Lấy lịch sử đơn hàng (cùng chi tiết) theo username.
     */
    public List<OrderHistoryEntry> getHistoryByUsername(String username) throws SQLException {
        List<OrderHistoryEntry> list = new ArrayList<>();
        try (PreparedStatement ps = c.prepareStatement(SQL_HISTORY_BY_USERNAME)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OrderHistoryEntry e = new OrderHistoryEntry();
                    e.setOrderID(rs.getInt("OrderID"));
                    e.setUsername(rs.getString("Username"));
                    e.setOrderDate(rs.getTimestamp("OrderDate"));
                    e.setTotalAmount(rs.getDouble("TotalAmount"));
                    e.setShippingName(rs.getString("ShippingName"));
                    e.setPhone(rs.getString("Phone"));
                    e.setCreatedAt(rs.getTimestamp("CreatedAt"));
                    e.setProductName(rs.getString("ProductName"));
                    e.setQuantity(rs.getInt("Quantity"));
                    e.setUnitPrice(rs.getDouble("UnitPrice"));
                    e.setTotalPrice(rs.getDouble("TotalPrice"));
                    list.add(e);
                }
            }
        }
        return list;
    
}

}
