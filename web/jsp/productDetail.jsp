<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>${product.productName} - Cửa Hàng Laptop ASUS</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="<c:url value='/css/style.css'/>" rel="stylesheet">
</head>
<body>
    <jsp:include page="/jsp/header.jsp" />
    <div class="product-detail-container">
        <div class="product-detail-image">
            <img id="mainImg" src="<c:url value='/${product.imageUrl}'/>" alt="${product.productName}" onclick="openModal()" title="Nhấn để phóng to">
        </div>
        <div class="product-detail-info">
            <h1>${product.productName}</h1>
            <div class="brand"><i class="fas fa-tag"></i> Thương hiệu: ${product.brand}</div>
            <div class="price">
                <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="$"/>
            </div>
            <div class="description">
                <strong>Thông số & Đặc điểm:</strong><br/>
                ${product.description}
            </div>
            <div class="stock ${product.stock > 0 ? '' : 'out-of-stock'}">
                <i class="fas fa-cubes"></i> Tình trạng: 
                ${product.stock > 0 ? 'Còn hàng (' += product.stock += ' sản phẩm)' : 'Hết hàng'}
            </div>
            <div class="product-actions">
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <form action="<c:url value='/CartServlet'/>" method="post" class="flex-gap-10">
                            <div class="qty-control">
                                <label for="quantity" class="qty-label">SL:</label>
                                <input type="number" name="quantity" id="quantity" value="1" min="1" max="${product.stock}" class="qty-input" ${product.stock == 0 ? 'disabled' : ''}>
                            </div>
                            <input type="hidden" name="productId" value="${product.productID}"/>
                            <input type="hidden" name="returnUrl" value="/productDetail?id=${product.productID}"/>
                            <button type="submit" name="action" value="add" class="btn btn-large ${product.stock == 0 ? 'btn-disabled' : ''}" ${product.stock == 0 ? 'onclick="alert(\'Sản phẩm hiện đã hết hàng!\'); return false;"' : ''}>
                                <i class="fas fa-cart-plus"></i> Thêm Vào Giỏ
                            </button>
                            <button type="submit" name="action" value="buyNow" class="btn btn-large btn-buy-now ${product.stock == 0 ? 'btn-disabled' : ''}" ${product.stock == 0 ? 'onclick="alert(\'Sản phẩm hiện đã hết hàng!\'); return false;"' : ''}>
                                <i class="fas fa-bolt"></i> Mua ngay
                            </button>
                        </form>
                    </c:when>
                    <c:otherwise>
                        <div class="flex-gap-10">
                            <div class="qty-control">
                                <label for="qtyGuest" class="qty-label">SL:</label>
                                <input type="number" id="qtyGuest" value="1" min="1" max="${product.stock}" class="qty-input" ${product.stock == 0 ? 'disabled' : ''} onchange="updateGuestLinks()">
                            </div>
                            <a id="btnCartGuest" href="<c:url value='/jsp/login.jsp?returnUrl=/CartServlet?action=add&productId=${product.productID}&quantity=1'/>" class="btn btn-large ${product.stock == 0 ? 'btn-disabled' : ''}" ${product.stock == 0 ? 'onclick="alert(\'Sản phẩm hiện đã hết hàng!\'); return false;"' : ''}>
                                <i class="fas fa-cart-plus"></i> Thêm Vào Giỏ
                            </a>
                            <a id="btnBuyGuest" href="<c:url value='/jsp/login.jsp?returnUrl=/CartServlet?action=buyNow%26productId=${product.productID}%26quantity=1'/>" class="btn btn-large btn-buy-now ${product.stock == 0 ? 'btn-disabled' : ''}" ${product.stock == 0 ? 'onclick="alert(\'Sản phẩm hiện đã hết hàng!\'); return false;"' : ''}>
                                <i class="fas fa-bolt"></i> Mua ngay
                            </a>
                        </div>
                        <script>
                            function updateGuestLinks() {
                                let qty = document.getElementById('qtyGuest').value;
                                let cartUrl = "<c:url value='/jsp/login.jsp?returnUrl=/CartServlet?action=add%26productId=${product.productID}%26quantity='/>" + qty;
                                let buyUrl = "<c:url value='/jsp/login.jsp?returnUrl=/CartServlet?action=buyNow%26productId=${product.productID}%26quantity='/>" + qty;
                                document.getElementById('btnCartGuest').href = cartUrl;
                                document.getElementById('btnBuyGuest').href = buyUrl;
                            }
                        </script>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
    <!-- Similar Products Section -->
    <c:if test="${not empty similarProducts}">
    <section id="similar-products" class="section section-similar">
        <h2 class="similar-title">Sản Phẩm Tương Tự</h2>
        <div class="products grid">
            <c:forEach items="${similarProducts}" var="p">
                <div class="product-card">
                    <a href="<c:url value='/productDetail?id=${p.productID}'/>" class="product-card-link">
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
    </c:if>
    <!-- The Modal Lightbox -->
    <div id="imageModal" class="modal">
      <span class="close" onclick="closeModal()">&times;</span>
      <img class="modal-content" id="img01">
      <div id="caption"></div>
    </div>
    <script>
        var modal = document.getElementById("imageModal");
        var modalImg = document.getElementById("img01");
        var captionText = document.getElementById("caption");
        function openModal() {
            var img = document.getElementById("mainImg");
            modal.style.display = "block";
            modalImg.src = img.src;
            captionText.innerHTML = img.alt;
            // Prevent body scrolling
            document.body.style.overflow = "hidden";
        }
        function closeModal() {
            modal.style.display = "none";
            // Restore body scrolling
            document.body.style.overflow = "auto";
        }
        // Close modal when clicking outside the image or pressing ESC
        window.onclick = function(event) {
            if (event.target == modal) {
                closeModal();
            }
        }
        document.addEventListener('keydown', function(event) {
            if (event.key === "Escape") {
                closeModal();
            }
        });
    </script>
    <jsp:include page="/jsp/footer.jsp" />
</body>
</html>
