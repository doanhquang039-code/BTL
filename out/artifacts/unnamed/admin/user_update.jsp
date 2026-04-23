<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Cập nhật thành viên | Hệ thống Thư viện</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        body { background-color: #f8f9fa; }
        .form-card { border-radius: 15px; border: none; box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.1); max-width: 550px; margin: 50px auto; }
        .form-label { font-weight: 600; color: #495057; }
        .readonly-field { background-color: #e9ecef !important; cursor: not-allowed; }
    </style>
</head>
<body>

<div class="container py-5">
    <div class="card form-card">
        <div class="card-header bg-warning py-3 text-center">
            <h5 class="mb-0 fw-bold text-dark">
                <i class="bi bi-pencil-square me-2"></i> CẬP NHẬT THÔNG TIN THÀNH VIÊN
            </h5>
        </div>
        <div class="card-body p-4">
            <form action="users?action=update" method="post">
                <input type="hidden" name="userCode" value="${user.userCode}">

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Mã số (ID)</label>
                        <input type="text" class="form-control readonly-field" value="#${user.userCode}" readonly>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Tên đăng nhập</label>
                        <%-- Username thường không cho sửa để tránh lỗi liên kết dữ liệu --%>
                        <input type="text" name="username" class="form-control readonly-field" 
                               value="${user.username}" readonly>
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label">Họ và tên thành viên</label>
                    <input type="text" name="fullName" class="form-control" 
                           value="${user.fullName}" required>
                </div>

                <div class="mb-3">
                    <label class="form-label text-danger">Mật khẩu (Password)</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-key"></i></span>
                        <input type="text" name="password" class="form-control" 
                               value="${user.password}" required>
                    </div>
                    <small class="text-muted">Lưu ý: Admin có quyền thay đổi mật khẩu trực tiếp tại đây.</small>
                </div>

                <div class="mb-4">
                    <label class="form-label">Vai trò quản trị</label>
                    <select name="role" class="form-select border-warning">
                        <%-- So sánh đúng các giá trị Role để hiển thị màu Badge chính xác --%>
                        <option value="User" ${user.role == 'user' ? 'selected' : ''}>user (Thành viên)</option>
                        <option value="Manager" ${user.role == 'manager' ? 'selected' : ''}>manager (Quản lý)</option>
                        <option value="Admin" ${user.role == 'admin' ? 'selected' : ''}>admin (Quản trị viên)</option>
                    </select>
                </div>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Ngày sinh</label>
                        <input type="date" name="birthDate" class="form-control" value="${user.birthDate}">
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Chức danh</label>
                        <input type="text" name="position" class="form-control" value="${user.position}">
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label">Địa chỉ</label>
                    <input type="text" name="address" class="form-control" value="${user.address}">
                </div>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label">CMND/CCCD</label>
                        <input type="text" name="identityNumber" class="form-control" value="${user.identityNumber}">
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Tiền ký gửi</label>
                        <input type="number" step="1000" name="depositAmount" class="form-control" value="${user.depositAmount}">
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-4 mb-3">
                        <label class="form-label">Ngày cấp thẻ</label>
                        <input type="date" name="cardIssueDate" class="form-control" value="${user.cardIssueDate}">
                    </div>
                    <div class="col-md-4 mb-3">
                        <label class="form-label">Ngày hết hạn</label>
                        <input type="date" name="cardExpiryDate" class="form-control" value="${user.cardExpiryDate}">
                    </div>
                    <div class="col-md-4 mb-3">
                        <label class="form-label">Số sách được mượn</label>
                        <input type="number" name="maxBorrowBooks" class="form-control" value="${user.maxBorrowBooks}">
                    </div>
                </div>

                <div class="d-flex gap-2">
                    <button type="submit" class="btn btn-warning w-100 fw-bold py-2 shadow-sm">
                        <i class="bi bi-save me-1"></i> LƯU THAY ĐỔI
                    </button>
                    <a href="users" class="btn btn-outline-secondary w-100 fw-bold py-2">
                        QUAY LẠI
                    </a>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
