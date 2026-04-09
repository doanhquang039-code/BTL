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
         <form action="penalties" method="post">
    <input type="hidden" name="penaltyCode" value="${penalty.penaltyCode}">
    <input type="hidden" name="action" value="update">

    Mã người dùng: <input type="number" name="userCode" value="${penalty.user.userCode}">
    Mã phiếu mượn: <input type="number" name="borrowingCode" value="${penalty.borrowing.borrowingCode}">
    Số tiền: <input type="text" name="amount" value="${penalty.amount}">
    Lý do: <input type="text" name="reason" value="${penalty.reason}">
    Trạng thái: 
    <select name="status">
        <option value="Chưa thanh toán" ${penalty.status == 'Chưa thanh toán' ? 'selected' : ''}>Chưa thanh toán</option>
        <option value="Đã thanh toán" ${penalty.status == 'Đã thanh toán' ? 'selected' : ''}>Đã thanh toán</option>
    </select>
    
    <button type="submit">Cập nhật</button>
</form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>