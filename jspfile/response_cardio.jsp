<%@page import="org.rosuda.REngine.Rserve.RConnection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("utf-8");

	int age = Integer.parseInt(request.getParameter("birth"));
	double height = Double.parseDouble(request.getParameter("height"));
	double weight = Double.parseDouble(request.getParameter("weight"));
	int ap_hi = Integer.parseInt(request.getParameter("max"));
	int ap_lo = Integer.parseInt(request.getParameter("min"));
	int cholesterol = Integer.parseInt(request.getParameter("cholesterol"));
	int gluc = Integer.parseInt(request.getParameter("glucose"));
	int age_year = Integer.parseInt(request.getParameter("ageYEAR"));
	double bmi = Double.parseDouble(request.getParameter("bmi"));
	int age_year2 = Integer.parseInt(request.getParameter("ageYEAR_2"));
	
	int extremelyobese = 0;
	int obese = 0;
	int overweight = 0;
	int normal = 0;
	int underweight = 0;
	
	if (bmi >= 30) {
		extremelyobese = 1;
	} else if (bmi >= 25) {
		obese = 1;
	} else if (bmi >= 23) {
		overweight = 1;
	} else if (bmi >= 18.5) {
		normal = 1;
	} else if (bmi >= 0) {
		underweight = 1;
	}

int sixties = 0;
int fifties = 0;
int forties = 0;
int thirties = 0;

if (age_year2 >= 60) {
    sixties = 1;
} else if (age_year2 >= 50) {
    fifties = 1;
} else if (age_year2 >= 40) {
    forties = 1;
} else if (age_year2 >= 30) {
    thirties = 1;
}



String result = "";

    RConnection conn = null;

    try {



        conn = new RConnection();

        conn.voidEval("library(randomForest)");


        if (age_year2==40) {


			
			conn.voidEval("rf <- readRDS(url('http://localhost:8080/Rserve/randomForest_cardio_40s.rds','rb'))");


			conn.voidEval("result <- as.character(predict(rf, (list(age=" + age + ", height=" + height + ","
			+ "weight=" + weight + ", ap_hi=" + ap_hi + ", ap_lo=" + ap_lo + ", cholesterol=" + cholesterol
			+ ", gluc=" + gluc + ", age_year=" + age_year + ", BMI=" + bmi + ", ageRange=" + 40 + ", ExtremelyOBESE=" + extremelyobese
			+ ", OBESE=" + obese + ", OVERWEIGHT=" + overweight + ", NORMAL=" + normal + ", UNDERWEIGHT=" + underweight + ",age30=" + thirties + ",age40=" + forties + ",age50=" + fifties + ",age60=" + sixties + "))))");
		



        } else {

			conn.voidEval("rf <- readRDS(url('http://localhost:8080/Rserve/randomForest_cardio_50s.rds','rb'))");

			conn.voidEval("result <- as.character(predict(rf, (list(age=" + age + ", height=" + height + ","
			+ "weight=" + weight + ", ap_hi=" + ap_hi + ", ap_lo=" + ap_lo + ", cholesterol=" + cholesterol
			+ ", gluc=" + gluc + ", age_year=" + age_year + ", BMI=" + bmi + ", ageRange=" + 50 + ", ExtremelyOBESE=" + extremelyobese
			+ ", OBESE=" + obese + ", OVERWEIGHT=" + overweight + ", NORMAL=" + normal + ", UNDERWEIGHT=" + underweight + ",age30=" + thirties + ",age40=" + forties + ",age50=" + fifties + ",age60=" + sixties + "))))");
	

        }


		result = conn.eval("result").asString();

    } catch (Exception e) {
        e.printStackTrace();
    } finally {

        if (conn != null) {
            conn.close();
        }
    }
%>
{"result":"<%=result %>"}	