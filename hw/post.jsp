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
        Connection conn = null;
        PreparedStatement query = null;

        String id = (String) session.getAttribute("id"); 
        try {
            // DB 연결
            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/web", "stageus", "1234");

            // 세션에서 사용자의 user_idx 받아오기
            HttpSession usersession = request.getSession();

            int user_idx = (int) usersession.getAttribute("user_idx");
            System.out.println("user_idx: " + user_idx);

            String title = request.getParameter("title");
            System.out.println("title: " + title);

            String content = request.getParameter("content");
            System.out.println("content: " + content);

            Integer user_idx = (Integer) usersession.getAttribute("user_idx");
            if (user_idx != null) {
                System.out.println("user_idx: " + user_idx);
            } else {
                System.out.println("user_idx is null");
            }



            // SQL 실행 - 게시글 등록
            String sql = "INSERT INTO post (user_idx, title, content) VALUES (?, ?, ?)";
            query = conn.prepareStatement(sql);
            query.setInt(1, user_idx);
            query.setString(2, request.getParameter("title"));
            query.setString(3, request.getParameter("content"));

            // INSERT 문 실행
            int affectedRows = query.executeUpdate();

            // 등록 성공 여부에 따라 처리
            if (affectedRows > 0) {
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
                    window.location.href = 'post.html'; 
                </script>
    <%
            }

        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Exception: " + e.getMessage());
    %>
            <script>
                alert("게시글 등록 중 오류가 발생했습니다.");
                    window.location.href = 'post.html'; 

            </script>
    <%
        } finally {
            // 여기서는 필요에 따라 자원을 해제하는 부분을 작성합니다.
            try {
                if (query != null) query.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    %>
</body>
</html>

