<%-- 
    Document   : import_list.jsp
    Created on : Jan 19, 2026, 7:52:29 PM
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
    <div class="row justify-content-center">
        <div class="col-md-6">
            <div class="card shadow">
                <div class="card-header bg-dark text-white text-center">
                    <h4 class="mb-0">NHẬP THÊM SÁCH VÀO KHO</h4>
                </div>
                <div class="card-body p-4">
                    <form action="imports" method="post">
                        <div class="mb-3">
                            <label class="form-label">Chọn sách</label>
                            <select name="bookCode" class="form-select">
                                <c:forEach var="book" items="${books}">
                                    <option value="${book.bookCode}">${book.title}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Số lượng nhập thêm</label>
                            <input type="number" name="quantity" class="form-control" min="1" value="1" required>
                        </div>
                        <button type="submit" class="btn btn-dark w-100">Xác nhận nhập kho</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
    </body>
</html>
