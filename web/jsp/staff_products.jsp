<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<jsp:include page="/jsp/mgmt_header.jsp">
    <jsp:param name="activeMenu" value="products" />
    <jsp:param name="pageTitle" value="Quản lý Sản phẩm" />
</jsp:include>

  <form class="row g-2 mb-4" method="get" action="<c:url value='/staff/products'/>">
    <input type="hidden" name="action" value="list"/>
    <div class="col-auto">
      <input type="text" class="form-control" name="kw"
             placeholder="Tìm theo tên..." value="${param.kw}">
    </div>
    <div class="col-auto">
      <button type="submit" class="btn btn-primary">Tìm</button>
      <a href="<c:url value='/staff/products?action=new'/>" class="btn btn-success">
        Thêm mới
      </a>
    </div>
  </form>

  <c:if test="${not empty sessionScope.errorMsg}">
    <div class="alert alert-danger alert-dismissible fade show mt-3" role="alert">
      ${sessionScope.errorMsg}
      <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
    <c:remove var="errorMsg" scope="session" />
  </c:if>

  <div class="table-container">
  <table class="table table-striped">
    <thead>
      <tr>
        <th>ID</th><th>Tên</th><th>Giá ($)</th><th>Kho</th><th>Hãng</th><th>Thao tác</th>
      </tr>
    </thead>
    <tbody>
      <c:forEach var="p" items="${products}">
        <tr>
          <td>${p.productID}</td>
          <td>${p.productName}</td>
          <td>${p.price}</td>
          <td>${p.stock}</td>
          <td>${p.brand}</td>
          <td>
            <a href="<c:url value='/staff/products?action=edit&amp;id=${p.productID}'/>"
               class="action-btn" title="Sửa"><i class="fas fa-pen"></i></a>
                <a href="<c:url value='/staff/products?action=delete&amp;id=${p.productID}'/>"
                   class="action-btn delete" title="Xóa"
                   onclick="return confirm('Xóa sản phẩm này?');"><i class="fas fa-trash-alt"></i>
                </a>
          </td>
        </tr>
      </c:forEach>
    </tbody>
  </table>
  </div>

  <c:if test="${empty products}">
    <div class="alert alert-info mt-3">Không tìm thấy sản phẩm nào.</div>
  </c:if>

  <%-- Pagination --%>
  <c:if test="${totalPages > 1}">
    <div class="d-flex justify-content-between align-items-center mt-3 mb-2 px-1">
      <span class="text-muted" style="font-size:0.85rem;">
        Tổng: <strong>${totalItems}</strong> sản phẩm &mdash; Trang <strong>${currentPage}</strong> / <strong>${totalPages}</strong>
      </span>
      <nav>
        <ul class="pagination pagination-sm mb-0" style="gap:4px;">
          <%-- Prev --%>
          <c:choose>
            <c:when test="${currentPage > 1}">
              <li class="page-item">
                <a class="page-link" href="${pageBase}&page=${currentPage - 1}">&laquo;</a>
              </li>
            </c:when>
            <c:otherwise>
              <li class="page-item disabled"><span class="page-link">&laquo;</span></li>
            </c:otherwise>
          </c:choose>

          <%-- Page numbers with ellipsis --%>
          <c:forEach begin="1" end="${totalPages}" var="i">
            <c:choose>
              <%-- Always show first, last, and pages near current --%>
              <c:when test="${i == 1 || i == totalPages || (i >= currentPage - 1 && i <= currentPage + 1)}">
                <c:choose>
                  <c:when test="${i == currentPage}">
                    <li class="page-item active">
                      <span class="page-link" style="background:#0ea5e9;border-color:#0ea5e9;">${i}</span>
                    </li>
                  </c:when>
                  <c:otherwise>
                    <li class="page-item">
                      <a class="page-link" href="${pageBase}&page=${i}">${i}</a>
                    </li>
                  </c:otherwise>
                </c:choose>
              </c:when>
              <%-- Ellipsis after first page --%>
              <c:when test="${i == 2 && currentPage > 3}">
                <li class="page-item disabled"><span class="page-link">...</span></li>
              </c:when>
              <%-- Ellipsis before last page --%>
              <c:when test="${i == totalPages - 1 && currentPage < totalPages - 2}">
                <li class="page-item disabled"><span class="page-link">...</span></li>
              </c:when>
            </c:choose>
          </c:forEach>

          <%-- Next --%>
          <c:choose>
            <c:when test="${currentPage < totalPages}">
              <li class="page-item">
                <a class="page-link" href="${pageBase}&page=${currentPage + 1}">&raquo;</a>
              </li>
            </c:when>
            <c:otherwise>
              <li class="page-item disabled"><span class="page-link">&raquo;</span></li>
            </c:otherwise>
          </c:choose>
        </ul>
      </nav>
    </div>
  </c:if>

<jsp:include page="/jsp/mgmt_footer.jsp" />

