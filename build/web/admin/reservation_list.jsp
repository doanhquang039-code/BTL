<%-- 
    Document   : reservation_list.jsp
    Created on : Jan 19, 2026, 7:52:08 PM
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
    <div class="container mt-5">
    <h2 class="fw-bold text-info mb-4"><i class="bi bi-clock-history"></i> Danh Sách Đặt Trước</h2>
    <div class="card shadow border-0">
        <div class="card-body text-center">
            <table class="table align-middle">
                <thead>
                    <tr>
                        <th>STT</th>
                        <th>Thành viên</th>
                        <th>Tên sách</th>
                        <th>Ngày đặt</th>
                        <th>Ưu tiên</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="r" items="${reservations}" varStatus="loop">
                        <tr>
                            <td>${loop.index + 1}</td>
                            <td>${r.userName}</td>
                            <td><strong>${r.bookName}</strong></td>
                            <td>${r.reserveDate}</td>
                            <td><span class="badge bg-info">Hạng ${loop.index + 1}</span></td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>
    </body>
</html>
