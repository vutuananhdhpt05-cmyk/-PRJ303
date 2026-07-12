<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/jsp/mgmt_header.jsp">
    <jsp:param name="activeMenu" value="reports" />
    <jsp:param name="pageTitle" value="Báo Cáo Thống Kê" />
</jsp:include>


<div class="container-fluid px-0 mt-3">
    <div class="row mb-4">
        <!-- 1. Monthly Revenue Chart -->
        <div class="col-lg-8 col-md-12 mb-4 mb-lg-0">
            <div class="report-card">
                <div class="report-header text-primary">
                    <i class="fas fa-chart-line"></i> Biểu đồ Doanh thu theo tháng
                </div>
                <div class="report-body">
                    <div class="chart-container">
                        <canvas id="revenueChart"></canvas>
                    </div>
                </div>
            </div>
        </div>

        <!-- 2. Orders by Status Chart -->
        <div class="col-lg-4 col-md-12">
            <div class="report-card">
                <div class="report-header text-info">
                    <i class="fas fa-chart-pie"></i> Trạng thái Đơn hàng
                </div>
                <div class="report-body d-flex justify-content-center align-items-center">
                    <div class="chart-container h-250">
                        <canvas id="statusChart"></canvas>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="row mb-4">
        <!-- 3. Top Selling Products -->
        <div class="col-md-12">
            <div class="report-card">
                <div class="report-header text-danger">
                    <i class="fas fa-fire"></i> Top Sản phẩm bán chạy nhất
                </div>
                <div class="table-responsive">
                    <table class="table table-modern">
                        <thead>
                            <tr>
                                <th class="px-4">Tên Sản phẩm</th>
                                <th class="px-4 text-end">Tổng Đã Bán (chiếc)</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="item" items="${topProducts}">
                                <tr>
                                    <td class="px-4 fw-medium">${item.productName}</td>
                                    <td class="px-4 text-end fw-bold text-danger">${item.totalSold}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
    
    <div class="row mb-4">
        <!-- 4. VIP Customers -->
        <div class="col-lg-6 mb-4 mb-lg-0">
            <div class="report-card">
                <div class="report-header text-warning">
                    <i class="fas fa-crown"></i> Khách Hàng VIP
                </div>
                <div class="table-responsive">
                    <table class="table table-modern">
                        <thead>
                            <tr>
                                <th class="px-4">Khách hàng</th>
                                <th class="px-4 text-end">Tổng Chi Tiêu</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="item" items="${vipCustomers}">
                                <tr>
                                    <td class="px-4">
                                        <div class="fw-bold text-dark">${item.username}</div>
                                        <div class="text-muted small">${item.fullName}</div>
                                    </td>
                                    <td class="px-4 text-end text-success fw-bold">
                                        <fmt:formatNumber value="${item.totalSpent}" type="currency" currencySymbol="$"/>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- 5. Inventory Report -->
        <div class="col-lg-6">
            <div class="report-card">
                <div class="report-header text-secondary">
                    <i class="fas fa-warehouse"></i> Cảnh báo Tồn kho
                </div>
                <div class="table-responsive">
                    <table class="table table-modern">
                        <thead>
                            <tr>
                                <th class="px-4">Sản phẩm</th>
                                <th class="px-4 text-center">Tồn Kho</th>
                                <th class="px-4 text-end">Giá Bán</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="item" items="${inventory}" end="4">
                                <tr>
                                    <td class="px-4 text-truncate mw-200" title="${item.productName}">${item.productName}</td>
                                    <td class="px-4 text-center">
                                        <span class="badge rounded-pill bg-${item.stock < 100 ? 'danger' : (item.stock < 500 ? 'warning text-dark' : 'success')} px-3 py-2">
                                            ${item.stock}
                                        </span>
                                    </td>
                                    <td class="px-4 text-end fw-medium">
                                        <fmt:formatNumber value="${item.price}" type="currency" currencySymbol="$"/>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Thư viện Chart.js -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
document.addEventListener("DOMContentLoaded", function() {
    // 1. Biểu đồ Doanh thu (Line Chart)
    const revCtx = document.getElementById('revenueChart').getContext('2d');
    const revLabels = [];
    const revData = [];
    <c:forEach var="item" items="${monthlyRevenue}">
        revLabels.push("Tháng " + "${item.month}");
        revData.push(${item.revenue});
    </c:forEach>

    let gradient = revCtx.createLinearGradient(0, 0, 0, 400);
    gradient.addColorStop(0, 'rgba(78, 115, 223, 0.5)');
    gradient.addColorStop(1, 'rgba(78, 115, 223, 0.0)');

    new Chart(revCtx, {
        type: 'line',
        data: {
            labels: revLabels,
            datasets: [{
                label: 'Doanh thu ($)',
                data: revData,
                backgroundColor: gradient,
                borderColor: 'rgba(78, 115, 223, 1)',
                pointBackgroundColor: 'rgba(78, 115, 223, 1)',
                pointBorderColor: '#fff',
                pointHoverBackgroundColor: '#fff',
                pointHoverBorderColor: 'rgba(78, 115, 223, 1)',
                fill: true,
                tension: 0.4,
                borderWidth: 2
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: { display: false }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    grid: { borderDash: [2, 4], color: '#eaecf4' }
                },
                x: {
                    grid: { display: false }
                }
            }
        }
    });

    // 2. Biểu đồ Trạng thái Đơn hàng (Doughnut Chart)
    const statusCtx = document.getElementById('statusChart').getContext('2d');
    const statusLabels = [];
    const statusData = [];
    <c:forEach var="item" items="${ordersByStatus}">
        statusLabels.push("${item.status}");
        statusData.push(${item.count});
    </c:forEach>

    new Chart(statusCtx, {
        type: 'doughnut',
        data: {
            labels: statusLabels,
            datasets: [{
                data: statusData,
                backgroundColor: ['#1cc88a', '#f6c23e', '#e74a3b', '#858796', '#36b9cc'],
                hoverBackgroundColor: ['#17a673', '#dda20a', '#be2617', '#60616f', '#2c9faf'],
                hoverBorderColor: "rgba(234, 236, 244, 1)",
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            cutout: '70%',
            plugins: {
                legend: {
                    position: 'bottom',
                    labels: { usePointStyle: true, padding: 20 }
                }
            }
        }
    });
});
</script>

<jsp:include page="/jsp/mgmt_footer.jsp" />

