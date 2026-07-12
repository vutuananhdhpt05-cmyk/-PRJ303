<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<jsp:include page="/jsp/mgmt_header.jsp">
    <jsp:param name="activeMenu" value="profile" />
    <jsp:param name="pageTitle" value="Hồ sơ cá nhân" />
</jsp:include>

    <!-- Alerts -->
    <c:if test="${not empty pwdError}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="fa-solid fa-circle-exclamation"></i> ${pwdError}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <c:remove var="pwdError" scope="session"/>
    </c:if>
    <c:if test="${not empty pwdSuccess}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <i class="fa-solid fa-circle-check"></i> ${pwdSuccess}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <c:remove var="pwdSuccess" scope="session"/>
    </c:if>
    <c:if test="${not empty profileError}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="fa-solid fa-circle-exclamation"></i> ${profileError}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <c:remove var="profileError" scope="session"/>
    </c:if>
    <c:if test="${not empty profileSuccess}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <i class="fa-solid fa-circle-check"></i> ${profileSuccess}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <c:remove var="profileSuccess" scope="session"/>
    </c:if>

    <div class="row">
        <!-- Profile Info -->
        <div class="col-md-5 mb-4">
            <div class="form-container h-100">
                <div class="text-center mb-4">
                    <div class="circle-avatar mx-auto mb-3 avatar-large">
                        ${fn:substring(sessionScope.user.fullName, 0, 1).toUpperCase()}
                    </div>
                    <h4>${sessionScope.user.fullName}</h4>
                    <span class="badge badge-admin px-3 py-2">${sessionScope.user.role}</span>
                </div>
                
                <hr>
                
                <div class="mt-4">
                    <form action="<%=request.getContextPath()%>/profile" method="post">
                        <div class="mb-3">
                            <label class="form-label text-muted small fw-bold"><i class="fas fa-user text-primary me-1"></i> Username</label>
                            <input type="text" class="form-control bg-light" value="${sessionScope.user.username}" disabled>
                        </div>
                        <div class="mb-3">
                            <label class="form-label text-muted small fw-bold"><i class="fas fa-envelope text-primary me-1"></i> Email</label>
                            <input type="email" class="form-control bg-light" value="${sessionScope.user.email}" disabled>
                        </div>
                        <div class="mb-3">
                            <label class="form-label text-muted small fw-bold">Họ và Tên</label>
                            <input type="text" name="fullName" class="form-control" value="${sessionScope.user.fullName}" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label text-muted small fw-bold">Số điện thoại</label>
                            <input type="text" name="phone" class="form-control" value="${sessionScope.user.phone}">
                        </div>
                        <div class="mb-4">
                            <label class="form-label text-muted small fw-bold">Địa chỉ</label>
                            <input type="text" name="address" class="form-control" value="${sessionScope.user.address}">
                        </div>
                        <button type="submit" class="btn btn-outline-primary w-100"><i class="fas fa-save me-2"></i> Cập nhật thông tin</button>
                    </form>
                </div>
            </div>
        </div>

        <!-- Change Password -->
        <div class="col-md-7 mb-4">
            <div class="form-container h-100">
                <h4 class="mb-4"><i class="fas fa-lock text-primary me-2"></i> Đổi mật khẩu</h4>
                <form action="<%=request.getContextPath()%>/changePassword" method="post">
                    <div class="mb-3">
                        <label class="form-label fw-bold">Mật khẩu hiện tại</label>
                        <input type="password" name="oldPassword" class="form-control" required placeholder="Nhập mật khẩu cũ">
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">Mật khẩu mới</label>
                        <input type="password" name="newPassword" class="form-control" required placeholder="Tối thiểu 6 ký tự">
                    </div>
                    <div class="mb-4">
                        <label class="form-label fw-bold">Xác nhận mật khẩu mới</label>
                        <input type="password" name="confirmPassword" class="form-control" required placeholder="Nhập lại mật khẩu mới">
                    </div>
                    <button type="submit" class="btn btn-primary"><i class="fas fa-save me-2"></i> Lưu thay đổi</button>
                </form>
            </div>
        </div>
    </div>

<jsp:include page="/jsp/mgmt_footer.jsp" />

