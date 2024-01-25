<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="javax.servlet.http.HttpSession" %>

<%
    request.setCharacterEncoding("UTF-8");
    String idValue = request.getParameter("id_value");
    String pwValue = request.getParameter("pw_value");

    Connection conn = null;
    PreparedStatement query = null;
    ResultSet result = null;

    try {
        // DB 연결
        Class.forName("com.mysql.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/web", "stageus", "1234");

        // SQL 실행 - 입력된 아이디와 비밀번호를 가진 사용자 조회
        String sql = "SELECT * FROM user WHERE id=? AND password=?";
        query = conn.prepareStatement(sql);
        query.setString(1, idValue);
        query.setString(2, pwValue);
         // 디버깅용 코드
        System.out.println("idValue: " + idValue);
        System.out.println("pwValue: " + pwValue);

        
        // 디버깅용 코드
        System.out.println("SQL Query: " + query.toString());

        result = query.executeQuery();

        // 로그인 성공 여부 확인
        if (result.next()) {
            // 세션에 사용자 정보 저장
            HttpSession userSession = request.getSession();
            userSession.setAttribute("id", idValue);
            
            // 로그인 성공 시에 post.jsp로 이동
            response.sendRedirect("boardlist.jsp");
        } else {
            // 디버깅용 코드
            System.out.println("로그인 실패. 아이디 또는 비밀번호를 확인하세요.");

            // 로그인 실패 시에 필요한 처리
%>
            <script>
                alert('로그인 실패. 아이디 또는 비밀번호를 확인하세요.');
                window.location.href = 'index.html';  // 실패 시에 다시 index.html로 이동하도록 설정
            </script>
<%
        }
    } catch (Exception e) {
        // 디버깅용 코드
        e.printStackTrace();
    } finally {
        // 자원 해제
        try {
            if (result != null) result.close();
            if (query != null) query.close();
            if (conn != null) conn.close();
        } catch (Exception e) {
            // 디버깅용 코드
            e.printStackTrace();
        }
    }
%>
