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
    <c:set var="resolvedBackUrl" value="${empty backUrl ? pageContext.request.contextPath.concat('/approvals') : backUrl}" />
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="fw-bold mb-0">Chi tiết phiếu mượn</h3>
        <a href="${resolvedBackUrl}" class="btn btn-outline-secondary">Quay lại</a>
    </div>

    <c:choose>
        <c:when test="${not empty borrowingDetail}">
            <div class="card border-0 shadow-sm">
                <div class="card-body p-4">
                    <div class="row g-4">
                        <div class="col-md-6">
                            <h6 class="text-muted">Thông tin phiếu</h6>
                            <p class="mb-2"><strong>Mã phiếu:</strong> #${borrowingDetail.borrowingCode}</p>
                            <p class="mb-2"><strong>Ngày mượn:</strong> ${borrowingDetail.borrowDate}</p>
                            <p class="mb-2"><strong>Hạn trả:</strong> ${borrowingDetail.dueDate}</p>
                            <p class="mb-0"><strong>Ngày trả:</strong> ${empty borrowingDetail.returnDate ? '-' : borrowingDetail.returnDate}</p>
                        </div>
                        <div class="col-md-6">
                            <h6 class="text-muted">Trạng thái</h6>
                            <span class="badge bg-primary fs-6">${borrowingDetail.status}</span>
                        </div>
                    </div>
                    <hr>
                    <div class="row g-4">
                        <div class="col-md-6">
                            <h6 class="text-muted">Độc giả</h6>
                            <p class="mb-2"><strong>Họ tên:</strong> ${borrowingDetail.user.fullName}</p>
                            <p class="mb-2"><strong>Tên đăng nhập:</strong> ${empty borrowingDetail.username ? '-' : borrowingDetail.username}</p>
                            <p class="mb-2"><strong>Mã độc giả:</strong> ${borrowingDetail.user.userCode}</p>
                            <p class="mb-0"><strong>CCCD/CMND:</strong> ${empty borrowingDetail.identityNumber ? '-' : borrowingDetail.identityNumber}</p>
                        </div>
                        <div class="col-md-6">
                            <h6 class="text-muted">Sách</h6>
                            <p class="mb-2"><strong>Tên sách:</strong> ${borrowingDetail.book.title}</p>
                            <p class="mb-0"><strong>Mã sách:</strong> ${borrowingDetail.book.bookCode}</p>
                        </div>
                    </div>
                    <hr>
                    <h6 class="text-muted">Địa chỉ độc giả</h6>
                    <p class="mb-0">${empty borrowingDetail.userAddress ? 'Chưa cập nhật địa chỉ' : borrowingDetail.userAddress}</p>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <div class="alert alert-warning">Không tìm thấy phiếu mượn cần xem chi tiết.</div>
        </c:otherwise>
    </c:choose>
</div>
</body>
</html>
