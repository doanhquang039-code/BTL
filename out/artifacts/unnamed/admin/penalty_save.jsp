<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thêm vi phạm mới</title>
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
                <i class="bi bi-exclamation-triangle me-2"></i>Tạo phiếu phạt vi phạm
            </h5>
        </div>
        <div class="card-body p-4">
            <c:if test="${not empty error}">
                <div class="alert alert-danger">${error}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/penalties?action=create" method="post">
                <div class="row mb-3">
                    <div class="col-md-6">
                        <label class="form-label">Mã thành viên</label>
                        <input type="number" name="userCode" class="form-control" placeholder="VD: 3" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Mã phiếu mượn</label>
                        <input type="number" name="borrowingCode" class="form-control" placeholder="VD: 1" required>
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label">Số tiền phạt (VNĐ)</label>
                    <div class="input-group">
                        <span class="input-group-text">đ</span>
                        <input type="number" step="1000" name="amount" class="form-control fw-bold" placeholder="Nhập số tiền..." required>
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label">Lý do vi phạm</label>
                    <textarea name="reason" class="form-control" rows="3" placeholder="VD: Trả sách muộn 3 ngày, làm rách bìa..." required></textarea>
                </div>

                <div class="mb-4">
                    <label class="form-label">Trạng thái thanh toán</label>
                    <select name="status" class="form-select">
                        <option value="Chưa thanh toán" selected>Chưa thanh toán</option>
                        <option value="Đã thanh toán">Đã thanh toán</option>
                    </select>
                </div>

                <div class="d-flex gap-2">
                    <button type="submit" class="btn btn-dark w-100 fw-bold py-2">
                        <i class="bi bi-check-circle me-1"></i>Lưu phiếu phạt
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
