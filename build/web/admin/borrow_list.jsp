<%-- 
    Document   : borrow_list.jsp
    Created on : Jan 19, 2026, 7:50:47 PM
    Author     : admoi
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý mượn trả sách-admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        body { background-color: #f8f9fa; }
        .table-card { border-radius: 15px; border: none; box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.1); }
        .table thead { background-color: #212529; color: white; }
        .badge-status { font-size: 0.85rem; padding: 0.5em 0.8em; border-radius: 30px; }
    </style>
</head>
<body>

<div class="container py-5">
    <div class="card table-card mb-4">
        <div class="card-header bg-dark text-white d-flex justify-content-between align-items-center py-3">
            <h5 class="mb-0 fs-4 fw-bold">DANH SÁCH TẤT CẢ PHIẾU MƯỢN</h5>
            <a href="borrow?action=create" class="btn btn-success btn-sm">
                <i class="bi bi-plus-circle me-1"></i> Thêm phiếu mới
            </a>
        </div>
        
      <div class="card-body">
            <div class="row mb-3">
                <div class="col-md-8">
                    <div class="d-flex gap-2">
                        <div class="input-group input-group-sm" style="max-width: 300px;">
                            <input type="text" class="form-control" placeholder="Tìm theo mã hoặc tên...">
                            <button class="btn btn-primary" type="button">
                                <i class="bi bi-search"></i> Tìm kiếm
                            </button>
                        </div>
                        
                        <a href="${pageContext.request.contextPath}/borrow" class="btn btn-sm btn-secondary d-flex align-items-center">
                            <i class="bi bi-arrow-clockwise me-1"></i> Làm mới
                        </a>
                    </div>
                </div>
            </div>

            <div class="table-responsive">

            <div class="table-responsive">
                <table class="table table-hover align-middle">
                    <thead class="text-center">
                        <tr>
                            <th style="width: 5%">Mã</th>
                            <th style="width: 20%">Người mượn</th>
                            <th style="width: 25%">Tên sách</th>
                            <th style="width: 15%">Ngày mượn</th>
                            <th style="width: 15%">Hạn trả</th>
                            <th style="width: 10%">Trạng thái</th>
                            <th style="width: 10%">Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="b" items="${borrowings}">
                            <tr>
                                <td class="text-center fw-bold">${b.borrowingCode}</td>
                                <td>
                                    <div class="fw-bold">${b.user.fullName}</div>
                                    <small class="text-muted">ID: ${b.user.userCode}</small>
                                </td>
                                <td>
                                    <div class="text-primary fw-bold">${b.book.title}</div>
                                </td>
                                <td class="text-center">${b.borrowDate}</td>
                                <td class="text-center">${b.dueDate}</td>
                              <td class="text-center">
    <c:choose>
        <c:when test="${b.status == 'Đã trả'}">
            <span class="badge bg-success badge-status">Đã trả</span>
        </c:when>
        <c:when test="${b.status == 'Quá hạn'}">
            <span class="badge bg-danger badge-status">Quá hạn</span>
        </c:when>
        <c:otherwise>
            <span class="badge bg-warning text-dark badge-status">Đang mượn</span>
        </c:otherwise>
    </c:choose>
</td>
                                <td class="text-center">
                                    <div class="d-flex justify-content-center gap-1">
                                        <a href="borrow?action=update&id=${b.borrowingCode}" 
                                           class="btn btn-warning btn-sm" title="Sửa">
                                            <i class="bi bi-pencil-square"></i> Sửa
                                        </a>
                                        <c:if test="${b.status != 'Đã trả'}">
                                            <a href="borrow?action=return&id=${b.borrowingCode}" 
                                               class="btn btn-danger btn-sm" 
                                               onclick="return confirm('Xác nhận trả sách này?')">
                                                <i class="bi bi-arrow-return-left"></i> Trả
                                            </a>
                                        </c:if>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        
                        <%-- Thông báo nếu danh sách trống --%>
                        <c:if test="${empty borrowings}">
                            <tr>
                                <td colspan="7" class="text-center py-4 text-muted">
                                    Không có dữ liệu phiếu mượn nào được tìm thấy.
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>