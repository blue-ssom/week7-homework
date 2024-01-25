<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page import="java.sql.Timestamp" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Board List</title>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f0f0f0;
            margin: 0;
            padding: 20px;
            display: flex;
            flex-direction: column;
            align-items: center;
            text-align: center;
        }

        h2 {
            color: #3498db;
        }

        .post-container {
            margin-top: 20px;
            display: flex;
            flex-wrap: wrap;
            justify-content: space-around;
        }

        .post-card {
            width: 300px;
            margin-bottom: 20px;
            padding: 10px;
            background-color: #ffffff;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            border-radius: 4px;
            text-align: left;
        }

        .post-card h3 {
            color: #3498db;
        }

        .post-card p {
            color: #555;
        }

         .create-post-button {
            display: inline-block;
            padding: 10px 20px;
            font-size: 16px;
            text-align: center;
            text-decoration: none;
            background-color: #3498db;
            color: #fff;
            border-radius: 4px;
            transition: background-color 0.3s ease;
        }

        .create-post-button:hover {
            background-color: #2980b9;
        }
    </style>
</head>
<body>

    <%
        Connection conn = null;
        PreparedStatement query = null;
        ResultSet result = null;

        try {
            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/web", "stageus", "1234");

            String sql = "SELECT post.*, user.id AS user_id FROM post JOIN user ON post.user_idx = user.idx";
            query = conn.prepareStatement(sql);
            result = query.executeQuery();
    %>

    <h2>게시글 목록</h2>

    <div class="post-container">
        <% while (result.next()) { %>
            <div class="post-card">
                <h3><%= result.getString("title") %></h3>
                <p><%= result.getString("content") %></p>
                <p>작성자: <%= result.getString("user_id") %></p>
                <p>작성일: <%= result.getTimestamp("creationDate") %></p>
                <p>수정일: <%= result.getTimestamp("updationDate") %></p>
            </div>
        <% } %>
    </div>
   
    <!-- 스타일을 추가한 새로운 게시글 생성 버튼 -->
    <a href="post.html" class="create-post-button">게시글 추가</a>

    <%
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            // 리소스 해제 코드 생략
        }
    %>

</body>
</html>
