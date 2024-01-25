<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpSession" %>

<%
    // request: 현재 요청에 대한 HttpServletRequest 객체
    // getSession(false): 세션이 없으면 새로운 세션을 생성하지 않고(null을 반환) 세션이 이미 존재하면 해당 세션을 반환
    HttpSession userSession = request.getSession(false);
    if (userSession != null) {
        // 세션을 무효화(로그아웃)
        userSession.invalidate();
    }
%>

<script>
    alert('로그아웃되었습니다.');
    window.location.href = "../html/index.html"; // 로그아웃 후 이동할 페이지
</script>