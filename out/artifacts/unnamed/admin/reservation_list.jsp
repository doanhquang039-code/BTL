<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Danh sách đặt trước</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
</head>
<body class="bg-light">
<div class="container mt-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="fw-bold text-info mb-0"><i class="bi bi-clock-history"></i> Danh sách đặt trước</h2>
        <a href="${pageContext.request.contextPath}/admin-dashboard" class="btn btn-outline-secondary">Trang chủ</a>
    </div>

    <div class="card shadow border-0">
        <div class="card-body">
            <div class="table-responsive">
                <table class="table align-middle">
                    <thead>
                        <tr>
                            <th>STT</th>
                            <th>Thành viên</th>
                            <th>Tên sách</th>
                            <th>Ngày đặt</th>
                            <th>Trạng thái</th>
                            <th>Ưu tiên</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="r" items="${reservations}" varStatus="loop">
                            <tr>
                                <td>${loop.index + 1}</td>
                                <td>${r.user.fullName}</td>
                                <td><strong>${r.book.title}</strong></td>
                                <td>${r.reserveDate}</td>
                                <td>${r.status}</td>
                                <td><span class="badge bg-info">Hạng ${loop.index + 1}</span></td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty reservations}">
                            <tr>
                                <td colspan="6" class="text-center text-muted py-4">Chưa có lượt đặt trước nào.</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
</body>
</html>
