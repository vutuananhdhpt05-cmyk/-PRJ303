<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Liên Hệ - ASUS</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="<c:url value='/css/style.css'/>" rel="stylesheet">
</head>
<body>
    <jsp:include page="/jsp/header.jsp" />

    <!-- Contact Section -->
    <section class="contact-section">
        <h1>Liên Hệ Với ASUS</h1>

        <!-- Contact Info -->
        <div class="contact-info">
            <h2>Thông Tin Liên Hệ</h2>
            <p><i class="fas fa-building"></i> Công Ty TNHH Công Nghệ Asus (Việt Nam)</p>
            <p><i class="fas fa-map-marker-alt"></i> Trường Đại hoc FPT, Việt Nam</p>
            <p><i class="fas fa-phone"></i> 1800 65 88</p>
            
        </div>

        <!-- Contact Form -->
        <div class="contact-form">
            <h2>Gửi Tin Nhắn</h2>
            <form action="<c:url value='/ContactServlet'/>" method="post">
                <label for="name">Họ và Tên <span class="text-error">*</span></label>
                <input type="text" id="name" name="name" required placeholder="Nhập họ và tên">

                <label for="email">Email <span class="text-error">*</span></label>
                <input type="email" id="email" name="email" required placeholder="Nhập email">

                <label for="phone">Số Điện Thoại</label>
                <input type="tel" id="phone" name="phone" placeholder="Nhập số điện thoại">

                <label for="message">Tin Nhắn <span class="text-error">*</span></label>
                <textarea id="message" name="message" required placeholder="Nhập tin nhắn của bạn"></textarea>

                <button type="submit"><i class="fas fa-paper-plane"></i> Gửi Tin Nhắn</button>
            </form>
            <c:if test="${not empty sessionScope.formMessage}">
                <p class="form-message ${sessionScope.formStatus}"><c:out value="${sessionScope.formMessage}" /></p>
                <c:remove var="formMessage" scope="session"/>
                <c:remove var="formStatus" scope="session"/>
            </c:if>
        </div>
    </section>

    <jsp:include page="/jsp/footer.jsp" />
</body>
</html>