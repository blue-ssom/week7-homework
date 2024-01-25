<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>

<%
    request.setCharacterEncoding("UTF-8");// 이전 페이지에서 온 값에 대한 인코딩 설정

    // 전달된 이름과 핸드폰 번호 파라미터 가져오기
    String name = request.getParameter("name_value");
    String phonenumber = request.getParameter("phone_number_value");

    try {
        // DB 연결
        Class.forName("com.mysql.jdbc.Driver"); // Connector 파일 찾아오는 명령어
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/web", "stageus", "1234");

        // sql 준비 및 전송
        // 입력된 정보를 가진 사용자 비밀번호  조회
        String sql = "SELECT id FROM user WHERE name=? AND phonenumber=?";
        PreparedStatement query = conn.prepareStatement(sql);
        query.setString(1, name);
        query.setString(2, phonenumber);

        // sql 결과 받아오기
        ResultSet result = query.executeQuery();

        // 조회된 아이디를 클라이언트에게 전송
        if (result.next()) {
            String foundId = result.getString("id");
%>
            <script>
                alert('아이디는 <%=foundId%> 입니다.');
                window.location.href = "../html/index.html";
            </script>
<%
        } else {
%>
            <script>
                alert('해당하는 아이디가 없습니다.');
                window.location.href = "../html/searchId.html";
            </script>
<%
        }

    } catch (Exception e) {
        e.printStackTrace();
    }
%>
