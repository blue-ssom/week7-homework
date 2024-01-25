<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.util.ArrayList" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>댓글 목록</title>
    <link rel="stylesheet" href="../css/viewComment.css"> 
</head>
<body>
    <header>
        <h1>댓글 목록</h1>
    </header>
    <div class="container">
        <!-- 댓글 작성 폼 -->
        <form action="createComment.jsp" method="post" onsubmit="return validateComment()">
            <input type="hidden" name="postId" value="<%= request.getParameter("postId") %>">
            <input type="text" class="comment-input" name="commentContent" placeholder="댓글을 입력하세요">
            <button class="input-button" type="submit">댓글 작성</button>
        </form>
        
<script>
    function validateComment() {
        var commentContent = document.getElementsByName("commentContent")[0].value.trim();
        
        if (commentContent === "") {
            alert("댓글 내용을 입력하세요.");
            return false; // Prevent form submission
        }

        // If the comment is not empty, allow form submission
        return true;
    }
</script>
        
        <%
            Connection connection = null;
            PreparedStatement preparedStatement = null;
            ResultSet resultSet = null;

            try {
                // 데이터베이스 연결
                Class.forName("com.mysql.jdbc.Driver");
                connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/web", "stageus", "1234");

                // 댓글 목록 조회 쿼리 실행 - filter comments for the selected post
                    String query = "SELECT * FROM comment WHERE post_id=? ORDER BY updationDate DESC";
                    preparedStatement = connection.prepareStatement(query);
                    preparedStatement.setInt(1, Integer.parseInt(request.getParameter("postId")));
                    resultSet = preparedStatement.executeQuery();

                // 댓글 목록을 담을 리스트
                ArrayList<ArrayList<String>> commentList = new ArrayList<>();

                // ResultSet에서 데이터를 읽어와서 리스트에 추가
                while (resultSet.next()) {
                    int commentId = resultSet.getInt("comment_id");
                    int postId = resultSet.getInt("post_id");
                    int userIdInt = resultSet.getInt("user_idx");
                    String content = resultSet.getString("content");
                    String creationDate = resultSet.getString("creationDate");
                    String updationDate = resultSet.getString("updationDate");

                    // Fetch the user's id based on user_idx
                        String getUserIdQuery = "SELECT id FROM user WHERE idx = ?";
                        PreparedStatement getUserIdStatement = connection.prepareStatement(getUserIdQuery);
                        getUserIdStatement.setInt(1, userIdInt);
                        ResultSet userResult = getUserIdStatement.executeQuery();

                        String userId = ""; // Default value if user_id is not found
                        if (userResult.next()) {
                            userId = userResult.getString("id");
                        }

                    // 각 필드를 문자열로 변환하여 리스트에 추가
                    ArrayList<String> commentInfo = new ArrayList<>();
                    commentInfo.add(String.valueOf(commentId));
                    commentInfo.add(String.valueOf(postId));
                    commentInfo.add(userId);
                    commentInfo.add(content);
                    commentInfo.add(creationDate);
                    commentInfo.add(updationDate);

                    commentList.add(commentInfo);
                }

                // 댓글 목록을 화면에 출력
                for (ArrayList<String> commentInfo : commentList) {
                %>
                    <div class="comment">
                        <h2><%= commentInfo.get(3) %></h2>
                        <p>댓글 작성자 ID: <%= commentInfo.get(2) %></p>
                        <p>작성일: <%= commentInfo.get(4) %></p>
                        <p>수정일: <%= commentInfo.get(5) %></p>

                        <div class="comment-buttons">
                            <form action="deleteComment.jsp" method="post">
                                <input type="hidden" name="commentId" value="<%= commentInfo.get(0) %>">
                                <input type="hidden" name="postId" value="<%= commentInfo.get(1) %>">

                                <button type="submit" class="delete-button">삭제</button>
                            </form>
            
                            <form action="updateCommentForm.jsp" method="post">
                                <input type="hidden" name="commentId" value="<%= commentInfo.get(0) %>">
                                <input type="hidden" name="postId" value="<%= commentInfo.get(1) %>">
                                <button type="submit" class="update-button">수정</button>
                            </form>
                        </div>
                    </div>
                <%
                }

            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                // 리소스 닫기
                try {
                    if (resultSet != null) resultSet.close();
                    if (preparedStatement != null) preparedStatement.close();
                    if (connection != null) connection.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        %>
    </div>
</body>
</html>
