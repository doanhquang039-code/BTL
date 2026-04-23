<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Báo cáo mượn trả | Manager</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        body { background: #f6f7f9; font-family: "Segoe UI", system-ui, sans-serif; color: #1f2937; }
        .page-card { background: #fff; border: 1px solid #e5e7eb; border-radius: 8px; box-shadow: 0 8px 24px rgba(15, 23, 42, 0.06); }
        .stat-card { border: 1px solid #e5e7eb; border-radius: 8px; background: #fff; }
        .stat-label { color: #6b7280; font-size: 0.82rem; font-weight: 700; text-transform: uppercase; }
        .stat-number { font-size: 2rem; font-weight: 800; }
        .btn { border-radius: 6px; }
        .table thead th { background: #f9fafb; color: #4b5563; font-size: 0.8rem; text-transform: uppercase; }
    </style>
</head>
<body>
<div class="container py-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2 class="fw-bold mb-1">Báo cáo mượn trả</h2>
            <p class="text-muted mb-0">Tổng hợp nhanh tình hình phục vụ và lượt mượn sách.</p>
        </div>
        <div class="d-flex gap-2">
            <a href="${pageContext.request.contextPath}/manager-dash" class="btn btn-outline-secondary">
                <i class="bi bi-arrow-left me-1"></i>Dashboard
            </a>
            <button type="button" class="btn btn-dark" onclick="window.print()">
                <i class="bi bi-printer me-1"></i>In báo cáo
            </button>
        </div>
    </div>

    <div class="row g-3 mb-4">
        <div class="col-md-4">
            <div class="stat-card p-4">
                <div class="stat-label">Yêu cầu chờ duyệt</div>
                <div class="stat-number text-primary">${pendingApprovals != null ? pendingApprovals : 0}</div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="stat-card p-4">
                <div class="stat-label">Sách quá hạn chưa trả</div>
                <div class="stat-number text-warning">${overdueBooks != null ? overdueBooks : 0}</div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="stat-card p-4">
                <div class="stat-label">Lượt mượn hôm nay</div>
                <div class="stat-number text-success">${todayBorrows != null ? todayBorrows : 0}</div>
            </div>
        </div>
    </div>

    <div class="page-card">
        <div class="p-4 border-bottom">
            <h5 class="fw-bold mb-0">Thống kê đầu sách theo lượt mượn</h5>
        </div>
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead>
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
                                <span class="badge bg-dark">${row.borrowCount}</span>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty bookStats}">
                        <tr>
                            <td colspan="7" class="text-center text-muted py-4">Chưa có dữ liệu báo cáo.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>
</body>
</html>
