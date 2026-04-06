<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %> <%-- Thư viện định dạng --%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Lịch sử nhập kho | Hệ thống Thư viện</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        body { background-color: #f4f7f6; }
        .table-card { border-radius: 15px; border: none; box-shadow: 0 4px 12px rgba(0,0,0,0.1); }
        .badge-qty { font-size: 0.9rem; padding: 0.5em 0.8em; }
    </style>
</head>
<body>
<div class="container py-5">
    <div class="card table-card">
        <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center py-3">
            <h5 class="mb-0 fw-bold"><i class="bi bi-clock-history me-2"></i> LỊCH SỬ NHẬP KHO CHI TIẾT</h5>
            <a href="imports?action=create" class="btn btn-light btn-sm fw-bold shadow-sm">
                <i class="bi bi-plus-circle-fill me-1"></i> Nhập kho mới
            </a>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover mb-0 align-middle">
                    <thead class="table-light text-center">
                        <tr>
                            <th style="width: 10%">Mã đơn</th>
                            <th class="text-start" style="width: 30%">Thông tin sách</th>
                            <th style="width: 15%">Số lượng</th>
                            <th style="width: 20%">Thời gian nhập</th>
                            <th style="width: 15%">Người thực hiện</th>
                            <th style="width: 10%">Thao tác</th>
                        </tr>
                    </thead>
                    <tbody class="text-center">
                        <c:forEach var="item" items="${imports}">
                            <tr>
                                <td class="text-secondary fw-bold">#${item.importId}</td>
                                <td class="text-start">
                                    <div class="fw-bold text-dark">${item.book.title}</div>
                                    <small class="text-muted">Mã sách: ${item.book.bookCode}</small>
                                </td>
                                <td>
                                    <span class="badge bg-success-subtle text-success badge-qty">
                                        <i class="bi bi-plus-lg"></i> ${item.importQuantity} cuốn
                                    </span>
                                </td>
                                <td>
                                    <%-- Định dạng hiển thị Giờ:Phút Ngày/Tháng/Năm --%>
                                    <div class="fw-semibold">
                                        <fmt:formatDate value="${item.importDate}" pattern="HH:mm" />
                                    </div>
                                    <small class="text-muted">
                                        <fmt:formatDate value="${item.importDate}" pattern="dd/MM/yyyy" />
                                    </small>
                                </td>
                                <td><i class="bi bi-person-badge me-1"></i>${item.importedBy}</td>
                                <td>
                                    <div class="d-flex justify-content-center gap-2">
                                        <a href="imports?action=update&id=${item.importId}" class="text-warning fs-5" title="Sửa"><i class="bi bi-pencil-square"></i></a>
                                        <a href="imports?action=delete&id=${item.importId}" class="text-danger fs-5" 
                                           onclick="return confirm('Bạn có chắc chắn muốn xóa lịch sử này?')" title="Xóa"><i class="bi bi-trash3"></i></a>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
</body>
</html>