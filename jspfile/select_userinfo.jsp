<%@page import="java.sql.*"%>
<%  
    /*
    Date: 2021-12-25
    Notes : Json Module을 이용한 Json 구성
    */
%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="org.json.simple.JSONArray"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%



    String uid = request.getParameter("uid");

	String url_mysql = "jdbc:mysql://localhost/self_diagnosis?serverTimezone=UTC&characterEncoding=utf8&useSSL=FALSE";
 	String id_mysql = "root";
 	String pw_mysql = "qwer1234";
    String WhereDefault = "select uid, upassword, uname, uemail, uphone, height, weight,uinsertdate, udeleted from user where uid = ?";

    // Date : 2021-12-25
    JSONObject jsonList = new JSONObject();
    JSONArray itemList = new JSONArray();
    
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn_mysql = DriverManager.getConnection(url_mysql, id_mysql, pw_mysql);
        Statement stmt_mysql = conn_mysql.createStatement();

        ps = conn_mysql.prepareStatement(WhereDefault);
	    ps.setString(1, uid);

        rs = ps.executeQuery();


        while (rs.next()){
            JSONObject tempJson = new JSONObject();
            tempJson.put("uid", rs.getString(1));
            tempJson.put("upassword", rs.getString(2));
            tempJson.put("uname", rs.getString(3));
            tempJson.put("uemail", rs.getString(4));
            tempJson.put("uphone", rs.getString(5));
            tempJson.put("height", rs.getInt(6));
            tempJson.put("weight", rs.getInt(7));
            tempJson.put("uinsertdate", rs.getString(8));
            tempJson.put("udeleted", rs.getInt(9));
            itemList.add(tempJson);
        }

        jsonList.put("results",itemList);
        conn_mysql.close();
        out.print(jsonList);

    } catch (Exception e) {
        e.printStackTrace();
    }
%>
