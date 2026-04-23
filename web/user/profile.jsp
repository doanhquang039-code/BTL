<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Hồ sơ độc giả</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container py-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="fw-bold mb-0">Hồ sơ độc giả</h2>
        <a href="${pageContext.request.contextPath}/user-dashboard" class="btn btn-outline-secondary">Quay lại</a>
    </div>

    <div class="card border-0 shadow-sm">
        <div class="card-body p-4">
            <form action="${pageContext.request.contextPath}/profile" method="post">
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Tên đăng nhập</label>
                        <input class="form-control" value="${profileUser.username}" readonly>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Họ tên</label>
                        <input type="text" name="fullName" class="form-control" value="${profileUser.fullName}" required>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Mật khẩu mới</label>
                        <input type="password" name="password" class="form-control" placeholder="Bỏ trống nếu không đổi">
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Ngày sinh</label>
                        <input type="date" name="birthDate" class="form-control" value="${profileUser.birthDate}">
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Chức danh</label>
                        <input type="text" name="position" class="form-control" value="${profileUser.position}">
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">CMND/CCCD</label>
                        <input type="text" name="identityNumber" class="form-control" value="${profileUser.identityNumber}">
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label">Địa chỉ</label>
                    <input type="text" name="address" class="form-control" value="${profileUser.address}">
                </div>

                <div class="row">
                    <div class="col-md-3 mb-3">
                        <label class="form-label">Ngày cấp thẻ</label>
                        <input type="date" name="cardIssueDate" class="form-control" value="${profileUser.cardIssueDate}">
                    </div>
                    <div class="col-md-3 mb-3">
                        <label class="form-label">Ngày hết hạn</label>
                        <input type="date" name="cardExpiryDate" class="form-control" value="${profileUser.cardExpiryDate}">
                    </div>
                    <div class="col-md-3 mb-3">
                        <label class="form-label">Tiền ký gửi</label>
                        <input type="number" step="1000" name="depositAmount" class="form-control" value="${profileUser.depositAmount}">
                    </div>
                    <div class="col-md-3 mb-3">
                        <label class="form-label">Số sách được mượn</label>
                        <input type="number" name="maxBorrowBooks" class="form-control" value="${profileUser.maxBorrowBooks}">
                    </div>
                </div>

                <button class="btn btn-primary px-4" type="submit">Lưu hồ sơ</button>
            </form>
        </div>
    </div>
</div>
</body>
</html>
