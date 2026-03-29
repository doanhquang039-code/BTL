<%-- 
    Document   : book_save.jsp
    Created on : Jan 18, 2026, 5:16:22 PM
    Author     : admoi
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${book != null ? "Cập nhật sách" : "Thêm sách mới"}</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body class="container mt-5">
    <div class="card shadow">
        <div class="card-header bg-success text-white">
            <h4>${book != null ? "CẬP NHẬT THÔNG TIN SÁCH" : "THÊM SÁCH MỚI"}</h4>
        </div>
        <div class="card-body">
            <form action="${pageContext.request.contextPath}/books" method="post" enctype="multipart/form-data">
                <input type="hidden" name="action" value="${book != null ? 'update' : 'create'}">
                <c:if test="${book != null}">
                    <input type="hidden" name="id" value="${book.bookCode}">
                    <input type="hidden" name="oldImage" value="${book.image}">
                </c:if>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Tiêu đề sách:</label>
                        <input type="text" class="form-control" name="title" value="${book.title}" required>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Tác giả:</label>
                        <input type="text" class="form-control" name="author" value="${book.author}">
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Danh mục:</label>
                        <select name="categoryCode" class="form-select" required>
                            <option value="">-- Chọn danh mục --</option>
                            <c:forEach var="cat" items="${categories}">
                                <option value="${cat.categoryCode}" 
                                    ${book.category.categoryCode == cat.categoryCode ? 'selected' : ''}>
                                    ${cat.name}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-3 mb-3">
                        <label class="form-label">Năm xuất bản:</label>
                        <input type="text" class="form-control" name="publishYear" value="${book.publishYear}">
                    </div>
                    <div class="col-md-3 mb-3">
                        <label class="form-label">Số lượng:</label>
                        <input type="number" class="form-control" name="quantity" value="${book.quantity != null ? book.quantity : 0}">
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label">Chọn ảnh bìa sách:</label>
                    <input type="file" class="form-control" name="image" accept="image/*">
                    <c:if test="${book != null && book.image != null}">
                        <div class="mt-2">
                            <small>Ảnh hiện tại:</small><br>
                            <img src="${pageContext.request.contextPath}/${book.image}" width="100" class="img-thumbnail">
                        </div>
                    </c:if>
                </div>

                <div class="mt-4">
                    <button type="submit" class="btn btn-primary px-4">Lưu dữ liệu</button>
                    <a href="${pageContext.request.contextPath}/books" class="btn btn-secondary">Quay lại</a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>