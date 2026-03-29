<%-- 
    Document   : penalty_update
    Created on : Jan 20, 2026, 5:09:45 PM
    Author     : admoi
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Cập nhật vi phạm | Hệ thống Thư viện</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        body { background-color: #f8f9fa; }
        .form-card { border-radius: 15px; border: none; box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.1); max-width: 600px; margin: 50px auto; }
        .card-header { border-top-left-radius: 15px !important; border-top-right-radius: 15px !important; }
        .form-label { font-weight: 600; color: #495057; }
    </style>
</head>
<body>

<div class="container">
    <div class="card form-card">
        <div class="card-header bg-warning py-3">
            <h5 class="mb-0 fw-bold text-dark text-center">
                <i class="bi bi-pencil-square me-2"></i> CẬP NHẬT THÔNG TIN VI PHẠM
            </h5>
        </div>
        <div class="card-body p-4">
            <form action="penalties?action=update" method="post">
                <input type="hidden" name="penaltyCode" value="${penalty.penaltyCode}">

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Mã Thành Viên</label>
                        <input type="text" class="form-control bg-light" value="${penalty.user.userCode}" readonly>
                        <input type="hidden" name="userCode" value="${penalty.user.userCode}">
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Mã Phiếu Mượn</label>
                        <input type="text" class="form-control bg-light" value="${penalty.borrowing.borrowingCode}" readonly>
                        <input type="hidden" name="borrowingCode" value="${penalty.borrowing.borrowingCode}">
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label text-danger">Số tiền phạt (VNĐ)</label>
                    <div class="input-group">
                        <span class="input-group-text bg-danger text-white">₫</span>
                        <input type="number" step="1000" name="amount" class="form-control fw-bold" 
                               value="${penalty.amount}" required>
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label">Lý do vi phạm</label>
                    <textarea name="reason" class="form-control" rows="3" required>${penalty.reason}</textarea>
                </div>

                <div class="mb-4">
                    <label class="form-label">Trạng thái thanh toán</label>
                    <select name="status" class="form-select border-primary">
                        <option value="Chưa thanh toán" ${penalty.status == 'Chưa thanh toán' ? 'selected' : ''}>Chưa thanh toán</option>
                        <option value="Đã thanh toán" ${penalty.status == 'Đã thanh toán' ? 'selected' : ''}>Đã thanh toán</option>
                    </select>
                </div>

                <div class="d-flex gap-2">
                    <button type="submit" class="btn btn-primary w-100 fw-bold py-2 shadow-sm">
                        <i class="bi bi-save me-1"></i> LƯU THAY ĐỔI
                    </button>
                    <a href="penalties" class="btn btn-outline-secondary w-100 fw-bold py-2">
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