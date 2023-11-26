<%@page import="org.rosuda.REngine.Rserve.RConnection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("utf-8");

	int ageGrade = Integer.parseInt(request.getParameter("ageGrade"));
	int gender = Integer.parseInt(request.getParameter("gender"));
	int cholesterol = Integer.parseInt(request.getParameter("cholesterol"));
	int bmi = Integer.parseInt(request.getParameter("bmi"));
	int cardio = Integer.parseInt(request.getParameter("cardio"));
	int exercise = Integer.parseInt(request.getParameter("exercise"));
	int fruit = Integer.parseInt(request.getParameter("fruit"));
	int vege = Integer.parseInt(request.getParameter("vege"));
	int drink = Integer.parseInt(request.getParameter("drink"));
	int health = Integer.parseInt(request.getParameter("health"));
	int walk = Integer.parseInt(request.getParameter("walk"));
	int highBP = Integer.parseInt(request.getParameter("highBP"));
	int mental = Integer.parseInt(request.getParameter("mental"));
	int physical = Integer.parseInt(request.getParameter("physical"));
	

	String result = "";

    RConnection conn = null;

    try {
        conn = new RConnection();

        conn.voidEval("library(nnet)");

        conn.voidEval("rf <- readRDS(url('http://localhost:8080/Rserve/self_Diabetes.rds','rb'))");

        conn.voidEval("result <- as.character(predict(rf, (list(나이=" + ageGrade + ", 성별=" + gender + ","
            + "chol체크_5년=" + cholesterol + ", BMI=" + bmi + ", 심혈관질환=" + cardio + ", 업무외운동=" + exercise
            + ", 과일섭취=" + fruit + ", 야채섭취=" + vege + ", 술선호도=" + drink + ", 건강인식=" + health + ", 걸음상태=" + walk
            + ", 고혈압=" + highBP + ", 정신건강구분=" + mental + ", 최근질병구분=" + physical + "))))");

        result = conn.eval("result").asString();
		System.out.println(result);

    } catch (Exception e) {
        e.printStackTrace();
		System.out.println(result);
    } finally {
		System.out.println(result);

        if (conn != null) {
            conn.close();
			System.out.println(result);
        }
    }
%>
{"result":"<%=result %>"}	