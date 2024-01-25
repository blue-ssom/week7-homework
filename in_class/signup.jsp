<%@ page language="java" contentType="text/html" pageEncoding="UTF-8" %>

<%-- 데이터베이스 탐색 라이브러리 --%>
<%@ page import="java.sql.DriverManager" %>

<%-- 데이터베이스 연결 라이브러리 --%>
<%@ page import="java.sql.Connection" %>

<%-- 데이터베이스 SQL 전송 라이브러리 --%>
<%@ page import="java.sql.PreparedStatement" %>

<%
    // JSP 영역
    request.setCharacterEncoding("UTF-8"); // 이전 페이지에서 온 값에 대한 인코딩 설정
    String idValue = request.getParameter("id_value");
    String pwValue = request.getParameter("pw_value");

    // DB 연결 코드
    Class.forName("com.mysql.jdbc.Driver"); // Connector 파일 찾아오는 명령어
    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/web","stageus","1234");

    // sql 준비 및 전송
    String sql = "INSERT INTO account(id,pw) VALUES(?,?)";
    PreparedStatement query = conn.prepareStatement(sql); // SQL을 전송 대기 상태로 만든 것
    query.setString(1,idValue);
    query.setString(2,pwValue);
    query.executeUpdate(); // DB에 전달
%>

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
    <h1>아이디 : <%=idValue%></h1>
    <h1>비밀번호 : <%=pwValue%></h1>

    <script>
        console.log("<%=idValue%>");
        console.log("<%=pwValue%>");
    </script>
</body>