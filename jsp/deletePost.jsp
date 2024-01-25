<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page import="java.sql.ResultSet" %>

<%
    // JSP 영역
    request.setCharacterEncoding("UTF-8");// 이전 페이지에서 온 값에 대한 인코딩 설정

    // 게시글 ID 가져오기
    String postIdStr = request.getParameter("postId");
    int postId = Integer.parseInt(postIdStr);

    try {
        // DB 연결
        Class.forName("com.mysql.jdbc.Driver");// Connector 파일 찾아오는 명령어
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/web", "stageus", "1234");

        // 현재 로그인한 사용자의 ID 가져오기(세션)
        HttpSession userSession = request.getSession();
        String loggedInUserId = (String) userSession.getAttribute("id");

        // 게시글 작성자의 ID 가져오기
        String getAuthorIdQuery = "SELECT user.id FROM post INNER JOIN user ON post.user_idx = user.idx WHERE post_id=?";
        PreparedStatement getAuthorIdStatement = conn.prepareStatement(getAuthorIdQuery);
        getAuthorIdStatement.setInt(1, postId);

        ResultSet resultSet = getAuthorIdStatement.executeQuery();

        if (resultSet.next()) {
            String authorId = resultSet.getString("id");

            // 현재 로그인한 사용자와 게시글 작성자가 동일한 경우에만 삭제 수행
            if (loggedInUserId.equals(authorId)) {
                // 게시글 삭제 쿼리 실행
                String deleteQuery = "DELETE FROM post WHERE post_id=?";
                PreparedStatement preparedStatement = conn.prepareStatement(deleteQuery);
                preparedStatement.setInt(1, postId);

                int rowsDeleted = preparedStatement.executeUpdate();

                if (rowsDeleted > 0) {
%>
                    <script>
                        alert('게시글이 성공적으로 삭제되었습니다.');
                        window.location.href = '../jsp/boardlist.jsp';
                    </script>
<%
                } else {
%>
                    <script>
                        alert('게시글 삭제에 실패했습니다. 다시 시도해주세요.');
                        window.location.href = '../jsp/boardlist.jsp';
                    </script>
<%
                }
            } else {
                // 현재 로그인한 사용자와 게시글 작성자가 다른 경우에 대한 처리
%>
                <script>
                    alert('다른 사용자의 게시글은 삭제할 수 없습니다.');
                    window.location.href = '../jsp/boardlist.jsp';
                </script>
<%
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
