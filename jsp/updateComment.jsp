<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="javax.servlet.http.HttpSession" %>

<%
    request.setCharacterEncoding("UTF-8");

    // 세션에서 사용자 정보 가져오기
    HttpSession userSession = request.getSession();
    String userId = (String) userSession.getAttribute("id");

    // 폼에서 제출된 데이터 가져오기
    String commentIdStr = request.getParameter("commentId");
    int commentId = Integer.parseInt(commentIdStr); // commentId를 정수로 변환
    String updatedCommentContent = request.getParameter("updatedCommentContent");
    int postId = Integer.parseInt(request.getParameter("postId"));

    int user_idx = 0;  // user_idx 초기화
    int commentAuthorIdx = 0;

    // 데이터베이스 연결
    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/web", "stageus", "1234");

        // 사용자 ID로부터 user_idx 가져오기
        String getUserIdQuery = "SELECT idx FROM user WHERE id=?";
        try (PreparedStatement preparedStatement = connection.prepareStatement(getUserIdQuery)) {
            preparedStatement.setString(1, userId);
            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                if (resultSet.next()) {
                    user_idx = resultSet.getInt("idx");
                }
            }
        }

        // 댓글 작성자 확인하기
        String getCommentAuthorQuery = "SELECT user_idx FROM comment WHERE comment_id=?";
        try (PreparedStatement preparedStatement = connection.prepareStatement(getCommentAuthorQuery)) {
            preparedStatement.setInt(1, commentId);
            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                if (resultSet.next()) {
                    commentAuthorIdx = resultSet.getInt("user_idx");
                    System.out.println("commentAuthorIdx found: " + commentAuthorIdx);
                } else {
                    System.out.println("No commentAuthorIdx found for comment_id: " + commentId);
                }
            }
        }

        // 댓글 작성자와 현재 로그인된 사용자가 동일한 경우에만 업데이트 수행
        if (user_idx == commentAuthorIdx) {
            // 댓글 업데이트 쿼리 실행
            String updateQuery = "UPDATE comment SET content=? WHERE comment_id=? AND user_idx=?";
            try (PreparedStatement preparedStatement = connection.prepareStatement(updateQuery)) {
                preparedStatement.setString(1, updatedCommentContent);
                preparedStatement.setInt(2, commentId);
                preparedStatement.setInt(3, user_idx);

                int rowsUpdated = preparedStatement.executeUpdate();

                if (rowsUpdated > 0) {
%>
                <script>
                    alert('댓글이 성공적으로 업데이트되었습니다.');
                    var postId = <%= request.getParameter("postId") %>;
                    window.location.href = '../jsp/viewComment.jsp?postId=' + postId;
                </script>
<%
                } else {
%>
                <script>
                    alert('댓글 업데이트에 실패했습니다. 다시 시도해주세요.');
                    var postId = <%= request.getParameter("postId") %>;
                    window.location.href = '../jsp/viewComment.jsp?postId=' + postId;
                </script>
<%
                }
            }
        } else {
%>
            <script>
                alert('댓글 작성자가 아닌 사용자는 업데이트할 수 없습니다.');
                var postId = <%= request.getParameter("postId") %>;
                window.location.href = '../jsp/viewComment.jsp?postId=' + postId;
            </script>
<%
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
