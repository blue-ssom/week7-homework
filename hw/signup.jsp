<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>

<%
    request.setCharacterEncoding("UTF-8");
    String idValue = request.getParameter("id_value");
    String pwValue = request.getParameter("pw_value");
    String nameValue = request.getParameter("name_value");
    String phoneNumberValue = request.getParameter("phone_number_value");
    String emailValue = request.getParameter("email_value");
    String addressValue = request.getParameter("address_value");

    Connection conn = null;
    PreparedStatement query = null;

    try {
        // DB 연결
        Class.forName("com.mysql.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/web", "stageus", "1234");

        // SQL 실행 - 회원가입 시 유저 정보를 user 테이블에 삽입
        String sql = "INSERT INTO user(id, password, name, phonenumber, email, address) VALUES (?, ?, ?, ?, ?, ?)";
        query = conn.prepareStatement(sql);
        query.setString(1, idValue);
        query.setString(2, pwValue);
        query.setString(3, nameValue);
        query.setString(4, phoneNumberValue);
        query.setString(5, emailValue);
        query.setString(6, addressValue);
        query.executeUpdate();
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        // 자원 해제
        try {
            if (query != null) query.close();
            if (conn != null) conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Signup Success</title>
</head>
<body>
    <script>
        // 회원가입 성공 메시지 표시
        alert("회원가입 성공! 다시 로그인하세요.");

        console.log("회원가입 성공!");
        console.log("id: <%=idValue%>");
        console.log("password: <%=pwValue%>");
        console.log("name: <%=nameValue%>");
        console.log("email: <%=phoneNumberValue%>");
        console.log("email: <%=emailValue%>");
        console.log("address: <%=addressValue%>");

        // 페이지 리디렉션
        window.location.href = "index.html";
    </script>
</body>
</html>
