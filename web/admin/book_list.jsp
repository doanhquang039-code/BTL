<%-- 
    Document   : book_list.jsp
    Created on : Jan 18, 2026, 5:15:59 PM
    Author     : admoi
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản lý kho sách - Admin</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        .book-img {
            width: 60px;
            height: 80px;
            object-fit: cover;
            border-radius: 4px;
        }
    </style>
</head>
<body class="bg-light">

<div class="container py-5">
    <div class="card shadow">
        <div class="card-header bg-dark text-white d-flex justify-content-between align-items-center">
            <h3 class="mb-0">DANH SÁCH TẤT CẢ SÁCH</h3>
            <a href="${pageContext.request.contextPath}/books?action=create" class="btn btn-success">
                <i class="bi bi-plus-circle"></i> Thêm sách mới
            </a>
        </div>
        
        <div class="card-body">
          <form action="${pageContext.request.contextPath}/books" method="post" class="row g-3 mb-4">
    <input type="hidden" name="action" value="search">
    
    <div class="col-auto">
        <input type="text" name="name" class="form-control" placeholder="Tìm theo tên hoặc tác giả...">
    </div>
    <div class="col-auto">
        <button type="submit" class="btn btn-primary">Tìm kiếm</button>
        <a href="${pageContext.request.contextPath}/books" class="btn btn-secondary">Tất cả sách</a>
    </div>
</form>

            <div class="table-responsive">
                <table class="table table-hover align-middle border">
                    <thead class="table-light">
                        <tr>
                            <th class="text-center">Mã</th>
                            <th>Ảnh bìa</th>
                            <th>Tên sách</th>
                            <th>Tác giả</th>
                            <th>Danh mục</th>
                            <th class="text-center">Năm XB</th>
                            <th class="text-center">Số lượng</th>
                            <th class="text-center">Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="book" items="${books}">
                            <tr>
                                <td class="text-center fw-bold">${book.bookCode}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty book.image}">
                                            <img src="${pageContext.request.contextPath}/${book.image}" 
                                                 class="book-img shadow-sm border" 
                                                 onerror="this.src='https://via.placeholder.com/60x80?text=No+Img'">
                                        </c:when>
                                        <c:otherwise>
                                            <img src="https://via.placeholder.com/60x80?text=No+Img" class="book-img border">
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="fw-semibold">${book.title}</td>
                                <td>${book.author}</td>
                                <td>
                                    <span class="badge bg-info text-dark">${book.category.name}</span>
                                </td>
                                <td class="text-center">${book.publishYear}</td>
                                <td class="text-center">
                                    <span class="badge ${book.quantity > 0 ? 'bg-success' : 'bg-danger'}">
                                        ${book.quantity}
                                    </span>
                                </td>
                                <td class="text-center">
                                    <a href="${pageContext.request.contextPath}/books?action=update&id=${book.bookCode}" 
                                       class="btn btn-warning btn-sm me-1 shadow-sm">
                                        <i class="bi bi-pencil-square"></i> Sửa
                                    </a>
                                    
                                    <a href="${pageContext.request.contextPath}/books?action=delete&id=${book.bookCode}" 
                                       class="btn btn-danger btn-sm shadow-sm"
                                       onclick="return confirm('Bạn có chắc chắn muốn xóa cuốn sách: ${book.title}?')">
                                        <i class="bi bi-trash"></i> Xóa
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                        
                     <c:forEach var="book" items="${books}">
    <tr>
        </tr>
</c:forEach>

<c:if test="${empty books}">
    <tr>
        <td colspan="8" class="text-center text-danger">
            Không tìm thấy sách hoặc tác giả nào có tên: <strong>${param.name}</strong>
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