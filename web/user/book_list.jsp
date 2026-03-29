<%-- 
    Document   : book_list.jsp
    Created on : Jan 18, 2026, 5:48:16 PM
    Author     : admoi
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Thư viện sách Online</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        .book-card {
            transition: transform 0.3s;
            height: 100%;
        }
        .book-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.1);
        }
        .book-img-container {
            height: 250px;
            overflow: hidden;
            background: #f8f9fa;
        }
        .book-img {
            width: 100%;
            height: 100%;
            object-fit: contain;
        }
    </style>
</head>
<body class="bg-light">

<nav class="navbar navbar-expand-lg navbar-dark bg-primary mb-4">
    <div class="container">
        <a class="navbar-brand" href="#"><i class="bi bi-book"></i> E-Library</a>
        <div class="collapse navbar-collapse">
            <ul class="navbar-nav me-auto">
                <li class="nav-item"><a class="nav-link active" href="#">Trang chủ</a></li>
                <li class="nav-item"><a class="nav-link" href="#">Sách của tôi</a></li>
            </ul>
            <span class="navbar-text text-white">
                Chào, ${userSession.fullName} | <a href="logout" class="text-white">Thoát</a>
            </span>
        </div>
    </div>
</nav>

<div class="container">
    <h2 class="text-center mb-4">Khám phá kho sách tri thức</h2>

    <div class="row justify-content-center mb-5">
        <div class="col-md-6">
            <form action="${pageContext.request.contextPath}/books" method="post" class="input-group shadow-sm">
                <input type="hidden" name="action" value="search">
                <input type="text" name="name" class="form-control" placeholder="Tìm tên sách hoặc tác giả..." value="${param.name}">
                <button class="btn btn-primary" type="submit"><i class="bi bi-search"></i> Tìm kiếm</button>
            </form>
        </div>
    </div>

    <div class="row row-cols-1 row-cols-md-3 row-cols-lg-4 g-4">
        <c:forEach var="book" items="${books}">
            <div class="col">
                <div class="card book-card border-0 shadow-sm">
                    <div class="book-img-container p-2">
                        <c:choose>
                            <c:when test="${not empty book.image}">
                                <img src="${pageContext.request.contextPath}/${book.image}" 
                                     class="book-img" onerror="this.src='https://via.placeholder.com/200x250?text=No+Cover'">
                            </c:when>
                            <c:otherwise>
                                <img src="https://via.placeholder.com/200x250?text=No+Cover" class="book-img">
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="card-body">
                        <h5 class="card-title text-truncate" title="${book.title}">${book.title}</h5>
                        <p class="card-text text-muted small mb-1">Tác giả: ${book.author}</p>
                        <p class="card-text mb-2">
                            <span class="badge bg-info text-dark">${book.category.name}</span>
                        </p>
                        <div class="d-flex justify-content-between align-items-center mt-3">
                            <span class="text-primary fw-bold">Còn: ${book.quantity} cuốn</span>
                            <c:choose>
                                <c:when test="${book.quantity > 0}">
                                    <a href="borrow?bookId=${book.bookCode}" class="btn btn-outline-primary btn-sm">Mượn ngay</a>
                                </c:when>
                                <c:otherwise>
                                    <button class="btn btn-secondary btn-sm" disabled>Hết sách</button>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>

    <c:if test="${empty books}">
        <div class="alert alert-warning text-center mt-5">
            Rất tiếc, chúng tôi không tìm thấy cuốn sách nào khớp với từ khóa "${param.name}".
        </div>
    </c:if>
</div>



</body>
</html>