<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Gửi phiếu mượn</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-md-8 col-lg-6">
            <div class="card border-0 shadow-sm">
                <div class="card-body p-4">
                    <h3 class="mb-3">Form gửi phiếu mượn</h3>
                    <p class="text-muted mb-1">Mã user: <strong>${sessionScope.userSession.userCode}</strong></p>
                    <p class="text-muted mb-1">Người mượn: <strong>${sessionScope.userSession.fullName}</strong></p>
                    <p class="text-muted mb-1">Mã sách: <strong>${book.bookCode}</strong></p>
                    <p class="text-muted mb-1">Sách: <strong>${book.title}</strong></p>
                    <p class="text-muted mb-1">Tác giả: ${book.author}</p>
                    <p class="text-muted mb-3">Số lượng còn lại: ${book.quantity}</p>

                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-warning">${errorMessage}</div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/borrow-request" method="post">
                        <input type="hidden" name="bookCode" value="${book.bookCode}">
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="borrowDate" class="form-label">Ngày mượn</label>
                                <input type="date" id="borrowDate" name="borrowDate" class="form-control"
                                       value="${empty borrowDateDefault ? '' : borrowDateDefault}" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="dueDate" class="form-label">Hạn trả</label>
                                <input type="date" id="dueDate" name="dueDate" class="form-control"
                                       value="${empty dueDateDefault ? '' : dueDateDefault}" required>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label for="note" class="form-label">Ghi chú (tuỳ chọn)</label>
                            <textarea id="note" name="note" class="form-control" rows="3" placeholder="Ví dụ: Mượn để học môn CSDL"></textarea>
                        </div>
                        <div class="form-check mb-3">
                            <input class="form-check-input" type="checkbox" value="yes" id="confirmRequest" name="confirmRequest">
                            <label class="form-check-label" for="confirmRequest">
                                Tôi đã kiểm tra thông tin và xác nhận gửi phiếu mượn.
                            </label>
                        </div>
                        <div class="d-flex gap-2">
                            <a href="${pageContext.request.contextPath}/books" class="btn btn-outline-secondary">Quay lại</a>
                            <button type="submit" class="btn btn-primary">Xác nhận gửi phiếu mượn</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
