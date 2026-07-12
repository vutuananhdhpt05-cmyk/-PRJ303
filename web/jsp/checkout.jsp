<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Thanh Toán - ASUS Store</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="<c:url value='/css/style.css'/>" rel="stylesheet">
</head>
<body>
    <jsp:include page="/jsp/header.jsp" />
    <!-- Page Title -->
    <div class="checkout-page-title">
        <i class="fa-solid fa-credit-card"></i> Thanh Toán
    </div>
    <!-- Alert messages -->
    <div class="checkout-container">
        <!-- Bỏ phần alert success ở đây vì sẽ hiển thị ở trang thành công riêng -->
        <c:if test="${not empty sessionScope.errorMessage}">
            <div class="alert-error">
                <i class="fa-solid fa-circle-exclamation"></i>
                ${sessionScope.errorMessage}
            </div>
        </c:if>
    </div>
    
    <c:set var="isBuyNow" value="${param.buyNow == 'true'}" />
    <c:set var="checkoutList" value="${isBuyNow ? sessionScope.buyNowItems : sessionScope.cartItems}" />
    
    <c:choose>
        <c:when test="${not empty sessionScope.successMessage}">
            <div class="checkout-wrapper">
                <div class="empty-cart success-container">
                    <i class="fa-solid fa-circle-check big success-icon"></i>
                    <h2 class="success-title">Đặt Hàng Thành Công!</h2>
                    <p class="success-message">${sessionScope.successMessage}</p>
                    <div class="success-actions">
                        <a href="<c:url value='/home'/>" class="btn btn-home"><i class="fa-solid fa-house"></i> Về Trang Chủ</a>
                        <a href="<c:url value='/products'/>" class="btn"><i class="fa-solid fa-cart-shopping"></i> Tiếp Tục Mua Sắm</a>
                    </div>
                </div>
            </div>
            <c:remove var="successMessage" scope="session"/>
        </c:when>
        <c:when test="${empty checkoutList or checkoutList.size() == 0}">
            <div class="checkout-wrapper">
                <div class="empty-cart">
                    <i class="fa-solid fa-cart-xmark big"></i>
                    <p>Giỏ hàng của bạn đang trống. Vui lòng thêm sản phẩm trước khi thanh toán.</p>
                    <a href="<c:url value='/products'/>" class="btn">
                        <i class="fas fa-shopping-bag"></i> Mua Sắm Ngay
                    </a>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <div class="checkout-wrapper">
                <!-- LEFT: Thông tin giao hàng -->
                <div class="checkout-form-panel">
                    <h2><i class="fa-solid fa-location-dot"></i> Thông tin giao hàng</h2>
                    <form action="<c:url value='/CheckoutServlet'/>" method="post">
                        <c:if test="${isBuyNow}">
                            <input type="hidden" name="buyNow" value="true" />
                        </c:if>
                        <div class="form-row">
                            <div class="form-group">
                                <label for="fullName"><i class="fa-regular fa-user"></i> Họ và Tên</label>
                                <input type="text" id="fullName" name="fullName"
                                       value="${sessionScope.user.fullName}" required
                                       placeholder="Nguyễn Văn A">
                            </div>
                            <div class="form-group">
                                <label for="phone"><i class="fa-solid fa-phone"></i> Số điện thoại</label>
                                <input type="tel" id="phone" name="phone" required
                                       placeholder="+84 xxx xxx xxx"
                                       value="${sessionScope.user.phone}">
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="address"><i class="fa-solid fa-house"></i> Địa chỉ giao hàng</label>
                            <input type="text" id="address" name="address" required
                                   placeholder="Số nhà, tên đường, phường/xã, quận/huyện, tỉnh/thành phố"
                                   value="${sessionScope.user.address}">
                        </div>
                        <h2 class="mt-10"><i class="fa-solid fa-wallet"></i> Phương thức thanh toán</h2>
                        <div class="payment-options">
                            <label class="payment-option">
                                <input type="radio" name="paymentMethod" value="cod" checked>
                                <span class="pay-label">
                                    <i class="fa-solid fa-money-bill-wave"></i>
                                    Thanh toán khi nhận hàng (COD)
                                </span>
                            </label>
                            <label class="payment-option">
                                <input type="radio" name="paymentMethod" value="bank">
                                <span class="pay-label">
                                    <i class="fa-solid fa-building-columns"></i>
                                    Chuyển khoản ngân hàng
                                </span>
                            </label>
                            <label class="payment-option">
                                <input type="radio" name="paymentMethod" value="momo">
                                <span class="pay-label">
                                    <i class="fa-solid fa-mobile-screen"></i>
                                    Ví điện tử (MoMo / ZaloPay)
                                </span>
                            </label>
                        </div>
                        <button type="submit" class="btn-checkout">
                            <i class="fa-solid fa-lock"></i> Xác nhận đặt hàng
                        </button>
                    </form>
                </div>
                <!-- RIGHT: Tóm tắt đơn hàng -->
                <div class="order-summary-panel">
                    <h2><i class="fa-solid fa-bag-shopping"></i> Đơn hàng của bạn</h2>
                    <c:set var="total" value="0"/>
                    <c:forEach var="item" items="${checkoutList}">
                        <div class="order-item">
                            <img src="<c:url value='/${item.product.imageUrl}'/>" alt="${item.product.productName}" />
                            <div class="order-item-info">
                                <div class="order-item-name">${item.product.productName}</div>
                                <div class="order-item-qty">x${item.quantity}</div>
                            </div>
                            <div class="order-item-price">
                                $<fmt:formatNumber value="${item.product.price * item.quantity}" pattern="#,##0.00"/>
                            </div>
                        </div>
                        <c:set var="total" value="${total + (item.product.price * item.quantity)}"/>
                    </c:forEach>
                    <div class="summary-row">
                        <span>Tạm tính</span>
                        <span>$<fmt:formatNumber value="${total}" pattern="#,##0.00"/></span>
                    </div>
                    <div class="summary-row">
                        <span>Phí vận chuyển</span>
                        <span class="text-free">Miễn phí</span>
                    </div>
                    <div class="summary-row total-row">
                        <span>Tổng cộng</span>
                        <span>$<fmt:formatNumber value="${total}" pattern="#,##0.00"/></span>
                    </div>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
    <jsp:include page="/jsp/footer.jsp" />
</body>
</html>