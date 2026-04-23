<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Danh sách đặt trước</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
</head>
<body class="bg-light">
<div class="container mt-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="fw-bold text-info mb-0"><i class="bi bi-clock-history"></i> Danh sách đặt trước</h2>
        <c:choose>
            <c:when test="${sessionScope.userSession.role == 'Manager' || sessionScope.userSession.role == 'manager'}">
                <a href="${pageContext.request.contextPath}/manager-dash" class="btn btn-outline-secondary">Trang chủ</a>
            </c:when>
            <c:otherwise>
                <a href="${pageContext.request.contextPath}/admin-dashboard" class="btn btn-outline-secondary">Trang chủ</a>
            </c:otherwise>
        </c:choose>
    </div>

    <div class="card shadow border-0">
        <div class="card-body">
            <c:if test="${param.msg == 'khongHoTroTaoMoi'}">
                <div class="alert alert-warning">Admin không tạo mới phiếu đặt trước. Chức năng này dành cho độc giả.</div>
            </c:if>
            <c:if test="${param.msg == 'trungYeuCau'}">
                <div class="alert alert-info">Độc giả này đã có phiếu đặt trước đang chờ cho sách đã chọn.</div>
            </c:if>
            <c:if test="${param.msg == 'capNhatThanhCong'}">
                <div class="alert alert-success">Cập nhật phiếu đặt trước thành công.</div>
            </c:if>
            <c:if test="${param.msg == 'xoaThanhCong'}">
                <div class="alert alert-success">Xóa phiếu đặt trước thành công.</div>
            </c:if>
            <c:if test="${param.msg == 'thieuDuLieuCapNhat'}">
                <div class="alert alert-warning">Thiếu dữ liệu khi cập nhật phiếu đặt trước.</div>
            </c:if>
            <c:if test="${param.msg == 'duLieuCapNhatKhongHopLe'}">
                <div class="alert alert-danger">Dữ liệu cập nhật không hợp lệ.</div>
            </c:if>
            <c:if test="${param.msg == 'maKhongHopLe'}">
                <div class="alert alert-danger">Không tìm thấy phiếu đặt trước cần thao tác.</div>
            </c:if>

            <c:if test="${not empty editReservation}">
                <form action="reservations" method="post" class="row g-2 mb-3">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="reservationCode" value="${editReservation.reservationCode}">
                    <div class="col-md-4">
                        <select name="userCode" class="form-select" required>
                            <option value="">-- Chọn độc giả --</option>
                            <c:forEach var="u" items="${users}">
                                <option value="${u.userCode}" ${editReservation.user.userCode == u.userCode ? 'selected' : ''}>
                                    ${u.fullName} (Mã: ${u.userCode})
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <select name="bookCode" class="form-select" required>
                            <option value="">-- Chọn sách --</option>
                            <c:forEach var="b" items="${books}">
                                <option value="${b.bookCode}" ${editReservation.book.bookCode == b.bookCode ? 'selected' : ''}>
                                    ${b.title} (Còn: ${b.quantity})
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <select name="status" class="form-select" required>
                            <option value="Đang chờ" ${editReservation.status == 'Đang chờ' ? 'selected' : ''}>Đang chờ</option>
                            <option value="Đã duyệt" ${editReservation.status == 'Đã duyệt' ? 'selected' : ''}>Đã duyệt</option>
                            <option value="Đã hủy" ${editReservation.status == 'Đã hủy' ? 'selected' : ''}>Đã hủy</option>
                        </select>
                    </div>
                    <div class="col-md-2 d-flex gap-2">
                        <button class="btn btn-warning w-100" type="submit">Cập nhật</button>
                        <a href="reservations" class="btn btn-outline-secondary w-100">Hủy</a>
                    </div>
                </form>
            </c:if>

            <form action="reservations" method="get" class="row g-2 mb-3">
                <div class="col-md-6">
                    <input type="text" name="keyword" class="form-control" placeholder="Tìm theo thành viên, tên sách hoặc mã phiếu..." value="${keyword}">
                </div>
                <div class="col-md-3">
                    <select name="status" class="form-select">
                        <option value="">-- Lọc theo trạng thái --</option>
                        <c:forEach var="st" items="${statusOptions}">
                            <option value="${st}" ${status == st ? 'selected' : ''}>${st}</option>
                        </c:forEach>
                    </select>
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
                    <a href="reservations" class="btn btn-outline-secondary w-100">Xóa lọc</a>
                </div>
            </form>

            <div class="table-responsive">
                <table class="table align-middle">
                    <thead>
                        <tr>
                            <th>STT</th>
                            <th>Thành viên</th>
                            <th>Tên sách</th>
                            <th>Ngày đặt</th>
                            <th>Trạng thái</th>
                            <th>Ưu tiên</th>
                            <th>Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="r" items="${reservations}" varStatus="loop">
                            <tr>
                                <td>${(currentPage - 1) * pageSize + loop.index + 1}</td>
                                <td>${r.user.fullName}</td>
                                <td><strong>${r.book.title}</strong></td>
                                <td>${r.reserveDate}</td>
                                <td>${r.status}</td>
                                <td><span class="badge bg-info">Hạng ${loop.index + 1}</span></td>
                                <td class="d-flex gap-2">
                                    <a class="btn btn-sm btn-outline-warning"
                                       href="reservations?keyword=${keyword}&status=${status}&startsWith=${startsWith}&page=${currentPage}&editId=${r.reservationCode}">
                                        Sửa
                                    </a>
                                    <form action="reservations" method="post" onsubmit="return confirm('Bạn có chắc muốn xóa phiếu đặt trước này?');">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="reservationCode" value="${r.reservationCode}">
                                        <button type="submit" class="btn btn-sm btn-outline-danger">Xóa</button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty reservations}">
                            <tr>
                                <td colspan="7" class="text-center text-muted py-4">Chưa có lượt đặt trước nào.</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>

            <div class="d-flex justify-content-between align-items-center mt-3">
                <small class="text-muted">Tổng: ${totalItems} bản ghi</small>
                <nav>
                    <ul class="pagination pagination-sm mb-0">
                        <li class="page-item ${currentPage <= 1 ? 'disabled' : ''}">
                            <a class="page-link" href="reservations?keyword=${keyword}&status=${status}&startsWith=${startsWith}&page=${currentPage - 1}">Trước</a>
                        </li>
                        <c:forEach begin="1" end="${totalPages}" var="p">
                            <li class="page-item ${p == currentPage ? 'active' : ''}">
                                <a class="page-link" href="reservations?keyword=${keyword}&status=${status}&startsWith=${startsWith}&page=${p}">${p}</a>
                            </li>
                        </c:forEach>
                        <li class="page-item ${currentPage >= totalPages ? 'disabled' : ''}">
                            <a class="page-link" href="reservations?keyword=${keyword}&status=${status}&startsWith=${startsWith}&page=${currentPage + 1}">Sau</a>
                        </li>
                    </ul>
                </nav>
            </div>
        </div>
    </div>
</div>
</body>
</html>
