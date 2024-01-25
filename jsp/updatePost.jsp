<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="javax.servlet.http.HttpSession" %>

<%
    request.setCharacterEncoding("UTF-8"); // Set encoding for form data

    // 세션에서 사용자 정보 가져오기
    HttpSession userSession = request.getSession();
    String userId = (String) userSession.getAttribute("id");

    // 폼에서 제출된 데이터 가져오기
    String postIdStr = request.getParameter("postId");
    int postId = Integer.parseInt(postIdStr); // postId를 정수로 변환
    String updatedTitle = request.getParameter("updatedTitle");
    String updatedContent = request.getParameter("updatedContent");

    int user_idx = 0;  // user_idx 초기화
    int postAuthorIdx = 0;

    try {
        // 데이터베이스 연결
        Class.forName("com.mysql.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/web", "stageus", "1234");

        // 사용자 ID로부터 user_idx 가져오기
        try (PreparedStatement preparedStatement = conn.prepareStatement("SELECT idx FROM user WHERE id=?")) {
            preparedStatement.setString(1, userId);

            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                if (resultSet.next()) {
                    user_idx = resultSet.getInt("idx");
                }
            }
        }

        // 게시글 작성자 확인하기
        try (PreparedStatement preparedStatement = conn.prepareStatement("SELECT user_idx FROM post WHERE post_id=?")) {
            preparedStatement.setInt(1, postId);

            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                if (resultSet.next()) {
                postAuthorIdx = resultSet.getInt("user_idx");
                } 
            }
        }

        // 게시글 작성자와 현재 로그인된 사용자가 동일한 경우에만 업데이트 수행
        if (user_idx == postAuthorIdx) {
            // 게시글 업데이트 쿼리 실행
            String updateQuery = "UPDATE post SET title=?, content=? WHERE post_id=? AND user_idx=?";
            try (PreparedStatement preparedStatement = conn.prepareStatement(updateQuery)) {
                preparedStatement.setString(1, updatedTitle);
                preparedStatement.setString(2, updatedContent);
                preparedStatement.setInt(3, postId);
                preparedStatement.setInt(4, user_idx);

                int rowsUpdated = preparedStatement.executeUpdate();

                if (rowsUpdated > 0) {
%>
                <script>
                    alert('게시글이 성공적으로 업데이트되었습니다.');
                    window.location.href = '../jsp/boardlist.jsp';
                </script>
<%
                } else {
%>
                <script>
                    alert('게시글 업데이트에 실패했습니다. 다시 시도해주세요.');
                    window.location.href = '../jsp/boardlist.jsp';
                </script>
<%
                }
            }
        } else {
%>
            <script>
                alert('게시글 작성자가 아닌 사용자는 업데이트할 수 없습니다.');
                window.location.href = '../jsp/boardlist.jsp';
            </script>
<%
        }
    } catch (Exception e) {
        e.printStackTrace();
    } 
%>

