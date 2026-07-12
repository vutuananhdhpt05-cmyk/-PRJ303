package dal;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.CartItem;
import model.Product;

public class CartDAO extends DBContext {

    // Lấy danh sách CartItem của user
    public List<CartItem> getCartByUser(int userId) throws SQLException {
        String sql = """
            SELECT c.UserID, c.ProductID, c.Quantity,
                   p.ProductID, p.ProductName, p.Price, p.Stock, p.ImageUrl
            FROM Cart c
            JOIN Products p ON c.ProductID = p.ProductID
            WHERE c.UserID = ?
            """;

        List<CartItem> list = new ArrayList<>();

        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Product product = new Product();
                    product.setProductID(rs.getInt("ProductID"));
                    product.setProductName(rs.getString("ProductName"));
                    product.setPrice(rs.getDouble("Price"));
                    product.setStock(rs.getInt("Stock"));
                    product.setImageUrl(rs.getString("ImageUrl"));

                    int quantity = rs.getInt("Quantity");
                    list.add(new CartItem(product, quantity));
                }
            }
        }

        return list;
    }

    // Thêm sản phẩm vào giỏ (nếu đã có thì cộng dồn)
    public boolean addToCart(int userId, int productId, int qty) throws SQLException {
        String checkStockSql   = "SELECT Stock FROM Products WHERE ProductID = ?";
        String selectCartSql   = "SELECT Quantity FROM Cart WHERE UserID = ? AND ProductID = ?";
        String insertCartSql   = "INSERT INTO Cart (UserID, ProductID, Quantity, CreatedAt) VALUES (?, ?, ?, GETDATE())";
        String updateCartSql   = "UPDATE Cart SET Quantity = Quantity + ? WHERE UserID = ? AND ProductID = ?";

        // 1. Kiểm tra tồn kho trước
        try (PreparedStatement ps = c.prepareStatement(checkStockSql)) {
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next() || rs.getInt("Stock") < qty) {
                    return false;
                }
            }
        }

        // 2. Xem đã có trong cart chưa
        try (PreparedStatement ps = c.prepareStatement(selectCartSql)) {
            ps.setInt(1, userId);
            ps.setInt(2, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    // Đã có -> cộng dồn, kiểm tra tồn kho mới
                    int existingQty = rs.getInt("Quantity");
                    int newQty = existingQty + qty;

                    try (PreparedStatement psCheck = c.prepareStatement(checkStockSql)) {
                        psCheck.setInt(1, productId);
                        try (ResultSet rs2 = psCheck.executeQuery()) {
                            if (rs2.next() && rs2.getInt("Stock") < newQty) {
                                return false;
                            }
                        }
                    }

                    try (PreparedStatement psUpd = c.prepareStatement(updateCartSql)) {
                        psUpd.setInt(1, qty);
                        psUpd.setInt(2, userId);
                        psUpd.setInt(3, productId);
                        psUpd.executeUpdate();
                    }
                } else {
                    // Chưa có -> insert mới
                    try (PreparedStatement psIns = c.prepareStatement(insertCartSql)) {
                        psIns.setInt(1, userId);
                        psIns.setInt(2, productId);
                        psIns.setInt(3, qty);
                        psIns.executeUpdate();
                    }
                }
            }
        }

        return true;
    }

    // Cập nhật số lượng trong cart (change có thể âm hoặc dương)
    public boolean updateQuantity(int userId, int productId, int change) throws SQLException {
        String selectCartSql  = "SELECT Quantity FROM Cart WHERE UserID = ? AND ProductID = ?";
        String checkStockSql  = "SELECT Stock FROM Products WHERE ProductID = ?";
        String updateCartSql  = "UPDATE Cart SET Quantity = ? WHERE UserID = ? AND ProductID = ?";
        String deleteCartSql  = "DELETE FROM Cart WHERE UserID = ? AND ProductID = ?";

        try (PreparedStatement ps = c.prepareStatement(selectCartSql)) {
            ps.setInt(1, userId);
            ps.setInt(2, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return false;

                int newQty = rs.getInt("Quantity") + change;
                if (newQty > 0) {
                    // Kiểm tra tồn kho
                    try (PreparedStatement psCheck = c.prepareStatement(checkStockSql)) {
                        psCheck.setInt(1, productId);
                        try (ResultSet rs2 = psCheck.executeQuery()) {
                            if (!rs2.next() || rs2.getInt("Stock") < newQty) {
                                return false;
                            }
                        }
                    }
                    // Cập nhật quantity
                    try (PreparedStatement psUpd = c.prepareStatement(updateCartSql)) {
                        psUpd.setInt(1, newQty);
                        psUpd.setInt(2, userId);
                        psUpd.setInt(3, productId);
                        psUpd.executeUpdate();
                    }
                } else {
                    // Xóa nếu quantity <= 0
                    try (PreparedStatement psDel = c.prepareStatement(deleteCartSql)) {
                        psDel.setInt(1, userId);
                        psDel.setInt(2, productId);
                        psDel.executeUpdate();
                    }
                }
            }
        }

        return true;
    }

    // Xóa một item khỏi cart
    public void removeItem(int userId, int productId) throws SQLException {
        String sql = "DELETE FROM Cart WHERE UserID = ? AND ProductID = ?";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, productId);
            ps.executeUpdate();
        }
    }

    // Lưu toàn bộ cart (clear + batch insert)
    public boolean saveCart(int userId, List<CartItem> cartItems) throws SQLException {
    String deleteSql = "DELETE FROM Cart WHERE UserID = ?";
    String insertSql = "INSERT INTO Cart (UserID, ProductID, Quantity) VALUES (?, ?, ?)";

    // 1) Kiểm tra connection
    if (c == null || c.isClosed()) {
        throw new SQLException("Connection c is closed or null!");
    }

    // 2) Bật transaction trên c
    boolean prevAuto = c.getAutoCommit();
    c.setAutoCommit(false);

    try (
        PreparedStatement delStmt = c.prepareStatement(deleteSql);
        PreparedStatement insStmt = c.prepareStatement(insertSql)
    ) {
        // Xóa toàn bộ trước
        delStmt.setInt(1, userId);
        int deleted = delStmt.executeUpdate();

        // Thêm batch tất cả item
        for (CartItem item : cartItems) {
            insStmt.setInt(1, userId);
            insStmt.setInt(2, item.getProduct().getProductID());
            insStmt.setInt(3, item.getQuantity());
            insStmt.addBatch();
        }
        int[] inserted = insStmt.executeBatch();

        // 3) Commit nếu mọi thứ OK
        c.commit();
        return true;

    } catch (SQLException ex) {
        // 4) Rollback nếu có lỗi
        c.rollback();
        throw ex;
    } finally {
        // 5) Khôi phục auto-commit
        c.setAutoCommit(prevAuto);
    }
}

}
