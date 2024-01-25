<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%
    request.setCharacterEncoding("UTF-8"); // 이전 페이지에서 온 값에 대한 인코딩 설정

    String idValue = request.getParameter("id_value");
    String pwValue = request.getParameter("pw_value");
    String nameValue = request.getParameter("name_value");
    String phoneNumberValue = request.getParameter("phone_number_value");
    String emailValue = request.getParameter("email_value");
    String addressValue = request.getParameter("address_value");

    try {
        // 예외 처리: 핸드폰 번호가 11자리가 아닐 때
        if (phoneNumberValue.length() != 11) {
%>
            <script>
                alert('입력된 정보를 확인해주세요.');
                window.location.href = "../html/signup.html";
            </script>
<%
        } else {
            // DB 연결
            Class.forName("com.mysql.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/web", "stageus", "1234");

            // sql 준비 및 전송
            // 회원가입 시 유저 정보를 user 테이블에 삽입
            String sql = "INSERT INTO user(id, password, name, phonenumber, email, address) VALUES (?, ?, ?, ?, ?, ?)";
            PreparedStatement query = conn.prepareStatement(sql);
            query.setString(1, idValue);
            query.setString(2, pwValue);
            query.setString(3, nameValue);
            query.setString(4, phoneNumberValue);
            query.setString(5, emailValue);
            query.setString(6, addressValue);
            query.executeUpdate();

            // 회원가입 성공 메시지 표시
%>
            <script>
                alert('회원가입 성공! 다시 로그인하세요.');
                window.location.href = '../html/index.html';
            </script>
<%
        }
    } catch (java.sql.SQLIntegrityConstraintViolationException e) {
        // Unique key 제약 조건 위반 처리
%>
        <script>
            alert('아이디/전화번호/이메일이 이미 존재합니다.');
            window.location.href = '../html/signup.html';
        </script>
<%
    } catch (Exception e) {
        e.printStackTrace();
    } 
%>

