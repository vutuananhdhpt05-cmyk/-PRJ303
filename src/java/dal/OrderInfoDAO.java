package dal;

import java.sql.*;
import model.OrderInfo;

public class OrderInfoDAO extends DBContext {

    private static final String SQL_INSERT = """
        INSERT INTO OrderInfo
          (OrderID, ShippingName, ShippingAddress, Phone, PaymentMethod)
        VALUES (?, ?, ?, ?, ?)
        """;

    private static final String SQL_SELECT_BY_ORDERID = """
        SELECT OrderID, ShippingName, ShippingAddress, Phone, PaymentMethod, CreatedAt
        FROM OrderInfo
        WHERE OrderID = ?
        """;

    private static final String SQL_UPDATE = """
        UPDATE OrderInfo
        SET ShippingName    = ?,
            ShippingAddress = ?,
            Phone           = ?,
            PaymentMethod   = ?
        WHERE OrderID = ?
        """;

    private static final String SQL_DELETE = """
        DELETE FROM OrderInfo
        WHERE OrderID = ?
        """;

    /**
     * Lưu mới OrderInfo.
     * @return true nếu insert thành công
     */
    public boolean insert(OrderInfo info) throws SQLException {
        try (PreparedStatement ps = c.prepareStatement(SQL_INSERT)) {
            ps.setInt(1, info.getOrderID());
            ps.setString(2, info.getShippingName());
            ps.setString(3, info.getShippingAddress());
            ps.setString(4, info.getPhone());
            ps.setString(5, info.getPaymentMethod());
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Lấy OrderInfo theo orderID.
     * @return OrderInfo hoặc null nếu không tìm thấy
     */
    public OrderInfo getByOrderId(int orderId) throws SQLException {
        try (PreparedStatement ps = c.prepareStatement(SQL_SELECT_BY_ORDERID)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    OrderInfo info = new OrderInfo();
                    info.setOrderID(rs.getInt("OrderID"));
                    info.setShippingName(rs.getString("ShippingName"));
                    info.setShippingAddress(rs.getString("ShippingAddress"));
                    info.setPhone(rs.getString("Phone"));
                    info.setPaymentMethod(rs.getString("PaymentMethod"));
                    info.setCreatedAt(rs.getTimestamp("CreatedAt"));
                    return info;
                }
            }
        }
        return null;
    }

    /**
     * Cập nhật thông tin giao hàng.
     * @return true nếu update thành công
     */
    public boolean update(OrderInfo info) throws SQLException {
        try (PreparedStatement ps = c.prepareStatement(SQL_UPDATE)) {
            ps.setString(1, info.getShippingName());
            ps.setString(2, info.getShippingAddress());
            ps.setString(3, info.getPhone());
            ps.setString(4, info.getPaymentMethod());
            ps.setInt(5, info.getOrderID());
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Xóa OrderInfo theo orderID.
     * @return true nếu delete thành công
     */
    public boolean delete(int orderId) throws SQLException {
        try (PreparedStatement ps = c.prepareStatement(SQL_DELETE)) {
            ps.setInt(1, orderId);
            return ps.executeUpdate() > 0;
        }
    }
}
