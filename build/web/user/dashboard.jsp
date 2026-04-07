<%-- 
    Document   : dashboard.jsp
    Created on : Apr 7, 2026, 4:28:46 PM
    Author     : admoi
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
 <div class="container py-4">
    <div class="row mb-4">
        <div class="col-md-8">
            <h3 class="fw-bold">Chào mừng trở lại, ${user.fullName}! 👋</h3>
            <p class="text-muted">Hôm nay bạn muốn đọc gì nào?</p>
        </div>
        <div class="col-md-4 text-end">
            <div class="card bg-light border-0 p-2">
                <span class="small text-muted">Điểm uy tín đọc giả</span>
                <span class="fw-bold text-primary">95/100 ⭐</span>
            </div>
        </div>
    </div>

    <div class="row g-4">
        <div class="col-md-8">
            <div class="card shadow-sm border-0 rounded-4">
                <div class="card-header bg-white py-3">
                    <h5 class="mb-0 fw-bold"><i class="bi bi-book-fill me-2 text-primary"></i> Sách bạn đang giữ</h5>
                </div>
                <div class="card-body">
                    <table class="table align-middle">
                        <thead>
                            <tr class="small text-muted">
                                <th>Tên sách</th>
                                <th>Ngày hết hạn</th>
                                <th>Trạng thái</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="b" items="${userBorrows}">
                                <tr>
                                    <td><strong>${b.bookTitle}</strong></td>
                                    <td><span class="text-danger">${b.dueDate}</span></td>
                                    <td><span class="badge bg-primary-subtle text-primary">Đang mượn</span></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="list-group shadow-sm rounded-4 mb-4">
                <label class="list-group-item bg-dark text-white fw-bold py-3">Thao tác nhanh</label>
                <a href="books" class="list-group-item list-group-item-action"><i class="bi bi-search me-2"></i> Tìm sách mới</a>
                <a href="history" class="list-group-item list-group-item-action"><i class="bi bi-clock-history me-2"></i> Lịch sử mượn</a>
                <a href="profile" class="list-group-item list-group-item-action"><i class="bi bi-person-gear me-2"></i> Đổi mật khẩu</a>
            </div>
            
            <div class="card border-warning bg-warning-subtle p-3">
                <h6 class="fw-bold"><i class="bi bi-megaphone me-2"></i> Thông báo</h6>
                <p class="small mb-0 text-dark">Cuốn "Java Core" của bạn sẽ hết hạn sau 2 ngày nữa. Vui lòng trả sách đúng hạn!</p>
            </div>
        </div>
    </div>
</div>
    </body>
</html>
