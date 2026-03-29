<%-- 
    Document   : borrow_update.jsp
    Created on : Jan 19, 2026, 8:24:33 PM
    Author     : admoi
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chỉnh sửa phiếu mượn | Hệ thống Thư viện</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        body { background-color: #f4f7f6; }
        .update-card {
            max-width: 600px;
            margin: 50px auto;
            border-radius: 15px;
            border: none;
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
        }
        .card-header {
            background: linear-gradient(45deg, #4e73df, #224abe);
            color: white;
            border-radius: 15px 15px 0 0 !important;
            padding: 20px;
        }
        .form-label { font-weight: 600; color: #4e73df; }
        .btn-update { background-color: #4e73df; color: white; border-radius: 8px; padding: 10px 20px; transition: 0.3s; }
        .btn-update:hover { background-color: #224abe; color: white; transform: translateY(-2px); }
    </style>
</head>
<body>

<div class="container">
    <div class="card update-card">
        <div class="card-header text-center">
            <h4 class="mb-0"><i class="bi bi-pencil-square me-2"></i> CHỈNH SỬA PHIẾU MƯỢN</h4>
        </div>
        <div class="card-body p-4">
            <form action="${pageContext.request.contextPath}/borrow" method="post">
                <input type="hidden" name="action" value="update">
                
                <input type="hidden" name="borrowingCode" value="${borrowing.borrowingCode}">

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Mã thành viên</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-person"></i></span>
                            <input type="number" name="userCode" class="form-control" 
                                   value="${borrowing.user.userCode}" required>
                        </div>
                        <small class="text-muted">Tên: ${borrowing.user.fullName}</small>
                    </div>

                    <div class="col-md-6 mb-3">
                        <label class="form-label">Mã sách</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-book"></i></span>
                            <input type="number" name="bookCode" class="form-control" 
                                   value="${borrowing.book.bookCode}" required>
                        </div>
                        <small class="text-muted">Tên sách: ${borrowing.book.title}</small>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Ngày mượn</label>
                        <input type="date" name="borrowDate" class="form-control" 
                               value="${borrowing.borrowDate}" required>
                    </div>

                    <div class="col-md-6 mb-3">
                        <label class="form-label">Hạn trả</label>
                        <input type="date" name="dueDate" class="form-control" 
                               value="${borrowing.dueDate}" required>
                    </div>
                </div>

                <div class="mb-4">
                    <label class="form-label">Trạng thái phiếu</label>
                    <select name="status" class="form-select">
                        <option value="Đang mượn" ${borrowing.status == 'Đang mượn' ? 'selected' : ''}>Đang mượn</option>
                        <option value="Đã trả" ${borrowing.status == 'Đã trả' ? 'selected' : ''}>Đã trả</option>
                        <option value="Quá hạn" ${borrowing.status == 'Quá hạn' ? 'selected' : ''}>Quá hạn</option>
                    </select>
                </div>

                <div class="d-grid gap-2">
                    <button type="submit" class="btn btn-update fw-bold">
                        <i class="bi bi-save me-2"></i> LƯU THAY ĐỔI
                    </button>
                    <a href="borrow" class="btn btn-outline-secondary">Hủy bỏ</a>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>