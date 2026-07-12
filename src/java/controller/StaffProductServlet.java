package controller;

import dal.ProductDAO;
import model.Product;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.sql.SQLException;
import java.util.Date;
import java.util.List;

@WebServlet("/staff/products")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class StaffProductServlet extends HttpServlet {
    private static final String UPLOAD_DIR = "images";
    private final ProductDAO dao = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        try {
            if (action == null || action.equals("list")) {
                String kw = req.getParameter("kw");
                List<Product> all = (kw != null && !kw.isBlank())
                    ? dao.searchByName(kw)
                    : dao.getAllProducts();

                // Pagination
                int pageSize = 15;
                int totalItems = all.size();
                int totalPages = (int) Math.ceil((double) totalItems / pageSize);
                int currentPage = 1;
                try {
                    String pageStr = req.getParameter("page");
                    if (pageStr != null) currentPage = Integer.parseInt(pageStr);
                } catch (NumberFormatException ignored) {}
                if (currentPage < 1) currentPage = 1;
                if (currentPage > totalPages && totalPages > 0) currentPage = totalPages;

                int fromIndex = (currentPage - 1) * pageSize;
                int toIndex = Math.min(fromIndex + pageSize, totalItems);
                List<Product> paged = (totalItems > 0) ? all.subList(fromIndex, toIndex) : all;

                req.setAttribute("products", paged);
                req.setAttribute("currentPage", currentPage);
                req.setAttribute("totalPages", totalPages);
                req.setAttribute("totalItems", totalItems);
                // Build base URL for page links (preserve kw)
                String pageBase = req.getContextPath() + "/staff/products?action=list"
                    + (kw != null && !kw.isBlank() ? "&kw=" + java.net.URLEncoder.encode(kw, "UTF-8") : "");
                req.setAttribute("pageBase", pageBase);
                req.getRequestDispatcher("/jsp/staff_products.jsp").forward(req, resp);

            } else if (action.equals("new")) {
                Product p = new Product();
                p.setCreatedAt(new Date());
                req.setAttribute("product", p);
                req.getRequestDispatcher("/jsp/staff_productForm.jsp").forward(req, resp);

            } else if (action.equals("edit")) {
                int id = Integer.parseInt(req.getParameter("id"));
                Product p = dao.getProductById(id);
                req.setAttribute("product", p);
                req.getRequestDispatcher("/jsp/staff_productForm.jsp").forward(req, resp);

            } else if (action.equals("delete")) {
                User user = (User) req.getSession().getAttribute("user");
                if (user == null || !"STAFF".equalsIgnoreCase(user.getRole())) {
                    req.getSession().setAttribute("errorMsg", "Bạn không có quyền xóa sản phẩm!");
                    resp.sendRedirect(req.getContextPath() + "/staff/products");
                    return;
                }
                int id = Integer.parseInt(req.getParameter("id"));
                try {
                    dao.deleteProduct(id);
                } catch (SQLException e) {
                    req.getSession().setAttribute("errorMsg", "Không thể xóa sản phẩm vì đã tồn tại trong đơn hàng!");
                }
                resp.sendRedirect(req.getContextPath() + "/staff/products");
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

@Override
protected void doPost(HttpServletRequest req, HttpServletResponse resp)
        throws ServletException, IOException {
    req.setCharacterEncoding("UTF-8");
    try {
        String idStr = req.getParameter("productID");
        Product p = new Product();
        boolean isEdit = false;
        int id = 0;

        // Parse và chỉ set isEdit khi id > 0
        if (idStr != null && !idStr.isBlank()) {
            id = Integer.parseInt(idStr);
            if (id > 0) {
                isEdit = true;
                p.setProductID(id);
                // Lấy old; chắc chắn old != null
                Product old = dao.getProductById(id);
                p.setCreatedAt(old.getCreatedAt());
            }
        }
        if (!isEdit) {
            p.setCreatedAt(new Date());
        }

            // 2. Đọc các trường text và Validate
            String productName = req.getParameter("productName");
            String description = req.getParameter("description");
            String priceStr = req.getParameter("price");
            String stockStr = req.getParameter("stock");
            String brand = req.getParameter("brand");

            if (productName == null || productName.trim().isEmpty() || priceStr == null || priceStr.trim().isEmpty() || stockStr == null || stockStr.trim().isEmpty() || brand == null || brand.trim().isEmpty()) {
                req.setAttribute("error", "Tên sản phẩm, Giá, Số lượng tồn kho và Hãng không được để trống!");
                req.setAttribute("product", p);
                req.getRequestDispatcher("/jsp/staff_productForm.jsp").forward(req, resp);
                return;
            }

            try {
                p.setProductName(productName.trim());
                p.setDescription(description != null ? description.trim() : "");
                p.setPrice(Double.parseDouble(priceStr.trim()));
                p.setStock(Integer.parseInt(stockStr.trim()));
                p.setBrand(brand != null ? brand.trim() : "");
                
                if (p.getPrice() <= 0 || p.getStock() <= 0) {
                    throw new NumberFormatException("Giá trị âm hoặc bằng 0");
                }
            } catch (NumberFormatException e) {
                req.setAttribute("error", "Giá và Số lượng tồn kho phải là số hợp lệ và lớn hơn 0!");
                req.setAttribute("product", p);
                req.getRequestDispatcher("/jsp/staff_productForm.jsp").forward(req, resp);
                return;
            }

            // 3. Xử lý phần upload ảnh
            Part filePart = req.getPart("imageFile");
            
            if (!isEdit && (filePart == null || filePart.getSize() == 0)) {
                req.setAttribute("error", "Vui lòng chọn ảnh sản phẩm khi thêm mới!");
                req.setAttribute("product", p);
                req.getRequestDispatcher("/jsp/staff_productForm.jsp").forward(req, resp);
                return;
            }

            if (filePart != null && filePart.getSize() > 0) {
                String fileName = Paths.get(filePart.getSubmittedFileName())
                                       .getFileName().toString();
                
                String brandFolder = p.getBrand().toLowerCase().replaceAll("\\s+", "");
                if (brandFolder.isEmpty()) brandFolder = "other";
                
                // Tạo folder nếu chưa có
                String appPath  = req.getServletContext().getRealPath("");
                String savePath = appPath + File.separator + UPLOAD_DIR + File.separator + brandFolder;
                File uploadDir = new File(savePath);
                if (!uploadDir.exists()) uploadDir.mkdirs();

                // Lưu file
                filePart.write(savePath + File.separator + fileName);
                // Ghi đường dẫn relative vào DB
                p.setImageUrl(UPLOAD_DIR + "/" + brandFolder + "/" + fileName);
            } else if (isEdit) {
                // Nếu edit và không chọn file mới, giữ lại đường dẫn cũ
                String oldUrl = dao.getProductById(p.getProductID()).getImageUrl();
                p.setImageUrl(oldUrl);
            }

            // 4. Gọi DAO lưu/upsert
            if (isEdit) {
                dao.updateProduct(p);
            } else {
                dao.insertProduct(p);
            }

            // 5. Redirect về list
            resp.sendRedirect(req.getContextPath() + "/staff/products");
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}

