<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Trả sách</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-md-8 col-lg-6">
            <div class="card border-0 shadow-sm">
                <div class="card-body p-4">
                    <h3 class="mb-3">Form trả sách</h3>
                    <p class="text-muted mb-1">Mã phiếu: <strong>#${borrowing.borrowingCode}</strong></p>
                    <p class="text-muted mb-1">Mã user: <strong>${borrowing.user.userCode}</strong></p>
                    <p class="text-muted mb-1">Người mượn: <strong>${borrowing.user.fullName}</strong></p>
                    <p class="text-muted mb-1">Mã sách: <strong>${borrowing.book.bookCode}</strong></p>
                    <p class="text-muted mb-1">Tên sách: <strong>${borrowing.book.title}</strong></p>
                    <p class="text-muted mb-1">Ngày mượn: ${borrowing.borrowDate}</p>
                    <p class="text-muted mb-3">Hạn trả: ${borrowing.dueDate}</p>

                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-warning">${errorMessage}</div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/history" method="post">
                        <input type="hidden" name="action" value="return">
                        <input type="hidden" name="id" value="${borrowing.borrowingCode}">
                        <div class="row">
                            <div class="col-md-12 mb-3">
                                <label for="returnDate" class="form-label">Ngày trả</label>
                                <input type="date" id="returnDate" name="returnDate" class="form-control"
                                       value="${empty returnDateDefault ? '' : returnDateDefault}" required>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label for="returnNote" class="form-label">Ghi chú trả sách (tuỳ chọn)</label>
                            <textarea id="returnNote" name="returnNote" class="form-control" rows="3" placeholder="Ví dụ: Sách còn mới, đầy đủ trang"></textarea>
                        </div>
                        <div class="form-check mb-3">
                            <input class="form-check-input" type="checkbox" value="yes" id="confirmReturn" name="confirmReturn">
                            <label class="form-check-label" for="confirmReturn">
                                Tôi xác nhận gửi yêu cầu trả cuốn sách này.
                            </label>
                        </div>
                        <div class="d-flex gap-2">
                            <a href="${pageContext.request.contextPath}/history" class="btn btn-outline-secondary">Quay lại</a>
                            <button type="submit" class="btn btn-success">Gửi yêu cầu trả sách</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
