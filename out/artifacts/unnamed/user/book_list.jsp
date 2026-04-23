<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thư viện sách Online</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        body { background: #f6f7f9; }
        .book-card { transition: transform 0.25s, box-shadow 0.25s; height: 100%; border-radius: 8px; }
        .book-card:hover { transform: translateY(-4px); box-shadow: 0 10px 20px rgba(15, 23, 42, 0.08); }
        .book-img-container { height: 250px; overflow: hidden; background: #f8f9fa; }
        .book-img { width: 100%; height: 100%; object-fit: contain; }
        .btn { border-radius: 6px; }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark bg-primary mb-4">
    <div class="container">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/index.jsp">
            <i class="bi bi-book"></i> E-Library
        </a>
        <div class="collapse navbar-collapse">
            <ul class="navbar-nav me-auto">
                <li class="nav-item"><a class="nav-link active" href="${pageContext.request.contextPath}/index.jsp">Trang chủ</a></li>
                <c:if test="${sessionScope.userSession.role == 'User' || sessionScope.userSession.role == 'user'}">
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/history">Sách của tôi</a></li>
                </c:if>
                <c:if test="${sessionScope.userSession.role == 'Manager' || sessionScope.userSession.role == 'manager'}">
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/manager-dash">Dashboard manager</a></li>
                </c:if>
            </ul>
            <span class="navbar-text text-white">
                Chào, ${userSession.fullName} | <a href="${pageContext.request.contextPath}/logout" class="text-white">Thoát</a>
            </span>
        </div>
    </div>
</nav>

<div class="container">
    <h2 class="text-center mb-4">Khám phá kho sách tri thức</h2>

    <c:if test="${param.msg == 'requested'}">
        <div class="alert alert-success text-center">Đã gửi phiếu mượn. Vui lòng chờ thủ thư duyệt.</div>
    </c:if>
    <c:if test="${param.msg == 'duplicate'}">
        <div class="alert alert-warning text-center">Bạn đã gửi phiếu mượn cho sách này. Vui lòng chờ thủ thư duyệt.</div>
    </c:if>
    <c:if test="${param.msg == 'unavailable'}">
        <div class="alert alert-warning text-center">Sách này hiện không còn trong kho.</div>
    </c:if>
    <c:if test="${param.msg == 'readerOnly'}">
        <div class="alert alert-info text-center">Chỉ tài khoản độc giả mới được gửi phiếu mượn.</div>
    </c:if>
    <c:if test="${param.msg == 'invalid'}">
        <div class="alert alert-danger text-center">Không xác định được sách cần mượn. Vui lòng thử lại.</div>
    </c:if>

    <c:if test="${sessionScope.userSession.role == 'Manager' || sessionScope.userSession.role == 'manager'}">
        <div class="alert alert-info text-center">
            Tài khoản thủ thư chỉ xem danh mục sách và duyệt phiếu mượn. Để gửi phiếu mượn, hãy đăng nhập bằng tài khoản độc giả.
        </div>
    </c:if>

    <div class="row justify-content-center mb-5">
        <div class="col-md-6">
            <form action="${pageContext.request.contextPath}/books" method="post" class="input-group shadow-sm">
                <input type="hidden" name="action" value="search">
                <input type="text" name="name" class="form-control" placeholder="Tìm tên sách, tác giả, NXB, năm xuất bản..." value="${param.name}">
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
                        <p class="card-text text-muted small mb-1">NXB: ${empty book.publisher ? 'Chưa cập nhật' : book.publisher}</p>
                        <p class="card-text text-muted small mb-1">Năm XB: ${book.publishYear}</p>
                        <p class="card-text mb-2">
                            <span class="badge bg-info text-dark">${book.category.name}</span>
                        </p>
                        <div class="d-flex justify-content-between align-items-center mt-3">
                            <span class="text-primary fw-bold">Còn: ${book.quantity} cuốn</span>
                            <c:choose>
                                <c:when test="${book.quantity <= 0}">
                                    <button class="btn btn-secondary btn-sm" disabled>Hết sách</button>
                                </c:when>
                                <c:when test="${sessionScope.userSession.role == 'User' || sessionScope.userSession.role == 'user'}">
                                    <form action="${pageContext.request.contextPath}/borrow-request" method="post" class="m-0">
                                        <input type="hidden" name="bookCode" value="${book.bookCode}">
                                        <button type="submit" class="btn btn-outline-primary btn-sm">Gửi phiếu mượn</button>
                                    </form>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-light text-muted border">Chỉ độc giả được mượn</span>
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
