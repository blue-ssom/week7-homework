<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Update Post</title>
    <link rel="stylesheet" href="../css/updatePost.css">
</head>
<body>
    <div>
        <h2>게시글 수정</h2>
        <form action="../jsp/updatePost.jsp" method="post">
            <!-- type="hidden" : 사용자에게 보이지 않고 서버로 데이터를 전송-->
            <input type="hidden" name="postId" value="<%= request.getParameter("postId") %>">
            
            <p>수정할 제목</p>
            <input type="text" name="updatedTitle" required>

            <p>수정할 내용</p>
            <input type="text"  name="updatedContent" required></input>

            <button type="submit">수정하기</button>
        </form>
    </div>
</body>
</html>
