<%-- 
    Document   : user_save
    Created on : Jan 20, 2026, 5:37:07 PM
    Author     : admoi
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thêm thành viên mới</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        body { background-color: #f8f9fa; }
        .form-card { border-radius: 15px; border: none; box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.1); max-width: 550px; margin: 50px auto; }
        .card-header { border-top-left-radius: 15px; border-top-right-radius: 15px; }
    </style>
</head>
<body>

<div class="container">
    <div class="card form-card">
        <div class="card-header bg-dark text-white py-3 text-center">
            <h5 class="mb-0 fw-bold"><i class="bi bi-person-plus-fill me-2"></i> THÊM THÀNH VIÊN MỚI</h5>
        </div>
        <div class="card-body p-4">
            <form action="users?action=create" method="post">
                <div class="mb-3">
                    <label class="form-label fw-bold">Tên đăng nhập (Username)</label>
                    <input type="text" name="username" class="form-control" placeholder="Nhập tên đăng nhập..." required>
                </div>

                <div class="mb-3">
                    <label class="form-label fw-bold">Mật khẩu</label>
                    <input type="password" name="password" class="form-control" placeholder="Nhập mật khẩu..." required>
                </div>

                <div class="mb-3">
                    <label class="form-label fw-bold">Họ và tên</label>
                    <input type="text" name="fullName" class="form-control" placeholder="Nhập họ tên đầy đủ..." required>
                </div>

                <div class="mb-4">
                    <label class="form-label fw-bold">Vai trò hệ thống</label>
                    <select name="role" class="form-select border-primary">
                        <option value="User" selected>User (Thành viên mượn sách)</option>
                        <option value="Manager">Manager (Thủ thư)</option>
                        <option value="Admin">Admin (Quản trị viên)</option>
                    </select>
                </div>

                <div class="d-flex gap-2">
                    <button type="submit" class="btn btn-primary w-100 fw-bold py-2">LƯU THÀNH VIÊN</button>
                    <a href="users" class="btn btn-outline-secondary w-100 fw-bold py-2">HỦY BỎ</a>
                </div>
            </form>
        </div>
    </div>
</div>

</body>
</html>