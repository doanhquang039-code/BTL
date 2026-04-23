<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý Danh mục | Hệ thống Thư viện</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        body { background-color: #f4f7fe; font-family: 'Inter', system-ui, sans-serif; }
        
        /* Card chính chứa bảng */
        .main-card {
            border: none;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.05);
            background: #fff;
            max-width: 850px;
            margin: auto;
            overflow: hidden;
        }

        /* Tiêu đề dải màu Indigo */
        .header-indigo {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 1.5rem 2rem;
        }

        /* Tùy chỉnh bảng */
        .table thead th {
            background-color: #f8f9fc;
            color: #764ba2;
            font-size: 0.8rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            font-weight: 700;
            padding: 1.2rem;
            border: none;
        }
        
        .table tbody td {
            padding: 1.2rem;
            vertical-align: middle;
            border-bottom: 1px solid #edf2f7;
        }

        /* Biểu tượng danh mục */
        .cat-icon {
            width: 42px;
            height: 42px;
            background-color: #f3f0ff;
            color: #764ba2;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 12px;
            font-size: 1.2rem;
        }

        .cat-name {
            font-weight: 700;
            color: #2d3748;
            font-size: 1rem;
        }

        /* Nút hành động tròn bo góc */
        .action-btn {
            width: 38px;
            height: 38px;
            border-radius: 10px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            transition: 0.3s;
            text-decoration: none;
            border: none;
        }
        .btn-edit { background-color: #eef2ff; color: #4361ee; }
        .btn-delete { background-color: #fff1f2; color: #f43f5e; }
        .action-btn:hover { transform: translateY(-3px); box-shadow: 0 4px 12px rgba(0,0,0,0.1); }

        /* Nút quay lại kiểu Minimalist */
        .back-link {
            text-decoration: none;
            color: #718096;
            font-weight: 600;
            transition: 0.3s;
            display: inline-flex;
            align-items: center;
        }
        .back-link:hover { color: #4361ee; }
    </style>
</head>
<body>

<div class="container py-5">
    <div class="d-flex justify-content-between align-items-center mb-4 px-2" style="max-width: 850px; margin: auto;">
        <a href="${pageContext.request.contextPath}/admin-dashboard" class="back-link">
            <i class="bi bi-arrow-left-circle-fill fs-4 me-2"></i> Quay về trang Admin
        </a>
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb mb-0 small">
                <li class="breadcrumb-item text-muted">Hệ thống</li>
                <li class="breadcrumb-item active fw-bold" aria-current="page">Danh mục</li>
            </ol>
        </nav>
    </div>

    <div class="card main-card">
        <div class="header-indigo d-flex justify-content-between align-items-center">
            <div>
                <h4 class="mb-0 text-white fw-bold"><i class="bi bi-tags-fill me-2"></i>DANH MỤC SÁCH</h4>
                <small class="text-white-50">Phân loại kho tri thức theo từng chủ đề</small>
            </div>
            <a href="categories?action=create" class="btn btn-light fw-bold px-4 shadow-sm" style="color: #764ba2; border-radius: 12px;">
                <i class="bi bi-plus-lg me-1"></i> THÊM MỚI
            </a>
        </div>

        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover mb-0">
                    <thead>
                        <tr class="text-center">
                            <th style="width: 15%">Mã số</th>
                            <th class="text-start" style="width: 55%">Tên danh mục</th>
                            <th style="width: 30%">Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="c" items="${categories}">
                            <tr class="text-center">
                                <td>
                                    <span class="badge bg-light text-muted border px-3 py-2">#ID-${c.categoryCode}</span>
                                </td>
                                <td class="text-start">
                                    <div class="d-flex align-items-center">
                                        <div class="cat-icon me-3 shadow-sm">
                                            <i class="bi bi-bookmark-fill"></i>
                                        </div>
                                        <div class="cat-name">${c.name}</div>
                                    </div>
                                </td>
                                <td>
                                    <div class="d-flex justify-content-center gap-3">
                                        <a href="categories?action=update&id=${c.categoryCode}" class="action-btn btn-edit" title="Chỉnh sửa">
                                            <i class="bi bi-pencil-square"></i>
                                        </a>
                                        <a href="categories?action=delete&id=${c.categoryCode}" class="action-btn btn-delete" 
                                           onclick="return confirm('Chú ý: Xóa danh mục này sẽ ảnh hưởng đến các sách liên quan. Xác nhận xóa?')" title="Xóa">
                                            <i class="bi bi-trash3-fill"></i>
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>

                        <c:if test="${empty categories}">
                            <tr>
                                <td colspan="3" class="text-center py-5">
                                    <div class="opacity-25 mb-3">
                                        <i class="bi bi-folder-x" style="font-size: 4rem; color: #764ba2;"></i>
                                    </div>
                                    <p class="text-muted fw-bold">Hiện chưa có danh mục nào trong hệ thống.</p>
                                    <a href="categories?action=create" class="btn btn-sm btn-outline-primary rounded-pill">Tạo ngay danh mục đầu tiên</a>
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
