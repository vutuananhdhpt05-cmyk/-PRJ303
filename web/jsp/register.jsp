<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Register</title>
    <link href="<c:url value='/css/auth.css'/>" rel="stylesheet">
</head>
    <body>
        <div class="register-box">
            <h2>Register</h2>

            <form action="${pageContext.request.contextPath}/register" method="post">
                <input type="text" name="fullname" placeholder="User Name" required>
                <input type="email" name="email" placeholder="Email" required>
                <input type="password" name="password" placeholder="Password" required>
                <input type="password" name="confirm" placeholder="Confirm Password" required>
                <input type="submit" value="Register">
            </form>

            <div class="message">
                <c:if test="${not empty error}">
                    <div class="error">${error}</div>
                </c:if>
                <c:if test="${not empty success}">
<div class="success">${success}</div>
                </c:if>
            </div>

            <p class="login-link">
                Bạn đã có tài khoản? <a href="${pageContext.request.contextPath}/jsp/login.jsp">Đăng nhập ngay</a>
            </p>
        </div>
    </body>
</html>
