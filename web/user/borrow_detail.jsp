<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết phiếu mượn</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container py-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="fw-bold mb-0">Chi tiết sách đang mượn</h3>
        <a href="${pageContext.request.contextPath}/history" class="btn btn-outline-secondary">Quay lại</a>
    </div>

    <c:if test="${not empty borrowing}">
        <div class="card border-0 shadow-sm">
            <div class="card-body p-4">
                <div class="row g-4">
                    <div class="col-md-6">
                        <h6 class="text-muted">Thông tin phiếu</h6>
                        <p class="mb-2"><strong>Mã phiếu:</strong> #${borrowing.borrowingCode}</p>
                        <p class="mb-2"><strong>Ngày mượn:</strong> ${borrowing.borrowDate}</p>
                        <p class="mb-2"><strong>Hạn trả:</strong> ${borrowing.dueDate}</p>
                        <p class="mb-0"><strong>Ngày trả:</strong> ${empty borrowing.returnDate ? '-' : borrowing.returnDate}</p>
                    </div>
                    <div class="col-md-6">
                        <h6 class="text-muted">Thông tin sách</h6>
                        <p class="mb-2"><strong>Tên sách:</strong> ${borrowing.book.title}</p>
                        <p class="mb-0"><strong>Mã sách:</strong> ${borrowing.book.bookCode}</p>
                    </div>
                </div>
                <hr>
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <strong>Trạng thái:</strong>
                        <span class="badge bg-primary">
                            <c:choose>
                                <c:when test="${borrowing.status == 'Returned'}">Đã trả</c:when>
                                <c:when test="${borrowing.status == 'Borrowing'}">Đang mượn</c:when>
                                <c:when test="${borrowing.status == 'Rejected'}">Từ chối</c:when>
                                <c:when test="${borrowing.status == 'Pending'}">Chờ duyệt</c:when>
                                <c:when test="${borrowing.status == 'ReturnPending' || borrowing.status == 'Chờ duyệt trả'}">Chờ duyệt trả</c:when>
                                <c:otherwise>${borrowing.status}</c:otherwise>
                            </c:choose>
                        </span>
                    </div>

                    <c:if test="${borrowing.status != 'Đã trả' && borrowing.status != 'Returned' && borrowing.status != 'Chờ duyệt trả' && borrowing.status != 'ReturnPending'}">
                        <a href="${pageContext.request.contextPath}/history?action=returnForm&id=${borrowing.borrowingCode}"
                           class="btn btn-success">Trả sách</a>
                    </c:if>
                </div>
            </div>
        </div>
    </c:if>
</div>
</body>
</html>
