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
    <c:if test="${param.msg == 'deleted'}">
        <div class="alert alert-success">Da xoa sach thanh cong.</div>
    </c:if>
    <c:if test="${param.msg == 'deleteFailed'}">
        <div class="alert alert-danger">Khong the xoa sach. Vui long kiem tra rang buoc du lieu lien quan.</div>
    </c:if>

    <div class="row mb-5 align-items-center">
        <div class="col-md-6">
            <h2 class="fw-bold m-0"><i class="bi bi-box-seam-fill text-primary me-2"></i>THÔNG SỐ KHO SÁCH</h2>
            <p class="text-muted">Dữ liệu chi tiết về tác giả, năm sản xuất và tồn kho thực tế.</p>
        </div>
        <div class="col-md-6 text-end">
            <c:choose>
                <c:when test="${sessionScope.userSession.role == 'Manager' || sessionScope.userSession.role == 'manager'}">
                    <a href="${pageContext.request.contextPath}/manager-dash" class="btn btn-light border shadow-sm me-2">Trang chủ</a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/admin-dashboard" class="btn btn-light border shadow-sm me-2">Trang chủ</a>
                </c:otherwise>
            </c:choose>
            <a href="${pageContext.request.contextPath}/books?action=create" class="btn btn-primary shadow">Thêm sách mới</a>
        </div>
    </div>

    <form action="${pageContext.request.contextPath}/books" method="get" class="card border-0 shadow-sm mb-4">
        <div class="card-body">
            <div class="row g-2 align-items-end">
                <div class="col-md-5">
                    <label class="form-label mb-1">Từ khóa</label>
                    <input type="text" class="form-control" name="filterKeyword"
                           value="${filterKeyword}" placeholder="Tên sách, tác giả, NXB, thể loại...">
                </div>
                <div class="col-md-2">
                    <label class="form-label mb-1">Số lượng từ</label>
                    <input type="number" min="0" class="form-control" name="minQty" value="${minQty}">
                </div>
                <div class="col-md-2">
                    <label class="form-label mb-1">Đến</label>
                    <input type="number" min="0" class="form-control" name="maxQty" value="${maxQty}">
                </div>
                <div class="col-md-2">
                    <label class="form-label mb-1">Tồn kho</label>
                    <select class="form-select" name="stockStatus">
                        <option value="">Tất cả</option>
                        <option value="inStock" ${stockStatus == 'inStock' ? 'selected' : ''}>Còn sách</option>
                        <option value="outOfStock" ${stockStatus == 'outOfStock' ? 'selected' : ''}>Hết sách</option>
                    </select>
                </div>
                <div class="col-md-2">
                    <label class="form-label mb-1">Thể loại</label>
                    <select class="form-select" name="categoryCode">
                        <option value="">Tất cả</option>
                        <c:forEach var="cat" items="${categories}">
                            <option value="${cat.categoryCode}" ${categoryCode == cat.categoryCode.toString() ? 'selected' : ''}>
                                ${cat.name}
                            </option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-2">
                    <label class="form-label mb-1">Sắp xếp SL</label>
                    <select class="form-select" name="qtySort">
                        <option value="">Mặc định</option>
                        <option value="asc" ${qtySort == 'asc' ? 'selected' : ''}>Tăng dần</option>
                        <option value="desc" ${qtySort == 'desc' ? 'selected' : ''}>Giảm dần</option>
                    </select>
                </div>
                <div class="col-md-1 d-grid">
                    <button type="submit" class="btn btn-outline-primary">Lọc</button>
                </div>
            </div>
            <div class="mt-2">
                <a href="${pageContext.request.contextPath}/books" class="btn btn-sm btn-link p-0 text-decoration-none">Xóa bộ lọc</a>
            </div>
        </div>
    </form>

    <div class="row g-4">
        <c:forEach var="book" items="${books}">
            <div class="col-md-4">
                <div class="card book-card shadow-sm">
                    <div class="img-area">
                        <c:set var="fallbackCover" value="data:image/svg+xml;utf8,%3Csvg xmlns='http://www.w3.org/2000/svg' width='320' height='400'%3E%3Crect width='100%25' height='100%25' fill='%23eef1f5'/%3E%3Ctext x='50%25' y='50%25' dominant-baseline='middle' text-anchor='middle' fill='%23727a87' font-size='20' font-family='Segoe UI'%3EChua co anh bia%3C/text%3E%3C/svg%3E" />
                        <c:choose>
                            <c:when test="${not empty book.image}">
                                <img src="${pageContext.request.contextPath}/${book.image}" class="book-img" onerror="this.src='${fallbackCover}'">
                            </c:when>
                            <c:otherwise>
                                <img src="${fallbackCover}" class="book-img">
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
        <c:if test="${empty books}">
            <div class="col-12">
                <div class="alert alert-warning mb-0">Không có sách nào khớp điều kiện lọc.</div>
            </div>
        </c:if>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
