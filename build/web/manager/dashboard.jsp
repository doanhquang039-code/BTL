<%-- 
    Document   : dashboard.jsp
    Created on : Apr 7, 2026, 4:28:25 PM
    Author     : admoi
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
    <div class="d-flex">
    <nav id="sidebar" class="bg-dark text-white" style="min-width: 250px;">
        <div class="p-4 text-center border-bottom border-secondary">
            <h5 class="text-success fw-bold">MANAGER PANEL</h5>
        </div>
        <ul class="nav flex-column p-3">
            <li class="nav-item"><a class="nav-link text-white active" href="manager-dash"><i class="bi bi-graph-up me-2"></i> Thống kê mượn trả</a></li>
            <li class="nav-item"><a class="nav-link text-white" href="approvals"><i class="bi bi-check2-circle me-2"></i> Duyệt yêu cầu mượn</a></li>
            <li class="nav-item"><a class="nav-link text-white" href="penalties"><i class="bi bi-info-circle me-2"></i> Xử lý vi phạm</a></li>
            <li class="nav-item"><a class="nav-link text-white" href="books"><i class="bi bi-book me-2"></i> Danh mục sách</a></li>
        </ul>
    </nav>

    <div class="flex-grow-1 p-4">
        <h2 class="fw-bold mb-4">Điều hành Thư viện</h2>
        <div class="row g-3">
            <div class="col-md-4">
                <div class="card border-0 shadow-sm bg-primary text-white p-3">
                    <h6>Yêu cầu chờ duyệt</h6>
                    <h2 class="fw-bold">${pendingApprovals}</h2>
                    <a href="approvals" class="text-white-50 small">Xem chi tiết -></a>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card border-0 shadow-sm bg-warning text-dark p-3">
                    <h6>Sách quá hạn chưa trả</h6>
                    <h2 class="fw-bold">${overdueBooks}</h2>
                    <a href="penalties" class="text-dark-50 small">Gửi thông báo ngay -></a>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card border-0 shadow-sm bg-info text-white p-3">
                    <h6>Lượt mượn hôm nay</h6>
                    <h2 class="fw-bold">${todayBorrows}</h2>
                </div>
            </div>
        </div>
    </div>
</div>
    </body>
</html>
