<%-- 
    Document   : penalty_save
    Created on : Jan 20, 2026, 5:25:25 PM
    Author     : admoi
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thêm vi phạm mới | Hệ thống Thư viện</title>
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
        <div class="card-header bg-danger text-white py-3 text-center">
            <h5 class="mb-0 fw-bold">
                <i class="bi bi-exclamation-triangle-fill me-2"></i> TẠO PHIẾU PHẠT VI PHẠM
            </h5>
        </div>
        <div class="card-body p-4">
            <%-- Hiển thị thông báo lỗi nếu có --%>
            <c:if test="${not empty error}">
                <div class="alert alert-danger">${error}</div>
            </c:if>

            <form action="penalties?action=create" method="post">
                <div class="row mb-3">
                    <div class="col-md-6">
                        <label class="form-label">Mã Thành Viên (User Code)</label>
                        <input type="number" name="userCode" class="form-control" 
                               placeholder="VD: 1001" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Mã Phiếu Mượn</label>
                        <input type="number" name="borrowingCode" class="form-control" 
                               placeholder="VD: 4001" required>
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label text-danger">Số tiền phạt (VNĐ)</label>
                    <div class="input-group">
                        <span class="input-group-text bg-danger text-white">₫</span>
                        <input type="number" step="1000" name="amount" class="form-control fw-bold" 
                               placeholder="Nhập số tiền..." required>
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label">Lý do vi phạm</label>
                    <textarea name="reason" class="form-control" rows="3" 
                              placeholder="VD: Trả sách muộn 3 ngày, làm rách bìa..." required></textarea>
                </div>

                <div class="mb-4">
                    <label class="form-label">Trạng thái thanh toán</label>
                    <select name="status" class="form-select border-danger">
                        <option value="Chưa thanh toán" selected>Chưa thanh toán</option>
                        <option value="Đã thanh toán">Đã thanh toán</option>
                    </select>
                </div>

                <div class="d-flex gap-2">
                    <button type="submit" class="btn btn-danger w-100 fw-bold py-2 shadow-sm">
                        <i class="bi bi-check-circle me-1"></i> XÁC NHẬN PHẠT
                    </button>
                    <a href="penalties" class="btn btn-outline-secondary w-100 fw-bold py-2">
                        HỦY BỎ
                    </a>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>