package dal;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Product;

public class ProductDAO extends DBContext {
    private static final String SQL_INSERT =
        "INSERT INTO Products (ProductName, Description, Price, Stock, ImageUrl, Brand, CreatedAt) " +
        "VALUES (?, ?, ?, ?, ?, ?, ?)";
    private static final String SQL_UPDATE =
        "UPDATE Products SET ProductName = ?, Description = ?, Price = ?, Stock = ?, ImageUrl = ?, Brand = ?, CreatedAt = ? " +
        "WHERE ProductID = ?";
    private static final String SQL_DELETE = "DELETE FROM Products WHERE ProductID = ?";
    private static final String SQL_SEARCH_BY_NAME =
        "SELECT * FROM Products WHERE ProductName LIKE ?";

    public List<Product> getAllProducts() throws SQLException {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM Products";
        try (PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapProduct(rs));
            }
        }
        return list;
    }

    public Product getProductById(int id) throws SQLException {
        String sql = "SELECT * FROM Products WHERE ProductID = ?";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapProduct(rs);
                }
            }
        }
        return null;
    }

    public List<Product> searchByName(String keyword) throws SQLException {
        List<Product> list = new ArrayList<>();
        try (PreparedStatement ps = c.prepareStatement(SQL_SEARCH_BY_NAME)) {
            ps.setString(1, "%" + keyword + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapProduct(rs));
                }
            }
        }
        return list;
    }

    public boolean insertProduct(Product p) throws SQLException {
        try (PreparedStatement ps = c.prepareStatement(SQL_INSERT)) {
            ps.setString(1, p.getProductName());
            ps.setString(2, p.getDescription());
            ps.setDouble(3, p.getPrice());
            ps.setInt(4, p.getStock());
            ps.setString(5, p.getImageUrl());
            ps.setString(6, p.getBrand());
            ps.setTimestamp(7, new Timestamp(p.getCreatedAt().getTime()));
            return ps.executeUpdate() > 0;
        }
    }

    public boolean updateProduct(Product p) throws SQLException {
        try (PreparedStatement ps = c.prepareStatement(SQL_UPDATE)) {
            ps.setString(1, p.getProductName());
            ps.setString(2, p.getDescription());
            ps.setDouble(3, p.getPrice());
            ps.setInt(4, p.getStock());
            ps.setString(5, p.getImageUrl());
            ps.setString(6, p.getBrand());
            ps.setTimestamp(7, new Timestamp(p.getCreatedAt().getTime()));
            ps.setInt(8, p.getProductID());
            return ps.executeUpdate() > 0;
        }
    }

    public boolean deleteProduct(int id) throws SQLException {
        try (PreparedStatement ps = c.prepareStatement(SQL_DELETE)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    private Product mapProduct(ResultSet rs) throws SQLException {
        return new Product(
            rs.getInt("ProductID"),
            rs.getString("ProductName"),
            rs.getString("Description"),
            rs.getDouble("Price"),
            rs.getInt("Stock"),
            rs.getString("ImageUrl"),
            rs.getString("Brand"),
            rs.getTimestamp("CreatedAt")
        );
    }
    
    public List<Product> getFeaturedProducts(int limit) throws SQLException {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT TOP " + limit + " p.* " +
                     "FROM Products p " +
                     "LEFT JOIN ( " +
                     "    SELECT ProductID, SUM(Quantity) as TotalSold " +
                     "    FROM OrderDetails " +
                     "    GROUP BY ProductID " +
                     ") as Sales ON p.ProductID = Sales.ProductID " +
                     "ORDER BY ISNULL(Sales.TotalSold, 0) DESC, p.CreatedAt DESC";
        try (PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapProduct(rs));
            }
        }
        return list;
    }

    public int getTotalProductsCount(String keyword) throws SQLException {
        return getTotalProductsCount(keyword, null, null, null);
    }

    public int getTotalProductsCount(String keyword, String brand, String minPrice, String maxPrice) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Products WHERE 1=1");
        List<Object> params = new ArrayList<>();
        
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND ProductName LIKE ?");
            params.add("%" + keyword.trim() + "%");
        }
        if (brand != null && !brand.trim().isEmpty() && !brand.equals("All")) {
            sql.append(" AND Brand = ?");
            params.add(brand);
        }
        if (minPrice != null && !minPrice.trim().isEmpty()) {
            try { sql.append(" AND Price >= ?"); params.add(Double.parseDouble(minPrice)); } catch (Exception ignored) {}
        }
        if (maxPrice != null && !maxPrice.trim().isEmpty()) {
            try { sql.append(" AND Price <= ?"); params.add(Double.parseDouble(maxPrice)); } catch (Exception ignored) {}
        }
        
        try (PreparedStatement ps = c.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return 0;
    }

    public List<String> getAllBrands() throws SQLException {
        List<String> brands = new ArrayList<>();
        String sql = "SELECT DISTINCT Brand FROM Products WHERE Brand IS NOT NULL AND Brand != ''";
        try (PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                brands.add(rs.getString("Brand"));
            }
        }
        return brands;
    }

    public List<Product> getProducts(String keyword, String sortType, int page, int pageSize) throws SQLException {
        return getProducts(keyword, null, null, null, sortType, page, pageSize);
    }

    public List<Product> getProducts(String keyword, String brand, String minPrice, String maxPrice, String sortType, int page, int pageSize) throws SQLException {
        List<Product> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM Products WHERE 1=1");
        List<Object> params = new ArrayList<>();
        
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND ProductName LIKE ?");
            params.add("%" + keyword.trim() + "%");
        }
        if (brand != null && !brand.trim().isEmpty() && !brand.equals("All")) {
            sql.append(" AND Brand = ?");
            params.add(brand);
        }
        if (minPrice != null && !minPrice.trim().isEmpty()) {
            try { sql.append(" AND Price >= ?"); params.add(Double.parseDouble(minPrice)); } catch (Exception ignored) {}
        }
        if (maxPrice != null && !maxPrice.trim().isEmpty()) {
            try { sql.append(" AND Price <= ?"); params.add(Double.parseDouble(maxPrice)); } catch (Exception ignored) {}
        }
        
        // Sorting
        if ("price_asc".equals(sortType)) {
            sql.append(" ORDER BY Price ASC");
        } else if ("price_desc".equals(sortType)) {
            sql.append(" ORDER BY Price DESC");
        } else if ("name_asc".equals(sortType)) {
            sql.append(" ORDER BY ProductName ASC");
        } else if ("name_desc".equals(sortType)) {
            sql.append(" ORDER BY ProductName DESC");
        } else {
            sql.append(" ORDER BY ProductID DESC"); // Default sorting
        }
        
        // Pagination (SQL Server 2012+)
        sql.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        
        try (PreparedStatement ps = c.prepareStatement(sql.toString())) {
            int i = 0;
            for (; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            
            // OFFSET requires 0-based index of row to start from
            int offset = (page - 1) * pageSize;
            ps.setInt(i + 1, offset);
            ps.setInt(i + 2, pageSize);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapProduct(rs));
                }
            }
        }
        return list;
    }

    public List<Product> getNewProducts(int limit) throws SQLException {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT TOP " + limit + " * FROM Products ORDER BY CreatedAt DESC";
        try (PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapProduct(rs));
            }
        }
        return list;
    }

    public List<Product> getSimilarProducts(int currentProductId, String brand, int limit) throws SQLException {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT TOP " + limit + " * FROM Products WHERE Brand = ? AND ProductID != ? ORDER BY NEWID()";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, brand);
            ps.setInt(2, currentProductId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapProduct(rs));
                }
            }
        }
        return list;
    }
}
