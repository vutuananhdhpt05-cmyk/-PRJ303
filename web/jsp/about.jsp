<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Giới Thiệu - ASUS</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="<c:url value='/css/style.css'/>" rel="stylesheet">
</head>
<body>
    <jsp:include page="/jsp/header.jsp" />

    <!-- Hero Section -->
    <section class="hero hero-about">
        <div class="hero-content">
            <h1>Đối Tác Đáng Tin Cậy Của Bạn</h1>
            <p>ASUS luôn lấy khách hàng làm trung tâm, cung cấp các giải pháp nhanh chóng, thông minh và linh hoạt giúp doanh nghiệp đạt được thành công.</p>
        </div>
    </section>

    <!-- Solutions Section -->
    <section id="solutions" class="section">
        <h2>Giải Pháp Công Nghệ Từ ASUS</h2>
        <div class="cards">
            <!-- Card 1: Doanh Nghiệp Vừa & Nhỏ -->
            <div class="card">
                <img src="https://dlcdnwebimgs.asus.com/gain/b8dfedf1-dd00-421b-81b4-7875e238057e/w618/w927/fwebp" alt="Doanh Nghiệp Vừa & Nhỏ">
                <div class="card-content">
                    <h3>Doanh Nghiệp Vừa & Nhỏ</h3>
                    <p>Vươn tầm cao mới nhờ công nghệ từ ASUS, thúc đẩy hiệu suất, làm việc linh hoạt và duy trì bảo mật cho doanh nghiệp.</p>
                </div>
            </div>

            <!-- Card 2: Công Ty -->
            <div class="card">
                <img src="https://dlcdnwebimgs.asus.com/gain/0703644f-b90b-4c4e-844b-99023af9f9e7/w618/w927/fwebp" alt="Công Ty">
                <div class="card-content">
                    <h3>Công Ty</h3>
                    <p>Tăng tốc số hóa, tinh giản quản lý CNTT, tăng cường bảo mật để phát triển doanh nghiệp và giữ chân nhân tài.</p>
                </div>
            </div>

            <!-- Card 3: Giáo Dục -->
            <div class="card">
                <img src="https://dlcdnwebimgs.asus.com/gain/638d28f1-24d1-4856-909f-f5f08d35eb0d/w618/w927/fwebp" alt="Giáo Dục">
                <div class="card-content">
                    <h3>Giáo Dục</h3>
                    <p>Tạo trải nghiệm học tập tuyệt vời với thiết bị và giải pháp từ ASUS, giúp kết nối sáng tạo giữa học sinh và giáo viên.</p>
                </div>
            </div>
        </div>
    </section>


    <jsp:include page="/jsp/footer.jsp" />
</body>
</html>