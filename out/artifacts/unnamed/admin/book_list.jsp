<%-- 
    Document   : book_list.jsp
    Mục đích   : Hiển thị danh sách sách dạng lưới (Grid) với đầy đủ thông số chi tiết
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Thông số kho sách chi tiết | Admin</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        body { background-color: #f0f2f5; font-family: 'Segoe UI', sans-serif; }
        
        .book-card {
            border: none;
            border-radius: 20px;
            background: #fff;
            transition: all 0.3s ease;
            height: 100%;
            display: flex;
            flex-direction: column;
        }

        .book-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 12px 24px rgba(0,0,0,0.12);
        }

        /* Vùng chứa ảnh bìa */
        .img-area {
            height: 320px;
            position: relative;
            background: #e9ecef;
            border-radius: 20px 20px 0 0;
            overflow: hidden;
        }

        .book-img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        /* Badge trạng thái */
        .status-badge {
            position: absolute;
            bottom: 15px;
            left: 15px;
            padding: 5px 12px;
            border-radius: 30px;
            font-size: 0.75rem;
            font-weight: 600;
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
        }

        /* Thông tin chi tiết */
        .info-area { padding: 20px; flex-grow: 1; }
        
        .book-id { font-size: 0.8rem; color: #6c757d; font-weight: 600; margin-bottom: 5px; }
        .book-title { font-size: 1.2rem; font-weight: 800; color: #1a1c1e; margin-bottom: 10px; line-height: 1.4; }
        
        /* Bảng thông số cụ thể */
        .specs-table { font-size: 0.85rem; width: 100%; margin-bottom: 15px; }
        .specs-table td { padding: 4px 0; }
        .label-spec { color: #8e94a0; width: 40%; }
        .value-spec { color: #2d3436; font-weight: 600; }

        /* Vùng kho bãi */
        .stock-zone {
            background: #f8f9fa;
            border-radius: 12px;
            padding: 12px;
            margin-bottom: 15px;
        }

        .action-zone {
            padding: 15px 20px 25px;
            border-top: 1px dashed #dee2e6;
        }
    </style>
</head>
<body>

<div class="container py-5">
    <div class="row mb-5 align-items-center">
        <div class="col-md-6">
            <h2 class="fw-bold m-0"><i class="bi bi-box-seam-fill text-primary me-2"></i>THÔNG SỐ KHO SÁCH</h2>
            <p class="text-muted">Dữ liệu chi tiết về tác giả, năm sản xuất và tồn kho thực tế.</p>
        </div>
        <div class="col-md-6 text-end">
            <a href="${pageContext.request.contextPath}/admin-dashboard" class="btn btn-light border shadow-sm me-2">Trang chủ</a>
            <a href="${pageContext.request.contextPath}/books?action=create" class="btn btn-primary shadow">Thêm sách mới</a>
        </div>
    </div>

    <div class="row g-4">
        <c:forEach var="book" items="${books}">
            <div class="col-md-4">
                <div class="card book-card shadow-sm">
                    <div class="img-area">
                        <c:choose>
                            <c:when test="${not empty book.image}">
                                <img src="${pageContext.request.contextPath}/${book.image}" class="book-img" onerror="this.src='https://via.placeholder.com/320x400?text=Chưa+có+ảnh'">
                            </c:when>
                            <c:otherwise>
                                <img src="https://via.placeholder.com/320x400?text=Chưa+có+ảnh" class="book-img">
                            </c:otherwise>
                        </c:choose>
                        
                        <c:if test="${book.quantity <= 0}">
                            <span class="status-badge bg-danger text-white text-uppercase">Hết hàng</span>
                        </c:if>
                        <c:if test="${book.quantity > 0}">
                            <span class="status-badge bg-success text-white text-uppercase">Đang sẵn có</span>
                        </c:if>
                    </div>

                    <div class="info-area">
                        <div class="book-id">MÃ SÁCH: #BT-${book.bookCode}</div>
                        <div class="book-title text-uppercase">${book.title}</div>
                        
                        <table class="specs-table">
                            <tr>
                                <td class="label-spec"><i class="bi bi-person-fill me-1"></i>Tác giả:</td>
                                <td class="value-spec text-primary">${book.author}</td>
                            </tr>
                            <tr>
                                <td class="label-spec"><i class="bi bi-calendar-event me-1"></i>Năm sản xuất:</td>
                                <td class="value-spec">${book.publishYear}</td>
                            </tr>
                            <tr>
                                <td class="label-spec"><i class="bi bi-building me-1"></i>NXB:</td>
                                <td class="value-spec">${empty book.publisher ? 'Chưa cập nhật' : book.publisher}</td>
                            </tr>
                            <tr>
                                <td class="label-spec"><i class="bi bi-file-text me-1"></i>So trang:</td>
                                <td class="value-spec">${book.pageCount}</td>
                            </tr>
                            <tr>
                                <td class="label-spec"><i class="bi bi-geo-alt me-1"></i>Vi tri:</td>
                                <td class="value-spec">${empty book.shelfLocation ? 'Chưa cập nhật' : book.shelfLocation}</td>
                            </tr>
                            <tr>
                                <td class="label-spec"><i class="bi bi-tag-fill me-1"></i>Thể loại:</td>
                                <td class="value-spec">${book.category.name}</td>
                            </tr>
                        </table>

                        <div class="stock-zone d-flex justify-content-between">
                            <div class="text-center w-50 border-end">
                                <small class="text-muted d-block">Hiện còn</small>
                                <span class="fw-bold fs-5 text-success">${book.quantity}</span>
                            </div>
                            <div class="text-center w-50">
                                <small class="text-muted d-block">Lịch sử nhập</small>
                                <span class="fw-bold fs-5 text-primary">${book.totalImported}</span>
                            </div>
                        </div>
                    </div>

                    <div class="action-zone">
                        <div class="row g-2">
                            <div class="col-9">
                                <a href="${pageContext.request.contextPath}/books?action=update&id=${book.bookCode}" class="btn btn-warning w-100 fw-bold">
                                    <i class="bi bi-pencil-square me-2"></i>CHỈNH SỬA
                                </a>
                            </div>
                            <div class="col-3">
                                <a href="${pageContext.request.contextPath}/books?action=delete&id=${book.bookCode}" 
                                   class="btn btn-outline-danger w-100"
                                   onclick="return confirm('Xóa dữ liệu sách: ${book.title}?')">
                                    <i class="bi bi-trash"></i>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
