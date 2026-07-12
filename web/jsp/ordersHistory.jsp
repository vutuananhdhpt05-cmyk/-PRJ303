<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List, model.OrderHistoryEntry" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Lịch sử đơn hàng - ASUS Store</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="<c:url value='/css/style.css'/>" rel="stylesheet">

</head>
<body>
    <jsp:include page="/jsp/header.jsp" />
    <div class="history-wrapper">
        <div class="history-header">
            <div class="history-title">
                <i class="fa-solid fa-clock-rotate-left"></i> Lịch sử đơn hàng
            </div>
            <a href="<c:url value='/profile'/>" class="btn-back">
                <i class="fa-solid fa-arrow-left"></i> Quay lại hồ sơ
            </a>
        </div>
        
        <!-- Alert messages -->
        <c:if test="${not empty sessionScope.successMessage}">
            <div class="alert-success order-alert">
                <i class="fa-solid fa-circle-check"></i> ${sessionScope.successMessage}
            </div>
            <c:remove var="successMessage" scope="session"/>
        </c:if>
        <c:if test="${not empty sessionScope.errorMessage}">
            <div class="alert-error order-alert">
                <i class="fa-solid fa-circle-exclamation"></i> ${sessionScope.errorMessage}
            </div>
            <c:remove var="errorMessage" scope="session"/>
        </c:if>

        <c:if test="${empty orders}">
            <div class="empty-state">
                <i class="fa-solid fa-box-open"></i>
                <p>Bạn chưa có đơn hàng nào.</p>
                <a href="<c:url value='/products'/>" class="btn">
                    <i class="fa-solid fa-shopping-bag"></i> Mua sắm ngay
                </a>
            </div>
        </c:if>
        <c:forEach var="o" items="${orders}">
            <!-- Mở card mới -->
            <div class="order-card">
                <div class="order-header">
                    <div class="order-id">
                        <i class="fa-solid fa-receipt"></i>
                        Đơn hàng #${o.orderID}
                    </div>
                    <div class="order-date">
                        <i class="fa-regular fa-calendar"></i>
                        <fmt:formatDate value="${o.orderDate}" pattern="dd/MM/yyyy HH:mm"/>
                    </div>
                </div>
                <div class="order-meta">
                    <div class="order-meta-item">
                        <i class="fa-solid fa-user"></i>
                        <span>${o.shippingName}</span>
                    </div>
                    <div class="order-meta-item">
                        <i class="fa-solid fa-phone"></i>
                        <span>${o.phone}</span>
                    </div>
                    <div class="order-total-badge">
                        $<fmt:formatNumber value="${o.totalAmount}" pattern="#,##0.00"/>
                    </div>
                </div>
                <div class="order-actions-bar">
                    <a href="<c:url value='/ordersHistory?action=view&id=${o.orderID}'/>" class="btn btn-order-view">
                        <i class="fa-solid fa-eye"></i> Xem chi tiết
                    </a>
                </div>
            </div>
        </c:forEach>
    </div>

    <!-- Pagination Controls -->
    <c:if test="${totalPages > 1}">
        <div class="pagination-container">
            <ul class="pagination-list">
                <c:if test="${currentPage > 1}">
                    <li>
                        <a href="<c:url value='/ordersHistory?page=${currentPage - 1}'/>" class="pagination-link"><i class="fa-solid fa-chevron-left"></i> Trang trước</a>
                    </li>
                </c:if>
                <c:forEach begin="1" end="${totalPages}" var="i">
                    <li>
                        <a href="<c:url value='/ordersHistory?page=${i}'/>" class="pagination-link ${i == currentPage ? 'active' : ''}">${i}</a>
                    </li>
                </c:forEach>
                <c:if test="${currentPage < totalPages}">
                    <li>
                        <a href="<c:url value='/ordersHistory?page=${currentPage + 1}'/>" class="pagination-link">Sau <i class="fa-solid fa-chevron-right"></i></a>
                    </li>
                </c:if>
            </ul>
        </div>
    </c:if>

    <jsp:include page="/jsp/footer.jsp" />
</body>
</html>
