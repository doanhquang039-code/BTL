<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý mượn trả sách | Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        body { background-color: #f4f7fe; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        
        .main-card {
            border: none;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.05);
            background: #fff;
        }

        .card-header {
            background: #1e1e2d !important;
            border-radius: 20px 20px 0 0 !important;
            padding: 1.5rem !important;
        }

        /* Tùy chỉnh bảng */
        .table { margin-bottom: 0; }
        .table thead th {
            background-color: #f8f9fa;
            color: #8e94a0;
            text-transform: uppercase;
            font-size: 0.75rem;
            letter-spacing: 0.5px;
            font-weight: 700;
            border-bottom: none;
            padding: 15px;
        }
        .table tbody td {
            padding: 15px;
            border-bottom: 1px solid #f1f1f4;
            color: #464e5f;
            font-size: 0.9rem;
        }
        .table tbody tr:hover { background-color: #f9f9ff; }

        /* Badge trạng thái "xịn" */
        .badge-status {
            font-weight: 600;
            padding: 6px 12px;
            border-radius: 8px;
            font-size: 0.75rem;
        }
        .status-returned { background-color: #e8fff3; color: #50cd89; } /* Đã trả - Xanh lá nhạt */
        .status-overdue { background-color: #fff5f8; color: #f1416c; }  /* Quá hạn - Đỏ nhạt */
        .status-borrowing { background-color: #fff8dd; color: #ffc700; } /* Đang mượn - Vàng nhạt */

        .user-info .name { font-weight: 700; color: #181c32; display: block; }
        .user-info .id { font-size: 0.8rem; color: #a1a5b7; }
        
        .book-title { font-weight: 600; color: #4361ee; }

        .btn-action {
            width: 32px;
            height: 32px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: 8px;
            transition: 0.2s;
        }
    </style>
</head>
<body>

<div class="container-fluid py-5 px-4">
    <div class="card main-card">
        <div class="card-header d-flex justify-content-between align-items-center">
            <div>
                <h4 class="mb-0 text-white fw-bold"><i class="bi bi-arrow-left-right me-2 text-primary"></i>QUẢN LÝ MƯỢN TRẢ</h4>
                <small class="text-muted">Theo dõi và phê duyệt trạng thái sách</small>
            </div>
            <div class="d-flex gap-2">
                <a href="${pageContext.request.contextPath}/admin/dashboard.jsp" class="btn btn-outline-light btn-sm">
                    <i class="bi bi-house"></i>
                </a>
                <a href="borrow?action=create" class="btn btn-primary btn-sm px-3 shadow">
                    <i class="bi bi-plus-lg me-1"></i> Tạo phiếu mới
                </a>
            </div>
        </div>
        
        <div class="card-body p-4">
            <div class="row mb-4">
                <div class="col-md-4">
                    <form action="borrow" method="get" class="input-group">
                        <input type="hidden" name="action" value="search">
                        <input type="text" name="keyword" class="form-control form-control-sm border-end-0" placeholder="Tìm theo mã hoặc tên...">
                        <button class="btn btn-sm btn-light border border-start-0" type="submit">
                            <i class="bi bi-search text-primary"></i>
                        </button>
                    </form>
                </div>
            </div>

            <div class="table-responsive">
                <table class="table align-middle">
                    <thead>
                        <tr class="text-center">
                            <th>MÃ PHIẾU</th>
                            <th class="text-start">ĐỘC GIẢ</th>
                            <th class="text-start">THÔNG TIN SÁCH</th>
                            <th>NGÀY MƯỢN</th>
                            <th>HẠN TRẢ</th>
                            <th>TRẠNG THÁI</th>
                            <th>HÀNH ĐỘNG</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="b" items="${borrowings}">
                            <tr class="text-center">
                                <td class="fw-bold">#BT-${b.borrowingCode}</td>
                                <td class="text-start">
                                    <div class="user-info">
                                        <span class="name">${b.user.fullName}</span>
                                        <span class="id">Mã thẻ: ${b.user.userCode}</span>
                                    </div>
                                </td>
                                <td class="text-start">
                                    <div class="book-title text-truncate" style="max-width: 250px;">
                                        <i class="bi bi-book me-1"></i>${b.book.title}
                                    </div>
                                </td>
                                <td>${b.borrowDate}</td>
                                <td>
                                    <span class="fw-semibold">${b.dueDate}</span>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${b.status == 'Đã trả'}">
                                            <span class="badge-status status-returned">Đã trả</span>
                                        </c:when>
                                        <c:when test="${b.status == 'Quá hạn'}">
                                            <span class="badge-status status-overdue">Quá hạn</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge-status status-borrowing">Đang mượn</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <div class="d-flex justify-content-center gap-2">
                                        <a href="borrow?action=update&id=${b.borrowingCode}" 
                                           class="btn btn-light-warning btn-action text-warning border" title="Sửa thông tin">
                                            <i class="bi bi-pencil-fill"></i>
                                        </a>
                                        
                                        <c:if test="${b.status != 'Đã trả'}">
                                            <a href="borrow?action=return&id=${b.borrowingCode}" 
                                               class="btn btn-light-danger btn-action text-danger border" 
                                               title="Xác nhận trả sách"
                                               onclick="return confirm('Xác nhận độc giả đã trả sách?')">
                                                <i class="bi bi-arrow-return-left"></i>
                                            </a>
                                        </c:if>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        
                        <c:if test="${empty borrowings}">
                            <tr>
                                <td colspan="7" class="text-center py-5">
                                    <img src="https://cdn-icons-png.flaticon.com/512/5058/5058046.png" width="60" class="mb-3 opacity-25">
                                    <p class="text-muted">Không tìm thấy phiếu mượn nào.</p>
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