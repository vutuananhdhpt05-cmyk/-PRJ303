<%@ page contentType="text/html; charset=UTF-8" %>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

      <jsp:include page="/jsp/mgmt_header.jsp">
        <jsp:param name="activeMenu" value="dashboard" />
        <jsp:param name="pageTitle" value="Dashboard" />
      </jsp:include>

      <!-- Hero Banner -->
      <div class="hero-banner">
        <div class="hero-title">Admin Dashboard</div>
        <div class="hero-subtitle">Quản lý người dùng và giám sát hoạt động hệ thống</div>
      </div>

      <!-- Statistics Row -->
      <div class="row g-4 mb-4">
        <div class="col-md-4">
          <div class="stat-card">
            <div class="stat-icon icon-users">
              <i class="fas fa-user-friends"></i>
            </div>
            <div class="stat-info">
              <h2>${totalUsers}</h2>
              <p>Tổng người dùng</p>
            </div>
          </div>
        </div>
        <div class="col-md-4">
          <div class="stat-card">
            <div class="stat-icon icon-orders">
              <i class="fas fa-chart-line"></i>
            </div>
            <div class="stat-info">
              <h2>${totalOrders}</h2>
              <p>Đơn hàng hoạt động</p>
            </div>
          </div>
        </div>
        <div class="col-md-4">
          <div class="stat-card">
            <div class="stat-icon icon-revenue">
              <i class="fas fa-shield-alt"></i>
            </div>
            <div class="stat-info">
              <h2>${allUsers != null ? allUsers.size() : 0}</h2>
              <p>Hoạt động gần đây</p>
            </div>
          </div>
        </div>
      </div>

      <!-- Tabs -->
      <div class="custom-tabs">
        <div class="custom-tab active">
          <i class="fas fa-users"></i> Quản lý người dùng
        </div>
      </div>

      <!-- Alerts -->
      <c:if test="${not empty sessionScope.successMessage}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
          ${sessionScope.successMessage}
          <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <c:remove var="successMessage" scope="session" />
      </c:if>
      <c:if test="${not empty sessionScope.errorMessage}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
          ${sessionScope.errorMessage}
          <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <c:remove var="errorMessage" scope="session" />
      </c:if>

      <!-- Toolbar -->
      <div class="toolbar">
        <form class="search-box" action="<%=request.getContextPath()%>/dashboard" method="get">
          <i class="fas fa-search"></i>
          <input type="text" name="kw" placeholder="Tìm kiếm theo tên..." value="${param.kw}"
            oninput="if(this.value.trim() === '') this.form.submit();">
        </form>
      </div>

      <!-- Users Table -->
      <div class="table-container">
        <table class="table">
          <thead>
            <tr>
              <th>Người dùng</th>
              <th>Liên hệ</th>
              <th>Vai trò</th>
              <th>Trạng thái</th>
              <th>Thao tác</th>
            </tr>
          </thead>
          <tbody>
            <c:forEach var="u" items="${allUsers}">
              <tr>
                <td>
                  <div class="user-cell">
                    <div class="circle-avatar">
                      ${fn:substring(u.fullName, 0, 2).toUpperCase()}
                    </div>
                    <div>
                      <div class="user-name-cell">${u.fullName}</div>
                      <div class="user-id-cell">ID: ${u.userID}</div>
                    </div>
                  </div>
                </td>
                <td class="contact-cell">
                  <div>${u.email}</div>
                  <div>${not empty u.phone ? u.phone : 'N/A'}</div>
                </td>
                <td>
                  <c:choose>
                    <c:when test="${fn:toUpperCase(u.role) == 'ADMIN'}">
                      <span class="badge badge-admin">Admin</span>
                    </c:when>
                    <c:when test="${fn:toUpperCase(u.role) == 'MANAGER'}">
                      <span class="badge badge-manager">Manager</span>
                    </c:when>
                    <c:when test="${fn:toUpperCase(u.role) == 'STAFF'}">
                      <span class="badge badge-staff">Staff</span>
                    </c:when>
                    <c:otherwise>
                      <span class="badge badge-customer">Customer</span>
                    </c:otherwise>
                  </c:choose>
                </td>
                <td>
                  <span class="badge badge-status">Hoạt động</span>
                </td>
                <td>
                  <button class="action-btn" title="Sửa"
                    onclick="openEditModal(${u.userID}, '${fn:escapeXml(u.username)}', '${fn:escapeXml(u.email)}', '${fn:escapeXml(u.fullName)}', '${fn:escapeXml(u.address)}', '${fn:escapeXml(u.phone)}', '${fn:escapeXml(u.role)}')">
                    <i class="fas fa-pen"></i>
                  </button>
                  <a href="<%=request.getContextPath()%>/admin/users?action=delete&id=${u.userID}"
                    class="action-btn delete" title="Xóa" onclick="return confirm('Bạn có chắc chắn xóa user này?');">
                    <i class="fas fa-trash-alt"></i>
                  </a>
                </td>
              </tr>
            </c:forEach>
            <c:if test="${empty allUsers}">
              <tr>
                <td colspan="5" class="text-center py-4 text-muted">Không có dữ liệu người dùng</td>
              </tr>
            </c:if>
          </tbody>
        </table>
      </div>

      <!-- Edit User Modal -->
      <div class="modal fade" id="editUserModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
          <div class="modal-content">
            <form action="<%=request.getContextPath()%>/admin/users" method="post">
              <div class="modal-header">
                <h5 class="modal-title">Sửa Người Dùng</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
              </div>
              <div class="modal-body">
                <input type="hidden" name="userID" id="editUserId" />
                <div class="mb-3">
                  <label class="form-label">Username</label>
                  <input name="username" id="editUsername" class="form-control" disabled />
                </div>
                <div class="mb-3">
                  <label class="form-label">Email</label>
                  <input name="email" id="editEmail" type="email" class="form-control" disabled />
                </div>
                <div class="mb-3">
                  <label class="form-label">Full Name</label>
                  <input name="fullName" id="editFullName" class="form-control" disabled />
                </div>
                <div class="mb-3">
                  <label class="form-label">Address</label>
                  <input name="address" id="editAddress" class="form-control" disabled />
                </div>
                <div class="mb-3">
                  <label class="form-label">Phone</label>
                  <input name="phone" id="editPhone" class="form-control" disabled />
                </div>
                <div class="mb-3">
                  <label class="form-label">Role</label>
                  <select name="role" id="editRole" class="form-select">
                    <option value="CUSTOMER">Customer</option>
                    <option value="STAFF">Staff</option>
                    <option value="MANAGER">Manager</option>
                    <option value="ADMIN">Admin</option>
                  </select>
                </div>
              </div>
              <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
              </div>
            </form>
          </div>
        </div>
      </div>

      <script>
        function openEditModal(id, username, email, fullName, address, phone, role) {
          document.getElementById('editUserId').value = id;
          document.getElementById('editUsername').value = username;
          document.getElementById('editEmail').value = email;
          document.getElementById('editFullName').value = fullName;
          document.getElementById('editAddress').value = address;
          document.getElementById('editPhone').value = phone;

          var roleSelect = document.getElementById('editRole');
          for (var i = 0; i < roleSelect.options.length; i++) {
            if (roleSelect.options[i].value.toUpperCase() === role.toUpperCase()) {
              roleSelect.selectedIndex = i;
              break;
            }
          }

          var modal = new bootstrap.Modal(document.getElementById('editUserModal'));
          modal.show();
        }
      </script>

      <jsp:include page="/jsp/mgmt_footer.jsp" />