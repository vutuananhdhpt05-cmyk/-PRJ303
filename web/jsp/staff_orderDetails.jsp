<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/jsp/mgmt_header.jsp">
    <jsp:param name="activeMenu" value="orders" />
    <jsp:param name="pageTitle" value="Chi tiết Đơn hàng" />
</jsp:include>

    <c:if test="${not empty sessionScope.successMessage}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            ${sessionScope.successMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <c:remove var="successMessage" scope="session"/>
    </c:if>

    <div class="row">
        <div class="col-md-6 mb-4">
            <div class="form-container h-100">
                <h4 class="mb-3">Chi tiết Đơn #${order.orderID}</h4>
                <p><strong>Ngày:</strong> <fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm"/></p>
                <p><strong>Tổng:</strong> <fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="$"/></p>
                
                <form action="<%=request.getContextPath()%>/staff/orders" method="post" class="mt-3">
                    <input type="hidden" name="action" value="updateStatus">
                    <input type="hidden" name="orderId" value="${order.orderID}">
                    <div class="input-group">
                        <span class="input-group-text">Trạng thái</span>
                        <select class="form-select" name="status">
                            <option value="Pending" ${order.status == 'Pending' ? 'selected' : ''}>Pending</option>
                            <option value="Processing" ${order.status == 'Processing' ? 'selected' : ''}>Processing</option>
                            <option value="Shipped" ${order.status == 'Shipped' ? 'selected' : ''}>Shipped</option>
                            <option value="Delivered" ${order.status == 'Delivered' ? 'selected' : ''}>Delivered</option>
                            <option value="Cancelled" ${order.status == 'Cancelled' ? 'selected' : ''}>Cancelled</option>
                        </select>
                        <button class="btn btn-primary" type="submit">Cập nhật</button>
                    </div>
                </form>
            </div>
        </div>
        <div class="col-md-6 mb-4">
            <div class="form-container h-100">
              <h4 class="mb-3">Thông tin Giao hàng</h4>
              <c:if test="${info != null}">
                <p><strong>Người nhận:</strong> ${info.shippingName}</p>
                <p><strong>Địa chỉ:</strong> ${info.shippingAddress}</p>
                <p><strong>Phone:</strong> ${info.phone}</p>
                <p><strong>Phương thức:</strong> ${info.paymentMethod}</p>
              </c:if>
              <c:if test="${info == null}">
                <p class="text-muted">Không có thông tin giao hàng</p>
              </c:if>
            </div>
        </div>
    </div>

    <div class="form-container">
      <h4 class="mb-4">Chi tiết sản phẩm</h4>
      <div class="table-container">
      <table class="table table-striped">
        <thead>
          <tr><th>Sản phẩm</th><th>SL</th><th>Đơn giá</th><th>Thành tiền</th></tr>
        </thead>
        <tbody>
          <c:forEach var="d" items="${details}">
            <tr>
              <td>${d.productName}</td>
              <td>${d.quantity}</td>
              <td><fmt:formatNumber value="${d.unitPrice}" type="currency" currencySymbol="$"/></td>
              <td><fmt:formatNumber value="${d.totalPrice}" type="currency" currencySymbol="$"/></td>
            </tr>
          </c:forEach>
        </tbody>
      </table>
      </div>
      <div class="mt-4">
          <a href="${pageContext.request.contextPath}/staff/orders" class="btn btn-secondary"><i class="fas fa-arrow-left"></i> Quay lại danh sách</a>
      </div>
    </div>

<jsp:include page="/jsp/mgmt_footer.jsp" />
