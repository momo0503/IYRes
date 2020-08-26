<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>예매 1페이지</title>
<link href = "img/favicon.jpg"/>
<link rel="stylesheet" type="text/css" href="../css/main.css" />
<link rel="stylesheet" type="text/css" href="../css/res11.css" />
</head>
<body>

<div class="res11-body-wrap">
<jsp:include page="../include/header.jsp"/>


<div class="res-container">
<div class="body-empty">공간 남겨놓자a</div>
<!-- reservation-contents-->

<div class="reservation-contents">



<!-- reservation-iframe -->
<iframe src="./res-conts.jsp" id ="reservation-conts" width="100%" height="700px">


</iframe>
<!-- reservation-iframe -->
</div>

<!-- /reservation-contents -->

</div>
<!-- /res-container -->
<jsp:include page="../include/footer.jsp"/>
</div>

</body>
</html>