<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Điều hành Thư viện | Manager Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    
    <style>
        :root {
            --manager-dark: #1a202c;
            --manager-sidebar: #2d3748;
            --accent-color: #10b981; /* Emerald Green */
        }

        body {
            background-color: #f7fafc;
            font-family: 'Inter', system-ui, -apple-system, sans-serif;
            overflow-x: hidden;
        }

        /* Sidebar Styling */
        #sidebar {
            min-width: 260px;
            max-width: 260px;
            min-height: 100vh;
            background: var(--manager-sidebar);
            color: #fff;
            transition: all 0.3s;
            box-shadow: 4px 0 10px rgba(0,0,0,0.05);
        }

        #sidebar .sidebar-header {
            padding: 2rem 1.5rem;
            background: var(--manager-dark);
        }

        #sidebar .nav-link {
            color: #a0aec0;
            padding: 1rem 1.5rem;
            font-weight: 500;
            transition: all 0.2s;
            border-left: 4px solid transparent;
        }

        #sidebar .nav-link:hover, #sidebar .nav-link.active {
            color: #fff;
            background: rgba(255,255,255,0.05);
            border-left: 4px solid var(--accent-color);
        }

        #sidebar .nav-link i {
            font-size: 1.2rem;
        }

        /* Main Content */
        .content-wrapper {
            width: 100%;
            padding: 2rem;
        }

        /* Dashboard Cards */
        .card-stat {
            border: none;
            border-radius: 1rem;
            transition: transform 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            overflow: hidden;
            position: relative;
        }

        .card-stat:hover {
            transform: scale(1.03);
        }

        .card-stat h6 {
            text-transform: uppercase;
            letter-spacing: 1px;
            font-size: 0.75rem;
            opacity: 0.8;
        }

        .card-stat .bi-background {
            position: absolute;
            right: -10px;
            bottom: -10px;
            font-size: 5rem;
            opacity: 0.15;
            transform: rotate(-15deg);
        }

        /* Table & List styling */
        .task-card {
            border: none;
            border-radius: 1rem;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
        }

        .btn-action {
            border-radius: 0.5rem;
            padding: 0.5rem 1rem;
            font-weight: 600;
        }

        .badge-status {
            padding: 0.5em 1em;
            border-radius: 0.5rem;
        }
    </style>
</head>
<body>

<div class="d-flex">
    <nav id="sidebar">
        <div class="sidebar-header">
            <h5 class="text-success fw-bold mb-0">
                <i class="bi bi-shield-check me-2"></i>MANAGER PANEL
            </h5>
            <small class="text-muted">Hệ thống quản lý mượn trả</small>
        </div>
        
        <ul class="nav flex-column mt-3">
            <li class="nav-item">
                <a class="nav-link active" href="${pageContext.request.contextPath}/manager-dash">
                    <i class="bi bi-graph-up me-3"></i>Thống kê mượn trả
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="${pageContext.request.contextPath}/approvals">
                    <i class="bi bi-check2-circle me-3"></i>Duyệt yêu cầu mượn/trả
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="${pageContext.request.contextPath}/reservations">
                    <i class="bi bi-clock-history me-3"></i>Quản lý đặt trước
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="${pageContext.request.contextPath}/penalties">
                    <i class="bi bi-exclamation-octagon me-3"></i>Xử lý vi phạm
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="${pageContext.request.contextPath}/books">
                    <i class="bi bi-book me-3"></i>Quản lý sách
                </a>
            </li>
            <hr class="mx-3 border-secondary opacity-25">
            <li class="nav-item">
                <a class="nav-link text-danger" href="${pageContext.request.contextPath}/logout">
                    <i class="bi bi-power me-3"></i>Đăng xuất
                </a>
            </li>
        </ul>
    </nav>

    <div class="content-wrapper">
        <div class="d-flex justify-content-between align-items-center mb-5">
            <div>
                <h2 class="fw-bold text-dark">Điều hành Thư viện</h2>
                <p class="text-muted">Chào buổi làm việc, Quản trị viên!</p>
            </div>
            <div class="d-flex gap-3">
                <button class="btn btn-white shadow-sm rounded-3"><i class="bi bi-bell"></i></button>
                <a href="${pageContext.request.contextPath}/manager-report" class="btn btn-emerald bg-success text-white px-4 rounded-3 fw-bold shadow-sm">
                    Tạo báo cáo
                </a>
            </div>
        </div>

        <div class="row g-4 mb-5">
            <div class="col-md-4">
                <div class="card card-stat bg-primary text-white p-4 shadow">
                    <h6>Yêu cầu chờ duyệt</h6>
                    <h2 id="pendingApprovalsCount" class="fw-bold display-6 mb-3">${pendingApprovals != null ? pendingApprovals : 0}</h2>
                    <a href="${pageContext.request.contextPath}/approvals" class="text-white text-decoration-none small fw-bold">
                        Xem danh sách duyệt <i class="bi bi-arrow-right ms-1"></i>
                    </a>
                    <i class="bi bi-clock-history bi-background"></i>
                </div>
            </div>
            
            <div class="col-md-4">
                <div class="card card-stat bg-warning text-dark p-4 shadow">
                    <h6>Sách quá hạn chưa trả</h6>
                    <h2 id="overdueBooksCount" class="fw-bold display-6 mb-3">${overdueBooks != null ? overdueBooks : 0}</h2>
                    <a href="${pageContext.request.contextPath}/penalties" class="text-dark text-decoration-none small fw-bold">
                        Gửi cảnh báo ngay <i class="bi bi-arrow-right ms-1"></i>
                    </a>
                    <i class="bi bi-exclamation-triangle bi-background"></i>
                </div>
            </div>
            
            <div class="col-md-4">
                <div class="card card-stat bg-info text-white p-4 shadow">
                    <h6>Lượt mượn hôm nay</h6>
                    <h2 id="todayBorrowsCount" class="fw-bold display-6 mb-3">${todayBorrows != null ? todayBorrows : 0}</h2>
                    <span class="small fw-bold">Tăng 12% so với hôm qua</span>
                    <i class="bi bi-graph-up-arrow bi-background"></i>
                </div>
            </div>
        </div>

        <div class="card task-card shadow-sm">
            <div class="card-header bg-white py-3 border-0">
                <h5 class="mb-0 fw-bold">Yêu cầu chờ duyệt mới nhất</h5>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table align-middle mb-0">
                        <thead class="bg-light">
                            <tr>
                                <th class="ps-4">Thành viên</th>
                                <th>Tên sách</th>
                                <th>Loại yêu cầu</th>
                                <th>Ngày đăng ký</th>
                                <th>Hành động</th>
                            </tr>
                        </thead>
                       <tbody id="latestRequestsBody">
    <c:forEach var="item" items="${latestRequests}">
        <tr>
            <td class="ps-4">
                <div class="fw-bold text-dark">${item.user.fullName}</div>
                <small class="text-muted">ID: ${item.user.userCode}</small>
            </td>
            <td>${item.book.title}</td>
            <td>
                <c:choose>
                    <c:when test="${item.status == 'Chờ duyệt trả'}">Trả sách</c:when>
                    <c:otherwise>Mượn sách</c:otherwise>
                </c:choose>
            </td>
            <td>${item.borrowDate}</td>
            <td>
                <a href="${pageContext.request.contextPath}/approvals?action=detail&id=${item.borrowingCode}" class="btn btn-sm btn-outline-secondary btn-action me-2">Chi tiết</a>
                <a href="${pageContext.request.contextPath}/approvals?action=approve&id=${item.borrowingCode}" class="btn btn-sm btn-success btn-action me-2">Duyệt</a>
                <a href="${pageContext.request.contextPath}/approvals?action=reject&id=${item.borrowingCode}" class="btn btn-sm btn-outline-danger btn-action">Từ chối</a>
            </td>
        </tr>
    </c:forEach>
    <c:if test="${empty latestRequests}">
        <tr>
            <td colspan="5" class="text-center py-4 text-muted">Không có yêu cầu nào cần xử lý.</td>
        </tr>
    </c:if>
</tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    (function () {
        const contextPath = '${pageContext.request.contextPath}';
        const dashboardApi = contextPath + '/manager-dash?ajax=1';
        const approvalsUrl = contextPath + '/approvals';
        const pendingEl = document.getElementById('pendingApprovalsCount');
        const overdueEl = document.getElementById('overdueBooksCount');
        const todayEl = document.getElementById('todayBorrowsCount');
        const tbodyEl = document.getElementById('latestRequestsBody');
        const refreshIntervalMs = 10000;
        let refreshTimer = null;

        function escapeHtml(raw) {
            if (raw === null || raw === undefined) {
                return '';
            }
            return String(raw)
                    .replace(/&/g, '&amp;')
                    .replace(/</g, '&lt;')
                    .replace(/>/g, '&gt;')
                    .replace(/"/g, '&quot;')
                    .replace(/'/g, '&#39;');
        }

        function renderLatestRequests(items) {
            if (!Array.isArray(items) || items.length === 0) {
                tbodyEl.innerHTML = '<tr><td colspan="5" class="text-center py-4 text-muted">Không có yêu cầu nào cần xử lý.</td></tr>';
                return;
            }

            const rows = items.map(function (item) {
                const requestType = item.status === 'Chờ duyệt trả' ? 'Trả sách' : 'Mượn sách';
                const borrowId = Number(item.borrowingCode) || 0;

                return '<tr>'
                        + '<td class="ps-4"><div class="fw-bold text-dark">' + escapeHtml(item.fullName) + '</div><small class="text-muted">ID: ' + escapeHtml(item.userCode) + '</small></td>'
                        + '<td>' + escapeHtml(item.bookTitle) + '</td>'
                        + '<td>' + requestType + '</td>'
                        + '<td>' + escapeHtml(item.borrowDate) + '</td>'
                        + '<td>'
                        + '<a href="' + approvalsUrl + '?action=detail&id=' + borrowId + '" class="btn btn-sm btn-outline-secondary btn-action me-2">Chi tiết</a>'
                        + '<a href="' + approvalsUrl + '?action=approve&id=' + borrowId + '" class="btn btn-sm btn-success btn-action me-2">Duyệt</a>'
                        + '<a href="' + approvalsUrl + '?action=reject&id=' + borrowId + '" class="btn btn-sm btn-outline-danger btn-action">Từ chối</a>'
                        + '</td>'
                        + '</tr>';
            });

            tbodyEl.innerHTML = rows.join('');
        }

        async function refreshDashboardData() {
            try {
                const response = await fetch(dashboardApi, {
                    method: 'GET',
                    headers: {'Accept': 'application/json'}
                });

                if (!response.ok) {
                    return;
                }

                const data = await response.json();
                pendingEl.textContent = data.pendingApprovals != null ? data.pendingApprovals : 0;
                overdueEl.textContent = data.overdueBooks != null ? data.overdueBooks : 0;
                todayEl.textContent = data.todayBorrows != null ? data.todayBorrows : 0;
                renderLatestRequests(data.latestRequests);
            } catch (error) {
                console.error('Không thể cập nhật dữ liệu dashboard theo thời gian thực:', error);
            }
        }

        function startRealtimeRefresh() {
            if (refreshTimer !== null) {
                return;
            }
            refreshDashboardData();
            refreshTimer = setInterval(refreshDashboardData, refreshIntervalMs);
        }

        function stopRealtimeRefresh() {
            if (refreshTimer === null) {
                return;
            }
            clearInterval(refreshTimer);
            refreshTimer = null;
        }

        function handleVisibilityChange() {
            if (document.visibilityState === 'visible') {
                startRealtimeRefresh();
            } else {
                stopRealtimeRefresh();
            }
        }

        document.addEventListener('visibilitychange', handleVisibilityChange);
        handleVisibilityChange();
    })();
</script>
</body>
</html>
