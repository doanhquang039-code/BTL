<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thống kê mượn trả</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
</head>
<body class="bg-light">
<div class="container py-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2 class="fw-bold mb-1">Thống kê mượn trả sách</h2>
            <p class="text-muted mb-0">Liệt kê đầu sách theo số lần được mượn để lập kế hoạch bổ sung hoặc hủy sách.</p>
        </div>
        <a href="${pageContext.request.contextPath}/admin-dashboard" class="btn btn-outline-secondary">
            <i class="bi bi-house"></i> Trang chủ
        </a>
    </div>

    <form action="statistics" method="get" class="row g-2 mb-3">
        <div class="col-md-4">
            <input type="text" name="keyword" class="form-control" placeholder="Tìm theo tên sách, tác giả, NXB..." value="${keyword}">
        </div>
        <div class="col-md-3">
            <select name="category" class="form-select">
                <option value="">-- Chọn danh mục --</option>
                <c:forEach var="c" items="${categories}">
                    <option value="${c.name}" ${fn:toLowerCase(category) == fn:toLowerCase(c.name) ? 'selected' : ''}>${c.name}</option>
                </c:forEach>
            </select>
        </div>
        <div class="col-md-2">
            <input type="number" min="0" name="minBorrow" class="form-control" placeholder="Mượn từ..." value="${minBorrow}">
        </div>
        <div class="col-md-1">
            <select name="startsWith" class="form-select">
                <option value="">A-Z</option>
                <c:forEach var="ch" items="${fn:split('A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z', ',')}">
                    <option value="${ch}" ${startsWith == ch ? 'selected' : ''}>${ch}</option>
                </c:forEach>
            </select>
        </div>
        <div class="col-md-1">
            <button class="btn btn-outline-primary w-100" type="submit">Lọc</button>
        </div>
        <div class="col-md-1">
            <a href="statistics" class="btn btn-outline-secondary w-100">Xóa</a>
        </div>
    </form>

    <div class="card border-0 shadow-sm">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-dark">
                    <tr>
                        <th>#</th>
                        <th>Tên sách</th>
                        <th>Tác giả</th>
                        <th>Thể loại</th>
                        <th>NXB</th>
                        <th>Năm XB</th>
                        <th class="text-center">Số lần mượn</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="row" items="${bookStats}" varStatus="loop">
                        <tr>
                            <td>${loop.index + 1}</td>
                            <td class="fw-bold">${row.title}</td>
                            <td>${row.author}</td>
                            <td>${row.categoryName}</td>
                            <td>${empty row.publisher ? 'Chưa cập nhật' : row.publisher}</td>
                            <td>${row.publishYear}</td>
                            <td class="text-center">
                                <span class="badge bg-primary">${row.borrowCount}</span>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty bookStats}">
                        <tr>
                            <td colspan="7" class="text-center text-muted py-4">Chưa có dữ liệu thống kê.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
        <div class="d-flex justify-content-between align-items-center p-3">
            <small class="text-muted">Tổng: ${totalItems} bản ghi</small>
            <nav>
                <ul class="pagination pagination-sm mb-0">
                    <li class="page-item ${currentPage <= 1 ? 'disabled' : ''}">
                        <a class="page-link" href="statistics?keyword=${keyword}&category=${category}&minBorrow=${minBorrow}&startsWith=${startsWith}&page=${currentPage - 1}">Trước</a>
                    </li>
                    <c:forEach begin="1" end="${totalPages}" var="p">
                        <li class="page-item ${p == currentPage ? 'active' : ''}">
                            <a class="page-link" href="statistics?keyword=${keyword}&category=${category}&minBorrow=${minBorrow}&startsWith=${startsWith}&page=${p}">${p}</a>
                        </li>
                    </c:forEach>
                    <li class="page-item ${currentPage >= totalPages ? 'disabled' : ''}">
                        <a class="page-link" href="statistics?keyword=${keyword}&category=${category}&minBorrow=${minBorrow}&startsWith=${startsWith}&page=${currentPage + 1}">Sau</a>
                    </li>
                </ul>
            </nav>
        </div>
    </div>
</div>
</body>
</html>
