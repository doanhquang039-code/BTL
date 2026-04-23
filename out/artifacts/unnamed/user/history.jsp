<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Lịch sử mượn sách</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container py-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="fw-bold mb-0">Lịch sử mượn sách</h2>
        <a href="${pageContext.request.contextPath}/user-dashboard" class="btn btn-outline-secondary">Quay lại</a>
    </div>

    <div class="card border-0 shadow-sm">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-dark">
                    <tr>
                        <th>Mã phiếu</th>
                        <th>Tên sách</th>
                        <th>Ngày mượn</th>
                        <th>Hạn trả</th>
                        <th>Ngày trả</th>
                        <th>Trạng thái</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="b" items="${borrowings}">
                        <tr>
                            <td>#${b.borrowingCode}</td>
                            <td class="fw-bold">${b.book.title}</td>
                            <td>${b.borrowDate}</td>
                            <td>${b.dueDate}</td>
                            <td>${empty b.returnDate ? '-' : b.returnDate}</td>
                            <td>${b.status}</td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty borrowings}">
                        <tr>
                            <td colspan="6" class="text-center text-muted py-4">Bạn chưa có lịch sử mượn sách.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>
</body>
</html>
