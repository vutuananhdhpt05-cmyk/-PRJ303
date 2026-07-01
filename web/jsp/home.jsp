<%-- 
    Document   : home
    Created on : Jun 29, 2026, 10:24:50 PM
    Author     : Trung Kien
--%>

<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cửa Hàng Laptop ASUS</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="<c:url value='/css/style.css'/>" rel="stylesheet">
</head>
<body>
    <jsp:include page="/jsp/header.jsp" />

    <!-- Hero Section -->
    <section class="hero">
    </section>

    <!-- Products Section -->
    <section id="products" class="section">
        <h2>Sản Phẩm Nổi Bật</h2>
        <div class="products grid">
            <c:forEach items="${featuredProducts}" var="p">
                <div class="product-card">
                    <a href="<c:url value='/productDetail?id=${p.productID}'/>" style="text-decoration:none; color:inherit;">
                        <img src="<c:url value='/${p.imageUrl}'/>" alt="${p.productName}">
                        <div class="product-card-content">
                            <h3>${p.productName}</h3>
                    </a>
                        <p>${p.description}</p>
                        <div class="price">$${p.price}</div>
                        <c:choose>
                            <c:when test="${not empty sessionScope.user}">
                                <a href="<c:url value='/CartServlet?action=add&productId=${p.productID}'/>" class="btn-cart">
                                    <i class="fas fa-cart-plus"></i> ASUS Thêm vào giỏ
                                </a>
                            </c:when>
                            <c:otherwise>
                                <a href="<c:url value='/jsp/login.jsp?returnUrl=/CartServlet?action=add&productId=${p.productID}'/>" class="btn-cart">
                                    <i class="fas fa-cart-plus"></i> ASUS Thêm vào giỏ
                                </a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </c:forEach>
        </div>
    </section>

    <!-- New Products Section -->
    <section id="new-products" class="section" style="padding-top: 0;">
        <h2>Sản Phẩm Mới</h2>
        <div class="products grid">
            <c:forEach items="${newProducts}" var="p">
                <div class="product-card">
                    <a href="<c:url value='/productDetail?id=${p.productID}'/>" style="text-decoration:none; color:inherit;">
                        <img src="<c:url value='/${p.imageUrl}'/>" alt="${p.productName}">
                        <div class="product-card-content">
                            <h3>${p.productName}</h3>
                    </a>
                        <p>${p.description}</p>
                        <div class="price">$${p.price}</div>
                        <c:choose>
                            <c:when test="${not empty sessionScope.user}">
                                <a href="<c:url value='/CartServlet?action=add&productId=${p.productID}'/>" class="btn-cart">
                                    <i class="fas fa-cart-plus"></i> ASUS Thêm vào giỏ
                                </a>
                            </c:when>
                            <c:otherwise>
                                <a href="<c:url value='/jsp/login.jsp?returnUrl=/CartServlet?action=add&productId=${p.productID}'/>" class="btn-cart">
                                    <i class="fas fa-cart-plus"></i> ASUS Thêm vào giỏ
                                </a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </c:forEach>
        </div>
    </section>

    <!-- Include footer -->
    <jsp:include page="/jsp/footer.jsp" />
</body>
</html>