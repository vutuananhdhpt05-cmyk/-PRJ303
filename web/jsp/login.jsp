<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <title>Đăng Nhập</title>
            <script src="https://www.google.com/recaptcha/api.js" async defer></script>
            <link href="<c:url value='/css/auth.css'/>" rel="stylesheet">
        </head>

        <body>
            <div class="login-box">
                <h2>Đăng Nhập</h2>
                <form action="${pageContext.request.contextPath}/login" method="post">
                    <input type="text" name="username" placeholder="Email hoặc Tên đăng nhập" required />
                    <input type="password" name="password" placeholder="Mật khẩu" required />
                    <div class="g-recaptcha" data-sitekey="6Lc232UrAAAAAAjYxvKYoSVsSALbDCo817OjHZRv"></div>
                    <br />
                    <input type="submit" value="Đăng Nhập" />
                    <c:if test="${not empty error}">
                        <div class="error">${error}</div>
                    </c:if>
                </form>
                <p class="signup-link">
            Bạn chưa có tài khoản? <a href="${pageContext.request.contextPath}/register">Đăng ký ngay</a>
            <br/><br/>
            <a href="${pageContext.request.contextPath}/forgotPassword" class="forgot-password-link">Quên mật khẩu?</a>
        </p>
            </div>
        </body>

        </html>