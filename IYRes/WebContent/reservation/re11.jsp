<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>예매 1페이지</title>
<link href = "img/favicon.jpg"/>
<link rel="stylesheet" type="text/css" href="../css/main.css" />
<link rel="stylesheet" type="text/css" href="../css/res11-css.css" />
</head>
<body>

<div class="res11-body-wrap">
<jsp:include page="../include/header.jsp"/>


<div class="res11-container">
<div class="body-empty">빠른 예매</div>
<!-- reservation-contents-->

<div class="reservation-contents">



<!-- reservation-iframe -->
<iframe src="./res-conts.jsp" id ="reservation-conts"  >
</iframe>


<!-- reservation-iframe -->
</div>

<!-- /reservation-contents -->

</div>
<!-- /res11-container -->
<jsp:include page="../include/footer.jsp"/>
</div>

</body>
</html>