<%@ page contentType="text/html; charset=UTF-8" %>
<%
    // Redirect the root context to the Admin Dashboard
    response.sendRedirect(request.getContextPath() + "/dashboard");
%>

