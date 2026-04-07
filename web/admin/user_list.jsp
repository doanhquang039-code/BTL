<%-- 
    Document   : user_list
    Created on : Jan 20, 2026, 5:00:39 PM
    Author     : admoi
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý người dùng | Hệ thống Thư viện</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        body { background-color: #f8f9fa; }
        .table-card { border-radius: 15px; border: none; box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.1); }
        .table thead { background-color: #0d6efd; color: white; }
        .badge-role { font-size: 0.8rem; padding: 0.5em 1em; border-radius: 30px; min-width: 80px; }
        .table td { vertical-align: middle; }
    </style>
</head>
<body>

<div class="container py-5">
    <div class="card table-card">
        <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center py-3">
            <h5 class="mb-0 fs-5 fw-bold"><i class="bi bi-people-fill me-2"></i> QUẢN LÝ THÀNH VIÊN</h5>
            <div class="d-flex gap-2">
                <a href="${pageContext.request.contextPath}/users" class="btn btn-light btn-sm fw-bold">
                    <i class="bi bi-arrow-clockwise"></i> Làm mới
                </a>
                <a href="users?action=create" class="btn btn-dark btn-sm fw-bold">
                    <i class="bi bi-person-plus-fill me-1"></i> Thêm thành viên
                </a>
            </div>
        </div>
        
        <div class="card-body">
            <div class="row mb-3">
                <div class="col-md-4">
                    <div class="input-group input-group-sm">
                        <input type="text" class="form-control" placeholder="Tìm tên hoặc username...">
                        <button class="btn btn-primary"><i class="bi bi-search"></i></button>
                    </div>
                </div>
            </div>

            <div class="table-responsive">
                <table class="table table-hover align-middle">
                    <thead class="text-center">
                        <tr>
                            <th style="width: 10%">Mã số</th>
                            <th style="width: 20%">Tên đăng nhập</th>
                            <th style="width: 25%">Họ và tên</th>
                            <th style="width: 15%">Mật khẩu</th>
                            <th style="width: 15%">Vai trò</th>
                            <th style="width: 15%">Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="u" items="${users}">
                            <tr class="text-center">
                                <td class="fw-bold text-secondary">#${u.userCode}</td>
                                <td class="fw-semibold">${u.username}</td>
                                <td class="text-start ps-4">${u.fullName}</td>
                                <td>
                                    <code class="text-muted">******</code>
                                </td>
                              <%-- Tìm đến phần hiển thị Vai trò (Role) trong bảng và thay thế bằng đoạn mã này --%>
<td>
    <c:choose>
        <%-- So sánh với chữ thường để an toàn hơn --%>
        <c:when test="${u.role == 'Admin' || u.role == 'admin'}">
            <span class="badge bg-danger badge-role">
                <i class="bi bi-shield-lock-fill me-1"></i> Admin
            </span>
        </c:when>
        <c:when test="${u.role == 'Manager' || u.role == 'manager'}">
            <span class="badge bg-warning text-dark badge-role">
                <i class="bi bi-person-badge-fill me-1"></i> Manager
            </span>
        </c:when>
        <c:otherwise>
            <span class="badge bg-success badge-role">
                <i class="bi bi-person-fill me-1"></i> User
            </span>
        </c:otherwise>
    </c:choose>
</td>
                                <td>
                                    <div class="d-flex justify-content-center gap-1">
                                        <a href="users?action=update&id=${u.userCode}" class="btn btn-sm btn-outline-warning" title="Sửa">
                                            <i class="bi bi-pencil-square"></i> Sửa
                                        </a>
                                        <a href="users?action=delete&id=${u.userCode}" 
                                           class="btn btn-sm btn-outline-danger" 
                                           onclick="return confirm('Bạn có chắc chắn muốn xóa người dùng này?')" title="Xóa">
                                            <i class="bi bi-trash"></i> Xóa
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        
                        <c:if test="${empty users}">
                            <tr>
                                <td colspan="6" class="text-center py-5 text-muted">
                                    Không tìm thấy người dùng nào trong hệ thống.
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
<div class="d-flex align-items-center mb-4">
    <a href="dashboard.jsp" class="btn btn-outline-secondary btn-sm me-3">
        <i class="bi bi-arrow-left"></i> Quay lại
    </a>
    <h2 class="mb-0 fw-bold text-primary">Quản lý Nhập kho</h2>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>