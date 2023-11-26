<%@page import="java.sql.*"%>
<%  
    /*
    Date: 2021-12-25
    Notes : Json Module을 이용한 Json 구성
    */
%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="org.json.simple.JSONArray"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    String url_mysql = "jdbc:mysql://localhost/self_diagnosis?serverTimezone=UTC&characterEncoding=utf8&useSSL=FALSE";
    String id_mysql = "root";
    String pw_mysql = "qwer1234";
    String uid = request.getParameter("uid");
    String insertdate = request.getParameter("insertdate");
    String WhereDefault = "select s.sSeq ,s.question, a.a_answer from answer as a, survey as s where a.a_insertdate = ? and a_uid = ? and s.sSeq = a.a_sSeq;";

    JSONObject jsonList = new JSONObject();
    JSONArray itemList = new JSONArray();
    PreparedStatement ps = null;
    ResultSet rs = null; // Declare the ResultSet

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn_mysql = DriverManager.getConnection(url_mysql, id_mysql, pw_mysql);
        Statement stmt_mysql = conn_mysql.createStatement();

        ps = conn_mysql.prepareStatement(WhereDefault);
        ps.setString(2, uid); // Set the parameter on the PreparedStatement
        ps.setString(1, insertdate); 

        rs = ps.executeQuery(); // Execute the query

        while (rs.next()){
            JSONObject tempJson = new JSONObject();
            tempJson.put("question", rs.getString(2));
            tempJson.put("answer", rs.getInt(3));
            itemList.add(tempJson);
        }

        jsonList.put("QnA", itemList);
        conn_mysql.close();
        out.print(jsonList);

    } catch (Exception e) {
        e.printStackTrace();
    }
%>