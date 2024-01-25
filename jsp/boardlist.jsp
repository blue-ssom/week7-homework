<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="javax.servlet.http.HttpSession" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>게시글 목록</title>
    <link rel="stylesheet" href="../css/boardlist.css"> 
</head>
<body>
    <header>
        <h1>게시판</h1>
        <form action="../jsp/viewProfile.jsp" method="post">
            <button type="submit">내 정보 보기</button>
        </form>
        <form action="../jsp/logout.jsp" method="post">
            <button type="submit">로그아웃</button>
        </form>
        <form action="../html/createPost.html" method="post">
            <button type="submit">게시글 추가</button>
        </form>
    </header>
<div class="container">
<%
    try {
        // DB 연결 코드
        Class.forName("com.mysql.jdbc.Driver"); // Connector 파일 찾아오는 명령어
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/web", "stageus", "1234");

        // sql 준비 및 전송
        // user, post 테이블 내부 조인, idx에 해당하는 사용자 id 가져오기
        // 두 테이블 간에 일치하는 행만 반환(교집합)
        String query = "SELECT post.*, user.id FROM post INNER JOIN user ON post.user_idx = user.idx ORDER BY updationDate DESC";
         // SQL을 전송 대기 상태로 만든 것
        PreparedStatement preparedStatement = conn.prepareStatement(query);
        // sql 결과 받아오기
        ResultSet resultSet = preparedStatement.executeQuery();

        // 후처리 (ResultSet을 JSP 내에서 모든 읽은 다음에, 2차원 리스트로 만들어 줄 것)
        ArrayList<ArrayList<String>> postList = new ArrayList<>();

        // ResultSet에서 데이터를 읽어와서 리스트에 추가
        while (resultSet.next()) {
            // getString(int index) : 지정한 column 값을 string 형으로 읽어오고 string 형 반환
            String postId = resultSet.getString("post_id");
            String userId = resultSet.getString("id");
            String title = resultSet.getString("title");
            String content = resultSet.getString("content");
            String creationDate = resultSet.getString("creationDate");
            String updationDate = resultSet.getString("updationDate");

            // 1차원 리스트를 만들고 값 다 넣기
            ArrayList<String> postInfo = new ArrayList<>();
            postInfo.add(postId); //0번 인덱스
            postInfo.add(userId);                 //1번 인덱스
            postInfo.add(title);                  //2번 인덱스
            postInfo.add(content);                //3번 인덱스
            postInfo.add(creationDate);           //4번 인덱스
            postInfo.add(updationDate);           //5번 인덱스

            // 만든 1차원 리스트를, 2차원 리스트에 넣어주는 것
            postList.add(postInfo); 
        }

        // 게시글 목록을 화면에 출력
        for (int i = 0; i < postList.size(); i++) {
            ArrayList<String> postInfo = postList.get(i);
%>
            <div class="post">
                <h2><%= postInfo.get(2) %></h2>
                <p><%= postInfo.get(3) %></p>
                <p>작성자 ID: <%= postInfo.get(1) %></p>
                <p>작성일: <%= postInfo.get(4) %></p>
                <p>수정일: <%= postInfo.get(5) %></p>

                <!-- 삭제 버튼 -->
                <form action="deletePost.jsp" method="post">
                    <input type="hidden" name="postId" value="<%= postInfo.get(0) %>">
                    <button type="submit">삭제</button>
                </form>

                <!-- 수정 버튼 -->
                <form action="updatePostForm.jsp" method="post">
                    <input type="hidden" name="postId" value="<%= postInfo.get(0) %>">
                    <button type="submit">수정</button>
                </form>

                <!-- 댓글 보기 버튼 -->
                <form action="viewComment.jsp?postId=<%= postInfo.get(0) %>" method="post">
                    <input type="hidden" name="postId" value="<%= postInfo.get(0) %>">
                    <button type="submit">댓글 보기</button>
                </form>
            </div>
        <%
}
    } catch (Exception e) {
        e.printStackTrace();
    } 
%>
</div>
</body>
</html>
