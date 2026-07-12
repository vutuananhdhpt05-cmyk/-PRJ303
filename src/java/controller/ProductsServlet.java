package controller;

import dal.ProductDAO;
import model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/products")
public class ProductsServlet extends HttpServlet {
    private ProductDAO dao = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String keyword = req.getParameter("keyword");
        String sortType = req.getParameter("sort");
        String brand = req.getParameter("brand");
        String minPrice = req.getParameter("minPrice");
        String maxPrice = req.getParameter("maxPrice");
        
        int page = 1;
        int pageSize = 8;
        
        String pageStr = req.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
        }
        
        try {
            int totalProducts = dao.getTotalProductsCount(keyword, brand, minPrice, maxPrice);
            int totalPages = (int) Math.ceil((double) totalProducts / pageSize);
            
            // If page requested is greater than totalPages, adjust it
            if (page > totalPages && totalPages > 0) {
                page = totalPages;
            }
            
            List<Product> products = dao.getProducts(keyword, brand, minPrice, maxPrice, sortType, page, pageSize);
            List<String> brands = dao.getAllBrands();
            
            req.setAttribute("products", products);
            req.setAttribute("brands", brands);
            req.setAttribute("keyword", keyword);
            req.setAttribute("sort", sortType);
            req.setAttribute("brand", brand);
            req.setAttribute("minPrice", minPrice);
            req.setAttribute("maxPrice", maxPrice);
            req.setAttribute("currentPage", page);
            req.setAttribute("totalPages", totalPages);
            req.setAttribute("currentCategory", req.getParameter("category"));
            
            req.getRequestDispatcher("/jsp/products.jsp").forward(req, resp);
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}
