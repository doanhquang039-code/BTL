<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard | Thư viện</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin_layout.css">
</head>
<body>

<div class="d-flex">
    <nav id="sidebar">
        <div class="sidebar-header">
            <h4 class="fw-bold text-primary">LIBRARY PRO</h4>
            <small class="text-muted">Admin Panel</small>
        </div>
        <ul class="list-unstyled">
            <li><a href="${pageContext.request.contextPath}/admin-dashboard" class="active"><i class="bi bi-speedometer2 me-2"></i> Dashboard</a></li>
            <li><a href="${pageContext.request.contextPath}/books"><i class="bi bi-book me-2"></i> Quản lý Sách</a></li>
            <li><a href="${pageContext.request.contextPath}/users"><i class="bi bi-people me-2"></i> Quản lý Thành viên</a></li>
            <li><a href="${pageContext.request.contextPath}/imports"><i class="bi bi-box-seam me-2"></i> Nhập kho sách</a></li>
            <li><a href="${pageContext.request.contextPath}/penalties"><i class="bi bi-exclamation-triangle me-2"></i> Quản lý Vi phạm</a></li>
            <li><a href="${pageContext.request.contextPath}/reservations"><i class="bi bi-calendar-check me-2"></i> Đặt trước</a></li>
            <hr class="mx-3 text-secondary">
            <li><a href="${pageContext.request.contextPath}/logout" class="text-danger"><i class="bi bi-box-arrow-right me-2"></i> Đăng xuất</a></li>
        </ul>
    </nav>

    <div id="content">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="fw-bold">Tổng quan hệ thống</h2>
            <div class="text-muted">Xin chào, <strong>Admin</strong></div>
        </div>

        <div class="row g-4">
            <div class="col-md-3">
                <div class="card card-stats bg-white shadow-sm p-3 border-start border-primary border-4">
                    <div class="d-flex align-items-center">
                        <div class="btn btn-primary btn-lg rounded-circle me-3"><i class="bi bi-book"></i></div>
                        <div>
                            <div class="text-muted small">Tổng số sách</div>
                            <h4 class="mb-0 fw-bold">${totalBooks != null ? totalBooks : 0}</h4>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card card-stats bg-white shadow-sm p-3 border-start border-success border-4">
                    <div class="d-flex align-items-center">
                        <div class="btn btn-success btn-lg rounded-circle me-3"><i class="bi bi-people"></i></div>
                        <div>
                            <div class="text-muted small">Thành viên</div>
                            <h4 class="mb-0 fw-bold">${totalUsers != null ? totalUsers : 0}</h4>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card card-stats bg-white shadow-sm p-3 border-start border-warning border-4">
                    <div class="d-flex align-items-center">
                        <div class="btn btn-warning btn-lg rounded-circle me-3"><i class="bi bi-truck"></i></div>
                        <div>
                            <div class="text-muted small">Nhập kho tháng</div>
                            <h4 class="mb-0 fw-bold">${totalImports != null ? totalImports : 0}</h4>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card card-stats bg-white shadow-sm p-3 border-start border-danger border-4">
                    <div class="d-flex align-items-center">
                        <div class="btn btn-danger btn-lg rounded-circle me-3"><i class="bi bi-shield-lock"></i></div>
                        <div>
                            <div class="text-muted small">Đang vi phạm</div>
                            <h4 class="mb-0 fw-bold">${activePenalties != null ? activePenalties : 0}</h4>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="mt-5">
            <h5 class="fw-bold mb-3">Lối tắt xử lý nhanh</h5>
            <div class="row g-3">
                <div class="col-md-4">
                    <a href="${pageContext.request.contextPath}/imports?action=create" class="btn btn-outline-dark w-100 py-4 rounded-4 shadow-sm h-100">
                        <i class="bi bi-plus-circle d-block fs-1 mb-2 text-primary"></i> 
                        <span class="fw-bold">Nhập thêm sách mới</span>
                    </a>
                </div>
                <div class="col-md-4">
                    <a href="${pageContext.request.contextPath}/penalties?action=add" class="btn btn-outline-dark w-100 py-4 rounded-4 shadow-sm h-100">
                        <i class="bi bi-person-plus d-block fs-1 mb-2 text-danger"></i> 
                        <span class="fw-bold">Ghi nhận vi phạm</span>
                    </a>
                </div>
                <div class="col-md-4">
                    <a href="${pageContext.request.contextPath}/books" class="btn btn-outline-dark w-100 py-4 rounded-4 shadow-sm h-100">
                        <i class="bi bi-search d-block fs-1 mb-2 text-success"></i> 
                        <span class="fw-bold">Tra cứu & Quản lý</span>
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>