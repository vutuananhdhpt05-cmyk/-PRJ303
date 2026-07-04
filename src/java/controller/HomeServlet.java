package controller;

import dal.ProductDAO;
import model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet(name = "HomeServlet", urlPatterns = {"/home", "/index"})
public class HomeServlet extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            // Get top 4 featured products
            List<Product> featuredProducts = productDAO.getFeaturedProducts(4);
            req.setAttribute("featuredProducts", featuredProducts);
            
            // Get top 4 new products
            List<Product> newProducts = productDAO.getNewProducts(4);
            req.setAttribute("newProducts", newProducts);
            
            // Forward to the actual home.jsp view
            req.getRequestDispatcher("/jsp/home.jsp").forward(req, resp);
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}
