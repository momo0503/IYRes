<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>예약하기2</title>
<link rel="stylesheet" type="text/css" href="../css/res03-css.css" />
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
<script>
function payready(){
	alert('결제를 시작합니다!');
}
</script>
	<div class="body-wrap">

		<div class=body-wrap-block1>
			 <span id="mes">할인혜택</span><br><br><Br>
			 현재 포인트 : <span id="mes2">1200  point</span><br><br><br>
			 마이 포인트 사용: 1000   최종 결제금액 : 9000<br><br><br><br><br><br><br>
			 
			 <hr>
			<span id="mes3">결제수단</span><br><br><br>
			 
			<input type="radio" value="신용/체크카드 "> &nbsp; 카드사 선택   &nbsp;:  &nbsp; <select>
			<option class="mes04" selected>국민은행</option>
			<option class="mes03">신한은행</option>
			<option class="mes03">기업은행</option>
			<option class="mes03">농협은행</option>
			<option class="mes03">산업은행</option>
			<option class="mes03">전북은행</option>
			<option class="mes03">부산은행</option>
			</select>
			 
			 
			 <br><br><br>  
			 
			<input type="radio" value="카카오페이 "> &nbsp; 카카오페이
			 
			 
			

		</div>


		<div class=body-wrap-block3>
		<div class= body-wrap-block3-a1><span id="titlee">연극제목 : 시크릿</span><br><br>
		연극지역 : <br><br>
		날짜 :  2020-08-18<br><br>
		시간 :    17:30 ~ 18:45<br><br>
		1매가격 : 10000 <br><br>
		매수 :  1매<br><br><br>
		최종 결제 금액 : 9000<br><br>
		<br><Br>
		</div>
		<img src="../img/secret.jpg" width="350px" height="230px"/>
		<button id="btn03" value="이전" onclick="location='re02.jsp';">이전</button>
		<button id="btn04" value="이전" onclick="payready();">결제</button>
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