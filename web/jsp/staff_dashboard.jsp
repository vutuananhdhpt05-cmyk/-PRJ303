<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<jsp:include page="/jsp/mgmt_header.jsp">
    <jsp:param name="activeMenu" value="dashboard" />
    <jsp:param name="pageTitle" value="Staff Dashboard" />
</jsp:include>
          
          <!-- Hero Banner -->
          <div class="hero-banner">
              <div class="hero-title">Staff Dashboard</div>
              <div class="hero-subtitle">Quản lý đơn hàng và vận hành hệ thống</div>
          </div>
          
          <!-- Statistics Row -->
          <div class="row g-4 mb-4">
            <div class="col-md-6">
              <div class="stat-card">
                  <div class="stat-icon icon-orders">
                      <i class="fas fa-chart-line"></i>
                  </div>
                  <div class="stat-info">
                      <h2>${totalOrders}</h2>
                      <p>Tổng số đơn hàng</p>
                  </div>
              </div>
            </div>
            <div class="col-md-6">
              <div class="stat-card">
                  <div class="stat-icon icon-revenue stat-icon-revenue">
                      <i class="fas fa-box-open"></i>
                  </div>
                  <div class="stat-info">
                      <h2>${recentOrders != null ? recentOrders.size() : 0}</h2>
                      <p>Đơn hàng gần đây</p>
                  </div>
              </div>
            </div>
          </div>
          
          <!-- Tabs for Staff -->
          <div class="custom-tabs mt-4">
              <div class="custom-tab active">
                  <i class="fas fa-receipt"></i> Đơn hàng mới nhất
              </div>
          </div>
          
          <div class="table-container">
              <table class="table">
                  <thead>
                      <tr>
                          <th>Mã Đơn</th>
                          <th>Ngày đặt</th>
                          <th>Tổng tiền</th>
                          <th>Trạng thái</th>
                          <th>Thao tác</th>
                      </tr>
                  </thead>
                  <tbody>
                      <c:forEach var="o" items="${recentOrders}">
                          <tr>
                              <td class="fw-bold text-primary">#${o.orderID}</td>
                              <td>${o.orderDate}</td>
                              <td class="fw-bold">$${o.totalAmount}</td>
                              <td><span class="badge badge-status">${o.status}</span></td>
                              <td>
                                  <a href="<%=request.getContextPath()%>/staff/orders?action=view&amp;id=${o.orderID}" class="btn btn-sm btn-outline-primary btn-action-sm">Xử lý</a>
                              </td>
                          </tr>
                      </c:forEach>
                      <c:if test="${empty recentOrders}">
                          <tr>
                              <td colspan="5" class="text-center py-4 text-muted">Chưa có đơn hàng nào</td>
                          </tr>
                      </c:if>
                  </tbody>
              </table>
          </div>
          
<jsp:include page="/jsp/mgmt_footer.jsp" />

