<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="javax.servlet.http.HttpSession" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>내 정보 보기</title>
    <link rel="stylesheet" href="../css/viewProfile.css">
</head>
<body>
<%
    // JSP 영역
    request.setCharacterEncoding("UTF-8"); // 이전 페이지에서 온 값에 대한 인코딩 설정

    try {
        // DB 연결
        Class.forName("com.mysql.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/web", "stageus", "1234");

        // 세션에서 사용자의 id 받아오기
        HttpSession userSession = request.getSession();
        String userId = (String) userSession.getAttribute("id");

        // sql 준비 및 전송
        // 사용자 정보 조회
        String sql = "SELECT * FROM user WHERE id=?";
        PreparedStatement query = conn.prepareStatement(sql);
        query.setString(1, userId);

         // sql 결과 받아오기
        ResultSet result = query.executeQuery();

        if (result.next()) {
            // 사용자 정보 출력
%>
        <h1>내 정보 보기</h1>
        <table>
            <tr>
                <td>아이디</td>
                <td><%= result.getString("id") %></td>
            </tr>
            <tr>
                <td>이름</td>
                <td><%= result.getString("name") %></td>
            </tr>
            <tr>
                <td>전화번호</td>
                <td><%= result.getString("phonenumber") %></td>
            </tr>
            <tr>
                <td>이메일</td>
                <td><%= result.getString("email") %></td>
            </tr>
            <tr>
                <td>주소</td>
                <td><%= result.getString("address") %></td>
            </tr>
        </table>


        <div class="button-container">
            <form action="../jsp/updateProfile.jsp" method="post">
                <button class="update" type="submit">수정하기</button>
            </form>

            <form action="../jsp/withdraw.jsp" method="post">
                <button class="delete" type="submit">탈퇴하기</button>
            </form>
        </div>

<%
        } else {
%>
    <script>
        alert('사용자 정보를 찾을 수 없습니다.');
        window.location.href = "../html/index.html";  // 사용자 정보를 찾을 수 없는 경우 로그인 페이지로 이동
    </script>
<%
    }
    } catch (Exception e) {
        e.printStackTrace();
    } 
%>
</body>
</html>
