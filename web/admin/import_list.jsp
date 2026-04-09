<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Nhật ký nhập kho | Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        body { background-color: #f8f9fc; font-family: 'Inter', system-ui, sans-serif; }
        
        .main-card {
            border: none;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.05);
            background: #fff;
            overflow: hidden;
        }

        .header-gradient {
            background: linear-gradient(135deg, #4e73df 0%, #224abe 100%);
            padding: 1.5rem 2rem;
        }

        /* Styling Table */
        .table thead th {
            background-color: #f8f9fc;
            color: #4e73df;
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

        /* Badge số lượng */
        .qty-badge {
            background-color: #e3f9ef;
            color: #1cc88a;
            font-weight: 700;
            padding: 8px 15px;
            border-radius: 10px;
            display: inline-block;
        }

        /* Time styling */
        .time-box {
            line-height: 1.2;
        }
        .date-text { color: #858796; font-size: 0.85rem; }
        .time-text { color: #4e73df; font-weight: 700; }

        .book-title {
            color: #2e3b4e;
            font-weight: 600;
            margin-bottom: 0;
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
        .btn-edit { background-color: #fff4e5; color: #ff9800; }
        .btn-delete { background-color: #ffe5e5; color: #f44336; }
        .action-btn:hover { transform: scale(1.1); }
    </style>
</head>
<body>

<div class="container-fluid py-5 px-lg-5">
    <div class="card main-card">
        <div class="header-gradient d-flex justify-content-between align-items-center">
            <div>
                <h4 class="mb-0 text-white fw-bold"><i class="bi bi-journal-arrow-down me-2"></i>NHẬT KÝ NHẬP KHO</h4>
                <small class="text-white-50 text-uppercase" style="letter-spacing: 1px;">Theo dõi luồng hàng hóa nhập vào</small>
            </div>
            <div class="d-flex gap-2">
                <a href="${pageContext.request.contextPath}/admin/dashboard.jsp" class="btn btn-outline-light border-0 shadow-none">
                    <i class="bi bi-house-door fs-5"></i>
                </a>
                <a href="imports?action=create" class="btn btn-light fw-bold px-4 shadow-sm text-primary">
                    <i class="bi bi-plus-lg me-1"></i> NHẬP MỚI
                </a>
            </div>
        </div>

        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover">
                    <thead>
                        <tr class="text-center">
                            <th>ID ĐƠN</th>
                            <th class="text-start">THÔNG TIN SÁCH</th>
                            <th>SỐ LƯỢNG</th>
                            <th>THỜI GIAN NHẬP</th>
                            <th>NHÂN VIÊN</th>
                            <th>THAO TÁC</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="item" items="${imports}">
                            <tr class="text-center">
                                <td>
                                    <span class="fw-bold text-muted small">#IMP-${item.importId}</span>
                                </td>
                                <td class="text-start">
                                    <p class="book-title text-uppercase">${item.book.title}</p>
                                    <small class="text-muted"><i class="bi bi-qr-code-scan me-1"></i>${item.book.bookCode}</small>
                                </td>
                                <td>
                                    <div class="qty-badge">
                                        + ${item.importQuantity} <small>cuốn</small>
                                    </div>
                                </td>
                                <td>
                                    <div class="time-box">
                                        <div class="time-text"><fmt:formatDate value="${item.importDate}" pattern="HH:mm" /></div>
                                        <div class="date-text"><fmt:formatDate value="${item.importDate}" pattern="dd/MM/yyyy" /></div>
                                    </div>
                                </td>
                                <td>
                                    <div class="d-flex align-items-center justify-content-center">
                                        <div class="bg-light rounded-circle p-2 me-2" style="width: 35px; height: 35px; display: flex; align-items: center; justify-content: center;">
                                            <i class="bi bi-person text-primary"></i>
                                        </div>
                                        <span class="fw-semibold">${item.importedBy}</span>
                                    </div>
                                </td>
                                <td>
                                    <div class="d-flex justify-content-center gap-2">
                                        <a href="imports?action=update&id=${item.importId}" class="action-btn btn-edit" title="Chỉnh sửa đơn">
                                            <i class="bi bi-pencil-fill"></i>
                                        </a>
                                        <a href="imports?action=delete&id=${item.importId}" class="action-btn btn-delete" 
                                           onclick="return confirm('Xác nhận gỡ bỏ bản ghi nhập kho này?')" title="Xóa bản ghi">
                                            <i class="bi bi-trash3-fill"></i>
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        
                        <c:if test="${empty imports}">
                            <tr>
                                <td colspan="6" class="text-center py-5">
                                    <img src="https://cdn-icons-png.flaticon.com/512/5058/5058046.png" width="80" class="mb-3 opacity-25">
                                    <p class="text-muted">Chưa có dữ liệu nhập kho nào được ghi nhận.</p>
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