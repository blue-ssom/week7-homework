<%-- 이름 createComment로 수정하기 --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="javax.servlet.http.HttpSession" %>

<%
    // 세션에서 사용자의 id 받아오기
    HttpSession userSession = request.getSession();
    String userId = (String) userSession.getAttribute("id");

    int postId = Integer.parseInt(request.getParameter("postId"));
    String commentContent = request.getParameter("commentContent");

    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/web", "stageus", "1234");

        // SQL 실행 - 사용자의 id로부터 user_idx 가져오기
        String getUserIdQuery = "SELECT idx FROM user WHERE id=?";
        PreparedStatement getUserIdStatement = conn.prepareStatement(getUserIdQuery);
        getUserIdStatement.setString(1, userId);

        ResultSet resultSet = getUserIdStatement.executeQuery();

        int userIdx = 0; 
        if (resultSet.next()) {
            userIdx = resultSet.getInt("idx");
        }

        // SQL 실행 - 댓글 등록
        String insertCommentQuery = "INSERT INTO comment (post_id, user_idx, content) VALUES (?, ?, ?)";
        PreparedStatement preparedStatement = conn.prepareStatement(insertCommentQuery);
        preparedStatement.setInt(1, postId);
        preparedStatement.setInt(2, userIdx);
        preparedStatement.setString(3, commentContent);

        int rowsAffected = preparedStatement.executeUpdate();

        if (rowsAffected > 0) {
            response.sendRedirect("viewComment.jsp?postId=" + postId);
        } else {
            out.println("댓글 추가에 실패했습니다.");
        }
    } catch (Exception e) {
        e.printStackTrace();
    } 
%>
