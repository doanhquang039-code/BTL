<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý danh mục sách</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body class="container mt-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2 class="mb-1">Quản lý danh mục</h2>
            <div class="d-flex gap-2">
                <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-outline-secondary btn-sm">Về trang chủ</a>
                <a href="${pageContext.request.contextPath}/admin-dashboard" class="btn btn-outline-primary btn-sm">Dashboard admin</a>
            </div>
        </div>
        <a href="${pageContext.request.contextPath}/categories?action=create" class="btn btn-success">Thêm danh mục mới</a>
    </div>

    <form action="${pageContext.request.contextPath}/categories" method="post" class="row g-3 mb-4">
        <input type="hidden" name="action" value="search">
        <div class="col-auto">
            <input type="text" name="name" class="form-control" placeholder="Nhập tên danh mục...">
        </div>
        <div class="col-auto">
            <button type="submit" class="btn btn-primary">Tìm kiếm</button>
        </div>
    </form>

    <table class="table table-bordered table-striped">
        <thead class="table-dark">
            <tr>
                <th>Mã danh mục</th>
                <th>Tên danh mục</th>
                <th>Hành động</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="cat" items="${categories}">
                <tr>
                    <td>${cat.categoryCode}</td>
                    <td>${cat.name}</td>
                    <td>
                        <a href="${pageContext.request.contextPath}/categories?action=update&id=${cat.categoryCode}"
                           class="btn btn-warning btn-sm">Sửa</a>
                        <a href="${pageContext.request.contextPath}/categories?action=delete&id=${cat.categoryCode}"
                           class="btn btn-danger btn-sm"
                           onclick="return confirm('Bạn có chắc chắn muốn xóa danh mục này?')">Xóa</a>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty categories}">
                <tr>
                    <td colspan="3" class="text-center text-muted py-4">Chưa có danh mục nào.</td>
                </tr>
            </c:if>
        </tbody>
    </table>
</body>
</html>
