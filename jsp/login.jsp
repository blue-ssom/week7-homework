<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%-- 데이터베이스 탐색 라이브러리 --%>
<%@ page import="java.sql.DriverManager" %>

<%-- 데이터베이스 연결 라이브러리 --%>
<%@ page import="java.sql.Connection" %>

<%-- 데이터베이스 SQL 전송 라이브러리 --%>
<%@ page import="java.sql.PreparedStatement" %>

<%-- Table에서 가져온 값을 처리하는 라이브러리 --%>
<%@ page import="java.sql.ResultSet" %>

<%-- 여태까지 이거 써야 세션 쓸 수 있는 줄 알았음..  --%>
<%@ page import="javax.servlet.http.HttpSession" %>

<%
    // JSP 영역
    request.setCharacterEncoding("UTF-8"); // 이전 페이지에서 온 값에 대한 인코딩 설정
    String idValue = request.getParameter("id_value");
    String pwValue = request.getParameter("pw_value");

    // 예외가 발생할 가능성이 있는 코드
    // 예외 발생 시 예외 객체가 생성되고, 해당 예외 객체가 catch 블록으로 전달됨
    try {
        // DB 연결
        Class.forName("com.mysql.jdbc.Driver"); // Connector 파일 찾아오는 명령어
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/web", "stageus", "1234");

         // sql 준비 및 전송
        // 입력된 아이디와 비밀번호를 가진 사용자 조회
        String sql = "SELECT * FROM user WHERE id=? AND password=?";
        PreparedStatement query = conn.prepareStatement(sql);
        query.setString(1, idValue); // 첫 번째 Column 읽어오기
        query.setString(2, pwValue); // 두 번째 Column 읽어오기

        // sql 결과 받아오기
        ResultSet result = query.executeQuery();

        // 로그인 성공 여부 확인
        // ResultSet에 결과 집합에서 다음 행으로 이동하고, 이동한 행이 존재하면 true를 반환
        if (result.next()) {
            // 세션에 사용자 정보 저장
            HttpSession userSession = request.getSession();
            userSession.setAttribute("id", idValue); // "id"는 세션에 저장될 속성의 이름, idValue는 그에 해당하는 값
            
            // JavaScript를 사용하여 클라이언트 측에서 alert 띄우기
%>
            <script>
                alert('로그인되었습니다');
                 window.location.href = '../jsp/boardlist.jsp'; // 로그인 성공 시에 boardlist.jsp로 이동
            </script>
<%
        } else {
            // 로그인 실패 시에 필요한 처리
%>
            <script>
                alert('해당 정보가 없습니다.');
                window.location.href = '../html/index.html';  // 실패 시에 다시 index.html로 이동하도록 설정
            </script>
<%
        }
    } catch (Exception e) {
        // 디버깅용 코드
        e.printStackTrace();
    }
%>