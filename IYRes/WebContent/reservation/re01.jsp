<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>예약하기</title>

<link rel="stylesheet" type="text/css" href="../css/res01-css.css" />
<link rel="stylesheet" type="text/css" href="../css/main.css" />

</head>
<body>
	
<jsp:include page="../include/header.jsp"/>

	<!-- body-wrap -->
	<form action="#" method="post">
	<div class="body-wrap">
		<div class="body-wrap-header">빠른예매</div>

		<div class="body-wrap-block1-wrap">
			<div class="body-wrap-block1">
				<div class="body-wrap-block1-a1">지역 선택</div>

				<div class="body-wrap-block1-a2">
				
				
				<input type="submit" class="loca_btn01" value="서울"/> 
				<input type="submit" class= "loca_btn01" value="경기"/>
				<input type="submit" class= "loca_btn01" value="제주"/>
				<input type="submit" class= "loca_btn01" value="경남"/>
				<input type="submit" class= "loca_btn01" value="경북"/>
				<input type="submit" class= "loca_btn01" value="광주"/>
				<input type="submit" class= "loca_btn01" value="부산"/>
				<input type="submit" class= "loca_btn01" value="충북"/>
				<input type="submit" class= "loca_btn01" value="충남"/>
				<input type="submit" class= "loca_btn01" value="전북"/>
				<input type="submit" class= "loca_btn01" value="전남"/>
				<input type="submit" class= "loca_btn01" value="대구"/>
				<input type="submit" class= "loca_btn01" value="울산"/>
				<input type="submit" class= "loca_btn01" value="인천"/>
				</div>

				<div class="body-wrap-block1-a3">
				<input type="submit" class= "loca_btn02" value="종로구"/>
				<input type="submit" class= "loca_btn02" value="동대문구"/>
				<input type="submit" class= "loca_btn02" value="중랑구"/>
				<input type="submit" class= "loca_btn02" value="성동구"/>
				<input type="submit" class= "loca_btn02" value="용산구"/>
				<input type="submit" class= "loca_btn02" value="강동구"/>
				<input type="submit" class= "loca_btn02" value="강서구"/>
				<input type="submit" class= "loca_btn02" value="양천구"/>
				<input type="submit" class= "loca_btn02" value="강남구"/>
				<input type="submit" class= "loca_btn02" value="은평구"/>
				<input type="submit" class= "loca_btn02" value="동작구"/>
				<input type="submit" class= "loca_btn02" value="관악구"/>
				<input type="submit" class= "loca_btn02" value="금천구"/>
				<input type="submit" class= "loca_btn02" value="서초구"/>
				<input type="submit" class= "loca_btn02" value="송파구"/>
				<input type="submit" class= "loca_btn02" value="기타"/>
				<input type="submit" class= "loca_btn02" value="등등"/>
				<input type="submit" class= "loca_btn02" value="등등"/>
				</div>

			</div>
		</div>
		<!-- body-wrap-block1 -->

		<div class="body-wrap-block2-wrap">
			<div class="body-wrap-block2">
			
				<div class="body-wrap-block2-a4">연극 선택</div>
				<div class="body-wrap-block2-a5">
				
				<input type="submit" class= "loca_btn03" value="SUPER SHOW 6: SUPER JUNIOR WORLD TOUR"/>
				<input type="submit" class= "loca_btn03" value="EXO-Love CONCERT in DOME"/>
				<input type="submit" class= "loca_btn03" value="난타(NANTA) [방콕]"/>
				<input type="submit" class= "loca_btn03" value="시크릿"/>
				<input type="submit" class= "loca_btn03" value="요리하는 마술사 [파주]"/>
				<input type="submit" class= "loca_btn03" value="쿵 시즌3 드리머"/>
				<input type="submit" class= "loca_btn03" value="당신이주인공 1탄"/>
				<input type="submit" class= "loca_btn03" value="그녀를 믿지마세요"/>
				<input type="submit" class= "loca_btn03" value="텐: 열흘간의 비밀"/>
				<input type="submit" class= "loca_btn03" value="김광석을 노래하다"/>
				<input type="submit" class= "loca_btn03" value="작업의 정석 1탄"/>
				<input type="submit" class= "loca_btn03" value="피노키오"/>
				<input type="submit" class= "loca_btn03" value="사랑은 비를 타고"/>
				<input type="submit" class= "loca_btn03" value="임혁필의 펀타지쇼"/>
				<input type="submit" class= "loca_btn03" value="성춘향"/>
				<input type="submit" class= "loca_btn03" value="만만파파 용피리"/>
				<input type="submit" class= "loca_btn03" value="오페라 마티네, 운명의 힘"/>
				<input type="submit" class= "loca_btn03" value="넌센스Ⅱ"/>
				<input type="submit" class= "loca_btn03" value="새봄맞이 가족오페라 마술피리"/>
				<input type="submit" class= "loca_btn03" value="이승연 바이올린 독주회"/>
				<input type="submit" class= "loca_btn03" value="정선호 피아노 독주회"/>
				<input type="submit" class= "loca_btn03" value="음악으로 떠나는 겨울여행"/>
				<input type="submit" class= "loca_btn03" value="아리"/>
				<input type="submit" class= "loca_btn03" value="한번더"/>
				<input type="submit" class= "loca_btn03" value="아나옜다. 배갈라라"/>
				</div>
			</div>
		</div>
		<!-- body-wrap-block2 -->

		<div class="body-wrap-block3-wrap">
			<div class="body-wrap-block3">
				<div class="body-wrap-block3-a6">날짜 선택</div>
				
				<div class="body-wrap-block3-a7">

<table id="calendar" border="3" align="center" style="border-color:#3333FF ">
    <tr><!-- label은 마우스로 클릭을 편하게 해줌 -->
        <td><label onclick="prevCalendar()"><</label></td>
        <td align="center" id="tbCalendarYM" colspan="5">
        yyyy년 m월</td>
        <td><label onclick="nextCalendar()">>
            
        </label></td>
    </tr>
    <tr>
        <td align="center"><font color ="#F79DC2">일</td>
        <td align="center">월</td>
        <td align="center">화</td>
        <td align="center">수</td>
        <td align="center">목</td>
        <td align="center">금</td>
        <td align="center"><font color ="skyblue">토</td>
    </tr> 
</table>
<script language="javascript" type="text/javascript">
    buildCalendar();//
</script>
				</div>

			</div>
		</div>
		<!-- body-wrap-block3 -->
	</div>
	</form>
	<button id="btn00" value="다음" onclick="location='re02.jsp';">다음</button>
	<!-- /body-wrap -->


	<jsp:include page="../include/footer.jsp"/>
</body>
</html>
















