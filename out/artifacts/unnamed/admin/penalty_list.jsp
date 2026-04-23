<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Danh sách vi phạm</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        body {
            background: #f6f7f9;
            color: #1f2937;
            font-family: "Segoe UI", system-ui, sans-serif;
        }

        .main-card {
            background: #fff;
            border: 1px solid #e5e7eb;
            border-radius: 8px;
            box-shadow: 0 8px 24px rgba(15, 23, 42, 0.06);
            overflow: hidden;
        }

        .page-header {
            background: #374151;
            padding: 20px 24px;
        }

        .page-header h4 {
            letter-spacing: 0;
        }

        .toolbar-btn {
            border-radius: 6px;
            font-weight: 600;
        }

        .table thead th {
            background: #f9fafb;
            color: #4b5563;
            border-bottom: 1px solid #e5e7eb;
            font-size: 0.8rem;
            font-weight: 700;
            padding: 14px;
            text-transform: uppercase;
        }

        .table tbody td {
            padding: 14px;
            vertical-align: middle;
            border-bottom: 1px solid #f1f5f9;
        }

        .reason-box {
            background: #f9fafb;
            border-left: 3px solid #9ca3af;
            border-radius: 6px;
            color: #374151;
            padding: 8px 10px;
        }

        .amount-text {
            color: #b91c1c;
            font-weight: 700;
        }

        .badge-status {
            border-radius: 6px;
            display: inline-block;
            font-size: 0.78rem;
            font-weight: 700;
            min-width: 128px;
            padding: 7px 10px;
        }

        .status-paid {
            background: #ecfdf5;
            color: #047857;
        }

        .status-unpaid {
            background: #fff7ed;
            color: #c2410c;
        }

        .action-btn {
            align-items: center;
            border-radius: 6px;
            display: inline-flex;
            height: 34px;
            justify-content: center;
            text-decoration: none;
            width: 34px;
        }

        .btn-edit {
            background: #eef2ff;
            color: #3730a3;
        }

        .btn-delete {
            background: #fef2f2;
            color: #b91c1c;
        }

        .empty-state {
            color: #6b7280;
            padding: 70px 0;
        }
    </style>
</head>
<body>

<c:set var="homeUrl" value="${pageContext.request.contextPath}/admin-dashboard" />
<c:if test="${sessionScope.userSession.role == 'Manager' || sessionScope.userSession.role == 'manager'}">
    <c:set var="homeUrl" value="${pageContext.request.contextPath}/manager-dash" />
</c:if>

<div class="container-fluid py-5 px-lg-5">
    <div class="card main-card">
        <div class="page-header d-flex justify-content-between align-items-center">
            <div>
                <h4 class="mb-1 text-white fw-bold">
                    <i class="bi bi-exclamation-octagon me-2"></i>Danh sách vi phạm
                </h4>
                <small class="text-white-50">Theo dõi tiền phạt và trạng thái bồi thường</small>
            </div>
            <div class="d-flex gap-2">
                <a href="${homeUrl}" class="btn btn-outline-light toolbar-btn" title="Về trang chủ">
                    <i class="bi bi-house-door me-1"></i> Trang chủ
                </a>
                <a href="${pageContext.request.contextPath}/penalties?action=create" class="btn btn-light toolbar-btn">
                    <i class="bi bi-plus-circle me-1"></i> Thêm mới
                </a>
            </div>
        </div>

        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover mb-0">
                    <thead>
                        <tr class="text-center">
                            <th>ID phạt</th>
                            <th class="text-start">Thành viên</th>
                            <th>Mã phiếu</th>
                            <th class="text-start">Lý do vi phạm</th>
                            <th>Tiền phạt</th>
                            <th>Trạng thái</th>
                            <th>Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="p" items="${penalties}">
                            <tr class="text-center">
                                <td>
                                    <span class="fw-bold text-muted small">#P-${p.penaltyCode}</span>
                                </td>
                                <td class="text-start">
                                    <div class="fw-bold">${p.user.fullName}</div>
                                    <small class="text-muted">
                                        <i class="bi bi-person-badge me-1"></i>${p.user.userCode}
                                    </small>
                                </td>
                                <td>
                                    <span class="badge bg-light text-primary border px-2 py-1">
                                        <i class="bi bi-hash"></i>${p.borrowing.borrowingCode}
                                    </span>
                                </td>
                                <td class="text-start">
                                    <div class="reason-box">${p.reason}</div>
                                </td>
                                <td>
                                    <div class="amount-text">
                                        <fmt:formatNumber value="${p.amount}" type="number" groupingUsed="true" />
                                        <small>đ</small>
                                    </div>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${p.status == 'Đã thanh toán' || p.status == 'Da thanh toan'}">
                                            <span class="badge-status status-paid">
                                                <i class="bi bi-check-circle me-1"></i>Đã thanh toán
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge-status status-unpaid">
                                                <i class="bi bi-clock me-1"></i>Chưa thanh toán
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <div class="d-flex justify-content-center gap-2">
                                        <a href="${pageContext.request.contextPath}/penalties?action=update&id=${p.penaltyCode}"
                                           class="action-btn btn-edit" title="Sửa thông tin">
                                            <i class="bi bi-pencil-fill"></i>
                                        </a>
                                        <a href="${pageContext.request.contextPath}/penalties?action=delete&id=${p.penaltyCode}"
                                           class="action-btn btn-delete"
                                           onclick="return confirm('Xóa bản ghi vi phạm này?')" title="Xóa dữ liệu">
                                            <i class="bi bi-trash3-fill"></i>
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>

                        <c:if test="${empty penalties}">
                            <tr>
                                <td colspan="7" class="text-center empty-state">
                                    <i class="bi bi-inbox fs-1 d-block mb-3 text-secondary"></i>
                                    Hiện tại không có trường hợp vi phạm nào cần xử lý.
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
