<%-- 
    Document   : penalty_list.jsp
    Created on : Jan 19, 2026, 7:51:11 PM
    Author     : admoi
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý vi phạm | Hệ thống Thư viện</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        body { background-color: #f8f9fa; }
        .table-card { border-radius: 15px; border: none; box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.1); }
        /* Tông màu đỏ chủ đạo cho trang vi phạm */
        .table thead { background-color: #dc3545; color: white; }
        .badge-status { font-size: 0.8rem; padding: 0.6em 1em; border-radius: 30px; min-width: 110px; }
        .table td { vertical-align: middle; }
    </style>
</head>
<body>

<div class="container py-5">
    <div class="card table-card">
        <div class="card-header bg-danger text-white d-flex justify-content-between align-items-center py-3">
            <h5 class="mb-0 fs-5 fw-bold"><i class="bi bi-exclamation-octagon me-2"></i> DANH SÁCH VI PHẠM</h5>
            <div class="d-flex gap-2">
                <a href="${pageContext.request.contextPath}/penalties" class="btn btn-light btn-sm fw-bold">
                    <i class="bi bi-arrow-clockwise"></i> Làm mới
                </a>
                <a href="penalties?action=create" class="btn btn-dark btn-sm fw-bold">
                    <i class="bi bi-plus-circle me-1"></i> Thêm vi phạm
                </a>
            </div>
        </div>
        
        <div class="card-body p-0"> <%-- Bỏ padding để bảng sát lề card --%>
            <div class="table-responsive">
                <table class="table table-hover mb-0">
                    <thead class="text-center align-middle">
                        <tr>
                            <th style="width: 8%">Mã Phạt</th>
                            <th style="width: 18%" class="text-start ps-4">Thành viên</th>
                            <th style="width: 10%">Mã Phiếu</th>
                            <th style="width: 25%" class="text-start">Lý do vi phạm</th>
                            <th style="width: 12%">Tiền phạt</th>
                            <th style="width: 15%">Trạng thái</th>
                            <th style="width: 12%">Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="p" items="${penalties}">
                            <tr class="text-center">
                                <td class="fw-bold text-secondary">#${p.penaltyCode}</td>
                                <td class="text-start ps-4">
                                    <div class="fw-bold text-dark">${p.user.fullName}</div>
                                    <small class="text-muted">ID: ${p.user.userCode}</small>
                                </td>
                                <td>
                                    <span class="badge bg-light text-primary border fw-semibold">
                                        ${p.borrowing.borrowingCode}
                                    </span>
                                </td>
                                <td class="text-start text-wrap" style="max-width: 250px;">
                                    ${p.reason}
                                </td>
                                <td class="fw-bold text-danger">
                                    <fmt:formatNumber value="${p.amount}" type="currency" currencySymbol="" /> 
                                    <small>VNĐ</small>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${p.status == 'Đã thanh toán'}">
                                            <span class="badge bg-success badge-status"><i class="bi bi-check-circle me-1"></i> Đã thanh toán</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-danger badge-status"><i class="bi bi-clock-history me-1"></i> Chưa thanh toán</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <div class="d-flex justify-content-center gap-1">
                                        <a href="penalties?action=update&id=${p.penaltyCode}" 
                                           class="btn btn-sm btn-outline-warning" title="Sửa">
                                            <i class="bi bi-pencil-fill"></i>
                                        </a>
                                        <a href="penalties?action=delete&id=${p.penaltyCode}" 
                                           class="btn btn-sm btn-outline-danger" 
                                           onclick="return confirm('Xác nhận xóa bản ghi này?')" title="Xóa">
                                            <i class="bi bi-trash-fill"></i>
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        
                        <c:if test="${empty penalties}">
                            <tr>
                                <td colspan="7" class="text-center py-5">
                                    <img src="https://cdn-icons-png.flaticon.com/512/7486/7486744.png" width="80" class="mb-3 opacity-25">
                                    <p class="text-muted">Chưa có ghi nhận vi phạm nào trong hệ thống.</p>
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