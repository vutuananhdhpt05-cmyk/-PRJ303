package controller;

import dal.CartDAO;
import dal.ProductDAO;
import model.CartItem;
import model.Product;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/CartServlet")
public class CartServlet extends HttpServlet {
    private final CartDAO cartDAO = new CartDAO();
    private final ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) {
            showCart(req, resp);
        } else {
            doPost(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) {
            resp.sendRedirect(req.getContextPath() + "/CartServlet");
            return;
        }
        switch (action) {
            case "add":
                addToCart(req, resp);
                break;
            case "update":
                updateCart(req, resp);
                break;
            case "remove":
                removeFromCart(req, resp);
                break;
            case "buyNow":
                buyNow(req, resp);
                break;
            default:
                resp.sendRedirect(req.getContextPath() + "/CartServlet");
        }
    }

    private void addToCart(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String pidStr = req.getParameter("productId");
        String returnUrl = req.getParameter("returnUrl");
        if (pidStr == null || pidStr.isBlank()) {
            resp.sendRedirect(req.getContextPath() + "/products");
            return;
        }

        int pid;
        try {
            pid = Integer.parseInt(pidStr);
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/products");
            return;
        }

        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/jsp/login.jsp?returnUrl=" + (returnUrl != null ? returnUrl : "/products"));
            return;
        }

        String quantityStr = req.getParameter("quantity");
        int quantity = 1;
        if (quantityStr != null && !quantityStr.isBlank()) {
            try {
                quantity = Integer.parseInt(quantityStr);
                if (quantity < 1) quantity = 1;
            } catch (NumberFormatException e) {
                quantity = 1;
            }
        }

        try {
            boolean added = cartDAO.addToCart(user.getUserID(), pid, quantity);
            if (!added) {
                session.setAttribute("errorMessage", "Sản phẩm không đủ tồn kho hoặc không tồn tại.");
                resp.sendRedirect(req.getContextPath() + (returnUrl != null && returnUrl.startsWith("/") ? returnUrl : "/products"));
                return;
            }
        } catch (SQLException e) {
            session.setAttribute("errorMessage", "Lỗi khi thêm sản phẩm vào giỏ.");
            resp.sendRedirect(req.getContextPath() + (returnUrl != null && returnUrl.startsWith("/") ? returnUrl : "/products"));
            return;
        }

        try {
            List<CartItem> cartItems = cartDAO.getCartByUser(user.getUserID());
            session.setAttribute("cartItems", cartItems);
            session.setAttribute("cartSize", calculateTotalQuantity(cartItems));
        } catch (SQLException e) {
            session.setAttribute("errorMessage", "Lỗi khi tải giỏ hàng.");
        }

        if (returnUrl != null && !returnUrl.isBlank() && returnUrl.startsWith("/")) {
            resp.sendRedirect(req.getContextPath() + returnUrl);
        } else {
            String referer = req.getHeader("Referer");
            if (referer != null && referer.contains(req.getContextPath())) {
                resp.sendRedirect(referer);
            } else {
                resp.sendRedirect(req.getContextPath() + "/products");
            }
        }
    }

    private void updateCart(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String pidStr = req.getParameter("productId");
        String deltaStr = req.getParameter("delta");
        if (pidStr == null || deltaStr == null || pidStr.isBlank() || deltaStr.isBlank()) {
            resp.sendRedirect(req.getContextPath() + "/CartServlet");
            return;
        }

        int pid, delta;
        try {
            pid = Integer.parseInt(pidStr);
            delta = Integer.parseInt(deltaStr);
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/CartServlet");
            return;
        }

        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/jsp/login.jsp?returnUrl=/CartServlet");
            return;
        }

        try {
            boolean updated = cartDAO.updateQuantity(user.getUserID(), pid, delta);
            if (!updated) {
                session.setAttribute("errorMessage", "Không thể cập nhật số lượng (tồn kho không đủ hoặc sản phẩm không tồn tại).");
            }
        } catch (SQLException e) {
            session.setAttribute("errorMessage", "Lỗi khi cập nhật giỏ hàng.");
        }

        try {
            List<CartItem> cartItems = cartDAO.getCartByUser(user.getUserID());
            session.setAttribute("cartItems", cartItems);
            session.setAttribute("cartSize", calculateTotalQuantity(cartItems));
        } catch (SQLException e) {
            session.setAttribute("errorMessage", "Lỗi khi tải giỏ hàng.");
        }

        resp.sendRedirect(req.getContextPath() + "/CartServlet");
    }

    private void removeFromCart(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String pidStr = req.getParameter("productId");
        if (pidStr == null || pidStr.isBlank()) {
            resp.sendRedirect(req.getContextPath() + "/CartServlet");
            return;
        }

        int pid;
        try {
            pid = Integer.parseInt(pidStr);
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/CartServlet");
            return;
        }

        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/jsp/login.jsp?returnUrl=/CartServlet");
            return;
        }

        try {
            cartDAO.removeItem(user.getUserID(), pid);
        } catch (SQLException e) {
            session.setAttribute("errorMessage", "Lỗi khi xóa sản phẩm khỏi giỏ.");
        }

        try {
            List<CartItem> cartItems = cartDAO.getCartByUser(user.getUserID());
            session.setAttribute("cartItems", cartItems);
            session.setAttribute("cartSize", calculateTotalQuantity(cartItems));
        } catch (SQLException e) {
            session.setAttribute("errorMessage", "Lỗi khi tải giỏ hàng.");
        }

        resp.sendRedirect(req.getContextPath() + "/CartServlet");
    }

    private void showCart(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/jsp/login.jsp?returnUrl=/CartServlet");
            return;
        }

        // Luôn tải giỏ hàng từ cơ sở dữ liệu
        try {
            List<CartItem> cartItems = cartDAO.getCartByUser(user.getUserID());
            session.setAttribute("cartItems", cartItems);
            session.setAttribute("cartSize", calculateTotalQuantity(cartItems));
        } catch (SQLException e) {
            session.setAttribute("errorMessage", "Lỗi khi tải giỏ hàng: " + e.getMessage());
            // Đảm bảo không để session.cartItems là null
            session.setAttribute("cartItems", new ArrayList<>());
            session.setAttribute("cartSize", 0);
        }

        req.setAttribute("cartItems", session.getAttribute("cartItems"));
        req.setAttribute("cartSize", session.getAttribute("cartSize"));
        req.getRequestDispatcher("/jsp/cart.jsp").forward(req, resp);
    }

    private int calculateTotalQuantity(List<CartItem> cart) {
        if (cart == null || cart.isEmpty()) {
            return 0;
        }
        return cart.stream().mapToInt(CartItem::getQuantity).sum();
    }

    private void buyNow(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String pidStr = req.getParameter("productId");
        if (pidStr == null || pidStr.isBlank()) {
            resp.sendRedirect(req.getContextPath() + "/products");
            return;
        }

        int pid;
        try {
            pid = Integer.parseInt(pidStr);
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/products");
            return;
        }

        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/jsp/login.jsp?returnUrl=/CartServlet?action=buyNow%26productId=" + pid + "%26quantity=1");
            return;
        }

        String quantityStr = req.getParameter("quantity");
        int quantity = 1;
        if (quantityStr != null && !quantityStr.isBlank()) {
            try {
                quantity = Integer.parseInt(quantityStr);
                if (quantity < 1) quantity = 1;
            } catch (NumberFormatException e) {
                quantity = 1;
            }
        }

        try {
            Product product = productDAO.getProductById(pid);
            if (product == null || product.getStock() < quantity) {
                session.setAttribute("errorMessage", "Sản phẩm không đủ tồn kho hoặc không tồn tại.");
                resp.sendRedirect(req.getContextPath() + "/productDetail?id=" + pid);
                return;
            }
            
            CartItem item = new CartItem(product, quantity);
            List<CartItem> buyNowItems = new ArrayList<>();
            buyNowItems.add(item);
            
            session.setAttribute("buyNowItems", buyNowItems);
            resp.sendRedirect(req.getContextPath() + "/jsp/checkout.jsp?buyNow=true");
        } catch (SQLException e) {
            session.setAttribute("errorMessage", "Lỗi xử lý hệ thống.");
            resp.sendRedirect(req.getContextPath() + "/productDetail?id=" + pid);
        }
    }
}