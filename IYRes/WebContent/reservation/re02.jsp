<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>예약하기2</title>
<link rel="stylesheet" type="text/css" href="../css/res02-css.css" />
<link rel="stylesheet" type="text/css" href="../css/main.css" />
</head>
<body>

	<div class="body-wrap">

		<div class=body-wrap-block1>
			잔여좌석/총좌석 매수 : <span id="mes">152/323</span><br>
			<br>
			<br>
			<br> 예매 매수 선택 : <span id="mes2"><select>
			<option class="mes03" selected>1매</option>
			<option class="mes03">2매</option>
			<option class="mes03">2매</option>
			<option class="mes03">4매</option>
			</select></span>

		</div>


		<div class=body-wrap-block2>
			 <img class="mySlides" src="../img/event_20.jpg" width=400px;
				height=300px; />
		

		</div>


		<div class=body-wrap-block3>
		<div class= body-wrap-block3-a1><span id="titlee">연극제목 : 시크릿</span><br><br>
		연극지역 : <br><br>
		날짜 :  2020-08-18<br><br>
		시간 :    17:30 ~ 18:45<br><br>
		1매가격 : 10000 <br><br>
		매수 :  1매<br><br><br>
		최종 결제 금액 : 10000<br><br>
		<br><Br>
		</div>
		<img src="../img/secret.jpg" width="350px" height="230px"/>
		<button id="btn01" value="이전" onclick="location='re01.jsp';">이전</button>
		<button id="btn02" value="이전" onclick="location='re03.jsp';">다음</button>
	
		</div>

	</div>


</body>
</html>