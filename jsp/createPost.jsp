<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Message Board</title>
</head>
<body>
    <%
        try {
            // DB 연결
            Class.forName("com.mysql.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/web", "stageus", "1234");

            // 세션에서 사용자의 id 받아오기
            HttpSession usersession = request.getSession();
            String userId = (String) usersession.getAttribute("id");

            // SQL 실행 - 사용자의 id로부터 user_idx 가져오기
            String getUserIdQuery = "SELECT idx FROM user WHERE id=?";
            try (PreparedStatement getUserIdStatement = conn.prepareStatement(getUserIdQuery)) {
                getUserIdStatement.setString(1, userId);

                try (ResultSet userIdResult = getUserIdStatement.executeQuery()) {
                    if (userIdResult.next()) {
                        int user_idx = userIdResult.getInt("idx");

                        // SQL 실행 - 게시글 등록
                        String sql = "INSERT INTO post (user_idx, title, content) VALUES (?, ?, ?)";
                        PreparedStatement query = conn.prepareStatement(sql);
                        query.setInt(1, user_idx);
                        query.setString(2, request.getParameter("title"));
                        query.setString(3, request.getParameter("content"));

                        // INSERT 문 실행
                        ResultSet result = query.executeUpdate();

                        // 등록 성공 여부에 따라 처리
                        if (result > 0) {
    %>
                            <script>
                                alert("게시글이 성공적으로 등록되었습니다.");
                                console.log("Before redirection");
                                location.href = "boardlist.jsp";
                            </script>
    <%
                        } else {
                            // 게시글 등록 실패 시
    %>
                            <script>
                                alert("게시글 등록에 실패했습니다.");
                            </script>
    <%
                        }
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    %>
</body>
</html>
