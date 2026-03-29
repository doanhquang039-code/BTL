<%-- 
    Document   : save
    Created on : Jan 17, 2026, 5:08:48 PM
    Author     : admoi
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${category != null ? "Cập nhật danh mục" : "Thêm danh mục mới"}</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body class="container mt-5">
    <div class="card">
        <div class="card-header bg-primary text-white">
            <h4>${category != null ? "CẬP NHẬT DANH MỤC" : "THÊM DANH MỤC MỚI"}</h4>
        </div>
        <div class="card-body">
            <form action="${pageContext.request.contextPath}/categories" method="post">
                <input type="hidden" name="action" value="${category != null ? 'update' : 'create'}">
                
                <c:if test="${category != null}">
                    <input type="hidden" name="id" value="${category.categoryCode}">
                </c:if>

                <div class="mb-3">
                    <label for="name" class="form-label">Tên danh mục:</label>
                    <input type="text" class="form-control" id="name" name="name" 
                           value="${category != null ? category.name : ''}" required>
                </div>

                <div class="mt-4">
                    <button type="submit" class="btn btn-success">Lưu lại</button>
                    <a href="${pageContext.request.contextPath}/categories" class="btn btn-secondary">Quay lại danh sách</a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>