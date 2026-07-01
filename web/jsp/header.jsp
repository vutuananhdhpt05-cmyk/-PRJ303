<%-- 
    Document   : Header
    Created on : Jun 29, 2026, 9:58:02 PM
    Author     : Trung Kien
--%>

<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

    <!-- Header -->
    <header class="header">
        <div class="left">
            <c:choose>
                <c:when test="${not empty sessionScope.user}">
                    <a href="<c:url value='/jsp/cart.jsp'/>" class="cart">
                        <i class="fas fa-shopping-cart"></i> Giỏ Hàng
                        <c:choose>
                            <c:when test="${not empty sessionScope.cartSize and sessionScope.cartSize > 0}">
                                <span class="badge active"><c:out value="${sessionScope.cartSize}" /></span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge inactive">0</span>
                            </c:otherwise>
                        </c:choose>
                    </a>
                </c:when>
                <c:otherwise>
                    <a href="<c:url value='/jsp/login.jsp?returnUrl=/jsp/cart.jsp'/>" class="cart">
                        <i class="fas fa-shopping-cart"></i> Giỏ Hàng
                        <span class="badge inactive">0</span>
                    </a>
                </c:otherwise>
            </c:choose>
        </div>
        <div class="logo">
            <a href="<c:url value='/home'/>">
                <img src="<c:url value='/images/LogoAsus.png'/>" alt="Asus AI 2025">
            </a>
        </div>
        <div class="right">
            <c:choose>
                <c:when test="${not empty sessionScope.user}">
                    <a href="<c:url value='/jsp/profile.jsp'/>">
                        <i class="fas fa-user"></i> <c:out value="${sessionScope.user.fullName != null ? sessionScope.user.fullName : sessionScope.user.fullname}" />
                    </a>
                    <a href="<c:url value='/logout'/>" class="logout-btn">
                        <i class="fas fa-sign-out-alt"></i> Đăng Xuất
                    </a>
                </c:when>
                <c:otherwise>
                    <a href="<c:url value='/jsp/login.jsp'/>" class="login-btn">
                        <i class="fas fa-sign-in-alt"></i> Đăng Nhập
                    </a>
                </c:otherwise>
            </c:choose>
        </div>
    </header>

    <!-- Main Menu -->
    <nav class="menu">
        <ul>
            <li><a href="<c:url value='/home'/>">Trang chủ</a></li>
            <li><a href="<c:url value='/jsp/about.jsp'/>">Giới Thiệu</a></li>
            <li><a href="<c:url value='/products'/>">Sản Phẩm</a></li>
            <li><a href="<c:url value='/jsp/contact.jsp'/>">Liên Hệ</a></li>
        </ul>
    </nav>
