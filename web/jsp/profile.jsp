<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Tài khoản của tôi - ASUS Store</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="<c:url value='/css/style.css'/>" rel="stylesheet">

</head>
<body>
    <jsp:include page="/jsp/header.jsp" />
    <div class="profile-wrapper">
        <!-- Sidebar -->
        <div class="profile-sidebar">
            <div class="avatar-circle">
                <i class="fa-solid fa-user"></i>
            </div>
            <div class="profile-name"><c:out value="${sessionScope.user.fullName}"/></div>
            <div class="profile-role"><c:out value="${sessionScope.user.role}"/></div>
            <ul class="profile-info-list">
                <li>
                    <i class="fa-solid fa-at"></i>
                    <span><c:out value="${sessionScope.user.username}"/></span>
                </li>
                <li>
                    <i class="fa-solid fa-envelope"></i>
                    <span><c:out value="${sessionScope.user.email}"/></span>
                </li>
                <li>
                    <i class="fa-solid fa-phone"></i>
                    <span><c:out value="${sessionScope.user.phone != null && sessionScope.user.phone != '' ? sessionScope.user.phone : 'Chưa cập nhật'}"/></span>
                </li>
                <li>
                    <i class="fa-solid fa-location-dot"></i>
                    <span><c:out value="${sessionScope.user.address != null && sessionScope.user.address != '' ? sessionScope.user.address : 'Chưa cập nhật'}"/></span>
                </li>
            </ul>
            <a href="#" onclick="openEditModal(); return false;" class="sidebar-link">
                <i class="fa-solid fa-user-pen"></i> Chỉnh sửa thông tin
            </a>
            <a href="<c:url value='/ordersHistory'/>" class="sidebar-link">
                <i class="fa-solid fa-clock-rotate-left"></i> Lịch sử đơn hàng
            </a>
            <a href="<c:url value='/logout'/>" class="sidebar-link danger">
                <i class="fa-solid fa-right-from-bracket"></i> Đăng xuất
            </a>
        </div>
        <!-- Main Content -->
        <div class="profile-main">
            <!-- Profile Alerts moved here so they show globally -->
            <c:if test="${not empty profileError}">
                <div class="alert alert-error mb-20">
                    <i class="fa-solid fa-circle-exclamation"></i> ${profileError}
                </div>
                <c:remove var="profileError" scope="session"/>
            </c:if>
            <c:if test="${not empty profileSuccess}">
                <div class="alert alert-success mb-20">
                    <i class="fa-solid fa-circle-check"></i> ${profileSuccess}
                </div>
                <c:remove var="profileSuccess" scope="session"/>
            </c:if>

            <!-- Password Change Card -->
            <div class="profile-card">
                <h3><i class="fa-solid fa-lock"></i> Đổi mật khẩu</h3>
                <c:if test="${not empty pwdError}">
                    <div class="alert alert-error">
                        <i class="fa-solid fa-circle-exclamation"></i> ${pwdError}
                    </div>
                    <c:remove var="pwdError" scope="session"/>
                </c:if>
                <c:if test="${not empty pwdSuccess}">
                    <div class="alert alert-success">
                        <i class="fa-solid fa-circle-check"></i> ${pwdSuccess}
                    </div>
                    <c:remove var="pwdSuccess" scope="session"/>
                </c:if>
                <form action="<c:url value='/changePassword'/>" method="post" class="pwd-form">
                    <div class="form-group">
                        <label for="oldPassword">Mật khẩu hiện tại</label>
                        <div class="input-wrap">
                            <i class="fa-solid fa-key icon"></i>
                            <input type="password" name="oldPassword" id="oldPassword" required placeholder="Nhập mật khẩu cũ"/>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="newPassword">Mật khẩu mới</label>
                        <div class="input-wrap">
                            <i class="fa-solid fa-lock icon"></i>
                            <input type="password" name="newPassword" id="newPassword" required placeholder="Tối thiểu 6 ký tự"/>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="confirmPassword">Xác nhận mật khẩu mới</label>
                        <div class="input-wrap">
                            <i class="fa-solid fa-shield-halved icon"></i>
                            <input type="password" name="confirmPassword" id="confirmPassword" required placeholder="Nhập lại mật khẩu mới"/>
                        </div>
                    </div>
                    <button type="submit" class="btn-save">
                        <i class="fa-solid fa-floppy-disk"></i> Lưu thay đổi
                    </button>
                </form>
            </div>
        </div>
    </div>
    <jsp:include page="/jsp/footer.jsp" />

    <!-- Edit Profile Modal -->
    <div id="editProfileModal" class="modal-overlay hidden">
        <div class="modal-content">
            <div class="modal-header">
                <h3><i class="fa-solid fa-user-pen"></i> Chỉnh sửa thông tin</h3>
                <span class="close-btn" onclick="closeEditModal()">&times;</span>
            </div>
            <form action="<c:url value='/profile'/>" method="post" class="pwd-form">
                <div class="form-group">
                    <label>Họ và Tên</label>
                    <div class="input-wrap">
                        <i class="fa-solid fa-id-card icon"></i>
                        <input type="text" name="fullName" value="${sessionScope.user.fullName}" required/>
                    </div>
                </div>
                <div class="form-group">
                    <label>Số điện thoại</label>
                    <div class="input-wrap">
                        <i class="fa-solid fa-phone icon"></i>
                        <input type="text" name="phone" value="${sessionScope.user.phone}"/>
                    </div>
                </div>
                <div class="form-group">
                    <label>Địa chỉ</label>
                    <div class="input-wrap">
                        <i class="fa-solid fa-map-location-dot icon"></i>
                        <input type="text" name="address" value="${sessionScope.user.address}"/>
                    </div>
                </div>
                <button type="submit" class="btn-save mt-15">
                    <i class="fa-solid fa-floppy-disk"></i> Lưu thay đổi
                </button>
            </form>
        </div>
    </div>

    <script>
        function openEditModal() {
            document.getElementById('editProfileModal').classList.remove('hidden');
        }
        function closeEditModal() {
            document.getElementById('editProfileModal').classList.add('hidden');
        }
        // Đóng modal khi bấm ra ngoài
        window.onclick = function(event) {
            var modal = document.getElementById('editProfileModal');
            if (event.target == modal) {
                closeEditModal();
            }
        }
    </script>
</body>
</html>
