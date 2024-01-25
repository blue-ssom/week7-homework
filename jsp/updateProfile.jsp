<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>

<%
    request.setCharacterEncoding("UTF-8");

    // 세션에서 사용자 ID 가져오기
    HttpSession userSession = request.getSession();
    String userId = (String) userSession.getAttribute("id");

    Connection conn = null;
    PreparedStatement query = null;
    ResultSet result = null;

    try {
        // DB 연결
        Class.forName("com.mysql.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/web", "stageus", "1234");

        // SQL 실행 - 사용자 정보 조회
        String sql = "SELECT * FROM user WHERE id=?";
        query = conn.prepareStatement(sql);
        query.setString(1, userId);

        // 결과 받아오기
        result = query.executeQuery();

        if (result.next()) {
            // 사용자 정보가 있을 경우
            String name = result.getString("name");
            String phoneNumber = result.getString("phonenumber"); // Move the declaration here
            String email = result.getString("email");
            String address = result.getString("address");

            // 핸드폰 번호가 11자리가 아닐 때
            if (phoneNumber.length() != 11) {
%>
            <script>
                alert('핸드폰 번호 11자리를 입력해주세요.');
                window.location.href = "modifyProfile.jsp";
            </script>
<%
            } else {
%>
            <!DOCTYPE html>
            <html lang="en">
            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Modify Profile</title>
                <link rel="stylesheet" href="../css/modifyProfile.css">
            </head>
            <body>
                <div>
                    <h1>내 정보 수정하기</h1>
                    <form action="updateProfile.jsp" method="post">
                            <p>아이디</p>
                            <input type="text" name="name_value" value="<%= name %>" required>
                       
                            <p>전화번호</p>
                            <input type="text" name="phone_number_value" value="<%= phoneNumber %>" required>
                       
                            <p>이메일</p>
                            <input type="text" name="email_value" value="<%= email %>" required>
                        
                            <p>주소</p>
                            <input type="text" name="address_value" value="<%= address %>" required>

                            <button type="submit">수정하기</button>
                    </form>
                </div>
            </body>
            </html>
<%
            }
        } else {
            // 사용자 정보가 없는 경우
%>
            <script>
                alert('프로필 업데이트에 실패했습니다.');
                window.location.href = "viewProfile.jsp";
            </script>
<%
        }
    } catch (Exception e) {
        e.printStackTrace();
    } 
%>
