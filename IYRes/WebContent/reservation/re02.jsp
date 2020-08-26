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
	<!-- header  -->
	<div class="top-gnb-wrap">

  <div class="top-login">
   <div class="top-login-right">
    <a href="#">로그인</a>
    <a href="#">마이페이지</a>
    </div>
  </div>
  <script>
    $(window).on('scroll',function(){
       var stop=$(this).scrollTop();
       if(stop>200){
          document.getElementsByClassName("top-login").style.display="block";
       }else{
          document.getElementsByClassName("top-login").style.display="none";
       }
    })
  </script>

  <header class="top-menu">
    <div class="top-gnb-left">
      <a href="#"><img src=""/></a>
    </div>
    <div class="top-menu-center">
      <a href="#">연극찾기</a>
      <a href="#">예매하기</a>
      <a href="#">게시판</a>
      <a href="#">극장 찾기</a>
    </div>
    
    <!-- <div class="top-menu-right">
      <a href="#">MY티켓</a>
    </div> -->
  </header>

</div><!-- header -->

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

	<!-- footer -->
	<footer>
  <div class="bot-cont">
  
    <div class="bot-logo">
      <a href="#">
        <img src="../img/logo.jpg"/>
      </a>
    </div>
    <div class="bot-txt">
      <p>TEAM  Hye Ah</p>
      <p>PM : 윤혜진 </p>
      <p>M : 김영모 신지환 신효창 이건희</p>
      <p class="bot-cr"> Copyright Team.Hye-Ah All Rights Reserved.</p>
    </div>
    <div class="bot-api">
      <img src="../img/utility_kams.png"/>
      <p> (재)예술경영지원센터 공연예술통합전산망(www.kopis.or.kr)</p>
    </div>
  </div>
</footer>
</body>
</html>