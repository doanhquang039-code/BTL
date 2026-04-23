<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thống kê mượn trả</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
</head>
<body class="bg-light">
<div class="container py-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2 class="fw-bold mb-1">Thống kê mượn trả sách</h2>
            <p class="text-muted mb-0">Liệt kê đầu sách theo số lần được mượn để lập kế hoạch bổ sung hoặc hủy sách.</p>
        </div>
        <a href="${pageContext.request.contextPath}/admin-dashboard" class="btn btn-outline-secondary">
            <i class="bi bi-house"></i> Trang chủ
        </a>
    </div>

    <div class="card border-0 shadow-sm">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-dark">
                    <tr>
                        <th>#</th>
                        <th>Tên sách</th>
                        <th>Tác giả</th>
                        <th>Thể loại</th>
                        <th>NXB</th>
                        <th>Năm XB</th>
                        <th class="text-center">Số lần mượn</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="row" items="${bookStats}" varStatus="loop">
                        <tr>
                            <td>${loop.index + 1}</td>
                            <td class="fw-bold">${row.title}</td>
                            <td>${row.author}</td>
                            <td>${row.categoryName}</td>
                            <td>${empty row.publisher ? 'Chưa cập nhật' : row.publisher}</td>
                            <td>${row.publishYear}</td>
                            <td class="text-center">
                                <span class="badge bg-primary">${row.borrowCount}</span>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty bookStats}">
                        <tr>
                            <td colspan="7" class="text-center text-muted py-4">Chưa có dữ liệu thống kê.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>
</body>
</html>
