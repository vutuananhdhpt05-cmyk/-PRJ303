package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ReportDAO extends DBContext {

    // 1. Monthly Revenue
    public List<Map<String, Object>> getMonthlyRevenue() {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT FORMAT(OrderDate, 'yyyy-MM') AS Month, SUM(TotalAmount) AS Revenue " +
                     "FROM Orders " +
                     "WHERE Status != 'Cancelled' " +
                     "GROUP BY FORMAT(OrderDate, 'yyyy-MM') " +
                     "ORDER BY Month DESC";
        try (PreparedStatement st = c.prepareStatement(sql)) {
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("month", rs.getString("Month"));
                map.put("revenue", rs.getDouble("Revenue"));
                list.add(map);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // 2. Top Selling Products
    public List<Map<String, Object>> getTopSellingProducts(int limit) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT TOP (?) p.ProductName, SUM(od.Quantity) AS TotalSold " +
                     "FROM OrderDetails od " +
                     "JOIN Products p ON od.ProductID = p.ProductID " +
                     "JOIN Orders o ON od.OrderID = o.OrderID " +
                     "WHERE o.Status != 'Cancelled' " +
                     "GROUP BY p.ProductID, p.ProductName " +
                     "ORDER BY TotalSold DESC";
        try (PreparedStatement st = c.prepareStatement(sql)) {
            st.setInt(1, limit);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("productName", rs.getString("ProductName"));
                map.put("totalSold", rs.getInt("TotalSold"));
                list.add(map);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // 3. Inventory Report (Low stock)
    public List<Map<String, Object>> getInventoryReport() {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT ProductName, Stock, Price FROM Products ORDER BY Stock ASC";
        try (PreparedStatement st = c.prepareStatement(sql)) {
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("productName", rs.getString("ProductName"));
                map.put("stock", rs.getInt("Stock"));
                map.put("price", rs.getDouble("Price"));
                list.add(map);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // 4. VIP Customers
    public List<Map<String, Object>> getVIPCustomers(int limit) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT TOP (?) u.Username, u.FullName, SUM(o.TotalAmount) AS TotalSpent " +
                     "FROM Orders o " +
                     "JOIN Users u ON o.UserID = u.UserID " +
                     "WHERE o.Status != 'Cancelled' " +
                     "GROUP BY u.UserID, u.Username, u.FullName " +
                     "ORDER BY TotalSpent DESC";
        try (PreparedStatement st = c.prepareStatement(sql)) {
            st.setInt(1, limit);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("username", rs.getString("Username"));
                map.put("fullName", rs.getString("FullName"));
                map.put("totalSpent", rs.getDouble("TotalSpent"));
                list.add(map);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // 5. Orders by Status
    public List<Map<String, Object>> getOrdersByStatus() {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT Status, COUNT(*) AS OrderCount FROM Orders GROUP BY Status";
        try (PreparedStatement st = c.prepareStatement(sql)) {
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("status", rs.getString("Status"));
                map.put("count", rs.getInt("OrderCount"));
                list.add(map);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
