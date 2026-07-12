<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.User" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || (!"ADMIN".equalsIgnoreCase(user.getRole()) && !"STAFF".equalsIgnoreCase(user.getRole()))) {
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
        return;
    }
    SimpleDateFormat sdf = new SimpleDateFormat("EEEE, d MMMM, yyyy", new java.util.Locale("vi", "VN"));
    String currentDate = sdf.format(new Date());
    String activeMenu = request.getParameter("activeMenu");
    String pageTitle = request.getParameter("pageTitle");
    if (pageTitle == null) pageTitle = "Dashboard";
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title><%= pageTitle %> - ASUS Store Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/css/admin.css" rel="stylesheet">
</head>
<body>
<!-- Wrapper -->
<div class="d-flex" style="min-height: 100vh;">
  <!-- Sidebar -->
  <div class="sidebar d-flex flex-column py-4">
    <div class="brand">ASUS Store</div>

    <div class="user-profile">
        <div class="user-avatar">
            ${fn:substring(sessionScope.user.fullName, 0, 1).toUpperCase()}
        </div>
        <div class="user-info">
            <div class="user-name">${sessionScope.user.fullName}</div>
            <div class="user-role">${sessionScope.user.role}</div>
        </div>
    </div>

    <ul class="nav flex-column mb-auto">
      <li class="nav-item">
        <a href="<%=request.getContextPath()%>/dashboard" class="nav-link <%="dashboard".equals(activeMenu) ? "active" : ""%>">
          <i class="fas fa-th-large"></i> Dashboard
        </a>
      </li>
      <c:if test="${fn:toUpperCase(sessionScope.user.role) == 'STAFF' || fn:toUpperCase(sessionScope.user.role) == 'MANAGER'}">
        <li class="nav-item">
          <a href="<%=request.getContextPath()%>/staff/products" class="nav-link <%="products".equals(activeMenu) ? "active" : ""%>">
            <i class="fas fa-box"></i> Sản phẩm
          </a>
        </li>
        <li class="nav-item">
          <a href="<%=request.getContextPath()%>/staff/orders" class="nav-link <%="orders".equals(activeMenu) ? "active" : ""%>">
            <i class="fas fa-receipt"></i> Đơn hàng
          </a>
        </li>
        <li class="nav-item">
          <a href="<%=request.getContextPath()%>/staff/messages" class="nav-link <%="messages".equals(activeMenu) ? "active" : ""%>">
            <i class="fas fa-envelope"></i> Tin nhắn
          </a>
        </li>
      </c:if>
      <c:if test="${fn:toUpperCase(sessionScope.user.role) == 'ADMIN'}">
        <li class="nav-item">
          <a href="<%=request.getContextPath()%>/admin/reports" class="nav-link <%="reports".equals(activeMenu) ? "active" : ""%>">
            <i class="fas fa-chart-line"></i> Báo Cáo
          </a>
        </li>
      </c:if>
      <li class="nav-item mt-3">
        <a href="<%=request.getContextPath()%>/profile" class="nav-link">
          <i class="fas fa-cog"></i> Cài đặt
        </a>
      </li>
    </ul>

    <div class="logout-link px-3">
      <a href="<%=request.getContextPath()%>/logout" class="nav-link mb-0">
        <i class="fas fa-sign-out-alt"></i> Đăng xuất
      </a>
    </div>
  </div>

  <!-- Main Content -->
  <div class="main-content">
    <!-- Top Navbar -->
    <div class="top-navbar">
      <div class="top-title"><%= pageTitle %></div>
      <div class="top-date"><%= currentDate %></div>
    </div>
    <!-- Content Body -->
    <div class="content-body">
