<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý người dùng | Hệ thống Thư viện</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        body { background-color: #f4f7fe; font-family: 'Inter', system-ui, sans-serif; }
        
        .main-card {
            border: none;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.05);
            background: #fff;
            overflow: hidden;
        }

        .header-gradient {
            background: linear-gradient(135deg, #4361ee 0%, #3f37c9 100%);
            padding: 1.5rem 2rem;
        }

        /* Styling Table */
        .table thead th {
            background-color: #f8f9fc;
            color: #4361ee;
            font-size: 0.8rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            font-weight: 700;
            border: none;
            padding: 1rem;
        }
        
        .table tbody td {
            padding: 1.2rem 1rem;
            vertical-align: middle;
            border-bottom: 1px solid #edf2f7;
        }

        /* Badge Vai trò - Soft Style */
        .badge-role {
            font-weight: 600;
            padding: 6px 12px;
            border-radius: 8px;
            font-size: 0.75rem;
            display: inline-block;
            min-width: 90px;
        }
        .role-admin { background-color: #fff5f8; color: #f1416c; } /* Đỏ nhạt */
        .role-manager { background-color: #fff8dd; color: #ffc700; } /* Vàng nhạt */
        .role-user { background-color: #e8fff3; color: #50cd89; } /* Xanh lá nhạt */

        /* Avatar giả lập */
        .user-avatar {
            width: 40px;
            height: 40px;
            background-color: #eef1ff;
            color: #4361ee;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 10px;
            font-weight: bold;
        }

        .action-btn {
            width: 35px;
            height: 35px;
            border-radius: 10px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            transition: 0.3s;
            text-decoration: none;
        }
        .btn-edit { background-color: #fff4e5; color: #ff9800; border: none; }
        .btn-delete { background-color: #ffe5e5; color: #f44336; border: none; }
        .action-btn:hover { transform: scale(1.1); }
    </style>
</head>
<body>

<div class="container-fluid py-5 px-lg-5">
    <div class="card main-card">
        <div class="header-gradient d-flex justify-content-between align-items-center">
            <div>
                <h4 class="mb-0 text-white fw-bold"><i class="bi bi-people-fill me-2"></i>QUẢN LÝ THÀNH VIÊN</h4>
                <small class="text-white-50">Quản lý tài khoản, vai trò và bảo mật người dùng</small>
            </div>
            <div class="d-flex gap-2">
                <a href="${pageContext.request.contextPath}/admin-dashboard" class="btn btn-outline-light border-0">
                    <i class="bi bi-house-door fs-5"></i>
                </a>
                <a href="users?action=create" class="btn btn-light fw-bold px-4 shadow-sm text-primary">
                    <i class="bi bi-person-plus-fill me-1"></i> THÊM MỚI
                </a>
            </div>
        </div>

        <div class="card-body p-4">
            <div class="row mb-4">
                <div class="col-md-4">
                    <div class="input-group shadow-sm rounded-3 overflow-hidden">
                        <input type="text" class="form-control border-0" placeholder="Tìm tên hoặc username...">
                        <button class="btn btn-primary border-0"><i class="bi bi-search"></i></button>
                    </div>
                </div>
            </div>

            <div class="table-responsive">
                <table class="table table-hover">
                    <thead>
                        <tr class="text-center">
                            <th>MÃ SỐ</th>
                            <th class="text-start">THÔNG TIN THÀNH VIÊN</th>
                            <th>TÊN ĐĂNG NHẬP</th>
                            <th>MẬT KHẨU</th>
                            <th>VAI TRÒ</th>
                            <th>THAO TÁC</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="u" items="${users}">
                            <tr class="text-center">
                                <td class="fw-bold text-muted small">#UID-${u.userCode}</td>
                                <td class="text-start">
                                    <div class="d-flex align-items-center">
                                        <div class="user-avatar me-3">
                                            ${u.fullName.substring(0,1).toUpperCase()}
                                        </div>
                                        <div>
                                            <div class="fw-bold text-dark mb-0">${u.fullName}</div>
                                            <small class="text-muted">ID: ${u.userCode}</small>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <span class="badge bg-light text-dark border px-3">${u.username}</span>
                                </td>
                                <td>
                                    <span class="text-muted" title="Mật khẩu đã được mã hóa">
                                        <i class="bi bi-shield-lock me-1"></i>••••••
                                    </span>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${u.role.equalsIgnoreCase('admin')}">
                                            <span class="badge-role role-admin"><i class="bi bi-shield-lock-fill me-1"></i>Admin</span>
                                        </c:when>
                                        <c:when test="${u.role.equalsIgnoreCase('manager')}">
                                            <span class="badge-role role-manager"><i class="bi bi-person-badge-fill me-1"></i>Manager</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge-role role-user"><i class="bi bi-person-fill me-1"></i>User</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <div class="d-flex justify-content-center gap-2">
                                        <a href="users?action=update&id=${u.userCode}" class="action-btn btn-edit" title="Chỉnh sửa">
                                            <i class="bi bi-pencil-fill"></i>
                                        </a>
                                        <a href="users?action=delete&id=${u.userCode}" class="action-btn btn-delete" 
                                           onclick="return confirm('Xóa thành viên này sẽ không thể khôi phục. Tiếp tục?')" title="Xóa">
                                            <i class="bi bi-trash3-fill"></i>
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        
                        <c:if test="${empty users}">
                            <tr>
                                <td colspan="6" class="text-center py-5">
                                    <img src="https://cdn-icons-png.flaticon.com/512/5058/5058046.png" width="80" class="mb-3 opacity-25">
                                    <p class="text-muted">Hệ thống chưa có thành viên nào.</p>
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
