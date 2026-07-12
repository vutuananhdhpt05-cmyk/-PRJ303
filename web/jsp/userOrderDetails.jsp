<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Chi tiết Đơn hàng - ASUS Store</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="<c:url value='/css/style.css'/>" rel="stylesheet">
    <link href="<c:url value='/css/ordersHistory.css'/>" rel="stylesheet">
</head>
<body>
    <jsp:include page="/jsp/header.jsp" />
    <div class="details-wrapper">
        <div class="history-header">
            <div class="history-title">
                <i class="fa-solid fa-receipt"></i> Chi tiết đơn hàng #${order.orderID}
            </div>
            <div class="flex-align-center-gap-10">
                <c:if test="${order.status == 'Pending'}">
                    <form action="<c:url value='/ordersHistory'/>" method="post" class="m-0" onsubmit="return confirm('Bạn có chắc chắn muốn hủy đơn hàng này không? Hành động này không thể hoàn tác.');">
                        <input type="hidden" name="action" value="cancel" />
                        <input type="hidden" name="id" value="${order.orderID}" />
                        <button type="submit" class="btn-back btn-danger">
                            <i class="fa-solid fa-ban"></i> Hủy đơn hàng
                        </button>
                    </form>
                </c:if>
                <a href="<c:url value='/ordersHistory'/>" class="btn-back">
                    <i class="fa-solid fa-arrow-left"></i> Quay lại lịch sử
                </a>
            </div>
        </div>
        <div class="order-card">
            <!-- Summary Info -->
            <div class="info-grid">
                <div class="info-box">
                    <h4><i class="fa-solid fa-circle-info"></i> Thông tin chung</h4>
                    <ul class="info-list">
                        <li><strong>Ngày đặt:</strong> <fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm"/></li>
                        <li><strong>Trạng thái:</strong> <span class="status-badge">${order.status}</span></li>
                        <li><strong>Tổng tiền:</strong> <span class="price-cell text-1-1rem">$<fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/></span></li>
                    </ul>
                </div>
                <c:if test="${info != null}">
                <div class="info-box">
                    <h4><i class="fa-solid fa-truck"></i> Thông tin giao hàng</h4>
                    <ul class="info-list">
                        <li><strong>Người nhận:</strong> ${info.shippingName}</li>
                        <li><strong>Số ĐT:</strong> ${info.phone}</li>
                        <li><strong>Địa chỉ:</strong> ${info.shippingAddress}</li>
                        <li><strong>Thanh toán:</strong> <span class="text-uppercase-primary">${info.paymentMethod}</span></li>
                    </ul>
                </div>
                </c:if>
            </div>
            <!-- Items Table -->
            <div class="table-container">
                <table class="order-items-table">
                    <thead>
                        <tr>
                            <th>Sản phẩm</th>
                            <th>Số lượng</th>
                            <th>Đơn giá</th>
                            <th>Thành tiền</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="d" items="${details}">
                            <tr>
                                <td class="product-name-cell">${d.productName}</td>
                                <td><span class="qty-badge">x${d.quantity}</span></td>
                                <td class="price-cell">$<fmt:formatNumber value="${d.unitPrice}" pattern="#,##0.00"/></td>
                                <td class="price-cell">$<fmt:formatNumber value="${d.totalPrice}" pattern="#,##0.00"/></td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <jsp:include page="/jsp/footer.jsp" />
</body>
</html>
