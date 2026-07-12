package dal;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.CartItem;
import model.Order;

public class OrderDAO extends DBContext {

    // ================= SQL Statements =================
    private static final String INSERT_ORDER = 
        "INSERT INTO Orders (UserID, OrderDate, TotalAmount, Status) " +
        "VALUES (?, GETDATE(), ?, ?)";

    private static final String UPDATE_PRODUCT_STOCK =
        "UPDATE Products SET Stock = Stock - ? WHERE ProductID = ?";

    private static final String INSERT_ORDER_DETAIL = 
        "INSERT INTO OrderDetails (OrderID, ProductID, Quantity, UnitPrice) " +
        "VALUES (?, ?, ?, ?)";

    private static final String SELECT_BY_USER = 
        "SELECT OrderID, UserID, OrderDate, TotalAmount, Status " +
        "FROM Orders WHERE UserID = ? ORDER BY OrderDate DESC";

    private static final String SELECT_ALL = 
        "SELECT OrderID, UserID, OrderDate, TotalAmount, Status " +
        "FROM Orders ORDER BY OrderDate DESC";

    // ================= Mapping Helpers =================
    private Order mapOrder(ResultSet rs) throws SQLException {
        Order o = new Order();
        o.setOrderID(rs.getInt("OrderID"));
        o.setUserID(rs.getInt("UserID"));
        o.setOrderDate(rs.getTimestamp("OrderDate"));
        o.setTotalAmount(rs.getDouble("TotalAmount"));
        o.setStatus(rs.getString("Status"));
        return o;
    }

    // ================= Public Methods =================

    /**
     * Tạo mới một Order và các OrderDetails tương ứng.
     * Nếu thành công trả về orderId, ngược lại ném SQLException.
     */
    public int createOrder(int userId, List<CartItem> cartItems) throws SQLException {
        int orderId = -1;
        double total = cartItems.stream()
                                .mapToDouble(i -> i.getQuantity() * i.getProduct().getPrice())
                                .sum();

        // Bắt đầu transaction
        c.setAutoCommit(false);
        try (PreparedStatement psOrder = c.prepareStatement(INSERT_ORDER, Statement.RETURN_GENERATED_KEYS)) {
            psOrder.setInt(1, userId);
            psOrder.setDouble(2, total);
            psOrder.setString(3, "Pending");

            psOrder.executeUpdate();
            try (ResultSet rs = psOrder.getGeneratedKeys()) {
                if (rs.next()) {
                    // SQL Server driver might return BigDecimal/numeric. getInt(1) typically works.
                    orderId = rs.getInt(1);
                } else {
                    throw new SQLException("Không lấy được OrderID sau khi insert Orders.");
                }
            }
        }

        // Thêm chi tiết OrderDetails và trừ Stock
        try (PreparedStatement psDetail = c.prepareStatement(INSERT_ORDER_DETAIL);
             PreparedStatement psStock = c.prepareStatement(UPDATE_PRODUCT_STOCK)) {
            for (CartItem item : cartItems) {
                psDetail.setInt(1, orderId);
                psDetail.setInt(2, item.getProduct().getProductID());
                psDetail.setInt(3, item.getQuantity());
                psDetail.setDouble(4, item.getProduct().getPrice());
                psDetail.addBatch();
                
                // Trừ stock
                psStock.setInt(1, item.getQuantity());
                psStock.setInt(2, item.getProduct().getProductID());
                psStock.addBatch();
            }
            psDetail.executeBatch();
            psStock.executeBatch();
        }

        c.commit();
        c.setAutoCommit(true);
        return orderId;
    }

    /**
     * Lấy danh sách Orders của một user.
     */
    public List<Order> getOrdersByUserId(int userId) {
        List<Order> list = new ArrayList<>();
        try (PreparedStatement ps = c.prepareStatement(SELECT_BY_USER)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapOrder(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Lấy toàn bộ Orders (dành cho admin).
     */
    public List<Order> getAllOrders() {
        List<Order> list = new ArrayList<>();
        try (PreparedStatement ps = c.prepareStatement(SELECT_ALL);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapOrder(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public List<Order> advancedSearchOrders(String orderId, String fromDate, String toDate, String status) {
        List<Order> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT OrderID, UserID, OrderDate, TotalAmount, Status FROM Orders WHERE 1=1 ");
        List<Object> params = new ArrayList<>();

        if (orderId != null && !orderId.trim().isEmpty()) {
            sql.append("AND OrderID = ? ");
            params.add(Integer.parseInt(orderId));
        }
        if (fromDate != null && !fromDate.trim().isEmpty()) {
            sql.append("AND CAST(OrderDate AS DATE) >= ? ");
            params.add(fromDate);
        }
        if (toDate != null && !toDate.trim().isEmpty()) {
            sql.append("AND CAST(OrderDate AS DATE) <= ? ");
            params.add(toDate);
        }
        if (status != null && !status.trim().isEmpty() && !status.equals("All")) {
            sql.append("AND Status = ? ");
            params.add(status);
        }
        sql.append("ORDER BY OrderDate DESC");

        try (PreparedStatement ps = c.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapOrder(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    public Order getOrderById(int id) throws SQLException {
  String sql = "SELECT OrderID, UserID, OrderDate, TotalAmount, Status FROM Orders WHERE OrderID=?";
  try (PreparedStatement ps = c.prepareStatement(sql)) {
    ps.setInt(1, id);
    try (ResultSet rs = ps.executeQuery()) {
      if (rs.next()) return mapOrder(rs);
    }
  }
  return null;
}

    public void updateOrderStatus(int orderId, String status) throws SQLException {
        String sql = "UPDATE Orders SET Status = ? WHERE OrderID = ?";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, orderId);
            ps.executeUpdate();
        }
    }

    public void cancelOrder(int orderId) throws SQLException {
        // Bắt đầu transaction
        c.setAutoCommit(false);
        try {
            // Cập nhật trạng thái
            updateOrderStatus(orderId, "Cancelled");
            
            // Lấy chi tiết đơn hàng để cộng lại kho
            String getDetailsSql = "SELECT ProductID, Quantity FROM OrderDetails WHERE OrderID = ?";
            String updateStockSql = "UPDATE Products SET Stock = Stock + ? WHERE ProductID = ?";
            
            try (PreparedStatement psGet = c.prepareStatement(getDetailsSql);
                 PreparedStatement psUpdate = c.prepareStatement(updateStockSql)) {
                
                psGet.setInt(1, orderId);
                try (ResultSet rs = psGet.executeQuery()) {
                    while (rs.next()) {
                        psUpdate.setInt(1, rs.getInt("Quantity"));
                        psUpdate.setInt(2, rs.getInt("ProductID"));
                        psUpdate.addBatch();
                    }
                }
                psUpdate.executeBatch();
            }
            c.commit();
        } catch (SQLException e) {
            c.rollback();
            throw e;
        } finally {
            c.setAutoCommit(true);
        }
    }

    public int countTotalOrders() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Orders";
        try (PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }
    
    public double sumTotalRevenue() throws SQLException {
        String sql = "SELECT SUM(TotalAmount) FROM Orders WHERE Status != 'Cancelled'";
        try (PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getDouble(1);
            }
        }
        return 0.0;
    }

}
