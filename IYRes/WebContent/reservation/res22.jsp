<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>예매2페이지</title>
<link rel="stylesheet" type="text/css" href="../css/main.css" />
<link rel="stylesheet" type="text/css" href="../css/res22-css.css" />
</head>
<body>

	<div class="body-wrap">
		<jsp:include page="../include/header.jsp" />
		
		
		<div class="res22-container">
			<div class="body-empty">빠른 예매</div>
			
			<!-- reservation-contents-->
			<div class="reservation22-contents">

				<!-- reservation-iframe -->
				<iframe src="./res22-conts.jsp" id="reservation22-conts"> </iframe>


				<!-- reservation22-iframe -->
			</div>
			<!-- /reservation-contents -->

		</div>
		<!-- /res22-container -->
		
		
		<jsp:include page="../include/footer.jsp" />
	</div>
	<!-- /res22-body-wrap -->
</body>
</html>