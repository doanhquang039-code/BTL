<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Cập nhật phiếu nhập | Hệ thống Thư viện</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        .form-card { border-radius: 15px; border: none; box-shadow: 0 5px 15px rgba(0,0,0,0.1); max-width: 550px; margin: 50px auto; }
    </style>
</head>
<body class="bg-light">
<div class="container">
    <div class="card form-card">
        <div class="card-header bg-warning py-3 text-center text-dark">
            <h5 class="mb-0 fw-bold"><i class="bi bi-pencil-square me-2"></i> CHỈNH SỬA THÔNG TIN NHẬP KHO</h5>
        </div>
        <div class="card-body p-4">
            <form action="imports?action=update" method="post">
            <input type="hidden" name="importId" value="${importItem.importId}">
                <div class="mb-3">
                    <label class="form-label fw-bold">Sách</label>
                    <select name="bookCode" class="form-select border-warning">
                        <c:forEach var="book" items="${books}">
                            <option value="${book.bookCode}" ${book.bookCode == importItem.book.bookCode ? 'selected' : ''}>
                                ${book.title}
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div class="mb-3">
                    <label class="form-label fw-bold">Số lượng đã nhập</label>
                    <input type="number" name="quantity" class="form-control" value="${importItem.importQuantity}" required>
                </div>

                <div class="mb-3">
                    <label class="form-label fw-bold"><i class="bi bi-calendar-check me-1"></i> Thời gian nhập (Ngày & Giờ)</label>
                    <%-- Sử dụng datetime-local và format đúng chuẩn HTML5 (yyyy-MM-ddTHH:mm) --%>
                    <input type="datetime-local" name="importDate" class="form-control border-warning" 
                           value="${importItem.importDate.toString().replace(' ', 'T').substring(0, 16)}" required>
                    <small class="text-muted">Bạn có thể điều chỉnh lại giờ phút nếu nhập sai.</small>
                </div>

                <div class="mb-3">
                    <label class="form-label fw-bold">Người thực hiện</label>
                    <input type="text" name="importedBy" class="form-control" value="${importItem.importedBy}" required>
                </div>

                <div class="d-flex gap-2 pt-3">
                    <button type="submit" class="btn btn-warning w-100 fw-bold py-2">LƯU THAY ĐỔI</button>
                    <a href="imports" class="btn btn-outline-secondary w-100 fw-bold py-2">QUAY LẠI</a>
                </div>
            </form>
        </div>
    </div>
</div>
</body>
</html>