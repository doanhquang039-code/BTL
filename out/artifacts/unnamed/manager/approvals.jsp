<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Duyệt yêu cầu mượn sách</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
</head>
<body class="bg-light">
<div class="container py-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2 class="fw-bold mb-1">Duyệt yêu cầu mượn sách</h2>
            <p class="text-muted mb-0">Các phiếu mượn đang chờ thủ thư xác nhận.</p>
        </div>
        <a href="${pageContext.request.contextPath}/manager-dash" class="btn btn-outline-secondary">Dashboard</a>
    </div>

    <div class="card border-0 shadow-sm">
        <div class="table-responsive">
            <table class="table align-middle mb-0">
                <thead class="table-dark">
                    <tr>
                        <th>Mã phiếu</th>
                        <th>Độc giả</th>
                        <th>Sách</th>
                        <th>Ngày yêu cầu</th>
                        <th>Ngày hẹn trả</th>
                        <th class="text-center">Xử lý</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="b" items="${requests}">
                        <tr>
                            <td>#${b.borrowingCode}</td>
                            <td>${b.user.fullName} <span class="text-muted small">(${b.user.userCode})</span></td>
                            <td class="fw-bold">${b.book.title}</td>
                            <td>${b.borrowDate}</td>
                            <td>${b.dueDate}</td>
                            <td class="text-center">
                                <a class="btn btn-success btn-sm" href="${pageContext.request.contextPath}/approvals?action=approve&id=${b.borrowingCode}">Duyệt</a>
                                <a class="btn btn-outline-danger btn-sm" href="${pageContext.request.contextPath}/approvals?action=reject&id=${b.borrowingCode}">Từ chối</a>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty requests}">
                        <tr>
                            <td colspan="6" class="text-center text-muted py-4">Không có yêu cầu nào cần duyệt.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>
</body>
</html>
