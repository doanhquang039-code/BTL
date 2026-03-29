<%-- 
    Document   : register
    Created on : Jan 19, 2026, 5:43:15 PM
    Author     : admoi
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký thành viên | Thư viện</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            font-family: 'Roboto', sans-serif;
            height: 100vh;
            margin: 0;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .register-card {
            background: rgba(255, 255, 255, 0.95);
            width: 100%;
            max-width: 450px;
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.2);
            transition: transform 0.3s ease;
        }
        .register-card:hover {
            transform: translateY(-5px);
        }
        .form-label {
            font-weight: 500;
            color: #4a4a4a;
        }
        .input-group-text {
            background-color: transparent;
            border-right: none;
            color: #764ba2;
        }
        .form-control {
            border-left: none;
            padding: 10px 15px;
        }
        .form-control:focus {
            box-shadow: none;
            border-color: #dee2e6;
        }
        .input-group:focus-within .input-group-text,
        .input-group:focus-within .form-control {
            border-color: #764ba2;
            background-color: #fff;
        }
        .btn-register {
            background: linear-gradient(to right, #667eea, #764ba2);
            border: none;
            padding: 12px;
            border-radius: 10px;
            font-weight: bold;
            letter-spacing: 1px;
            transition: opacity 0.3s;
        }
        .btn-register:hover {
            opacity: 0.9;
            color: white;
        }
        .login-link {
            color: #764ba2;
            text-decoration: none;
            font-weight: bold;
        }
        .login-link:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

<div class="register-card">
    <div class="text-center mb-4">
        <div class="display-6 fw-bold text-primary mb-2" style="color: #764ba2 !important;">
            <i class="bi bi-person-plus-fill"></i>
        </div>
        <h2 class="fw-bold" style="color: #333;">Tạo Tài Khoản</h2>
        <p class="text-muted">Khám phá kho tàng tri thức ngay hôm nay</p>
    </div>

    <c:if test="${not empty error}">
        <div class="alert alert-danger alert-dismissible fade show border-0 shadow-sm" role="alert">
            <i class="bi bi-exclamation-triangle-fill me-2"></i> ${error}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>

    <form action="${pageContext.request.contextPath}/register" method="post">
        <div class="mb-3">
            <label class="form-label">Họ và tên</label>
            <div class="input-group">
                <span class="input-group-text"><i class="bi bi-person"></i></span>
                <input type="text" name="fullname" class="form-control" placeholder="Nguyễn Văn A" required>
            </div>
        </div>

        <div class="mb-3">
            <label class="form-label">Tên đăng nhập</label>
            <div class="input-group">
                <span class="input-group-text"><i class="bi bi-person-badge"></i></span>
                <input type="text" name="username" class="form-control" placeholder="username123" required>
            </div>
        </div>

        <div class="mb-4">
            <label class="form-label">Mật khẩu</label>
            <div class="input-group">
                <span class="input-group-text"><i class="bi bi-lock"></i></span>
                <input type="password" name="password" class="form-control" placeholder="Ít nhất 8 ký tự" minlength="8" required>
            </div>
        </div>

        <button type="submit" class="btn btn-register btn-primary w-100 mb-3 text-white">ĐĂNG KÝ NGAY</button>
    </form>

    <div class="text-center mt-3">
        <span class="text-muted">Đã có tài khoản?</span> 
        <a href="login.jsp" class="login-link">Đăng nhập</a>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>