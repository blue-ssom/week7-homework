<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="javax.servlet.http.HttpSession" %>

<%
    // Get the comment ID from the request
    int commentId = Integer.parseInt(request.getParameter("commentId"));
    int postId = Integer.parseInt(request.getParameter("postId"));

    // Get the user ID from the session
    HttpSession userSession = request.getSession();
    String userId = (String) userSession.getAttribute("id");

    // Initialize variables
    int user_idx = 0;
    int commentAuthorIdx = 0;

    try {
        // Database connection
        Class.forName("com.mysql.jdbc.Driver");
        try (Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/web", "stageus", "1234")) {
            // Get user_idx based on user ID
            String getUserIdQuery = "SELECT idx FROM user WHERE id=?";
            try (PreparedStatement getUserIdStatement = connection.prepareStatement(getUserIdQuery)) {
                getUserIdStatement.setString(1, userId);
                try (ResultSet userResult = getUserIdStatement.executeQuery()) {
                    if (userResult.next()) {
                        user_idx = userResult.getInt("idx");
                    }
                }
            }

            // Get comment author's user_idx
            String getCommentAuthorQuery = "SELECT user_idx FROM comment WHERE comment_id=?";
            try (PreparedStatement getCommentAuthorStatement = connection.prepareStatement(getCommentAuthorQuery)) {
                getCommentAuthorStatement.setInt(1, commentId);
                try (ResultSet commentAuthorResult = getCommentAuthorStatement.executeQuery()) {
                    if (commentAuthorResult.next()) {
                        commentAuthorIdx = commentAuthorResult.getInt("user_idx");
                    }
                }
            }
        }

        // Check if the logged-in user is the author of the comment
        if (user_idx != commentAuthorIdx) {
            // Display an alert on the client side
%>
            <script>
                alert('You are not authorized to edit this comment.');
                var postId = <%= request.getParameter("postId") %>;
                window.location.href = '../jsp/viewComment.jsp?postId=' + postId; // Redirect to viewComment.jsp with the specific postId
            </script>
<%
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Comment</title>
    <link rel="stylesheet" href="../css/updateComment.css"> 
</head>
<body>
    <header>
        <h1>Edit Comment</h1>
    </header>
    <div class="container">
        <form action="../jsp/updateComment.jsp" method="post">
            <input type="hidden" name="commentId" value="<%= request.getParameter("commentId") %>">
            <input type="hidden" name="postId" value="<%= request.getParameter("postId") %>">
            
            <p>수정할 내용</p>
            <input type="text" name="updatedCommentContent"></input>
            
            <button type="submit">Update Comment</button>
        </form>
    </div>
</body>
</html>
