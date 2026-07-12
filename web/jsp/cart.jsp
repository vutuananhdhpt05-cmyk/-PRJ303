<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c"    uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt"  uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Giỏ Hàng - ASUS</title>
  <link href="<c:url value='/css/style.css'/>" rel="stylesheet">
  <!-- Icons & Fonts -->
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
  <jsp:include page="/jsp/header.jsp" />

  <!-- Cart Content -->
  <section class="section">
    <h1>Giỏ Hàng Của Bạn</h1>

    <c:if test="${not empty sessionScope.errorMessage}">
      <div class="error">${sessionScope.errorMessage}</div>
    </c:if>

    <c:choose>
      <c:when test="${empty sessionScope.cartItems}">
        <div class="empty-cart">
          <p>Giỏ hàng của bạn đang trống.</p>
          <a href="<c:url value='/products'/>" class="btn">
            <i class="fas fa-shopping-bag"></i> Mua Sắm Ngay
          </a>
        </div>
      </c:when>
      <c:otherwise>
        <div class="container">
          <table class="cart-table">
            <thead>
              <tr>
                <th>Ảnh</th>
                <th>Sản Phẩm</th>
                <th>Giá</th>
                <th>Số Lượng</th>
                <th>Thành Tiền</th>
                <th>Xóa</th>
              </tr>
            </thead>
            <tbody>
              <c:set var="total" value="0"/>
              <c:forEach var="item" items="${sessionScope.cartItems}">
                <tr>
                  <td data-label="Ảnh">
                    <img src="<c:url value='/${item.product.imageUrl}'/>" alt="${item.product.productName}" />
                  </td>
                  <td data-label="Sản Phẩm">${item.product.productName}</td>
                  <td data-label="Giá">
                    <fmt:formatNumber value="${item.product.price}" type="currency" currencySymbol="$"/>
                  </td>
                  <td data-label="Số Lượng">
                    <div class="qty-control">
                      <form action="<c:url value='/CartServlet'/>" method="post">
                        <input type="hidden" name="action" value="update"/>
                        <input type="hidden" name="productId" value="${item.product.productID}"/>
                        <button type="submit" name="delta" value="-1">−</button>
                        <span>${item.quantity}</span>
                        <button type="submit" name="delta" value="1">+</button>
                      </form>
                    </div>
                  </td>
                  <td data-label="Thành Tiền">
                    <fmt:formatNumber value="${item.product.price * item.quantity}" type="currency" currencySymbol="$"/>
                  </td>
                  <td data-label="Xóa">
                    <form action="<c:url value='/CartServlet'/>" method="post">
                      <input type="hidden" name="action" value="remove"/>
                      <input type="hidden" name="productId" value="${item.product.productID}"/>
                      <button type="submit" class="remove-btn">×</button>
                    </form>
                  </td>
                </tr>
                <c:set var="total" value="${total + (item.product.price * item.quantity)}"/>
              </c:forEach>
            </tbody>
          </table>

          <div class="cart-total">
            <p><strong>Tổng cộng:</strong>
              <fmt:formatNumber value="${total}" type="currency" currencySymbol="$"/>
            </p>
            <a href="<c:url value='/products'/>" class="btn">
              <i class="fas fa-shopping-bag"></i> Tiếp Tục Mua Sắm
            </a>
            <a href="<c:url value='/jsp/checkout.jsp'/>" class="btn">
              <i class="fas fa-check"></i> Thanh Toán
            </a>
          </div>
        </div>
      </c:otherwise>
    </c:choose>
  </section>

  <jsp:include page="/jsp/footer.jsp" />

  <!-- External JS -->
  <script src="<c:url value='/assets/js/site.js'/>"></script>
</body>
</html>