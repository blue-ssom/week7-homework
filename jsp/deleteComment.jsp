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
    String loggedInUserId = (String) userSession.getAttribute("id");

    // 폼에서 제출된 데이터 가져오기
    String commentIdStr = request.getParameter("commentId");
    int commentId = Integer.parseInt(commentIdStr); // commentId를 정수로 변환

    // 댓글 작성자의 ID 가져오기
    String sql = "SELECT user.id FROM comment INNER JOIN user ON comment.user_idx = user.idx WHERE comment_id=?";
    try (Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/web", "stageus", "1234");
         PreparedStatement getAuthorIdStatement = connection.prepareStatement(sql)) {
        getAuthorIdStatement.setInt(1, commentId);

        ResultSet resultSet = getAuthorIdStatement.executeQuery();

        if (resultSet.next()) {
            String authorId = resultSet.getString("id");

            if (loggedInUserId.equals(authorId)) {
                // 댓글 삭제 쿼리 실행
                String deleteQuery = "DELETE FROM comment WHERE comment_id=?";
                try (PreparedStatement preparedStatement = connection.prepareStatement(deleteQuery)) {
                    preparedStatement.setInt(1, commentId);

                    int rowsDeleted = preparedStatement.executeUpdate();
                    if (rowsDeleted > 0) {
%>
                    <script>
                        alert('댓글이 성공적으로 삭제되었습니다.');
                        window.location.href = '../jsp/viewComment.jsp?postId=<%= request.getParameter("postId") %>';
                    </script>
<%
                    }
                }
            } else {
%>
                    <script>
                        alert('댓글 삭제에 실패했습니다. 다시 시도해주세요.');
                        window.location.href = '../jsp/viewComment.jsp?postId=<%= request.getParameter("postId") %>';
                    </script>
<%
            }
        } else {
            // 현재 로그인한 사용자와 댓글 작성자가 다른 경우에 대한 처리
%>
                <script>
                    alert('다른 사용자의 댓글은 삭제할 수 없습니다.');
                    window.location.href = '../jsp/viewComment.jsp?postId=<%= request.getParameter("postId") %>';
                </script>
<%
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
