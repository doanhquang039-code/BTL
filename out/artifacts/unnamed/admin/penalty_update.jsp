<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Cập nhật vi phạm</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        body { background: #f6f7f9; font-family: "Segoe UI", system-ui, sans-serif; }
        .form-card { border: 1px solid #e5e7eb; border-radius: 8px; box-shadow: 0 8px 24px rgba(15, 23, 42, 0.06); max-width: 680px; margin: 40px auto; }
        .card-header { background: #374151; border-radius: 8px 8px 0 0 !important; }
        .form-label { color: #374151; font-weight: 600; }
        .btn { border-radius: 6px; }
    </style>
</head>
<body>

<c:set var="homeUrl" value="${pageContext.request.contextPath}/admin-dashboard" />
<c:if test="${sessionScope.userSession.role == 'Manager' || sessionScope.userSession.role == 'manager'}">
    <c:set var="homeUrl" value="${pageContext.request.contextPath}/manager-dash" />
</c:if>

<div class="container">
    <div class="d-flex gap-2 justify-content-center mt-4">
        <a href="${homeUrl}" class="btn btn-outline-secondary btn-sm">
            <i class="bi bi-house-door me-1"></i>Trang chủ
        </a>
        <a href="${pageContext.request.contextPath}/penalties" class="btn btn-outline-dark btn-sm">
            Danh sách vi phạm
        </a>
    </div>

    <div class="card form-card">
        <div class="card-header text-white py-3">
            <h5 class="mb-0 fw-bold text-center">
                <i class="bi bi-pencil-square me-2"></i>Cập nhật thông tin vi phạm
            </h5>
        </div>
        <div class="card-body p-4">
            <form action="${pageContext.request.contextPath}/penalties" method="post">
                <input type="hidden" name="penaltyCode" value="${penalty.penaltyCode}">
                <input type="hidden" name="action" value="update">

                <div class="row mb-3">
                    <div class="col-md-6">
                        <label class="form-label">Mã thành viên</label>
                        <input type="number" name="userCode" class="form-control" value="${penalty.user.userCode}" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Mã phiếu mượn</label>
                        <input type="number" name="borrowingCode" class="form-control" value="${penalty.borrowing.borrowingCode}" required>
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label">Số tiền phạt (VNĐ)</label>
                    <div class="input-group">
                        <span class="input-group-text">đ</span>
                        <input type="text" name="amount" class="form-control fw-bold" value="${penalty.amount}" required>
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label">Lý do vi phạm</label>
                    <textarea name="reason" class="form-control" rows="3" required>${penalty.reason}</textarea>
                </div>

                <div class="mb-4">
                    <label class="form-label">Trạng thái thanh toán</label>
                    <select name="status" class="form-select">
                        <option value="Chưa thanh toán" ${penalty.status == 'Chưa thanh toán' || penalty.status == 'Chua thanh toan' ? 'selected' : ''}>Chưa thanh toán</option>
                        <option value="Đã thanh toán" ${penalty.status == 'Đã thanh toán' || penalty.status == 'Da thanh toan' ? 'selected' : ''}>Đã thanh toán</option>
                    </select>
                </div>

                <div class="d-flex gap-2">
                    <button type="submit" class="btn btn-dark w-100 fw-bold py-2">
                        <i class="bi bi-check-circle me-1"></i>Cập nhật
                    </button>
                    <a href="${pageContext.request.contextPath}/penalties" class="btn btn-outline-secondary w-100 fw-bold py-2">
                        Hủy bỏ
                    </a>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
