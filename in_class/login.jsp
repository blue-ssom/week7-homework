<%@ page language="java" contentType="text/html" pageEncoding="UTF-8" %>

<%-- 데이터베이스 탐색 라이브러리 --%>
<%@ page import="java.sql.DriverManager" %>

<%-- 데이터베이스 연결 라이브러리 --%>
<%@ page import="java.sql.Connection" %>

<%-- 데이터베이스 SQL 전송 라이브러리 --%>
<%@ page import="java.sql.PreparedStatement" %>

<%-- Table에서 가져온 값을 처리하는 라이브러리 --%>
<%@ page import="java.sql.ResultSet" %>

<%-- List 라이브러리 --%>
<%@ page import="java.util.ArrayList" %>

<%
    // JSP 영역
    request.setCharacterEncoding("UTF-8"); // 이전 페이지에서 온 값에 대한 인코딩 설정
    String idValue = request.getParameter("id_value");
    String pwValue = request.getParameter("pw_value");

    // DB 연결 코드
    Class.forName("com.mysql.jdbc.Driver"); // Connector 파일 찾아오는 명령어
    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/web","stageus","1234");

    // sql 준비 및 전송
    String sql = "SELECT * FROM account WHERE id=? AND pw=?";
    PreparedStatement query = conn.prepareStatement(sql); // SQL을 전송 대기 상태로 만든 것
    query.setString(1,idValue);
    query.setString(2,pwValue);

    // sql 결과 받아오기
    ResultSet result = query.executeQuery();

    // 후처리 (ResultSet을 JSP 내에서 모든 읽은 다음에, 2차원 리스트로 만들어 줄 것)
    // reulst.next() 명령어가 cursor를 한 줄 움직이는 명령어
    ArrayList<ArrayList<String>> data = new ArrayList<ArrayList<String>>();

    while(result.next()){
        String id = result.getString(1); // 첫 번째 Column 읽어오기
        String pw = result.getString(2); // 두 번째 Column 읽어오기
        
        // 1차원 리스트를 만들고, id와 pw를 넣어주는 것
        ArrayList<String> elem= new ArrayList<String>();
        elem.add("\"" + id + "\"");
        elem.add("\"" + pw + "\"");

        // 만든 1차원 리스트를, 2차원 리스트에 넣어주는 것
        data.add(elem);
    }

    // var tmpList=[] // js에서의 list
    // ArrayList<String> tmpList = new ArrayList<String>() // java에서의 list
%>

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
    <script>
        var data = <%=data%> // jsp 변수를 js 변수로 담아주기
        for(var index=0;index<data.length;index++){
            console.log(data[index]);
        }
    </script>
</body>