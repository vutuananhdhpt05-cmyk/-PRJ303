<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quên Mật Khẩu - Asus AI 2025</title>
    <!-- Import Google Font Outfit and FontAwesome -->
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="<c:url value='/css/forgotPassword.css'/>" rel="stylesheet">
</head>
<body>
    <div class="auth-container">
        <div class="auth-logo">
            <i class="fa-solid fa-laptop-code"></i>
        </div>
        <h2>Quên Mật Khẩu</h2>
        <!-- Step Indicators -->
        <div class="step-indicator">
            <div class="step-node ${step == null || step == 1 ? 'active' : 'completed'}">
                <div class="step-circle">1</div>
                <div class="step-label">Nhập Email</div>
            </div>
            <div class="step-node ${step == 2 ? 'active' : (step > 2 ? 'completed' : '')}">
                <div class="step-circle">2</div>
                <div class="step-label">Mã OTP</div>
            </div>
            <div class="step-node ${step == 3 ? 'active' : ''}">
                <div class="step-circle">3</div>
                <div class="step-label">Mật khẩu mới</div>
            </div>
        </div>
        <!-- Alerts -->
        <c:if test="${not empty success}">
            <div class="alert alert-success">
                <i class="fa-solid fa-circle-check"></i>
                <span>${success}</span>
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-error">
                <i class="fa-solid fa-circle-exclamation"></i>
                <span>${error}</span>
            </div>
        </c:if>
        <c:choose>
            <%-- BƯỚC 3: ĐẶT LẠI MẬT KHẨU --%>
            <c:when test="${not empty sessionScope.verifiedUser or step == 3}">
                <p class="subtitle">
                    Tài khoản hợp lệ! Hãy đặt lại mật khẩu mới cho tài khoản <strong><c:out value="${sessionScope.verifiedUser.username}"/></strong>.
                </p>
                <form action="${pageContext.request.contextPath}/forgotPassword" method="post">
                    <input type="hidden" name="action" value="reset" />
                    <div class="input-group">
                        <input type="password" name="newPassword" placeholder="Mật khẩu mới" required minlength="6" />
                        <i class="fa-solid fa-lock"></i>
                    </div>
                    <div class="input-group">
                        <input type="password" name="confirmPassword" placeholder="Xác nhận mật khẩu mới" required />
                        <i class="fa-solid fa-shield-halved"></i>
                    </div>
                    <input type="submit" value="Xác nhận đổi mật khẩu" />
                </form>
            </c:when>
            <%-- BƯỚC 2: NHẬP MÃ OTP --%>
            <c:when test="${step == 2}">
                <p class="subtitle">
                    Hệ thống đã tạo mã xác minh gửi tới email <strong><c:out value="${sessionScope.resetEmail}"/></strong>.
                </p>
                <!-- Mô phỏng OTP phục vụ test -->
                <div class="otp-sandbox">
                    <i class="fa-solid fa-bug mr-5"></i>
                    <strong>[Chế độ thử nghiệm]</strong> Mã OTP của bạn là:
                    <span class="otp-code"><c:out value="${sessionScope.resetOtp}"/></span>
                </div>
                <form action="${pageContext.request.contextPath}/forgotPassword" method="post">
                    <input type="hidden" name="action" value="verify_otp" />
                    <div class="input-group">
                        <input type="text" name="otp" placeholder="Nhập mã OTP 6 số" required pattern="[0-9]{6}" maxlength="6" autocomplete="off" />
                        <i class="fa-solid fa-key"></i>
                    </div>
                    <input type="submit" value="Xác minh mã OTP" />
                </form>
            </c:when>
            <%-- BƯỚC 1: NHẬP EMAIL ĐỂ NHẬN OTP (Mặc định) --%>
            <c:otherwise>
                <p class="subtitle">
                    Vui lòng cung cấp email đăng ký để nhận mã OTP xác thực khôi phục tài khoản.
                </p>
                <form action="${pageContext.request.contextPath}/forgotPassword" method="post">
                    <input type="hidden" name="action" value="send_otp" />
                    <div class="input-group">
                        <input type="email" name="email" placeholder="Email đăng ký" required />
                        <i class="fa-solid fa-envelope"></i>
                    </div>
                    <input type="submit" value="Gửi mã OTP xác nhận" />
                </form>
            </c:otherwise>
        </c:choose>
        <div class="back-link">
            <a href="${pageContext.request.contextPath}/login.jsp"><i class="fa-solid fa-arrow-left mr-6"></i>Quay lại Đăng nhập</a>
        </div>
    </div>
</body>
</html>
