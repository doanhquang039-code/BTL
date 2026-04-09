<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard | Thư viện</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    
    <style>
        :root {
            --primary-gradient: linear-gradient(135deg, #4361ee, #4cc9f0);
            --success-gradient: linear-gradient(135deg, #2ecc71, #27ae60);
            --warning-gradient: linear-gradient(135deg, #f1c40f, #f39c12);
            --danger-gradient: linear-gradient(135deg, #e74c3c, #c0392b);
            --sidebar-color: #1e1e2d;
        }

        body {
            background-color: #f4f7fe;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        /* Sidebar Styling */
        #sidebar {
            min-width: 260px;
            max-width: 260px;
            min-height: 100vh;
            background: var(--sidebar-color);
            color: #a2a3b7;
            transition: all 0.3s;
            box-shadow: 4px 0 10px rgba(0,0,0,0.1);
        }

        #sidebar .sidebar-header {
            padding: 25px;
            background: #1b1b28;
            border-bottom: 1px solid #2d2d3f;
        }

        #sidebar ul li a {
            padding: 15px 25px;
            display: flex;
            align-items: center;
            color: #a2a3b7;
            text-decoration: none;
            transition: 0.2s;
            border-left: 4px solid transparent;
        }

        #sidebar ul li a:hover, #sidebar ul li a.active {
            color: #fff;
            background: rgba(255, 255, 255, 0.05);
            border-left: 4px solid #4361ee;
        }

        /* Content Styling */
        #content {
            width: 100%;
            padding: 30px;
        }

        /* Card Stats Animation */
        .card-stats {
            border: none;
            border-radius: 20px;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .card-stats:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 30px rgba(0,0,0,0.1) !important;
        }

        .card-stats h4 {
            font-size: 1.8rem;
            color: #2b3674;
        }

        /* Icon Background Effect */
        .card-stats .btn-lg {
            width: 60px;
            height: 60px;
            display: flex;
            align-items: center;
            justify-content: center;
            border: none;
        }

        /* Quick Action Buttons */
        .rounded-4 {
            border-radius: 20px !important;
        }

        .btn-outline-dark {
            border: 2px dashed #cbd5e0;
            background: white;
            color: #4a5568;
            transition: all 0.3s;
        }

        .btn-outline-dark:hover {
            border-style: solid;
            background: #f8f9fa;
            border-color: #4361ee;
            color: #4361ee;
            transform: scale(1.02);
        }

        .header-title {
            color: #2b3674;
            letter-spacing: -0.5px;
        }

        /* Dashboard Glows */
        .border-primary { border-color: #4361ee !important; }
        .border-success { border-color: #2ecc71 !important; }
        .border-warning { border-color: #f1c40f !important; }
        .border-danger { border-color: #e74c3c !important; }

    </style>
</head>
<body>

<div class="d-flex text-secondary">
    <nav id="sidebar">
        <div class="sidebar-header">
            <h4 class="fw-bold text-white mb-0"><i class="bi bi-book-half me-2"></i>LIBRARY PRO</h4>
            <small class="text-muted">Administrator System</small>
        </div>
        <ul class="list-unstyled mt-3">
            <li><a href="${pageContext.request.contextPath}/admin-dashboard" class="active"><i class="bi bi-speedometer2 me-3"></i> Dashboard</a></li>
            <li><a href="${pageContext.request.contextPath}/books"><i class="bi bi-book me-3"></i> Quản lý Sách</a></li>
            <li><a href="${pageContext.request.contextPath}/users"><i class="bi bi-people me-3"></i> Quản lý Thành viên</a></li>
            <li><a href="${pageContext.request.contextPath}/imports"><i class="bi bi-box-seam me-3"></i> Nhập kho sách</a></li>
            <li><a href="${pageContext.request.contextPath}/penalties"><i class="bi bi-exclamation-triangle me-3"></i> Quản lý Vi phạm</a></li>
            <li><a href="${pageContext.request.contextPath}/reservations"><i class="bi bi-calendar-check me-3"></i> Đặt trước</a></li>
            <li><a href="${pageContext.request.contextPath}/categories"><i class="bi bi-tags me-3"></i> Quản lý Danh mục</a></li>
            <hr class="mx-3 border-secondary opacity-25">
            <li><a href="${pageContext.request.contextPath}/logout" class="text-danger"><i class="bi bi-box-arrow-right me-3"></i> Đăng xuất</a></li>
        </ul>
    </nav>

    <div id="content">
        <div class="d-flex justify-content-between align-items-center mb-5">
            <div>
                <h2 class="fw-bold header-title mb-0">Tổng quan hệ thống</h2>
                <p class="text-muted mb-0">Chào mừng trở lại, bạn đang có toàn quyền quản trị.</p>
            </div>
            <div class="d-flex align-items-center">
                <div class="bg-white p-2 rounded-circle shadow-sm me-3">
                    <img src="https://ui-avatars.com/api/?name=Admin&background=4361ee&color=fff" class="rounded-circle" width="40" alt="avatar">
                </div>
                <div class="text-end">
                    <div class="fw-bold text-dark">Administrator</div>
                    <small class="text-success"><i class="bi bi-circle-fill fs-6 me-1" style="font-size: 8px !important;"></i> Đang hoạt động</small>
                </div>
            </div>
        </div>

        <div class="row g-4">
            <div class="col-md-3">
                <div class="card card-stats bg-white shadow-sm p-4 border-start border-primary border-5">
                    <div class="d-flex align-items-center">
                        <div class="btn btn-primary btn-lg rounded-4 me-3 shadow-sm" style="background: var(--primary-gradient)">
                            <i class="bi bi-book fs-3 text-white"></i>
                        </div>
                        <div>
                            <div class="text-muted small fw-bold">TỔNG SỐ SÁCH</div>
                            <h4 class="mb-0 fw-bold">${totalBooks != null ? totalBooks : 0}</h4>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card card-stats bg-white shadow-sm p-4 border-start border-success border-5">
                    <div class="d-flex align-items-center">
                        <div class="btn btn-success btn-lg rounded-4 me-3 shadow-sm" style="background: var(--success-gradient)">
                            <i class="bi bi-people fs-3 text-white"></i>
                        </div>
                        <div>
                            <div class="text-muted small fw-bold">THÀNH VIÊN</div>
                            <h4 class="mb-0 fw-bold">${totalUsers != null ? totalUsers : 0}</h4>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card card-stats bg-white shadow-sm p-4 border-start border-warning border-5">
                    <div class="d-flex align-items-center">
                        <div class="btn btn-warning btn-lg rounded-4 me-3 shadow-sm" style="background: var(--warning-gradient)">
                            <i class="bi bi-truck fs-3 text-white"></i>
                        </div>
                        <div>
                            <div class="text-muted small fw-bold">NHẬP KHO THÁNG</div>
                            <h4 class="mb-0 fw-bold">${totalImports != null ? totalImports : 0}</h4>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card card-stats bg-white shadow-sm p-4 border-start border-danger border-5">
                    <div class="d-flex align-items-center">
                        <div class="btn btn-danger btn-lg rounded-4 me-3 shadow-sm" style="background: var(--danger-gradient)">
                            <i class="bi bi-shield-lock fs-3 text-white"></i>
                        </div>
                        <div>
                            <div class="text-muted small fw-bold">ĐANG VI PHẠM</div>
                            <h4 class="mb-0 fw-bold">${activePenalties != null ? activePenalties : 0}</h4>
                        </div>
                    </div>
                </div>
            </div>
                        <div class="col-md-3">
    <div class="card card-stats bg-white shadow-sm p-4 border-start border-info border-5">
        <div class="d-flex align-items-center">
            <div class="btn btn-info btn-lg rounded-4 me-3 shadow-sm" style="background: linear-gradient(135deg, #667eea, #764ba2)">
                <i class="bi bi-grid-fill fs-3 text-white"></i>
            </div>
            <div>
                <div class="text-muted small fw-bold">DANH MỤC</div>
                <h4 class="mb-0 fw-bold">${totalCategories != null ? totalCategories : 0}</h4>
            </div>
        </div>
    </div>
</div>
        </div>

       <div class="mt-5 pt-4">
    <h5 class="fw-bold mb-4 text-dark"><i class="bi bi-lightning-charge-fill text-warning me-2"></i>Lối tắt xử lý nhanh</h5>
    <div class="row g-4">
        <div class="col-md-3">
            <a href="${pageContext.request.contextPath}/imports?action=create" class="btn btn-outline-dark w-100 py-5 rounded-4 shadow-sm h-100">
                <i class="bi bi-plus-circle d-block display-4 mb-3 text-primary"></i> 
                <span class="fs-5 fw-bold">Nhập kho</span>
                <p class="small text-muted mb-0 mt-2">Cập nhật số lượng sách</p>
            </a>
        </div>
        
        <div class="col-md-3">
            <a href="${pageContext.request.contextPath}/penalties?action=add" class="btn btn-outline-dark w-100 py-5 rounded-4 shadow-sm h-100">
                <i class="bi bi-person-plus d-block display-4 mb-3 text-danger"></i> 
                <span class="fs-5 fw-bold">Vi phạm</span>
                <p class="small text-muted mb-0 mt-2">Xử phạt & bồi thường</p>
            </a>
        </div>

        <div class="col-md-3">
            <a href="${pageContext.request.contextPath}/categories" class="btn btn-outline-dark w-100 py-5 rounded-4 shadow-sm h-100">
                <i class="bi bi-tags d-block display-4 mb-3" style="color: #764ba2;"></i> 
                <span class="fs-5 fw-bold">Danh mục</span>
                <p class="small text-muted mb-0 mt-2">Phân loại kho sách</p>
            </a>
        </div>

        <div class="col-md-3">
            <a href="${pageContext.request.contextPath}/books" class="btn btn-outline-dark w-100 py-5 rounded-4 shadow-sm h-100">
                <i class="bi bi-search d-block display-4 mb-3 text-success"></i> 
                <span class="fs-5 fw-bold">Kho sách</span>
                <p class="small text-muted mb-0 mt-2">Quản lý & Chỉnh sửa</p>
            </a>
        </div>
    </div>
</div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>