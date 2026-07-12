<%@ page contentType="text/html; charset=UTF-8" %>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

      <jsp:include page="/jsp/mgmt_header.jsp">
        <jsp:param name="activeMenu" value="orders" />
        <jsp:param name="pageTitle" value="Quản lý Đơn hàng" />
      </jsp:include>

      <div class="form-container mb-4">
        <form action="${pageContext.request.contextPath}/staff/orders" method="GET" class="row g-3">
          <input type="hidden" name="action" value="list">
          <div class="col-md-3">
            <label class="form-label">Mã Đơn Hàng (ID)</label>
            <input type="number" class="form-control" name="searchId" value="${searchId}">
          </div>
          <div class="col-md-3">
            <label class="form-label">Từ ngày</label>
            <input type="date" class="form-control" name="fromDate" value="${fromDate}">
          </div>
          <div class="col-md-3">
            <label class="form-label">Đến ngày</label>
            <input type="date" class="form-control" name="toDate" value="${toDate}">
          </div>
          <div class="col-md-3">
            <label class="form-label">Trạng thái</label>
            <select class="form-select" name="status">
              <option value="All" ${status=='All' ? 'selected' : '' }>Tất cả</option>
              <option value="Pending" ${status=='Pending' ? 'selected' : '' }>Pending</option>
              <option value="Processing" ${status=='Processing' ? 'selected' : '' }>Processing</option>
              <option value="Shipped" ${status=='Shipped' ? 'selected' : '' }>Shipped</option>
              <option value="Cancelled" ${status=='Cancelled' ? 'selected' : '' }>Cancelled</option>
            </select>
          </div>
          <div class="col-12 text-end">
            <button type="submit" class="btn btn-primary">Tìm kiếm / Lọc</button>
            <a href="${pageContext.request.contextPath}/staff/orders" class="btn btn-secondary">Xóa bộ lọc</a>
          </div>
        </form>
      </div>

      <div class="table-container">
        <table class="table table-striped">
          <thead>
            <tr>
              <th>OrderID</th>
              <th>Ngày</th>
              <th>Tổng</th>
              <th>Trạng thái</th>
              <th>Thao tác</th>
            </tr>
          </thead>
          <tbody>
            <c:forEach var="o" items="${orders}">
              <tr>
                <td>${o.orderID}</td>
                <td>
                  <fmt:formatDate value="${o.orderDate}" pattern="dd/MM/yyyy HH:mm" />
                </td>
                <td>
                  <fmt:formatNumber value="${o.totalAmount}" type="currency" currencySymbol="$" />
                </td>
                <td>
                  <c:choose>
                    <c:when test="${o.status == 'Pending'}"><span class="badge bg-warning text-dark">Pending</span>
                    </c:when>
                    <c:when test="${o.status == 'Processing'}"><span class="badge bg-info text-dark">Processing</span>
                    </c:when>
                    <c:when test="${o.status == 'Shipped'}"><span class="badge bg-success">Shipped</span></c:when>
                    <c:when test="${o.status == 'Cancelled'}"><span class="badge bg-danger">Cancelled</span></c:when>
                    <c:otherwise><span class="badge bg-secondary">${o.status}</span></c:otherwise>
                  </c:choose>
                </td>
                <td>
                  <a href="${pageContext.request.contextPath}/staff/orders?action=view&amp;id=${o.orderID}" class="action-btn" title="Xem chi tiết"><i
                      class="fas fa-eye"></i></a>
                </td>
              </tr>
            </c:forEach>
            <c:if test="${empty orders}">
              <tr>
                <td colspan="5" class="text-center text-muted">Không tìm thấy đơn hàng nào.</td>
              </tr>
            </c:if>
          </tbody>
        </table>
      </div>

      <jsp:include page="/jsp/mgmt_footer.jsp" />
