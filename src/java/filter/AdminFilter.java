package filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.User;

public class AdminFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization if needed
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);
        
        boolean isAuthorized = false;
        
        if (session != null) {
            User user = (User) session.getAttribute("user");
            if (user != null && "ADMIN".equalsIgnoreCase(user.getRole())) {
                isAuthorized = true;
            }
        }
        
        if (isAuthorized) {
            chain.doFilter(request, response);
        } else {
            // Not authorized, redirect to login page or access denied
            String returnUrl = req.getRequestURI() + (req.getQueryString() != null ? "?" + req.getQueryString() : "");
            res.sendRedirect(req.getContextPath() + "/jsp/login.jsp?returnUrl=" + java.net.URLEncoder.encode(returnUrl, "UTF-8"));
        }
    }

    @Override
    public void destroy() {
        // Cleanup if needed
    }
}
