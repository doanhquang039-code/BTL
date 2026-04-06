<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Nhập kho mới | Hệ thống Thư viện</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        .form-card { border-radius: 20px; border: none; box-shadow: 0 10px 30px rgba(0,0,0,0.1); max-width: 550px; margin: 50px auto; }
    </style>
</head>
<body class="bg-light">
<div class="container">
    <div class="card form-card">
        <div class="card-header bg-dark text-white text-center py-4">
            <h4 class="mb-0 fw-bold"><i class="bi bi-box-arrow-in-right me-2"></i> NHẬP THÊM SÁCH VÀO KHO</h4>
        </div>
        <div class="card-body p-4">
            <form action="imports?action=create" method="post">
                <div class="mb-3">
                    <label class="form-label fw-bold">Chọn sách cần nhập</label>
                    <select name="bookCode" class="form-select form-select-lg border-primary" required>
                        <option value="" disabled selected>-- Chọn đầu sách --</option>
                        <c:forEach var="book" items="${books}">
                            <option value="${book.bookCode}">
                                ${book.title} (Tồn: ${book.quantity} | Tổng nhập cũ: ${book.totalImported})
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label fw-bold">Số lượng nhập thêm</label>
                        <input type="number" name="quantity" class="form-control" min="1" value="1" required>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label fw-bold">Người thực hiện</label>
                        <input type="text" name="importedBy" class="form-control" placeholder="Tên nhân viên" required>
                    </div>
                </div>

                <div class="alert alert-info py-2 small">
                    <i class="bi bi-info-circle me-2"></i> Hệ thống sẽ tự động cập nhật <b>Số lượng tồn kho</b> và <b>Tổng lượng nhập</b> sau khi xác nhận.
                </div>

                <div class="d-flex gap-2 pt-3">
                    <button type="submit" class="btn btn-primary w-100 fw-bold py-2 shadow">XÁC NHẬN NHẬP KHO</button>
                    <a href="imports" class="btn btn-outline-secondary w-100 fw-bold py-2">HỦY BỎ</a>
                </div>
            </form>
        </div>
    </div>
</div>
</body>
</html>