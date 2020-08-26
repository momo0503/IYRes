<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>


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

</div><!-- /header -->
</body>
</html>