<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="javax.servlet.http.HttpSession" %>

<%
    // 세션에서 사용자 ID 가져오기
    HttpSession userSession = request.getSession();
    String userId = (String) userSession.getAttribute("id");

    try {
        // DB 연결
        Class.forName("com.mysql.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/web", "stageus", "1234");

        // sql 준비 및 전송
        // 사용자 삭제
        String sql = "DELETE FROM user WHERE id=?";
        PreparedStatement query = conn.prepareStatement(sql);
        query.setString(1, userId);

        // sql 결과 받아오기
        ResultSet result = query.executeQuery();

        if (rowsAffected > 0) {
            // 삭제 성공 시
%>
            <script>
                alert('탈퇴가 완료되었습니다.');
                window.location.href = "../html/index.html"; // 회원 탈퇴 후 이동할 페이지
            </script>
<%
        } else {
            // 삭제 실패 시
%>
            <script>
                alert('탈퇴에 실패했습니다.');
                window.location.href = "viewProfile.jsp"; // 탈퇴에 실패하면 이동할 페이지
            </script>
<%
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
