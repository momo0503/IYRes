





<!doctype html>
<html>
<head>
<meta charset="utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=yes" />
<title>Megabox</title>



    
		<link rel="stylesheet" href="/static/pc/dist/megabox.min.css" media="all" />
	
	


<script src="/static/pc/js/jquery-1.12.4.js"></script>
<script src="/static/pc/js/jquery-ui.1.12.1.js"></script>
<script src="/static/pc/js/gsaps.js"></script>
<script src="/static/pc/js/jquery.mCustomScrollbar.concat.min.js"></script>
<script src="/js/megaboxCom.js"></script>
<script src="/js/common/mega.prototype.js"></script>
<script src="/js/common/commons.js"></script>
<script src="/static/pc/js/bootstrap-custom.js"></script>
<script src="/static/pc/js/bootstrap-select.js"></script>
<script type="text/javascript" src="/js/netfunnel/netfunnel.js" charset="UTF-8"></script>
<script type="text/javascript" src="/js/netfunnel/netfunnel_skin.js" charset="UTF-8"></script>
<script type="text/javascript" src="/js/netfunnel/netfunnel_frm.js" charset="UTF-8"></script>

<!-- 2019.07.30 hjchoi 예매관련 팝업 js분리 -->
<script src="/js/megabox-simpleBokd.js"></script>

<script type="text/javascript">
    var _init = {
        cache    : Date.now(),
        path    : '/static/pc/js/'
    };


    document.write(
        '<script src="'+_init.path+'ui.common.js?v='+_init.cache+'"><\/script>'+
        '<script src="'+_init.path+'front.js?v='+_init.cache+'"><\/script>'
    );

    var sysCd = 'ON';

    //넷퍼넬 스킨 타입 지정
	NetfunnelChk.setting( sysCd, MegaboxUtil.Common.isApp() );
//영화에서 왔을때 초기 영화 셋팅

/*
    영화편성일자목록조회   편성일자 클릭시 처리 안함.
    영화목록조회           영화 클릭시 처리안함
    큐레이션영화목록조회   영화 클릭시 처리안함
    지역지점목록조회
    특별관지점목록조회
    회원일경우
        선호지점목록조회
    영화명선택있는경우
        영화명셋팅
    지점명선택있는경우
        지점명셋팅
        영화편성목록조회
    최초화면진입인경우
        회원인경우
            선호지점자동선택
 */

var localeCode = "kr";               //한영 구분 코드
var allPlayDates = [];                          //달력 선택 가능한 날짜 상단 날짜부분
var loginPopupCallScn = "SimpleBokdM";          //로그인 레이어 팝업 띄울때 필요한 PARAM
var movieScnEntry = "";
var movieScnTheabKindCd1 = ""; // 2019.07.23 hjchoi 영화정보에서 상영관종류코드로 넘어온 경우
var movieScnBrchNo1 = ""; // 2019.07.23 hjchoi 영화정보에서 지점코드로 넘어온 경우

//일자 선택 이후 콜백 메소드
function tempMthd(opts, dates) {
    var tgt = "";
    var cls = "";

    if(opts === undefined){
        if(dates !== undefined)    tgt = document.querySelector('[date-data="'+ dates +'"]');
    }
    else {
        tgt = document.querySelector('.date-area button.on');
    }

    if(tgt != ""){
        var cls = tgt.getAttribute('class');
        $(tgt).addClass('on');
        mbThCalendar.lastSavedDate = dates;
    }

    if (cls.indexOf('disabled') !== -1) {
        gfn_alertMsgBoxSize('예매가능한 날짜가 아닙니다.',400,250);    //예매가능한 날짜가 아닙니다.
        return;
    }
    else {
        if(tgt != ""){
            palyDe = tgt.getAttribute('date-data');
            //console.log(palyDe);
            if(palyDe != $('#playDe').val()){
                $('#datePicker').val(palyDe);
                $('#playDe').val(palyDe);
            }
        }
        fn_selectBokdList(false,'movieFormDe');
    }
};

$(function(){
    $('#choiceMovieList').hide();
    $('#choiceBrchList').hide();
    var crtDe = '20200816';  //서버일자
    var crtDt = '2211';  //서버시간
    var paramPlayDe = '20200816';	//파라메터일자
    mbThCalendar.globalSvrDate = crtDe;
    mbThCalendar.tempMthd = tempMthd;
    //fn_setDatePicker(crtDe);
    //console.log(crtDe);
    mbThCalendar.init();
    mbThCalendar.arrCkFlag = true; //날짜 플래그 시작부분
    //mbThCalendar.setUI();
    //mbThCalendar.events.trimdate({ mnDate:crtDe.maskDate()});   //현재서버일자를 셋팅한다. 2019.05.27 주석처리
    $('#crtDe').val(crtDe.maskDate());
    $('#playDe').val(paramPlayDe.maskDate());
    $('#datePicker').val(paramPlayDe.maskDate());

    /*영화선택후 들어오면 영화세팅*/
    if("" != ""){
        //fn_movieListChange("", "set");
    }
    fn_selectBokdList(true);   //한판조회 param onLoad 여부

    /* 영화 전체 영화선택 */
    $("#movieList").on("click",".btn", function(){
        mbThCalendar.arrCkFlag = false; //날짜 플래그 시작부분
        if($(this).hasClass("on") ==  true){
            fn_deleteMovieChoice($(this).attr("movie-no"));
        }
        else {
            fn_validateMovieChoi($(this));
        }
    });

    /*영화 큐레이션 영화선택*/
    $("#crtnMovieList").on("click",".btn", function(){
        mbThCalendar.arrCkFlag = false; //날짜 플래그 시작부분
        if($(this).hasClass("on") ==  true){
            fn_deleteMovieChoice($(this).attr("movie-no"));
        }
        else {
            fn_validateMovieChoi($(this));
        }
    });

    /*영화관 전체 지점클릭*/
    $("#brchList").on("click","#btn", function(){
        mbThCalendar.arrCkFlag = false; //날짜 플래그 시작부분
        if($(this).hasClass("on") ==  true){
            fn_deleteBrchChoice($(this).attr("brch-no"), $(this).attr("area-cd"));
        }
        else {
            fn_validateBrchChoi($(this), "area");
        }
    });

    /*영화관 특별관 지점클릭*/
    $("#specialBrchList").on("click","#btn", function(){
        mbThCalendar.arrCkFlag = false; //날짜 플래그 시작부분
        if($(this).hasClass("on") ==  true){
            fn_deleteBrchChoice($(this).attr("brch-no"), $(this).attr("area-cd"));
        }
        else {
            fn_validateBrchChoi($(this), "spcl");
        }
    });

    /*상영스케쥴 클릭*/
    $(".movie-schedule-area").on("click",".btn", function(){
    	//남은 좌석수 체크
		var restSeatCnt = Number($(this).attr("rest-seat-cnt"));
    	if(restSeatCnt == 0){
    		gfn_alertMsgBoxSize('선택하신 회차는 매진으로 예매진행이 불가합니다.',400,250);    //선택하신 회차는 매진으로 예매진행이 불가합니다.
    		return;
    	}

    	// TODO 라이브 중계일 경우 넷퍼넬 (오류로 잠시 제거)
        fn_mainValidAndPopup($(this),"simpleBokd");
        /*
    	if( $(this).attr("ctts-ty-div-cd") == "MVCT09" ){
    		NetfunnelChk.script("BOOK_STEP2",function(){
    			fn_mainValidAndPopup($(this),"simpleBokd");
    		});
    	}else{
    		// 2019.07.29 hjchoi 20분 미만 체크 및 팝업 조회 순서 변경
            //fn_valid20MinBlw($(this)); //20분 미만 체크
            fn_mainValidAndPopup($(this),"simpleBokd");
            //상영관 팝업 여부 체크
            //파라메타 넘김
    	}
    	*/
    });

    //달력 오늘 클릭
    $.datepicker._gotoToday = function(id) {
       var target = $(id);
       var inst   = this._getInst(target[0]);
       var arr    = $('#crtDe').val().split('.');
       inst.selectedDay = arr[2]
       inst.drawMonth   = inst.selectedMonth = arr[1] -1;
       inst.drawYear    = inst.selectedYear  = arr[0].toNumber();
       this._setDateDatepicker(target, new Date());
       this._selectDate(id, this._getDateDatepicker(target));
    }
});

//달력 삭제
function fn_setDatePickerDestory(){
    $("#datePicker").datepicker("destroy");
}

//달력 초기화 셋팅
function fn_setDatePicker(crtDe, param){

    $("#datePicker").datepicker({
         tempHtmlShow : true
        ,allPlayDateClassName : "meagBox-selected-day"
        ,allPlayDates : param
        ,showButtonPanel : true
        ,minDate : crtDe.maskDate()       //TODO 서버시간으로 변경
        ,onSelect : function(){ fn_setFormDeOnclickCalendar() }
        ,showAnim : 'fadeIn'
        // 달력 좌측으로 뜨기
        ,beforeShow : function(input, inst){
        var _cal = inst.dpDiv;

            setTimeout(function(){
                _cal.position({
                    of : $('.time-schedule'),
                    my : 'right top',
                    at : 'right top',
                    collision : 'none none'
                });
            }, 0);
        }
    });
}

/*달력 클릭으로 일자 이동*/
function fn_setFormDeOnclickCalendar(){
    var isBokd = false;

    for(var i=0; i<allPlayDates.length; i++){
        if(allPlayDates[i] == $('#datePicker').val()) {
            isBokd = true
        }
    }

    //일자 이동
    if(isBokd){
        $(".time-schedule").addClass("not-available");
         mbThCalendar.events.trimdate({ mnDate:$('#datePicker').val(), callback:mbThCalendar.tempMthd});
         // mbThCalendar.events.trimdate({ mnDate:$('#datePicker').val(), callback:tempMthd.bind(this, undefined, $('#datePicker').val())});
    }
    else {
        gfn_alertMsgBoxSize('예매가능한 날짜가 아닙니다.',400,250);    //예매가능한 날짜가 아닙니다.
        $('#datePicker').val($('#playDe').val());
    }

}

//서버시간조회
function fn_getCrtPlayTime(){
    var rtnVal = new Date();
    var paramData = {};
    $.ajaxMegaBox({
     //      url: "/on/oh/ohb/SimpleBooking/selectPlayScheduleList.do", 변경
         url: "/on/oh/ohb/SimpleBooking/selectCrtPlayTime.do",
         data: JSON.stringify(paramData),
         //async: false,
         success: function (data, textStatus, jqXHR) {
            var year = (data.crtPlayTimeMap.crtDe).substr(0,4);
            var mm   = (data.crtPlayTimeMap.crtDe).substr(4,2);
            var dd   = (data.crtPlayTimeMap.crtDe).substr(6,2);
            var hh   = (data.crtPlayTimeMap.crtDt).substr(0,2);
            var mi   = (data.crtPlayTimeMap.crtDt).substr(2,2);
            rtnVal = new Date(year, Number(mm)-1, dd, hh, mi);
         },
         error: function(xhr,status,error){
             var err = JSON.parse(xhr.responseText);
             alert(xhr.status);
             alert(err.message);
         }
    });
    return rtnVal;
}

//영화 선택전 벨리데이션 체크
function fn_validateMovieChoi(obj){
    var rowCnt = 0;
    $("#choiceMovieList .bg").each(function(idx){
        if($.trim($(this).html()) == ""){
            if(rowCnt == 0){
                rowCnt++;
            }
        }
    });
    if(rowCnt == 0){
        gfn_alertMsgBoxSize('영화는 최대 3개까지 선택이 가능합니다.',400,250);    //영화는 최대 3개까지 선택이 가능합니다.
        return false;
    }
    //빠른일자 검색
    fn_selectMinBokdAbleDe(obj);
}

//영화전체 큐레이션 영화선택
function fn_setMovieChoi(arrayParam){
    var obj         = arrayParam[0];
    var uptUnableAt = arrayParam[1];
    var movieNo     = $(obj).attr("movie-no");
    var movieNm	    = $(obj).attr("movie-nm");
    var imgPath     = $(obj).attr("img-path");
    var rowCnt      = 0;

    $("#choiceMovieList .bg").each(function(idx){
        if($.trim($(this).html()) == ""){
            if(rowCnt == 0){
                var appendHtml = "";
                appendHtml += "<div class=\"wrap\">";
                appendHtml += "    <div class=\"img\"><img src=\""+imgPath+"\" alt=\""+movieNm+"\" movie-no=\""+movieNo+"\" onerror=\"noImg(this);\" /></div>";
                appendHtml += "    <button type=\"button\" class=\"del\" onclick=\"fn_deleteMovieChoice('"+movieNo+"')\">삭제</button>";
                appendHtml += "</div>";
                $(this).append(appendHtml);
                rowCnt++;
            }
        }
    });
    if(typeof uptUnableAt != 'undefined' && (uptUnableAt == 'N' || uptUnableAt == '')){
        fn_movieListChange(movieNo, "ins");
    }
}


//영화 특별관 지점선택전 벨리데이션 체크
function fn_validateBrchChoi(obj, type){
    var brchNo = $(obj).attr("brch-no");
    var areaCd = $(obj).attr("area-cd");
    var rowCnt = 0;

    $("#choiceBrchList .bg").each(function(idx){

    	var tarBrchNo = $(this).find(".del").attr("brch-no");
    	var tarAreaCd = $(this).find(".del").attr("area-cd");

        if($.trim($(this).html()) == ""){
            rowCnt ++;
        }
        if(tarBrchNo == brchNo){
        	rowCnt ++;
        }
    });
    if(rowCnt == 0){
        gfn_alertMsgBoxSize('극장은 최대 3개까지 선택이 가능합니다.',400,250);    //극장은 최대 3개까지 선택이 가능합니다.
        return false;
    }

    fn_getBrchBokdUnablePopup(obj, type);
}



//영화관 특별관 지점선택
function fn_setBrchChoi(arrayParam){
    var obj = arrayParam[0];
    var type = arrayParam[1];
    var uptAt = typeof arrayParam[2] != 'undefined' ? arrayParam[2] : "N";
    var brchNo = $(obj).attr("brch-no");
    var brchNm = $(obj).attr("brch-nm");
    var brchEngNm = $(obj).attr("brch-eng-nm");
    var areaCd = $(obj).attr("area-cd");
    var spclbYn = $(obj).attr("spclb-yn");
    var theabKind = $(obj).attr("area-cd-nm");
    var theabKindCd = $(obj).attr("area-cd");


    var rowCnt = 0;
    //fn_brchPopup(brchNo ,unableAt, popupAt, popupNo);

    //같은건이 있으면 삭제
    $("#choiceBrchList .bg").each(function(idx){
        if($(this).find(".del").attr("brch-no") == brchNo){
            $(this).empty()
        }
    });

    $("#choiceBrchList .bg").each(function(idx){
        //극장에서 선택했을때 동일극장이 특별관에도 있는지 확인하여 체크해제
        if(type =="area"){
            $("#specialBrchList #btn").each(function(idx){
                if($(this).attr("brch-no") == brchNo){
                    $(this).removeClass("on");
                }
            });
        }

        //특별관에서 선택했을때 동일극장이 전체극장에도 있는지 확인하여 체크해제
        if(type =="spcl"){
            $("#brchList #btn").each(function(idx){
                if($(this).attr("brch-no") == brchNo){
                    $(this).removeClass("on");
                }
            });
        }

        if($.trim($(this).html()) == ""){
            if(rowCnt == 0){
                var appendHtml = "";
                appendHtml += "<div class=\"wrap\">";
                appendHtml += "<p class=\"txt\">";
                if(localeCode == 'en'){
                    appendHtml +=brchEngNm;
                }
                else {
                    appendHtml +=brchNm;
                }

                if(type =="spcl"){
                    appendHtml += "</br>"+theabKind+"</p>";
                }
                appendHtml += "<button type=\"button\" class=\"del\" ";
                appendHtml += "onclick=\"fn_deleteBrchChoice('"+brchNo+"', '"+areaCd+"')\" ";
                appendHtml += "brch-no=\""+brchNo+"\" area-cd=\""+areaCd+"\" spclb-yn=\""+spclbYn+"\" theab-kind-cd=\""+theabKindCd+"\">";
                appendHtml += "삭제";
                appendHtml += "</button>";
                appendHtml += "</div>";

                $(this).append(appendHtml);
                rowCnt++;
            }
        }
    });
    fn_brchListChange(brchNo, "ins", areaCd);

    if(uptAt != "N"){
        fn_selectBokdList(false,"brchList") //예매 목록 갱신
    }
    return;
}

/*선택한 영화 삭제*/
function fn_deleteMovieChoice(movieNo){
    var obj = $('#choiceMovieList');
    var movieChoiCnt = $('#choiceMovieList .img').size();
    var brchChoiCnt = $('#choiceBrchList .txt').size();
    $("#choiceMovieList .bg").each(function(idx){
        if($(this).find("img").attr("movie-no") == movieNo){
            //$(this).empty();
            $(this).remove();
            var appendHtml = "";
            appendHtml += "<div class=\"bg\"></div>";
            $(obj).append(appendHtml);
        }
    });

    if($('#choiceBrchList .txt').size() == 0 && $("#choiceMovieList .del").size() == 0){
    	fn_selectBokdList(true,"reLoad") //예매 목록 갱신 초기화상태
    }
    else {
    	fn_movieListChange(movieNo, "del");
    }

}


/*선택한 지점 삭제*/
function fn_deleteBrchChoice(brchNo, areaCd){
	var allDisabled = true;
    var obj = $('#choiceBrchList');
    var movieChoiCnt = $('#choiceMovieList .img').size();
    var brchChoiCnt = $('#choiceBrchList .txt').size();
    $("#choiceBrchList .bg").each(function(idx){
        if($(this).find(".del").attr("brch-no") == brchNo && areaCd == $(this).find(".del").attr("area-cd")){
            //$(this).empty();
            $(this).remove();
            var appendHtml = "";
            appendHtml += "<div class=\"bg\"></div>";
            $(obj).append(appendHtml);
        }
    });
	fn_brchListChange(brchNo, "del", areaCd);

	$('#brchList li ul button.on').each(function(idx){
    	if(!$(this).hasClass("disabled")){
    		allDisabled = false;
    	}
    });

	$('#specialBrchTab li ul button.on').each(function(idx){
    	if(!$(this).hasClass("disabled")){
    		allDisabled = false;
    	}
    });

	if(!allDisabled || $('#choiceBrchList .txt').size() == 0){
		if($('#choiceBrchList .txt').size() == 0 && $("#choiceMovieList .del").size() == 0){
			fn_selectBokdList(true,"reLoad") //예매 목록 갱신 초기화상태
		}
		else {
			fn_selectBokdList(false,"brchList") //예매 목록 갱신
		}

	}
	else {
    	if($('#choiceBrchList .txt').size() > 0){
    		fn_selectMinBokdAbleDe(undefined);
    	}
    }
}

/*목록에서 영화선택, 삭제후 UI변경*/
function fn_movieListChange(movieNo, type){
	var allDisabled = true;
    $("#movieList .btn").each(function(idx){
        if($(this).attr("movie-no") == movieNo){
            if(type=="del"){
                $(this).removeClass("on");
            }else{
                $(this).addClass("on");
            }
        }
    });
    $("#crtnMovieList .btn").each(function(idx){
        if($(this).attr("movie-no") == movieNo){
            if(type=="del"){
                $(this).removeClass("on");
            }else{
                $(this).addClass("on");
            }
        }
    });

    $("#movieList .btn.on").each(function(idx){
    	if(!$(this).hasClass("disabled")){
    		allDisabled = false;
    	}
    });

	if("set" != type){
		if(!allDisabled || $('#choiceMovieList .img').size() == 0){
			fn_selectBokdList(false,"movieList");
		}
		else {
	    	if($('#choiceMovieList .img').size() > 0){
	    		fn_selectMinBokdAbleDe(undefined);
	    	}
	    }
    }
}

/*목록에서 지점선택, 삭제후 UI변경*/
function fn_brchListChange(brchNo, type, areaCd){
    //console.log("fn_brchListChange param : "+brchNo+"/"+type+"/"+areaCd)
    $("#brchList #btn").each(function(idx){
        if($(this).attr("brch-no") == brchNo){
            if(type=="del"){
                if(areaCd == $(this).attr("area-cd")){
                    $(this).removeClass("on");
                }
            }else{
                if(areaCd == $(this).attr("area-cd")){
                    $(this).addClass("on");
                }
            }
        }
    });
    $("#specialBrchList #btn").each(function(idx){
        if($(this).attr("brch-no") == brchNo){
            if(type=="del"){
                if(areaCd == $(this).attr("area-cd")){
                    $(this).removeClass("on");
                }
            }else{
                if(areaCd == $(this).attr("area-cd")){
                    $(this).addClass("on");
                }
            }
        }
    });
}

//영화편성일자목록 갱신
function fn_movieFormDeListUpt(bOnLoad, list, crtPlayTimeMap, paramMap){
    var crtDe = crtPlayTimeMap.crtDe; //서버일자
    holidaysFromServer = [];            //상단 일자부분 서버 휴일 설정
    disdaysFromServer = [];             //
    allPlayDates = [];                  //달력활성일자
    if("" != $('#playDe').val()){
        fn_setDatePickerDestory();
    }
    for(var i=0; i<list.length; i++) {

        if(list[i].scrdtDivCd == "HLDY"){
            setHldyAdopt(list[i].playDe);    //휴일일자셋팅
        }
        if(list[i].formAt == "Y"){
            setDisdyAdopt((list[i].playDe).maskDate());  //영화편성일자셋팅
            allPlayDates.push((list[i].playDe).maskDate()); //달력셋팅
        }
    }
    fn_setDatePicker(crtDe, allPlayDates);

    if(bOnLoad){
		$('#playDe').val(paramMap.playDe.maskDate());
        $('#crtDe').val(crtDe.maskDate());
        $('#datePicker').val($('#playDe').val());
    }
    //if (typeof mbThCalendar === 'object') mbThCalendar.init({ target:'date-area', fetchHoliday:setHldyAdopt, holidays:'holidaysFromServer' });  //상단일자부분 휴일설정
}

//영화목록 갱신
function fn_movieListUpt(list,type, paramMap){
    if(type == "crtn"){
        //console.log("fn_crtnMovieListUpt in");
        $("#crtnMovieList div div:eq(0)").empty();
    }
    else {
        //console.log("fn_movieListUpt in");
        $("#movieList div div:eq(0)").empty();
    }
    if(0 < list.length){
        var appendHtml = "<ul>";
           for(var i=0; i<list.length; i++) {
                appendHtml += "<li>";
                appendHtml += "<button type=\"button\" class=\"btn";
                //최초 로딩상황
                if(typeof paramMap.onLoad !== "undefined" && paramMap.onLoad != "" && paramMap.onLoad == "Y"){
                    if($.trim(paramMap.movieNo1) == list[i].movieNo){
                        appendHtml += " on";
                    }

                    if((typeof $.trim(paramMap.movieNo1) !==  "undefined"
                            && $.trim(paramMap.movieNo1) !=  ""
                            && list[i].formAt != "Y"
                            && "" == parent.sellChnlCd)
                        ||
                        (typeof $.trim(paramMap.brchNo1) !==  "undefined"
                            && $.trim(paramMap.brchNo1) !=  ""
                            && list[i].formAt != "Y"
                            && "" == parent.sellChnlCd)){
                        appendHtml += " disabled";
                    }
                }
                else {
                    //편성여부
                    if(list[i].formAt != "Y"){
                        appendHtml += " disabled";
                    }
                }
//                 else {
//                     var splitMovieNo = paramMap.arrMovieNo.split(",");
//                     for(var j=0;j<splitMovieNo.length;j++){
//                         if($.trim(splitMovieNo[j]) == list[i].movieNo){
//                             appendHtml += " on";
//                         }
//                     }
//                 }
                var movieImgPath = list[i].movieImgPath != null ? list[i].movieImgPath : '';

                appendHtml += "\" movie-nm=\""+list[i].movieNm+"\" movie-no=\""+list[i].movieNo+"\" img-path=\""+movieImgPath+"\" movie-popup-at=\""+list[i].moviePopupAt+"\" movie-popup-no=\""+list[i].moviePopupNo;
                appendHtml += "\" form-at=\""+list[i].formAt;
                appendHtml += "\" >";

                //등급
                if(list[i].admisClassCd == "AD01"){
                    appendHtml += "<span class=\"movie-grade small age-all\">"+list[i].admisClassCdNm+"</span>";
                }
                else if(list[i].admisClassCd == "AD02"){
                    appendHtml += "<span class=\"movie-grade small age-12\">"+list[i].admisClassCdNm+"</span>";
                }
                else if(list[i].admisClassCd == "AD03"){
                    appendHtml += "<span class=\"movie-grade small age-15\">"+list[i].admisClassCdNm+"</span>";
                }
                else if(list[i].admisClassCd == "AD04"){
                    appendHtml += "<span class=\"movie-grade small age-19\">"+list[i].admisClassCdNm+"</span>";
                }
                else if(list[i].admisClassCd == "AD06"){
                    appendHtml += "<span class=\"movie-grade small age-no\">"+list[i].admisClassCdNm+"</span>";
                }

                //보고싶어 여부
                if("" == parent.sellChnlCd){	//RIA가 아닌경우
                	if(list[i].intrstMovieAt == "Y"){
	                    appendHtml += "<i class=\"iconset ico-heart-on-small\">보고싶어 설정함</i>";

	                }
	                else {
	                    appendHtml += "<i class=\"iconset ico-heart-small\">보고싶어 설정안함</i>";
	                }
                }
                appendHtml += "<span class=\"txt\">";

                //영화명 한/영
                if(localeCode == 'en'){
                    appendHtml +=list[i].movieEngNm+"</span>";
                }
                else {
                    appendHtml +=list[i].movieNm+"</span>";
                }
                appendHtml += "</button></li>";
            }
        if(type == "crtn"){
            $("#crtnMovieList div div:eq(0)").append(appendHtml);
        }
        else {
            $("#movieList div div:eq(0)").append(appendHtml);
        }
    }
}


//선호지점표시
function fn_favorBrchDisp(bOnLoad, uptType) {
    //console.log("fn_favorBrchDisp in");
    var appendHtml = "";
    appendHtml += "<li id=\"liFavorBrch\"><button id=\"btnFavorBrch\" type=\"button\" class=\"btn";
    if(bOnLoad && uptType == undefined){
        appendHtml += " on";
    }

    appendHtml += "\">";
    appendHtml += "<span calss=\"txt\">선호극장</span></button>";
    appendHtml += "<div class=\"depth on\" id=\"favorite\"></div>";
    if(bOnLoad){
        $("#brchList>ul").append(appendHtml);
    }
}


//선호지점목록갱신
function fn_favorBrchListUpt(bOnload, uptType, list){
    //console.log("fn_favorBrchListUpt in");
    var brchOnlineExpoAt = false;
    var innerHtml = "";
    if(list != null && list.length > 0){    //선호지점 있는경우
        if(bOnload && uptType == undefined){
            $("#favorite").append("<div class=\"detail-list m-scroll\"><ul></ul></div>");
        }

        for(var i=0; i<list.length; i++){
            if(list[i].brchOnlineExpoAt == "Y"){
                brchOnlineExpoAt = true;
            }
            innerHtml += "<li><button id=\"btn\" type=\"button\" ";
            if(list[i].formAt != "Y"){
                innerHtml += "class=\"disabled\" ";
            }
            innerHtml += "brch-no=\""+list[i].brchNo+"\" brch-nm=\""+list[i].brchNm+"\" brch-eng-nm=\""+list[i].brchEngNm+"\" ";
            innerHtml += "area-cd=\""+list[i].areaCd+"\" area-cd-nm=\""+list[i].areaCdNm+"\" ";
            innerHtml += "spclb-yn=\"N\" ";
            innerHtml += "form-at=\""+list[i].formAt+"\" ";
            innerHtml += "brch-bokd-unable-at=\""+list[i].brchBokdUnableAt+"\" brch-popup-at=\""+list[i].brchPopupAt+"\" brch-popup-no=\""+list[i].brchPopupNo+"\">";

            if(list[i].brchOnlineExpoAt == "Y"){
                innerHtml += "<span class=\"jq-tooltip\" title=\"";
                if(localeCode == 'en'){
                    innerHtml += list[i].brchOnlineExpoStatCdEngNm;
                }
                else {
                    innerHtml += list[i].brchOnlineExpoStatCdNm;
                }

                innerHtml += "\">";

                if(localeCode == 'en'){
                    innerHtml += list[i].brchEngNm;
                }
                else {
                    innerHtml += list[i].brchNm;
                }

                innerHtml += "</span>";
            }
            else {
                if(localeCode == 'en'){
                    innerHtml += list[i].brchEngNm;
                }
                else {
                    innerHtml += list[i].brchNm;
                }
            }
            if(list[i].brchOnlineExpoAt == "Y"){

                var expoStatHtml = "";
                if(localeCode == 'en'){
                    expoStatHtml += list[i].brchOnlineExpoStatCdEngNm+"\">"+list[i].brchOnlineExpoStatCdEngNm+"</i>";
                }
                else {
                    expoStatHtml += list[i].brchOnlineExpoStatCdNm+"\">"+list[i].brchOnlineExpoStatCdNm+"</i>";
                }

                if(list[i].brchOnlineExpoStatCd == 'OES01'){
                    innerHtml += "<i class=\"iconset ico-theater-new\" title=\""+expoStatHtml;
                }
                else if (list[i].brchOnlineExpoStatCd == 'OES02'){
                    innerHtml += "<i class=\"iconset ico-theater-renewal\" title=\""+expoStatHtml;
                }
                else if (list[i].brchOnlineExpoStatCd == 'OES03'){
                    innerHtml += "<i class=\"iconset ico-theater-open\" title=\""+expoStatHtml;
                }
                else if (list[i].brchOnlineExpoStatCd == 'OES04'){
                    innerHtml += "<i class=\"iconset ico-theater-open\" title=\""+expoStatHtml;
                }
            }
            innerHtml += "</button></li>";
        }
        $("#favorite ul").append(innerHtml);
    }

    innerHtml = "";
    innerHtml +="<div class=\"no-favorite\">";
    innerHtml +="<div class=\"wrap\">";
    innerHtml +="<i class=\"iconset ico-theater-favorite\"></i>";
    innerHtml +="<div class=\"txt\">";
    innerHtml +="자주가는 극장을<br />";
    innerHtml +="등록해 보세요!";
    innerHtml +="</div>";
    innerHtml +="<div class=\"setting\">";
    innerHtml +="<a href=\"javaScript:fn_favorBrchReg()\" title=\"선호극장 설정\"><i class=\"iconset ico-theater-chk-purple\"></i> 선호극장 설정</a>";
    innerHtml +="</div>";
    innerHtml +="</div>";
    innerHtml +="</div>";
    $("#favorite").append(innerHtml);

    if(brchOnlineExpoAt){
        $("#btnFavorBrch").addClass("has-issue");
    }
}


function fn_favorBrchReg(){
    var paramFavorBrchReg = { localeCode : localeCode };
    gfn_favorBrchReg(fn_simpleBokdComplFavorBrch, paramFavorBrchReg);
}


function fn_simpleBokdComplFavorBrch(){
    location.reload();
}

//지역지점, 특별관지점 목록갱신
function fn_brchListUpt(list, type, paramMap) {

    //최초 로딩 아닌경우 지점 상세 초기화
    if(typeof paramMap.onLoad === "undefined" || paramMap.onLoad == "" || paramMap.onLoad != "Y" || paramMap.uptType =="reLoad"){
        if(type != "area") {
            $('#specialBrchList li ul').empty();    //특별관 상세 초기화
        }
    }
    var curAreaCd = "";    //현재 지역코드


    for(var i=0; i<list.length; i++) {
        var appendHtml = "";    //지점 마스터
        var innerHtml = "";        //지점 상세

        //최초 로딩인경우
        if(typeof paramMap.onLoad !== "undefined" && paramMap.onLoad != "" && paramMap.onLoad == "Y" && paramMap.uptType === undefined){
            var appendHtml = "";
            var toAreaCd = list[i].areaCd;        //데이터 지역코드

            var innerHtml = "";
            if(curAreaCd != toAreaCd){    //현재 지역코드와 데이터에서 조회된 지역코드가 다르면
                curAreaCd = toAreaCd;    //지역코드값 셋팅

                appendHtml += "<li><button type=\"button\" class=\"btn";
                if(list[i].areaOnlineExpoAt == "Y"){
                    appendHtml += " has-issue";
                }
                //전체 극장 지역 on
                if(type == "area" && paramMap.brchAll == curAreaCd){
                    appendHtml += " on";
                }
                  //특별관 극장 극장 지역 on
                if(type == "spcl" && paramMap.brchSpcl == curAreaCd){
                    appendHtml += " on";
                }

                appendHtml += "\" id=\""+curAreaCd+"\">";
                appendHtml += "<span calss=\"txt\">";
                if(localeCode == 'en'){
                    appendHtml += list[i].areaCdEngNm+"("+ list[i].formBrchCnt+")";
                }
                else {
                    appendHtml += list[i].areaCdNm+"("+ list[i].formBrchCnt+")";
                }
                appendHtml +="</span></button>";
                appendHtml +="<div class=\"depth\">";
                appendHtml +="<div class=\"detail-list m-scroll area-cd"+curAreaCd.trim().replaceAll(" ","")+"\" ><ul></ul></div></div>";
                if(type == "area") {
                    $("#brchList>ul").append(appendHtml);
                }
                else {
                    $("#specialBrchList>ul").append(appendHtml);
                }
                //console.log(appendHtml)
            }
        }

        innerHtml += "<li><button id=\"btn\" type=\"button\" ";
        //최초 로딩이 아닌경우
        if(typeof paramMap.onLoad === "undefined" || paramMap.onLoad == "" || paramMap.onLoad != "Y"){

            if(list[i].brchFormAt != "Y"){
                innerHtml += "class=\"disabled\" ";
            }
        }
        //최초로딩인경우
        else {
            if((typeof $.trim(paramMap.movieNo1) !==  "undefined"
                && $.trim(paramMap.movieNo1) !=  ""
                && list[i].brchFormAt != "Y"
                && "" == parent.sellChnlCd)
            ||
            (typeof $.trim(paramMap.brchNo1) !==  "undefined"
                && $.trim(paramMap.brchNo1) !=  ""
                && list[i].brchFormAt != "Y"
                && "" == parent.sellChnlCd)){
                innerHtml += "class=\"disabled\" ";
            }
        }

        innerHtml += "brch-no=\""+list[i].brchNo+"\" brch-nm=\""+list[i].brchNm+"\" brch-eng-nm=\""+list[i].brchEngNm;
        innerHtml += "\" form-at=\""+list[i].brchFormAt;
        innerHtml += "\" area-cd=\""+list[i].areaCd+"\" area-cd-nm=\""+list[i].areaCdNm+"\" ";
        if(type == "area") {
            innerHtml += "spclb-yn=\"N\" ";
        }
        else {
            innerHtml += "spclb-yn=\"Y\" ori-area-cd =\""+list[i].oriAreaCd+"\" ";
        }
        innerHtml += "brch-bokd-unable-at=\""+list[i].brchBokdUnableAt+"\" brch-popup-at=\""+list[i].brchPopupAt+"\" brch-popup-no=\""+list[i].brchPopupNo+"\">";


        if(list[i].brchOnlineExpoAt == "Y"){
            innerHtml += "<span class=\"jq-tooltip\" title=\"";
            if(localeCode == 'en'){
                innerHtml += list[i].brchOnlineExpoStatCdEngNm;
            }
            else {
                innerHtml += list[i].brchOnlineExpoStatCdNm;
            }

            innerHtml += "\">";

            if(localeCode == 'en'){
                innerHtml += list[i].brchEngNm;
            }
            else {
                innerHtml += list[i].brchNm;
            }

            innerHtml += "</span>";
        }
        else {
            if(localeCode == 'en'){
                innerHtml += list[i].brchEngNm;
            }
            else {
                innerHtml += list[i].brchNm;
            }
        }
        if(list[i].brchOnlineExpoAt == "Y"){

            var expoStatHtml = "";
            if(localeCode == 'en'){
                expoStatHtml += list[i].brchOnlineExpoStatCdEngNm+"\">"+list[i].brchOnlineExpoStatCdEngNm+"</i>";
            }
            else {
                expoStatHtml += list[i].brchOnlineExpoStatCdNm+"\">"+list[i].brchOnlineExpoStatCdNm+"</i>";
            }

            if(list[i].brchOnlineExpoStatCd == 'OES01'){
                innerHtml += "<i class=\"iconset ico-theater-renewal\" title=\""+expoStatHtml;
            }
            else if (list[i].brchOnlineExpoStatCd == 'OES02'){
                innerHtml += "<i class=\"iconset ico-theater-new\" title=\""+expoStatHtml;
            }
            else if (list[i].brchOnlineExpoStatCd == 'OES03'){
                innerHtml += "<i class=\"iconset ico-theater-open\" title=\""+expoStatHtml;
            }
            else if (list[i].brchOnlineExpoStatCd == 'OES04'){
                innerHtml += "<i class=\"iconset ico-theater-open\" title=\""+expoStatHtml;
            }
        }

        innerHtml += "</button>";
        innerHtml += "</li>";

        //최초로딩인경우
        if(typeof paramMap.onLoad !== "undefined" && paramMap.onLoad != "" && paramMap.onLoad == "Y" && paramMap.uptType === undefined){
            $(".area-cd"+curAreaCd.trim().replaceAll(" ","")+">ul").append(innerHtml);
        }
        //최초로딩아닌경우
        else {
            $('#'+list[i].areaCd.trim().replaceAll(" ","")).next().find('ul').append(innerHtml);
        }

    }
}


//영화편성목록 갱신
function fn_movieFormListUpt(list, crtPlayTimeMap) {
    //console.log("fn_movieFormListUpt in");

    $("#playScheduleList").show();
    $("#playScheduleNonList").hide();

    var appendHtml = ""
    appendHtml = "<ul>";

    for(var i=0; i<list.length; i++) {
        appendHtml += "<li>";
        appendHtml += "<button type=\"button\" class=\"btn\" ";
        appendHtml += "play-start-time=\""+(list[i].playStartTime).replaceAll(":","")+"\" "; //시작시간
        appendHtml += "play-de=\"" + list[i].playDe + "\" play-seq=\"" + list[i].seq + "\" rpst-movie-no=\"" + list[i].movieNo + "\" brch-no=\""+list[i].brchNo+"\" theab-no=\""+list[i].theabNo+"\" play-schdl-no=\""+list[i].playSchdlNo+"\" "; //지점번호, 상영관 번호
        appendHtml += "rest-seat-cnt=\""+Number(list[i].restSeatCnt)+"\" "; //시작시간
        appendHtml += "ctts-ty-div-cd=\""+ list[i].cttsTyDivCd +"\" "; //콘텐츠 유형
        appendHtml += "theab-popup-At=\""+list[i].theabPopupAt+"\" theab-popup-no=\""+list[i].theabPopupNo+"\">";//상영관 팝업여부, 상영관 팝업 번호
        appendHtml += "<div class=\"legend\">";

        if(list[i].playTyCd == "ERYM"){
            appendHtml += "<i class=\"iconset ico-sun\" title=\"조조\">조조</i>";
        }
        else if(list[i].playTyCd == "BRUNCH"){
            appendHtml += "<i class=\"iconset ico-brunch\" title=\"브런치\">브런치</i>";
        }
        else if(list[i].playTyCd == "MNIGHT"){
            appendHtml += "<i class=\"iconset ico-moon\" title=\"심야\">심야</i>";
        }
        appendHtml += "</div>";

        appendHtml += "<span class=\"time\">";
        appendHtml += "<strong title=\"상영 시작\">"+list[i].playStartTime+"</strong>";
        appendHtml += "<em title=\"상영 종료\">~"+list[i].playEndTime+"</em>";
        appendHtml += "</span>";

        appendHtml += "<span class=\"title\">";

        if(list[i].eventDivCd != null && list[i].eventDivCd != "") {
        	var eventDivStr = "";

        	//무대인사
        	if(list[i].eventDivCd == "MEK01") {
        		eventDivStr = "fc01"	//무대인사
        	}
        	//오픈시사
        	else if(list[i].eventDivCd == "MEK02"){
        		eventDivStr = "fc03"	//오픈시사
        	}
        	//회원시사
        	else if(list[i].eventDivCd == "MEK03"){
        		eventDivStr = "fc02"	//회원시사
        	}
        	//굿즈패키지
        	else if(list[i].eventDivCd == "MEK04"){
        		eventDivStr = "fc04"	//굿즈패키지
        	}
        	//싱어롱
        	else if(list[i].eventDivCd == "MEK05"){
        		eventDivStr = "fc05"	//싱어롱
        	}
        	//GV
        	else if(list[i].eventDivCd == "MEK06"){
        		eventDivStr = "fc06"	//GV
        	}
        }

        if(localeCode == 'en'){
            appendHtml += "<strong title=\""+list[i].movieEngNm+"\">"+list[i].movieEngNm+"</strong>";
            appendHtml += "<em>"+list[i].playKindEngNm;
            if(list[i].eventDivCd != null && list[i].eventDivCd != "") {
            	appendHtml += "&middot; <b class=\"fw0 "+eventDivStr+"\">"+list[i].eventDivCdEngNm+"</b>"
            }
        }
        else {
            appendHtml += "<strong title=\""+list[i].movieNm+"\">"+list[i].movieNm+"</strong>";
            appendHtml += "<em>"+list[i].playKindNm;
            if(list[i].eventDivCd != null && list[i].eventDivCd != "") {
            	appendHtml += "&middot; <b class=\"fw0 "+eventDivStr+"\">"+list[i].eventDivCdNm+"</b>"
            }
        }

        appendHtml += "</em>"
        appendHtml += "</div>";
        appendHtml += "</span>";

        appendHtml += "<div class=\"info\">";
        appendHtml += "<span class=\"theater\" title=\"극장\">";
        if(localeCode == 'en'){
            appendHtml += ""+list[i].brchEngNm+"<br />"+list[i].theabEngNm;
        }
        else{
            appendHtml += ""+list[i].brchNm+"<br />"+list[i].theabExpoNm;
        }
        appendHtml += "</span>";

        appendHtml += "<span class=\"seat\">";

        if(Number(list[i].restSeatCnt) > 0){
        	appendHtml += "<strong class=\"now\" title=\"잔여 좌석\">";
            appendHtml += list[i].restSeatCnt;
            appendHtml += "</strong>";
            appendHtml += "<span>/</span>";
            appendHtml += "<em class=\"all\" title=\"전체 좌석\">"+list[i].totSeatCnt+"</em>";
        }
        else {
        	appendHtml += "<strong class=\"now\" title=\"잔여 좌석\">";
        	appendHtml += "매진";
        	appendHtml += "</strong>";
        }
        appendHtml += "</span>";
        appendHtml += "</div>";
        appendHtml += "</button>";
        appendHtml += "</li>";
    }
    appendHtml += "</ul>";
    $("#playScheduleList div div:eq(0)").append(appendHtml);
    var hour=crtPlayTimeMap.crtDt
    hour = hour.substr(0,2);
    //mbThCalendar.events.selhour({ hour:Number(hour) });

     $("#playScheduleList").mCustomScrollbar("destroy");
     $m_scroll();        //스크롤바 생성
}


/*파라메타 설정*/
function fn_setParamData(arrayParam){

    var fndMovieNo      = "";
    var fndBrchNo       = "";
    var fndAreaCd       = "";
    var fndSpclbYn      = "";
    var fndTheabKindCd  = "";

    if(typeof arrayParam != 'undefined' && arrayParam != ""){
        fndMovieNo      = typeof arrayParam[0] != 'undefined' && arrayParam[0] != '' ? arrayParam[0] : "";
        fndBrchNo       = typeof arrayParam[1] != 'undefined' && arrayParam[1] != '' ? arrayParam[1] : "";
        fndAreaCd       = typeof arrayParam[2] != 'undefined' && arrayParam[2] != '' ? arrayParam[2] : "";
        fndSpclbYn      = typeof arrayParam[3] != 'undefined' && arrayParam[3] != '' ? arrayParam[3] : "";
        fndTheabKindCd  = typeof arrayParam[4] != 'undefined' && arrayParam[4] != '' ? arrayParam[4] : "";
    }

    var brchCnt = 0;
    var movieNo = "";
    var playDe = "";
    var brchAll ="";
    var brchSpcl ="";
    var movieNo1 ="";
    var movieNo2 = "";
    var movieNo3 = "";
    var brchNo1 = "";
    var brchNo2 = "";
    var brchNo3 = "";
    var areaCd1 = "";
    var areaCd2 = "";
    var areaCd3 = "";
    var spclbYn1 = "";
    var spclbYn2 = "";
    var spclbYn3 = "";
    var theabKindCd1 = "";
    var theabKindCd2 = "";
    var theabKindCd3 = "";

    //선택한 영화 세팅
    $("#choiceMovieList .bg").find("img").each(function(idx){
        if(idx == 0){
               movieNo1 = $(this).attr("movie-no");
            movieNo = movieNo1;
        }
        else if(idx == 1){
            movieNo2 = $(this).attr("movie-no");
            movieNo += ","+movieNo2;
        }
        else{
            movieNo3 = $(this).attr("movie-no");
            movieNo += ","+movieNo3;
        }
    });

    if(fndMovieNo != "" && typeof fndMovieNo != 'undefined'){
        if(movieNo1 == ""){
            movieNo1 = fndMovieNo;
            movieNo = movieNo1;
        }
        else if(movieNo2 == ""){
            movieNo2 = fndMovieNo;
            movieNo += ","+movieNo2;
        }
        else if(movieNo3 == ""){
            movieNo3 = fndMovieNo;
            movieNo += ","+movieNo3;
        }
    }

    //선택한 지점 세팅
    $("#choiceBrchList .bg").find(".del").each(function(idx){
//       if(brchCnt == 0){
//           brchNo = $(this).attr("brch-no");
//       }else{
//           brchNo += ","+$(this).attr("brch-no");
//       }
        if(idx == 0){
            brchNo1  = $(this).attr("brch-no");
            areaCd1  = $(this).attr("area-cd");
            spclbYn1 = $(this).attr("spclb-yn");
            theabKindCd1 = $(this).attr("theab-kind-cd");
        }else if(idx == 1){
            brchNo2  = $(this).attr("brch-no");
            areaCd2  = $(this).attr("area-cd");
            spclbYn2 = $(this).attr("spclb-yn");
            theabKindCd2 = $(this).attr("theab-kind-cd");
        }else{
            brchNo3  = $(this).attr("brch-no");
            areaCd3  = $(this).attr("area-cd");
            spclbYn3 = $(this).attr("spclb-yn");
            theabKindCd3 = $(this).attr("theab-kind-cd");
        }
        brchCnt++;
    });

    if(fndBrchNo != "" && typeof fndBrchNo != 'undefined'){
        if(brchNo1 == ""){
            brchNo1      = fndBrchNo;
            areaCd1      = fndAreaCd;
            spclbYn1     = fndSpclbYn;
            theabKindCd1 = fndTheabKindCd;
        }
        else if(brchNo2){
            brchNo2      = fndBrchNo;
            areaCd2      = fndAreaCd;
            spclbYn2     = fndSpclbYn;
            theabKindCd2 = fndTheabKindCd;
        }
        else{
            brchNo3      = fndBrchNo;
            areaCd3      = fndAreaCd;
            spclbYn3     = fndSpclbYn;
            theabKindCd3 = fndTheabKindCd;
        }
    }

    theabKindCd1 = theabKindCd1.indexOf("TB") != -1 ? "TB" : theabKindCd1;
    theabKindCd2 = theabKindCd1.indexOf("TB") != -1 ? "TB" : theabKindCd2;
    theabKindCd3 = theabKindCd1.indexOf("TB") != -1 ? "TB" : theabKindCd3;

    if(brchCnt == 0){
//   if(movieCnt == 0 || brchCnt ==0){
        $("#playScheduleList div div:eq(0)").empty();
        $("#playScheduleList").hide();
        $("#playScheduleNonList").show();
        //return;
    }

    //선택한 날짜 세팅
    playDe = $('#playDe').val().replaceAll( ".", "");
    if(playDe == ""){
        return;
    }

    //전체극장 선택
    $("#brchList>ul>li>button.on").each(function(idx){
        brchAll = $(this).attr("id");
    });

    //특별관 선택
    $("#specialBrchList>ul>li>button.on").each(function(idx){
        brchSpcl = $(this).attr("id");
    });

    //specialBrchList find on

    var paramData = { arrMovieNo:movieNo, playDe:playDe
            , brchNoListCnt:brchCnt, brchNo1:brchNo1, brchNo2:brchNo2, brchNo3:brchNo3
            , areaCd1:areaCd1, areaCd2:areaCd2, areaCd3:areaCd3
            , spclbYn1:spclbYn1, spclbYn2:spclbYn2, spclbYn3:spclbYn3
            , theabKindCd1:theabKindCd1, theabKindCd2:theabKindCd2, theabKindCd3:theabKindCd3
            , brchAll:brchAll, brchSpcl:brchSpcl
            , movieNo1:movieNo1, movieNo2:movieNo2, movieNo3:movieNo3
            , sellChnlCd:parent.sellChnlCd };

    return paramData;
}


//예매목록조회
function fn_selectBokdList(bOnLoad,uptType){
	parent.$(".bg-loading").show();

    var paramData = null;

    if(bOnLoad){
        //console.log("fn_selectBokdList paramData onload param bOnLoad:"+bOnLoad+"/ uptType:"+uptType);
        // 2019.07.23 hjchoi 영화화면에서 상영관종류 또는 지점코드 추가
        //paramData = { playDe:$('#playDe').val().replaceAll( ".", ""), movieNo1:movieScnEntry, onLoad:"Y", sellChnlCd:parent.sellChnlCd}
        if(uptType != undefined && uptType == "reLoad"){
        	paramData = { playDe:$('#crtDe').val().replaceAll( ".", ""), onLoad:"Y", uptType:"reLoad", sellChnlCd:parent.sellChnlCd}
        }
        else {
        	paramData = { playDe:$('#playDe').val().replaceAll( ".", "")
        			, incomeMovieNo:movieScnEntry
        			, onLoad:"Y"
        			, sellChnlCd:parent.sellChnlCd
        			, incomeTheabKindCd:movieScnTheabKindCd1
        			, incomeBrchNo1:movieScnBrchNo1
        			, incomePlayDe:parent.bokdMPlayDe}
        }
    }
    else {
        //console.log("fn_selectBokdList paramData event param bOnLoad:"+bOnLoad+"/ uptType:"+uptType);
        paramData = fn_setParamData('','','','');
    }

    $.ajaxMegaBox({
//         url: "/on/oh/ohb/SimpleBooking/selectPlayScheduleList.do", 변경
        url: "/on/oh/ohb/SimpleBooking/selectBokdList.do",
        data: JSON.stringify(paramData),
        success: function (data, textStatus, jqXHR) {
            //console.log("fn_selectBokdList success paramMap:"+JSON.stringify(data.paramMap));
            var choiceBrchCnt = 0;                 //선택된극장수
            var crtPlayTimeUptAt = false;          //현재일자
            var movieFormDeListUptAt = false;      //영화편성일자목록조회
            var favorBrchDispAt = false;           //선호지점표시여부
            var movieListUptAt = false;            //영화목록갱신여부
            var crtnMovieListUptAt = false;        //큐레이션영화목록갱신여부
            var favorBrchListUptAt = false;        //선호지점갱신여부
            var areaBrchListUptAt = false;         //지역지점목록갱신여부
            var spclbBrchListUptAt = false;        //특별관지점목록갱신여부
            var movieFormListUptAt = false;        //영화편성목록갱신여부

            //선택된 극장수 업데이트
            $("#choiceBrchList .bg").each(function(idx){
                if(typeof $(this).find(".del").attr("brch-no") != 'undefined'){
                    choiceBrchCnt++
                }
            });

            //갱신여부 업데이트
            if(bOnLoad){    //온로드일경우
                crtPlayTimeUptAt = true;
                movieFormDeListUptAt = true;
                movieListUptAt = true;
                crtnMovieListUptAt = true;
                if(typeof data.paramMap.loginAt !== "undefined" && data.paramMap.loginAt != null){favorBrchDispAt = true; }
                if(typeof data.paramMap.loginAt !== "undefined" && data.paramMap.loginAt != null){favorBrchListUptAt = true;}

                // 2019.07.24 hjchoi 영화정보에서 넘어온 상영관종류코드가 있을시 선호지점 무시
                if((typeof data.paramMap.incomeTheabKindCd != "undefined" && data.paramMap.incomeTheabKindCd != "") ||
                    (typeof data.paramMap.incomeBrchNo1 != "undefined" && data.paramMap.incomeBrchNo1 != "")
                ) {
                    favorBrchDispAt = false;
                    favorBrchListUptAt = false;
                }

                if(uptType == "reLoad"){
                	favorBrchDispAt = false;
                	if(typeof data.paramMap.loginAt !== "undefined" && data.paramMap.loginAt != null){favorBrchListUptAt = true;}
                	else favorBrchListUptAt = false;

                }

                areaBrchListUptAt = true;
                spclbBrchListUptAt = true;
                if(data.movieFormList != null && data.movieFormList.length > 0){movieFormListUptAt = true;}
            }
            else {  //온로드 아닐경우
                if(uptType == "movieFormDe"){
                    movieFormDeListUptAt = true;
                    movieListUptAt = true;
                    crtnMovieListUptAt = true;
                    if(typeof data.paramMap.loginAt !== "undefined"){favorBrchDispAt = true; }
                    if(typeof data.paramMap.loginAt !== "undefined"){favorBrchListUptAt = true;}
                    areaBrchListUptAt = true;
                    spclbBrchListUptAt = true;
                    if(choiceBrchCnt > 0 && data.movieFormList != null && data.movieFormList.length > 0){movieFormListUptAt = true;}
                }
                else if (uptType == "movieList"){
                    movieFormDeListUptAt = true;
                    movieListUptAt = true;
                    crtnMovieListUptAt = true;
                    if(typeof data.paramMap.loginAt !== "undefined"){favorBrchDispAt = true; }
                    if(typeof data.paramMap.loginAt !== "undefined"){favorBrchListUptAt = true;}
                    areaBrchListUptAt = true;
                    spclbBrchListUptAt = true;
                    if(choiceBrchCnt > 0 && data.movieFormList != null && data.movieFormList.length > 0){movieFormListUptAt = true;}
                }
                else if (uptType == "brchList"){
                    movieFormDeListUptAt = true;
                    movieListUptAt = true;
                    crtnMovieListUptAt = true;
                    if(typeof data.paramMap.loginAt !== "undefined"){favorBrchDispAt = true; }
                    if(typeof data.paramMap.loginAt !== "undefined"){favorBrchListUptAt = true;}
                    areaBrchListUptAt = true;
                    spclbBrchListUptAt = true;
                    if(choiceBrchCnt > 0 && data.movieFormList != null && data.movieFormList.length > 0 ){movieFormListUptAt = true;}
                }
            }

            //RIA는 선호지점 무시
            if("" != parent.sellChnlCd){
            	favorBrchDispAt = false;
                favorBrchListUptAt = false;
            }

            //전체 지점상세갱신
            if(favorBrchListUptAt || areaBrchListUptAt){
            	if(!bOnLoad){
            		$('#brchList li ul').empty();            //지점상세 초기화
            	}
            	else if(bOnLoad && uptType == "reLoad"){
            		$('#brchList li ul').empty();            //지점상세 초기화
            	}
            }

            //갱신
            if(movieFormDeListUptAt){ fn_movieFormDeListUpt(bOnLoad, data.movieFormDeList, data.crtPlayTimeMap, data.paramMap);} //편성일자갱신
            if(movieListUptAt)      { fn_movieListUpt(data.movieList,"all", data.paramMap); }            //영화목록갱신
            if(crtnMovieListUptAt)  { fn_movieListUpt(data.crtnMovieList,"crtn", data.paramMap); }       //큐레이션목록갱신
            if(favorBrchDispAt)     { fn_favorBrchDisp(bOnLoad, uptType); }                                       //선호지점표시
            if(favorBrchListUptAt)  { fn_favorBrchListUpt(bOnLoad, uptType, data.favorBrchList); }                         //선호지점갱신
            if(areaBrchListUptAt)   { fn_brchListUpt(data.areaBrchList,"area", data.paramMap); }         //지역지점목록갱신
            if(spclbBrchListUptAt)  { fn_brchListUpt(data.spclbBrchList,"spcl", data.paramMap); }        //특별관지점목록갱신



            // 2019.07.23 hjchoi 영화정보에서 넘어온 상영관종류코드가 있을시 특별관 설정
            if(typeof data.paramMap.incomeTheabKindCd != "undefined" && data.paramMap.incomeTheabKindCd != "") {
                fn_TheabKindCdUpt(data.paramMap.incomeTheabKindCd);
            }

            // 2019.07.24 hjchoi 영화정보에서 넘어온 지점코드가 있을시 설정
            if(typeof data.paramMap.incomeBrchNo1 != "undefined" && data.paramMap.incomeBrchNo1 != "") {
                fn_IncomeBrchNoUpt(data.paramMap.incomeBrchNo1);
            }

            if(movieFormListUptAt)  {
            	$("#playScheduleList div div:eq(0)").empty();
                $('.hour-schedule button.hour').removeClass('on');
                $('.hour-schedule button.hour').attr("disabled","disabled");
                $('.hour-schedule button.hour').attr("style","opacity: 0.5");
                fn_movieFormListUpt(data.movieFormList, data.crtPlayTimeMap);    //영화편성목록갱신
                mScrollUpdate();    //시간 스크롤바 업데이트
            }
            else {
                $m_scroll();        //스크롤바 생성
                $("#playScheduleList div div:eq(0)").empty();
                $('.hour-schedule button.hour').removeClass('on');
                $('.hour-schedule button.hour').attr("disabled","disabled");
                $('.hour-schedule button.hour').attr("style","opacity: 0.5");
                $("#playScheduleList").hide();
                $("#playScheduleNonList").show();
                mScrollUpdate();    //시간 스크롤바 업데이트
            }

            //if(crtPlayTimeUptAt)    { fn_crtPlayTimeUpt(data.crtPlayTimeMap);}    //현재일자표시
              //선호지점 갱신여부가 false일 경우
            if(favorBrchDispAt == false){
                $('.liFavorBrch').empty();
            }
            fn_requestSetParam(data.paramMap);//파라메타 갱신

            return;
        },
        error: function(xhr,status,error){
             var err = JSON.parse(xhr.responseText);
             alert(xhr.status);
             alert(err.message);
        },
        complete: function() {
            var dsDate = $('#playDe').val();

            if(!bOnLoad){
            	mbThCalendar.arrCkFlag = true; //날짜 플래그 끝부분
            	mbThCalendar.events.trimdate({ mnDate: '', callback:''});
            }
            else {
            	mbThCalendar.setUI();
            	mbThCalendar.events.trimdate({ mnDate: $('#playDe').val(), callback:''});
            }

            if (document.querySelector('[date-data="'+ dsDate +'"]') !== null){
                var timeObj = document.querySelector('[date-data="'+ dsDate +'"]');
                $(timeObj).addClass('on');
            }
            $jqTooltip();       //튤팁생성
            parent.$(".bg-loading").hide();

            if(bOnLoad){
            	parent.fn_getMsgStrToAlert();
            }


        }
    });
}

//2019.07.23 hjchoi 영화정보에서 넘어온 상영관종류코드가 있을시 특별관 설정
function fn_TheabKindCdUpt(theabKindCode1) {
    $('.theater-choice .all-list .btn-tab').removeClass('on');
    $('.theater-choice .all-list .list').hide();
    $('.theater-choice .other-list .btn-tab').addClass('on');
    $('.theater-choice .other-list .list').show();

    $('.theater-choice .other-list .list #'+theabKindCode1).trigger("click");
}

//2019.07.24 hjchoi 영화정보에서 넘어온 지점코드가 있을시 설정
function fn_IncomeBrchNoUpt(brchNo) {
    $('.theater-choice .all-list .list').find('button').each(function(index) {
        if ($(this).attr("brch-no") == brchNo) {
            var areaCd = $(this).attr("area-cd");

            $('.theater-choice .all-list .list #'+areaCd).trigger("click"); // 지역클릭
            $(this).trigger("click"); // 지점클릭
        }
    });
}

//리턴받은 파라메타 설정
function fn_requestSetParam(paramMap){
    //영화셋팅
//  if(typeof data.paramMap.movieNo1 !== "undefined" && data.paramMap.movieNo1 != ""){};
//  if(typeof data.paramMap.movieNo2 !== "undefined" && data.paramMap.movieNo2 != ""){};
//  if(typeof data.paramMap.movieNo3 !== "undefined" && data.paramMap.movieNo3 != ""){};

    //극장셋팅
    //최초진입시 선호극장 선택된목록에 표시처리
    if(typeof paramMap.onLoad != "undefined" && paramMap.onLoad == "Y" && paramMap.uptType != "reLoad"){
        $("#favorite #btn").each(function(idx){
            var type = "area";
            var spclbYn   = eval("paramMap.spclbYn"+(idx+1));
            if(spclbYn == 'Y') {type = "splc";}
            if(!$(this).hasClass("disabled")){
                fn_setBrchChoi([$(this), type,"N"]);
            }
        });
    }
    else {
        //선택한 극장을 극장 목록에서 에서 선택처리 셋팅
        $("#choiceBrchList .bg").each(function(idx){
            var brchNo = $(this).find(".del").attr("brch-no");
            var areaCd =  $(this).find(".del").attr("area-cd");
            if(typeof brchNo != 'undefined'){
                fn_brchListChange(brchNo, "ins", areaCd);
            }
        });

        //선택된 영화를 영화 목록에서 에서 선택처리 셋팅
        $("#choiceMovieList .bg").each(function(idx){
            var movieNo = $(this).find("img").attr("movie-no");
            if(typeof movieNo != 'undefined'){
                fn_movieListChange(movieNo, "set");
            }
        });
    }

    if(typeof paramMap.onLoad != "undefined" && paramMap.onLoad == "Y" && paramMap.movieNo1 != ""){
        fn_setMovieChoi($('#movieList button.on'));
    }

    //영화선택개수 카운팅
    var movieChoiCnt = 0;
    $("#choiceMovieList .bg").each(function(idx){
        if($.trim($(this).html()) == ""){
            movieChoiCnt++;
        }

    });
    if(movieChoiCnt == 3){
        $('#choiceMovieNone').show();
        $('#choiceMovieList').hide();
    }
    else{
        $('#choiceMovieNone').hide();
        $('#choiceMovieList').show();
    }

    //극장선택개수 카운팅
    var brchChoiCnt = 0;
    $("#choiceBrchList .bg").each(function(idx){
        if($.trim($(this).html()) == ""){
            brchChoiCnt++;
        }
    });
    if(brchChoiCnt == 3){
        $('#choiceBrchNone').show();
        $('#choiceBrchList').hide();
    }
    else{
        $('#choiceBrchNone').hide();
        $('#choiceBrchList').show();
    }

    //전체극장 탭 선택시 하위 지역 선택
    $("#brchList>ul>li>button").each(function(idx){
        if(paramMap.brchAll == $(this).attr("id")){
            $(this).trigger("click");
        }
    });

    //특별관 탭 선택시 선택 하위 특별관 목록 선택
    $("#specialBrchList>ul>li>button").each(function(idx){
        if(paramMap.brchSpcl == $(this).attr("id")){
            $(this).trigger("click");
        }
    });

    //지역 버튼 개수 카운팅
    var areaButton = $('.depth').prev();
    for(var i=0;i<areaButton.length;i++){    //지역버튼 개수만큼 반복
        var brchButton = $('#'+$(areaButton[i]).attr("id")).next().find('li button');    //지점 버튼 객체
        var brchFormSize = 0;
        //최초로딩의 경우
        if(typeof paramMap.onLoad != "undefined" && paramMap.onLoad == "Y"){
            if((typeof $.trim(paramMap.movieNo1) !==  "undefined"
                && $.trim(paramMap.movieNo1) !=  ""
                && "" == parent.sellChnlCd)
            ||
            (typeof $.trim(paramMap.brchNo1) !==  "undefined"
                && $.trim(paramMap.brchNo1) !=  ""
                && "" == parent.sellChnlCd)){
                $(brchButton).each(function(idx){
                    if("Y" == $(this).attr("form-at")){
                        brchFormSize++;
                    }
                });
            }else {
                brchFormSize = brchButton.size();    //전체 버튼 개수를 설정
            }
        }
        //최초로딩 아닌경우
        else {
            //반복하여 돌고 객체의 편성여부를 체크
            $(brchButton).each(function(idx){
                if("Y" == $(this).attr("form-at")){
                    brchFormSize++;
                }
            });
        }
        var areaSpan = $(areaButton[i]).find('span');
        var areaNm = $(areaSpan).html().replace(')','').split('(')[0];
        areaNm += "("+brchFormSize+")";
        $(areaSpan).html(areaNm);
    }

//  if(typeof data.paramMap.brchNo1 !== "undefined" && data.paramMap.brchNo1 != ""){};
//     if(typeof data.paramMap.brchNo2 !== "undefined" && data.paramMap.brchNo2 != ""){};
//     if(typeof data.paramMap.brchNo3 !== "undefined" && data.paramMap.brchNo3 != ""){};
}


//빠른일자 셋팅
function fn_setMinBokdDe(arrayParam){
    //console.log("fn_setMinBokdDe in param : "+arrayParam);
    var type              = arrayParam[0];
    var minBokdAbleDeList = arrayParam[1];
    var crtPlayTimeMap    = arrayParam[2];
    var obj               = arrayParam[3];
    var bIsRe             = typeof arrayParam[4] != 'undefined';
    var minBokdAbleDe     = "";

    //영화일때
    if(type == "movie"){
        //영화 하단 셋팅
        if(!bIsRe && typeof obj != 'undefined'){
            fn_setMovieChoi([obj,'Y']);
        }
    }
    //극장일때
    else if(type == "spcl" || type == "area") {
        //극장 하단 상단 셋팅
        var arrBrchChoi = [];
        var typeObj = document.querySelector('#brchTab button.on');
        arrBrchChoi[0] = obj;
        arrBrchChoi[1] = type;
        if(!bIsRe){
            fn_setBrchChoi(arrBrchChoi);
        }
    }

    //console.log(minBokdAbleDe);
    fn_movieFormDeListUpt(false, minBokdAbleDeList, crtPlayTimeMap);
    minBokdAbleDe = (minBokdAbleDeList[0].playDe).maskDate();

    mbThCalendar.events.trimdate({ mnDate:minBokdAbleDe, callback:mbThCalendar.tempMthd});
    if($('#crtDe').val() != minBokdAbleDe) {
         //$('#datePicker').datepicker('show');//    달력 자동으로 뜨는 기능대신 메시지 처리    김민영 과장 요청
    }
}

//빠른일자 찾기
function fn_selectMinBokdAbleDe(obj){
    var movieNo          = typeof $(obj).attr("movie-no") != 'undefined' ? $(obj).attr("movie-no") : "";
    var brchNo        = typeof $(obj).attr("brch-no")  != 'undefined' ? $(obj).attr("brch-no") : "";
    var areaCd        = typeof $(obj).attr("area-cd")  != 'undefined' ? $(obj).attr("area-cd") : "";
    var spclbYn         = typeof $(obj).attr("spclb-yn")  != 'undefined' ? $(obj).attr("spclb-yn") : "";
    var theabKindCd  = spclbYn == "Y" ? $(obj).attr("area-cd") : "";
    var type         = spclbYn == "" ? "movie" : spclbYn == "Y" ? 'spcl' : 'area';
    var paramData    = type == "movie" ? fn_setParamData([movieNo, '', '', '','']) : fn_setParamData(['', brchNo, areaCd, spclbYn, theabKindCd]);
    var formAt        = $(obj).attr("form-at") == "Y" ? true : false;
    var movieChoi    = $('#choiceMovieList .img').size() < 1 ? false : true;
    var brchChoi     = $('#choiceBrchList .txt').size() < 1 ? false : true;
    if(typeof obj == 'undefined' || (!formAt && ((!movieChoi && !brchChoi)
                    ||    (!movieChoi && brchChoi && type == "movie")
                    ||    (movieChoi && !brchChoi && type != "movie")
                    ))){
        $.ajaxMegaBox({
            url: "/on/oh/ohb/SimpleBooking/selectMinBokdAbleDe.do",
            data: JSON.stringify(paramData),
            success: function (data, textStatus, jqXHR) {
                //console.log("selectMinBokdAbleDe calback ===> "+JSON.stringify(data.minBokdAbleDeMap));
                var msg = "";
                var confirmFnName = "";
                var confirmFnParam = null;

                if(data.minBokdAbleDeList != null && data.minBokdAbleDeList.length > 0){    //있음
                    confirmFnName = fn_setMinBokdDe;
                    confirmFnParam = [];
                    confirmFnParam[0] = type;
                    confirmFnParam[1] = data.minBokdAbleDeList;
                    confirmFnParam[2] = data.crtPlayTimeMap;
                    confirmFnParam[3] = obj;

                    if(type == "movie") {    //영화
                        //빠른예매일로 변경
                        msg = '해당 일자에 상영 시간표가 없습니다.\n 선택하신 영화의 가장 빠른 예매일로 변경하시겠습니까?'; //해당 일자에 상영 시간표가 없습니다. 선택하신 영화의 가장 빠른 예매일로 변경하시겠습니까?
                    }
                    else if(type == "area" || type == "spcl") {    //극장
                        //영화관유지
                        //빠른예매일로변경
                        //영화유지
                        msg = '해당 일자에 상영 시간표가 없습니다.\n 선택하신 영화관의 가장 빠른 상영일로 변경하시겠습니까?'; //해당 일자에 상영 시간표가 없습니다. 선택하신 영화관의 가장 빠른 상영일로 변경하시겠습니까?
                    }

                    $(".time-schedule").addClass("not-available");
                }
                else {    //없음
                    if(type == "movie") {    //영화
                        //영화관 초기화
                        //빠른예매일로 변경
                        //영화유지
                        confirmFnName = fn_setReMinBokdAbleDe;
                        confirmFnParam = [obj, "R", "Y", "U", type];    //변경여부 param : obj 영화관 예매일 영화
                        msg ='해당 일자에 상영 시간표가 없습니다.\n 선택하신 영화가 상영중인 다른 영화관을 선택하시겠습니까?';    //해당 일자에 상영 시간표가 없습니다. 선택하신 영화가 상영중인 다른 영화관을 선택하시겠습니까?
                    }
                    else if(type == "area" || type == "spcl") {    //극장
                        //선택영화 카운팅
                        var movieCnt = 0;
                        $("#choiceMovieList .bg").each(function(idx){
                            if($.trim($(this).html()) == ""){
                                movieCnt++;
                            }
                        });

                        //선택된 영화가 있는경우
                        if(movieCnt < 3){
                            //영화관초기화
                            //날짜유지
                            //영화유지
                            confirmFnName = fn_setReMinBokdAbleDe;
                            confirmFnParam = [obj, "R", "N", "N", type];    //변경여부 param : obj 영화관 예매일 영화
                            msg ='해당 일자에 상영 시간표가 없습니다.\n 선택하신 영화가 상영중인 다른 영화관을 선택하시겠습니까?';    //해당 일자에 상영 시간표가 없습니다. 선택하신 영화가 상영중인 다른 영화관을 선택하시겠습니까?
                        }
                        //선택된 영화가 없는경우
                        else {
                            //선택한영화관
                              //빠른예매일 변경
                              //영화유지
                              confirmFnName = fn_setReMinBokdAbleDe;
                              confirmFnParam = [obj, "U", "Y", "N", type];    //변경여부 param : obj 영화관 예매일 영화
                              msg ='해당 일자에 상영 시간표가 없습니다.\n 선택하신 영화관의 가장 빠른 상영일로 변경하시겠습니까?'//해당 일자에 상영 시간표가 없습니다. 선택하신 영화관의 가장 빠른 상영일로 변경하시겠습니까
                        }
                    }
                }

                var options = {};
                options.msg          = msg;
                options.confirmFn    = confirmFnName;
                options.cancelFn     = '';
                options.okBtnTxt     = "확인";
                options.cancelBtnTxt = "취소";
                options.param        = {confirm:confirmFnParam ,cancel:""} ;
                options.minWidth     = 400
                options.minHeight    = 250
                gfn_confirmMsgBox(options);
            },
            error: function(xhr,status,error){
                var err = JSON.parse(xhr.responseText);
                alert(xhr.status);
                alert(err.message);
            }
        });
    }
    else {
        if(type == "movie"){
            //영화팝업
            // 2019.07.28 hjchoi 상영스케줄 클릭으로 이동
            //fn_selectMovieChoiPopup(obj); //영화 팝업 조회
        	fn_setMovieChoi([obj,"N"]);
        }
        else {
            //지점팝업
            // 2019.07.28 hjchoi 상영스케줄 클릭으로 이동
            //fn_selectBrchChoiPopup(obj);  //지점 팝업 조회
        	fn_setBrchChoi([obj, type,"Y"]);
        }
    }
}


//빠른일자 재조회를 위한 셋팅
function fn_setReMinBokdAbleDe(arrayParam){
    //console.log("fn_setReMinBokdAbleDe in param : "+arrayParam);
    var obj         = arrayParam[0];
    var brchUptCn   = arrayParam[1];
    var bokdDeUptAt = arrayParam[2];
    var movieUptCn  = arrayParam[3];
    var type        = arrayParam[4];
    //param : obj, brchUptCn, bokdDeUptAt, movieUptCn, type
    //영화관 R : 초기화               U : 선택영화관,
    //예매일 Y : 빠른예매일로 변경    N : 날짜유지
    //영화   R : 초기화               U : 선택영화, N : 영화관유지
    //type   movie: 영화목록선택 spcl,area: 극장목록선택

    //영화관
    if(brchUptCn == "R") {
        //영화관 초기화
        $('#choiceBrchList .bg').empty();
        $("#brchList #btn").removeClass("on");
        $("#specialBrchList #btn").removeClass("on");
    }
    else if(brchUptCn == "U") {
        fn_setBrchChoi([obj, type,"N"]);
    }

    //영화
    if(movieUptCn == "U") {
        fn_setMovieChoi([obj, 'Y']);
    }

    //일자
    if(bokdDeUptAt == "Y"){
        var  paramData = fn_setParamData();
        $.ajaxMegaBox({
//             url: "/on/oh/ohb/SimpleBooking/selectPlayScheduleList.do", 변경
            url: "/on/oh/ohb/SimpleBooking/selectMinBokdAbleDe.do",
            data: JSON.stringify(paramData),
            success: function (data, textStatus, jqXHR) {
                //console.log("fn_setReMinBokdAbleDe calback ===> "+JSON.stringify(data.minBokdAbleDeMap));
                if(typeof data.minBokdAbleDeList != 'undefined' && data.minBokdAbleDeList != null && data.minBokdAbleDeList.length > 0){    //있음
                    confirmFnParam = [];
                    confirmFnParam[0] = type;
                    confirmFnParam[1] = data.minBokdAbleDeList;
                    confirmFnParam[2] = data.crtPlayTimeMap;
                    confirmFnParam[3] = obj;
                    confirmFnParam[4] = true;
                    fn_setMinBokdDe(confirmFnParam);
                }
                else {    //없음
                    if(type == "movie"){
                        //영화날림
                        $("#choiceMovieList .bg").empty();
                        $("#movieList .btn").removeClass("on");
                        $("#crtnMovieList .btn").removeClass("on");
                        gfn_alertMsgBoxSize('선택한 극장에서 상영중인 스케줄이 없습니다.',400,250);    //선택한 극장에서 상영중인 스케줄이 없습니다.
                        if($('#choiceBrchList .txt').size() == 0 && $("#choiceMovieList .del").size() == 0){
                			fn_selectBokdList(true,"reLoad") //예매 목록 갱신 초기화상태
                		}
                        else {
                        	fn_selectBokdList(false,'movieFormDe');
                        }
                        mbThCalendar.arrCkFlag = true;    //날자 플래그 끝나는 부분
                    }else {
                        //지점날림
                        $('#choiceBrchList .bg').empty();
                        $("#brchList #btn").removeClass("on");
                        $("#specialBrchList #btn").removeClass("on");
                        gfn_alertMsgBoxSize('선택한 극장에서 상영중인 스케줄이 없습니다.',400,250);    //선택한 극장에서 상영중인 스케줄이 없습니다.
                        if($('#choiceBrchList .txt').size() == 0 && $("#choiceMovieList .del").size() == 0){
                			fn_selectBokdList(true,"reLoad") //예매 목록 갱신 초기화상태
                		}
                        else {
                        	fn_selectBokdList(false,'movieFormDe');
                        }
                        mbThCalendar.arrCkFlag = true;    //날자 플래그 끝나는 부분
                    }
                }
            },
            error: function(xhr,status,error){
                var err = JSON.parse(xhr.responseText);
                alert(xhr.status);
                alert(err.message);
            }
        });
    }
    else {
        mbThCalendar.arrCkFlag = true;    //날자 플래그 끝나는 부분
    }
}

//상영시간이 초과 되었을때 상영스케쥴 재조회
function fn_selectMovieFormDeBokdList(){
	fn_selectBokdList(false,'movieFormDe');
}

</script>
</head>
<body class="body-iframe">
        <!-- inner-wrap -->
        <div class="inner-wrap" style="padding-top:40px; padding-bottom:100px;">
            <input type="hidden" id="playDe" name="playDe" value=""/>
            <input type="hidden" id="crtDe" name="crtDe" value=""/>

            <!-- quick-reserve -->
            <div class="quick-reserve">
                <div class="tit-util">
                    <h2 class="tit">빠른예매</h2>

					<div id="btnLangChg" class="right btn-ticket" style="display:none">
                        <button type="button" class="button gray-line" onClick="parent.setLangChg()">English</button>
                    </div>
                </div>

                






<script type="text/javascript">
var requestPayAt = "N";

$(function(){
	//RIA의 경우
    if(parent.sellChnlCd != ""){
        $('.inner-wrap')
        	.css('padding-bottom','')
        	.css('padding-top','');	//하단 상단 공백 제거
//         $('#btnLangChg').hide();    //언어전환 버튼숨김

        //로그인 되었으면
        if(parent.riaLoginAt == "Y"){
        	$('.cti-area input[name=riaName]').attr('value',parent.riaParamName);	//고객명
            $('.cti-area input[name=riaMobileNo]').attr('value',parent.riaParamMobileNo);	//고객전화번호
            $('.cti-area input[name=riaBirthday]').attr('value',parent.riaParamBirthday);	//고객생년월일
        	$('.cti-area input[name=riaMemberYn]').attr('value',parent.riaMemberYn == "Y" ? "회원" : "비회원");	//회원여부

        	$('.cti-area input[name=riaName]').attr("readonly",true);		//고객명
            $('.cti-area input[name=riaMobileNo]').attr("readonly",true);	//고객전화번호
            $('.cti-area input[name=riaBirthday]').attr("readonly",true);	//고객생년월일

            $('.cti-area input[name=riaMemberYn]').attr("readonly",true);	//회원여부

        	$('.cti-area button').attr('login-at',"Y");

            //결제화면이 아니면
            if("N" == requestPayAt){
            	$('.cti-area button').html('재인증');
            }
        }
        //로그인 되지 않았으면
        else {
        	$('.cti-area input[name=riaName]').attr('value',parent.riaParamName);	//고객명
            $('.cti-area input[name=riaMobileNo]').attr('value',parent.riaParamMobileNo);	//고객전화번호
            $('.cti-area input[name=riaBirthday]').attr('value',parent.riaParamBirthday);	//고객생년월일
            $('.cti-area input[name=riaMemberYn]').attr('value','');	//회원여부

        	$('.cti-area input[name=riaName]').attr("readonly",false);		//고객명
            $('.cti-area input[name=riaMobileNo]').attr("readonly",false);	//고객전화번호
            $('.cti-area input[name=riaBirthday]').attr("readonly",false);	//고객생년월일

            $('.cti-area input[name=riaMemberYn]').attr("readonly",true);	//회원여부

            $('.cti-area button').attr('login-at',"N");	//회원여부
          	//결제화면이 아니면
            if("N" == requestPayAt){
        		$('.cti-area button').html('인증요청');
            }
        }

        //드림센터의 경우
		if(parent.sellChnlCd == "TELLER"){
			$('.cti-area').show();	//cti 로그인창 표시
		}
		else {
			$('.cti-area').hide();	//cti 로그인창 표시
		}


		//회원정보 확인을 위한 초기 파라메타 셋팅

		//파라메타 셋팅후
		//회원여부확인				부모창
		//나머지 화면 disable 처리	부모창

	}
    else {
        $('.quick-reserve-ad-area').show();	//광고영역 표시
//         $('#btnLangChg').show();	//언어전환 버튼표시 사용안함 20200106 김민영
    }

    /* RIA 재인증 버튼 클릭 */
    $('.cti-area button').on("click", function(){

		//입력값 검증
		if($('.cti-area button').attr('login-at') == "N"){

// 			if($(".cti-area input[name=riaName]").val().length == 0){
// 				gfn_alertMsgBoxSize('이름은  필수 입력 항목 입니다.',400,250);	//{0} 필수 입력 항목 입니다.
// 				return;
// 			}

			if(!fn_validateDateYn($(".cti-area input[name=riaBirthday]").val())){
				gfn_alertMsgBoxSize('생년월일을 정확히 입력해주세요.',400,250);	//생년월일을 정확히 입력해주세요.
				return;
			}

			if($(".cti-area input[name=riaMobileNo]").val().length < 10){
				gfn_alertMsgBoxSize('휴대폰번호를 정확히 입력해주세요.',400,250);	//휴대폰번호를 정확히 입력해주세요.
				return;
			}

			if($(".cti-area input[name=riaMobileNo]").val().substr(0,2) != "01"){
				gfn_alertMsgBoxSize('휴대폰번호를 정확히 입력해주세요.',400,250);	//휴대폰번호를 정확히 입력해주세요.
				return;
			}
		}
		parent.fn_setRiaLoginToggle( [$('.cti-area button').attr('login-at')
    								 ,$(".cti-area input[name=riaName]").val()
    								 ,$(".cti-area input[name=riaBirthday]").val()
    								 ,$(".cti-area input[name=riaMobileNo]").val()]
    								);
    });


    /* 이름 숫자를 제외한 입력 여부판단 */
	$(".cti-area input[name=riaName]").on("keyup", function(e){
		var partton = /[^ㄱ-힣a-zA-Z]/g;
		if(partton.test($(this).val())) {
			var value = $(this).val().replace(/[^ㄱ-힣a-zA-Z]/g,"");
			$(this).val(value);
		}
 	});
	$(".cti-area input[name=riaName]").focusout(function(){
		var partton = /[^ㄱ-힣a-zA-Z]/g;
		if(partton.test($(this).val())) {
			var value = $(this).val().replace(/[^ㄱ-힣a-zA-Z]/g,"");
			$(this).val(value);
		}
	});

    /* 생년월일 숫자만 입력 여부판단 */
	$(".cti-area input[name=riaBirthday]").on("keyup", function(e){
		$(this).val($(this).val().replace(/[^0-9]/g,""));
	});
	$(".cti-area input[name=riaBirthday]").focusout(function(){
		$(this).val($(this).val().replace(/[^0-9]/g,""));
	});

    /* 휴대폰번호 숫자만 입력 여부판단 */
	$(".cti-area input[name=riaMobileNo]").on("keyup", function(e){
		$(this).val($(this).val().replace(/[^0-9]/g,""));
    });
	$(".cti-area input[name=riaMobileNo]").focusout(function(){
		$(this).val($(this).val().replace(/[^0-9]/g,""));
	});
});


/*날짜 형태 확인*/
function fn_validateDateYn(param) {
	try
	{
		var yearFront = "";
		var year = "";
		var month = "";
		var day = "";

		param = param.replace(/-/g,'');

		// 자리수가 맞지않을때
		if( isNaN(param) || param.length < 6 || param.length == 7) {
			return false;
		}

		if(param.length == 6){
			year = Number(param.substring(0, 2));
			month = Number(param.substring(2, 4));
			day = Number(param.substring(4, 6));
		}
		else if (param.length == 8){
			var date = new Date();
			yearFront = Number(param.substring(0, 4));
			year = Number(param.substring(2, 4));
			month = Number(param.substring(4, 6));
			day = Number(param.substring(6, 8));

			if(yearFront > date.getFullYear()){
				return false;
			}
		}
		var dd = day / 0;

		if( month<1 || month>12 ) {
			return false;
		}

		var maxDaysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
		var maxDay = maxDaysInMonth[month-1];

		// 윤년 체크
		if( month==2 && ( year%4==0 && year%100!=0 || year%400==0 ) ) {
			maxDay = 29;
		}

		if( day<=0 || day>maxDay ) {
			return false;
		}
		return true;

	} catch (err) {
		return false;
	}
}

</script>
<!-- cti 일때만 출력 -->
<div class="cti-area" style="display:none">
    <p>이름</p>
    <input maxlength="20" name="riaName" type="text" title="이름 출력" class="input-text a-c w120px" placeholder="이름" value="" />

    <p>생년월일</p>
    <input maxlength="8" name="riaBirthday" type="text" title="생년월일 출력" class="input-text a-c w150px" placeholder="6자리 또는 8자리" value="" />

    <p>휴대폰번호</p>
    <input maxlength="11" name="riaMobileNo" type="text" title="휴대폰번호 출력" class="input-text a-c w150px" placeholder="- 없이 입력" value="" />

    <p>회원</p>
    <input name="riaMemberYn" type="text" title="회원여부 출력" class="input-text a-c w100px" value="" readyonly="readyonly" />

	
		<button type="button" class="button gray ml10" login-at="N"></button>
	
</div>

                <!-- mege-quick-reserve-inculde : 다른 페이지에서 iframe 으로 설정될 영역 -->
                <div class="mege-quick-reserve-inculde">

                    <!-- time-schedule -->
                    <div class="time-schedule quick">
                        <div class="wrap">

                            <!-- 이전날짜 -->
                            <button type="button" title="이전 날짜 보기" class="btn-pre">
                                <i class="iconset ico-cld-pre"></i> <em>이전</em>
                            </button>
                            <!--// 이전날짜 -->

                            <div class="date-list">
                                <!-- 년도, 월 표시 -->
                                <div class="year-area">
                                    <div class="year" style="left:30px;"></div>
                                    <div class="year" style="left:450px;"></div>
                                </div>


                                <div class="date-area" id="formDeList">
                                    <!--
                                        날짜클릭시 class : on

                                        토요일 class : sat
                                        공휴일 class : holi

                                        클릭불가능 class : imposs
                                    -->

<!--                                     <button type="button" class="on sat" disabled="disabled"><span class="ir">2018년 12월</span><em>25<span class="ir">일</span></em> <span>오늘</span></button> -->
<!--                                     <button type="button" class="holi"><span class="ir">2018년 12월</span><em>25<span class="ir">일</span></em> <span>내일</span></button> -->
<!--                                     <button type="button" class=""><span class="ir">2018년 12월</span><em>26<span class="ir">일</span></em> <span>월</span></button> -->
<!--                                     <button type="button" class=""><span class="ir">2018년 12월</span><em>27<span class="ir">일</span></em> <span>화</span></button> -->
<!--                                     <button type="button" class=""><span class="ir">2018년 12월</span><em>28<span class="ir">일</span></em> <span>수</span></button> -->
<!--                                     <button type="button" class=""><span class="ir">2018년 12월</span><em>29<span class="ir">일</span></em> <span>목</span></button> -->
<!--                                     <button type="button" class=""><span class="ir">2018년 12월</span><em>30<span class="ir">일</span></em>    <span>금</span></button> -->
<!--                                     <button type="button" class="sat"><span class="ir">2018년 12월</span><em>31<span class="ir">일</span></em>    <span>토</span></button> -->
<!--                                     <button type="button" class="holi"><span class="ir">2019년 1월</span><em>1<span class="ir">일</span></em>    <span>일</span></button> -->
<!--                                     <button type="button" class=""><span class="ir">2019년 1월</span><em>2<span class="ir">일</span></em>    <span>월</span></button> -->
<!--                                     <button type="button" class=""><span class="ir">2019년 1월</span><em>3<span class="ir">일</span></em>    <span>화</span></button> -->
<!--                                     <button type="button" class=""><span class="ir">2019년 1월</span><em>4<span class="ir">일</span></em>    <span>수</span></button> -->
<!--                                     <button type="button" class=""><span class="ir">2019년 1월</span><em>5<span class="ir">일</span></em>    <span>목</span></button> -->
<!--                                     <button type="button" class=""><span class="ir">2019년 1월</span><em>6<span class="ir">일</span></em>    <span>금</span></button> -->
<!--                                     <button type="button" class=""><span class="ir">2019년 1월</span><em>7<span class="ir">일</span></em>    <span>금</span></button> -->
<!--                                     <button type="button" class="sat"><span class="ir">2019년 1월</span><em>8<span class="ir">일</span></em>    <span>토</span></button> -->
<!--                                     <button type="button" class="holi"><span class="ir">2019년 1월</span><em>9<span class="ir">일</span></em>    <span>일</span></button> -->
<!--                                     <button type="button" class=""><span class="ir">2019년 1월</span><em>10<span class="ir">일</span></em>    <span>월</span></button> -->
<!--                                     <button type="button" class=""><span class="ir">2019년 1월</span><em>11<span class="ir">일</span></em>    <span>화</span></button> -->
<!--                                     <button type="button" class=""><span class="ir">2019년 1월</span><em>12<span class="ir">일</span></em>    <span>수</span></button> -->
<!--                                     <button type="button" class=""><span class="ir">2019년 1월</span><em>13<span class="ir">일</span></em>    <span>목</span></button> -->
<!--                                     <button type="button" class=""><span class="ir">2019년 1월</span><em>14<span class="ir">일</span></em>    <span>금</span></button> -->
                                </div>
                            </div>

                            <!-- 다음날짜 -->
                            <button type="button"  title="다음 날짜 보기" class="btn-next">
                                <i class="iconset ico-cld-next"></i> <em>다음</em>
                            </button>
                            <!--// 다음날짜 -->

                            <!-- 달력보기 -->
                            <div class="bg-line">
                                <input type="hidden" id="datePicker">
                                <button type="button" id="calendar" onClick="$('#datePicker').datepicker('show')" class="btn-calendar-large" title="달력보기"> 달력보기</button>

                            </div>
                            <!--// 달력보기 -->
                        </div>
                    </div>
                    <!--// time-schedule -->

                    <!-- quick-reserve-area -->
                    <div class="quick-reserve-area">

                        <!-- movie-choice : 영화 선택  -->
                        <div class="movie-choice">
                            <p class="tit">영화</p>

                            <!-- list-area -->
                            <div class="list-area">

                                <!-- all : 전체 -->
                                <div class="all-list">
                                    <button type="button" class="btn-tab on" id="movieAll">전체</button>
                                    <div class="list">
                                        <div class="scroll m-scroll" id="movieList">
                                        </div>
                                    </div>
                                </div>
                                <!--// all : 전체 -->

                                <!-- other-list  : 큐레이션 -->
                                <div class="other-list">
                                    <button type="button" class="btn-tab" id="movieCrtn">큐레이션</button>
                                    <div class="list">
                                        <div class="scroll m-scroll" id="crtnMovieList">
                                        </div>
                                    </div>
                                </div>
                                <!--// other-list  : 큐레이션 -->
                            </div>
                            <!--// list-area -->

                            <!-- view-area -->
                            <div class="view-area">

                                <!-- 영화 선택 하지 않았을 때 -->
                                <div class="choice-all" id="choiceMovieNone">
                                    <strong>모든영화</strong>
                                    <span>목록에서 영화를 선택하세요.</span>
                                </div>

                                <!-- 영화를 한개라도 선택했을 때 -->
                                <div class="choice-list" id="choiceMovieList">
                                    <!-- 비어있는 영역 -->
                                    <div class="bg">
                                    </div>
                                    <div class="bg">
                                    </div>
                                    <div class="bg">
                                    </div>
                                </div>
                            </div>
                            <!--// view-area -->
                        </div>
                        <!--// movie-choice : 영화 선택  -->

                        <!-- theater-choice : 극장 선택  -->
                        <div class="theater-choice">
                            <div class="tit-area">
                                <p class="tit">극장</p>
                            </div>

                            <!-- list-area -->
                            <div class="list-area" id="brchTab">

                                <!-- all-list : 전체 -->
                                <div class="all-list">
                                    <button type="button" class="btn-tab on">전체</button>
                                    <div class="list">
                                        <div class="scroll" id="brchList">
                                            <ul></ul>
                                        </div>
                                    </div>
                                </div>
                                <!--// all-list : 전체 -->

                                <!-- other-list : 특별관 -->
                                <div class="other-list">
                                    <button type="button" class="btn-tab">특별관</button>
                                    <!-- list -->
                                    <div class="list" id="specialBrchTab">
                                        <div class="scroll" id="specialBrchList">
                                            <ul></ul>
                                        </div>
                                    </div>
                                    <!--// list -->
                                </div>
                                <!--// other-list : 특별관 -->
                            </div>
                            <!--// list-area -->

                            <!-- view-area -->
                            <div class="view-area">

                                <!-- 영화관 선택 하지 않았을 때 -->
                                <div class="choice-all" id="choiceBrchNone">
                                    <strong>전체극장</strong>
                                    <span>목록에서 극장을 선택하세요.</span>
                                </div>

                                <!-- 영화관을 한개라도 선택 했을때 -->
                                <div class="choice-list" id="choiceBrchList">
                                    <div class="bg">
                                    </div>
                                    <div class="bg">
                                    </div>
                                    <div class="bg">
                                    </div>
                                </div>
                            </div>
                            <!--// view-area -->


                        </div>
                        <!--// theater-choice : 영화관 선택  -->

                        <!-- time-choice : 상영시간표 선택 -->
                        <div class="time-choice">
                            <div class="tit-area">
                                <p class="tit">시간</p>

                                <div class="right legend">
                                    <i class="iconset ico-sun" title="조조"></i> 조조
                                    <i class="iconset ico-brunch" title="브런치"></i> 브런치
                                    <i class="iconset ico-moon" title="심야"></i> 심야
                                </div>
                            </div>

                            <!-- hour-schedule : 시간 선택  : 00~30 시-->
                            <div class="hour-schedule">
                                <button type="button" class="btn-prev-time">이전 시간 보기</button>

                                <div class="wrap">
                                    <div class="view">
                                        <button type="button" class="hour">00</button>
                                        <button type="button" class="hour">01</button>
                                        <button type="button" class="hour">02</button>
                                        <button type="button" class="hour">03</button>
                                        <button type="button" class="hour">04</button>
                                        <button type="button" class="hour">05</button>
                                        <button type="button" class="hour">06</button>
                                        <button type="button" class="hour">07</button>
                                        <button type="button" class="hour">08</button>
                                        <button type="button" class="hour">09</button>
                                        <button type="button" class="hour">10</button>
                                        <button type="button" class="hour">11</button>
                                        <button type="button" class="hour">12</button>
                                        <button type="button" class="hour">13</button>
                                        <button type="button" class="hour">14</button>
                                        <button type="button" class="hour">15</button>
                                        <button type="button" class="hour">16</button>
                                        <button type="button" class="hour">17</button>
                                        <button type="button" class="hour">18</button>
                                        <button type="button" class="hour">19</button>
                                        <button type="button" class="hour">20</button>
                                        <button type="button" class="hour">21</button>
                                        <button type="button" class="hour">22</button>
                                        <button type="button" class="hour">23</button>
                                        <button type="button" class="hour">24</button>
                                        <button type="button" class="hour">25</button>
                                        <button type="button" class="hour">26</button>
                                        <button type="button" class="hour">27</button>
                                        <button type="button" class="hour">28</button>
                                        
                                    </div>
                                </div>

                                <button type="button" class="btn-next-time">다음 시간 보기</button>
                            </div>
                            <!--// hour-schedule : 시간 선택  : 00~30 시-->

                            <!-- movie-schedule-area : 시간표 출력 영역-->
                            <div class="movie-schedule-area">

                                <!-- 영화, 영화관 선택 안했을때 -->
                                <!---->
                                <div class="no-result" id="playScheduleNonList">
                                    <i class="iconset ico-movie-time"></i>

                                    <p class="txt">
                                        영화와 극장을 선택하시면<br />
                                        상영시간표를 비교하여 볼 수 있습니다.
                                    </p>
                                </div>


                                <!-- 영화, 영화관 선택 했을때 -->
                                <div class="result">
                                    <div class="scroll m-scroll" id="playScheduleList" style="display: none;">
                                    </div>

                                </div>
                            </div>
                            <!--// movie-schedule-area : 시간표 출력 영역-->

                        </div>
                        <!--// time-choice : 상영시간표 선택 -->
                    </div>
                    <!--// quick-reserve-area -->
                </div>
                <!--// mege-quick-reserve-inculde : 다른 페이지에서 iframe 으로 설정될 영역 -->

            </div>
            <!--// quick-reserve -->

				<!--// RIA의 경우에만 표시하도록 -->
	            <div class="quick-reserve-ad-area" style="display:none">
	                <script data-id="Sk8ODqWvTfiYIQGxHdGNHw" name="megabox_p/sub/sub@sub_bottom_booking_1100x80?mlink=347" src="//cast.imp.joins.com/persona.js" async></script>
	            </div>
			
        </div>
        <!--// inner-wrap -->

