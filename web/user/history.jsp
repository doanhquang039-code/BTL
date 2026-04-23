<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Lịch sử mượn sách</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container py-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="fw-bold mb-0">Lịch sử mượn sách</h2>
        <a href="${pageContext.request.contextPath}/user-dashboard" class="btn btn-outline-secondary">Quay lại</a>
    </div>

    <c:if test="${param.msg == 'yeuCauTraThanhCong'}">
        <div class="alert alert-success">Yêu cầu trả sách đã được gửi, vui lòng chờ duyệt.</div>
    </c:if>
    <c:if test="${param.msg == 'daTra'}">
        <div class="alert alert-info">Phiếu này đã ở trạng thái trả sách.</div>
    </c:if>
    <c:if test="${param.msg == 'khongTimThay'}">
        <div class="alert alert-warning">Không tìm thấy phiếu mượn hoặc bạn không có quyền truy cập.</div>
    </c:if>
    <c:if test="${param.msg == 'khongHopLe'}">
        <div class="alert alert-warning">Dữ liệu phiếu mượn không hợp lệ.</div>
    </c:if>
    <c:if test="${param.msg == 'daGuiYeuCauTra'}">
        <div class="alert alert-info">Phiếu này đang ở trạng thái chờ duyệt trả sách.</div>
    </c:if>

    <div class="card border-0 shadow-sm">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-dark">
                    <tr>
                        <th>Mã phiếu</th>
                        <th>Tên sách</th>
                        <th>Ngày mượn</th>
                        <th>Hạn trả</th>
                        <th>Ngày trả</th>
                        <th>Trạng thái</th>
                        <th>Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="b" items="${borrowings}">
                        <tr>
                            <td>#${b.borrowingCode}</td>
                            <td class="fw-bold">${b.book.title}</td>
                            <td>${b.borrowDate}</td>
                            <td>${b.dueDate}</td>
                            <td>${empty b.returnDate ? '-' : b.returnDate}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${b.status == 'Returned'}">Đã trả</c:when>
                                    <c:when test="${b.status == 'Borrowing'}">Đang mượn</c:when>
                                    <c:when test="${b.status == 'Rejected'}">Từ chối</c:when>
                                    <c:when test="${b.status == 'Pending'}">Chờ duyệt</c:when>
                                    <c:when test="${b.status == 'ReturnPending' || b.status == 'Chờ duyệt trả'}">Chờ duyệt trả</c:when>
                                    <c:otherwise>${b.status}</c:otherwise>
                                </c:choose>
                            </td>
                            <td class="text-nowrap">
                                <a href="${pageContext.request.contextPath}/history?action=detail&id=${b.borrowingCode}" class="btn btn-outline-secondary btn-sm">Chi tiết</a>
                                <c:if test="${b.status != 'Đã trả' && b.status != 'Returned' && b.status != 'Chờ duyệt trả' && b.status != 'ReturnPending'}">
                                    <a href="${pageContext.request.contextPath}/history?action=returnForm&id=${b.borrowingCode}"
                                       class="btn btn-success btn-sm">Trả sách</a>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty borrowings}">
                        <tr>
                            <td colspan="7" class="text-center text-muted py-4">Bạn chưa có lịch sử mượn sách.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>
</body>
</html>
