package dal;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.OrderDetail;

public class OrderDetailDAO extends DBContext {

    private static final String GET_BY_ORDER_ID = """
        SELECT 
          OrderDetailID AS orderDetailID,
          OrderID       AS orderID,
          ProductID     AS productID,
          Quantity      AS quantity,
          UnitPrice     AS unitPrice,
          TotalPrice    AS totalPrice
        FROM OrderDetails
        WHERE OrderID = ?
        """;

    /**
     * Lấy danh sách OrderDetail theo orderId.
     */
    public List<OrderDetail> getOrderDetailsByOrderId(int orderId) {
        List<OrderDetail> list = new ArrayList<>();

        try (PreparedStatement ps = c.prepareStatement(GET_BY_ORDER_ID)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OrderDetail d = new OrderDetail();
                    d.setOrderDetailID(rs.getInt("orderDetailID"));
                    d.setOrderID(rs.getInt("orderID"));
                    d.setProductID(rs.getInt("productID"));
                    d.setQuantity(rs.getInt("quantity"));
                    d.setUnitPrice(rs.getDouble("unitPrice"));
                    d.setTotalPrice(rs.getDouble("totalPrice"));
                    list.add(d);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Lỗi khi lấy chi tiết đơn hàng", e);
        }

        return list;
    }
    
}
