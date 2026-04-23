<%-- 
    Document   : borrow_save.jsp
    Created on : Jan 19, 2026, 8:41:22 PM
    Author     : admoi
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Tạo phiếu mượn mới | Hệ thống Thư viện</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        body { background-color: #f4f7f6; }
        .save-card {
            max-width: 650px;
            margin: 50px auto;
            border-radius: 15px;
            border: none;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }
        .card-header {
            background: linear-gradient(45deg, #1cc88a, #13855c);
            color: white;
            border-radius: 15px 15px 0 0 !important;
            padding: 20px;
        }
        .form-label { font-weight: 600; color: #13855c; }
        .btn-save { background-color: #1cc88a; color: white; border-radius: 8px; padding: 12px; transition: 0.3s; border: none; }
        .btn-save:hover { background-color: #17a673; transform: translateY(-2px); color: white; }
    </style>
</head>
<body>

<div class="container">
    <div class="card save-card">
        <div class="card-header text-center">
            <h4 class="mb-0"><i class="bi bi-plus-circle-fill me-2"></i> THÊM PHIẾU MƯỢN MỚI</h4>
        </div>
        <div class="card-body p-4">
            
            <%-- Hiển thị thông báo lỗi nếu có --%>
            <c:if test="${not empty error}">
                <div class="alert alert-danger border-0 shadow-sm mb-4">
                    <i class="bi bi-exclamation-triangle-fill me-2"></i> ${error}
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/borrows" method="post">
                <input type="hidden" name="action" value="create">

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Mã thành viên</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-person-badge"></i></span>
                            <input type="number" name="userCode" class="form-control" placeholder="Nhập mã user..." required>
                        </div>
                    </div>

                    <div class="col-md-6 mb-3">
                        <label class="form-label">Mã sách</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-book-half"></i></span>
                            <input type="number" name="bookCode" class="form-control" placeholder="Nhập mã sách..." required>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Ngày mượn</label>
                        <input type="date" name="borrowDate" class="form-control" id="borrowDate" required>
                    </div>

                    <div class="col-md-6 mb-3">
                        <label class="form-label">Hạn trả (Dự kiến)</label>
                        <input type="date" name="dueDate" class="form-control" id="dueDate" required>
                    </div>
                </div>

                <div class="mb-4">
                    <label class="form-label">Trạng thái ban đầu</label>
                    <select name="status" class="form-select">
                        <option value="Đang mượn" selected>Đang mượn</option>
                        <option value="Đã trả">Đã trả (Nhập bù)</option>
                    </select>
                </div>

                <div class="d-grid gap-2 mt-4">
                    <button type="submit" class="btn btn-save fw-bold shadow-sm">
                        <i class="bi bi-check-lg me-2"></i> TẠO PHIẾU MƯỢN
                    </button>
                    <a href="${pageContext.request.contextPath}/borrows" class="btn btn-light text-muted">Hủy và quay lại</a>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    const today = new Date().toISOString().split('T')[0];
    document.getElementById('borrowDate').value = today;
    
    const next2Weeks = new Date();
    next2Weeks.setDate(next2Weeks.getDate() + 14);
    document.getElementById('dueDate').value = next2Weeks.toISOString().split('T')[0];
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
