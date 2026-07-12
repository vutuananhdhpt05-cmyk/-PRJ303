<%@ page contentType="text/html; charset=UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1">
                    <title>Sản Phẩm - ASUS</title>
                    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"
                        rel="stylesheet">
                    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap"
                        rel="stylesheet">
                    <link href="<c:url value='/css/style.css'/>" rel="stylesheet">
                </head>

                <body>
                    <jsp:include page="/jsp/header.jsp" />

                    <!-- Search Bar -->
                    <form class="search-form search-form-layout" action="<c:url value='/products'/>" method="get">
                        <input type="text" name="keyword" placeholder="Tìm kiếm sản phẩm..."
                            value="<c:out value='${keyword}'/>"
                            oninput="if(this.value.trim() === '') this.form.submit();" class="flex-1-min-200" />
                        
                        <select name="brand" onchange="this.form.submit()"
                            class="form-control-custom">
                            <option value="">Tất cả các hãng</option>
                            <c:forEach var="b" items="${brands}">
                                <option value="${b}" ${b == brand ? 'selected' : ''}>${b}</option>
                            </c:forEach>
                        </select>

                        <div class="flex-align-center-gap-5">
                            <input type="number" name="minPrice" placeholder="Giá từ ($)" value="${minPrice}" 
                                class="price-input" min="0" step="0.01"/>
                            <span>-</span>
                            <input type="number" name="maxPrice" placeholder="Đến ($)" value="${maxPrice}" 
                                class="price-input" min="0" step="0.01"/>
                        </div>

                        <select name="sort" onchange="this.form.submit()"
                            class="form-control-custom">
                            <option value="">Sắp xếp mặc định</option>
                            <option value="price_asc" ${sort=='price_asc' ? 'selected' : '' }>Giá tăng dần</option>
                            <option value="price_desc" ${sort=='price_desc' ? 'selected' : '' }>Giá giảm dần</option>
                            <option value="name_asc" ${sort=='name_asc' ? 'selected' : '' }>Tên A-Z</option>
                            <option value="name_desc" ${sort=='name_desc' ? 'selected' : '' }>Tên Z-A</option>
                        </select>
                        <div class="flex-gap-5">
                            <button type="submit" class="btn btn-custom"><i
                                    class="fas fa-search"></i> Tìm / Lọc</button>
                            <c:if test="${not empty keyword or not empty brand or not empty minPrice or not empty maxPrice or not empty sort}">
                                <a href="<c:url value='/products'/>" class="btn-reset">
                                    <i class="fa-solid fa-rotate-right"></i> Đặt lại
                                </a>
                            </c:if>
                        </div>
                    </form>

                    <!-- Products Grid -->
                    <section class="section">
                        <div class="products grid">
                            <c:choose>
                                <c:when test="${empty products}">
                                    <div class="empty-search-state">
                                        <i class="fa-solid fa-box-open empty-search-icon"></i>
                                        <p class="empty-search-text">Không tìm thấy sản phẩm nào phù hợp.</p>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="product" items="${products}">
                                        <div class="product">
                                            <a href="<c:url value='/productDetail?id=${product.productID}'/>"
                                                class="product-card-link">
                                                <img src="<c:url value='/${product.imageUrl}'/>"
                                                    alt="${product.productName}" />
                                                <div class="content">
                                                    <div class="name">${product.productName}</div>
                                            </a>
                                            <div class="category">${product.description}</div>
                                            <div class="price">
                                                <fmt:formatNumber value="${product.price}" type="currency"
                                                    currencySymbol="$" />
                                            </div>
                                            <form action="<c:url value='/CartServlet'/>" method="post">
                                                <input type="hidden" name="action" value="add" />
                                                <input type="hidden" name="productId" value="${product.productID}" />
                                                <button type="submit" class="btn">
                                                    <i class="fas fa-cart-plus"></i> Thêm Vào Giỏ
                                                </button>
                                            </form>
                                        </div>
                        </div>
                        </c:forEach>
                        </c:otherwise>
                        </c:choose>
                        </div>

                        <!-- Pagination -->
                        <c:if test="${totalPages > 1}">
                            <div class="pagination-bar">
                                <c:if test="${currentPage > 1}">
                                    <a href="<c:url value='/products?page=${currentPage - 1}&keyword=${keyword}&sort=${sort}'/>"
                                        class="btn">&laquo;</a>
                                </c:if>

                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <c:choose>
                                        <c:when
                                            test="${i == 1 || i == totalPages || (i >= currentPage - 1 && i <= currentPage + 1)}">
                                            <a href="<c:url value='/products?page=${i}&keyword=${keyword}&sort=${sort}'/>"
                                                class="btn ${currentPage == i ? 'active' : ''}">${i}</a>
                                        </c:when>
                                        <c:when test="${i == currentPage - 2 || i == currentPage + 2}">
                                            <span class="page-link pagination-ellipsis">...</span>
                                        </c:when>
                                    </c:choose>
                                </c:forEach>

                                <c:if test="${currentPage < totalPages}">
                                    <a href="<c:url value='/products?page=${currentPage + 1}&keyword=${keyword}&sort=${sort}'/>"
                                        class="btn">&raquo;</a>
                                </c:if>
                            </div>
                        </c:if>
                    </section>

                    <jsp:include page="/jsp/footer.jsp" />
                </body>

                </html>