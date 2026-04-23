<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Bảng điều khiển độc giả</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    
    <style>
        :root {
            --primary-color: #4361ee;
            --secondary-color: #3f37c9;
            --bg-light: #f8f9fa;
        }

        body {
            background-color: var(--bg-light);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        /* Hiệu ứng cho các thẻ Card */
        .rounded-4 { border-radius: 1rem !important; }
        
        .card {
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        
        .shadow-sm:hover {
            transform: translateY(-5px);
            box-shadow: 0 1rem 3rem rgba(0,0,0,0.1) !important;
        }

        /* Điểm uy tín */
        .reputation-card {
            background: linear-gradient(135deg, #ffffff 0%, #f1f3ff 100%);
            border: 1px solid #e0e4ff !important;
        }

        /* Bảng danh sách sách */
        .table thead th {
            border-top: none;
            background-color: #fcfcfc;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            font-size: 0.75rem;
        }

        /* Sidebar - Thao tác nhanh */
        .list-group-item {
            border: none;
            padding: 1rem 1.25rem;
            margin-bottom: 2px;
            transition: all 0.2s;
        }
        
        .list-group-item-action:hover {
            background-color: #eef1ff;
            color: var(--primary-color);
            padding-left: 1.5rem;
        }

        /* Badge trạng thái */
        .badge.bg-primary-subtle {
            color: var(--primary-color);
            background-color: #eef1ff !important;
            font-weight: 600;
        }

        /* Animation cho thông báo */
        .notification-card {
            border-left: 5px solid #ffca2c !important;
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0% { box-shadow: 0 0 0 0 rgba(255, 202, 44, 0.4); }
            70% { box-shadow: 0 0 0 10px rgba(255, 202, 44, 0); }
            100% { box-shadow: 0 0 0 0 rgba(255, 202, 44, 0); }
        }
    </style>
</head>
<body>

<div class="container py-5">
    <div class="row mb-5 align-items-center">
        <div class="col-md-8">
            <h2 class="fw-bold mb-1 text-dark">Chào mừng trở lại, ${userSession.fullName}! 👋</h2>
            <p class="text-muted mb-0">Hôm nay bạn muốn khám phá kho tri thức nào?</p>
        </div>
        <div class="col-md-4 text-md-end mt-3 mt-md-0">
            <div class="card reputation-card border-0 p-3 shadow-sm d-inline-block">
                <span class="small text-muted d-block">Điểm uy tín độc giả</span>
                <span class="fw-bold text-primary fs-4">95/100 <small class="fs-6">⭐</small></span>
            </div>
        </div>
    </div>

    <div class="row g-4">
        <div class="col-lg-8">
            <div class="card shadow-sm border-0 rounded-4 overflow-hidden">
                <div class="card-header bg-white py-3 border-bottom-0 d-flex justify-content-between align-items-center">
                    <h5 class="mb-0 fw-bold"><i class="bi bi-book-fill me-2 text-primary"></i> Sách bạn đang giữ</h5>
                    <span class="badge bg-light text-dark border">${userBorrows.size()} cuốn</span>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table align-middle mb-0">
                            <thead>
                                <tr class="text-muted">
                                    <th class="ps-4">Tên sách</th>
                                    <th>Ngày hết hạn</th>
                                    <th class="text-center">Trạng thái</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty userBorrows}">
                                        <c:forEach var="b" items="${userBorrows}">
                                            <tr>
                                                <td class="ps-4">
                                                    <div class="fw-bold text-dark">${b.book.title}</div>
                                                </td>
                                                <td><span class="text-danger fw-semibold">${b.dueDate}</span></td>
                                                <td class="text-center">
                                                    <span class="badge bg-primary-subtle rounded-pill">${b.status}</span>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="3" class="text-center py-5 text-muted">
                                                <i class="bi bi-inbox fs-1 d-block mb-2"></i>
                                                Bạn hiện không mượn cuốn sách nào.
                                            </td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-lg-4">
            <div class="list-group shadow-sm rounded-4 mb-4 overflow-hidden border-0">
                <label class="list-group-item bg-dark text-white fw-bold py-3">
                    <i class="bi bi-lightning-charge-fill me-2 text-warning"></i> Thao tác nhanh
                </label>
                <a href="${pageContext.request.contextPath}/books" class="list-group-item list-group-item-action border-bottom">
                    <i class="bi bi-search me-2 text-primary"></i> Tìm sách mới
                </a>
                <a href="${pageContext.request.contextPath}/history" class="list-group-item list-group-item-action border-bottom">
                    <i class="bi bi-clock-history me-2 text-success"></i> Lịch sử mượn
                </a>
                <a href="${pageContext.request.contextPath}/profile" class="list-group-item list-group-item-action">
                    <i class="bi bi-person-gear me-2 text-secondary"></i> Đổi mật khẩu
                </a>
            </div>
            
            <div class="card notification-card border-0 shadow-sm p-4 bg-white rounded-4">
                <h6 class="fw-bold text-dark mb-3"><i class="bi bi-megaphone-fill me-2 text-warning"></i> Thông báo mới</h6>
                <div class="d-flex border-start border-warning border-3 ps-3">
                    <p class="small mb-0 text-muted">
                        Cuốn <strong class="text-dark">"Java Core"</strong> của bạn sẽ hết hạn sau <span class="text-danger fw-bold">2 ngày</span> nữa. 
                        Vui lòng trả sách đúng hạn để duy trì điểm uy tín!
                    </p>
                </div>
            </div>
            
            <div class="mt-4">
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-danger w-100 rounded-pill fw-bold border-2">
                    <i class="bi bi-box-arrow-right me-2"></i> ĐĂNG XUẤT
                </a>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
