<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<jsp:include page="./mypage_header.jsp" />
<%-- 상단 공통부분 끝 --%>
<style>
    #my_estimate_list { width: 99%; margin: 20px auto; }
    .my_estimate_wrap { width:100%; display: flex; justify-content:space-between; flex-direction: column; align-items: center; }
    .my_apply_cont { width: 90%; }
    .my_apply_table th { background-color: #f7f7f7; font-size: 0.9rem; height: 30px; border-bottom: 1px solid #B3B9BE; border-top: 2px solid #2b2a29; }
    .my_apply_table { width: 100%; text-align: center; border-collapse: collapse; }
    .my_apply_table td { border-bottom: 1px solid #B3B9BE; padding: 10px 0; font-size: 0.8rem; }
    .estimate_info { width: 100%; text-align: left; margin-left: 30px; }
    .estimate_info>ul>li { list-style: none; padding-left: 10px; }
    .page_area{ text-align:center; margin-top: 10px; }
    #my_est_text { text-align: center; font-weight: bold; margin: 50px auto; }
    #my_est_text  a { text-decoration: underline; color: #347844; }
    #permit_btn{ border: none; background-color: #3333FF; color: white; height: 25px; margin-right: 5px; }
    #reject_btn{ border: none; background-color: #FF0033; color: white; height: 25px; }
    #detail{ overflow: hidden; white-space: nowrap; text-overflow: ellipsis; word-break: break-all; max-width : 300px; min-width : 100px; }
</style>

<%-- 견적신청내역 --%>
<div class="mypage_body" id="my_estimate_list">
    <div class="my_estimate_wrap">
        <div class="estimate_info">
            <p style="font-size: 1.7rem; font-weight: bold; margin: 0;">견적신청 내역 확인(입찰)</p>
            <ul style="padding:0px;">
                <li style="font-size: 0.8rem; margin-bottom: 7px;"><img src="/images/dozip/blt_check_red.jpg"/>&nbsp;고객님이 업체를 지정하지 않고 신청한 견적 내역을 확인합니다.</li>
                <li style="font-size: 0.8rem; margin-bottom: 7px;"><img src="/images/dozip/blt_check_red.jpg"/>&nbsp;입찰현황에서 신청번호를 선택하면 참여한 업체를 확인할 수 있습니다.</li>
                <li style="font-size: 0.8rem; margin-bottom: 7px;"><img src="/images/dozip/blt_check_red.jpg"/>&nbsp;상태는 <b style="font-size: 1.0rem; color: #9B51E0"">[대기중->계약요청->작성완료->계약완료->공사완료]</b> 순으로 진행됩니다.</li>
                <li style="font-size: 0.8rem;"><img src="/images/dozip/blt_check_red.jpg"/>&nbsp;마감일자가 되기 전에 공사를 진행할 업체를 선택해주세요.</li>
            </ul>
        </div>
        <hr style="width: 100%; border:0px; border-top: #7f8c8d double;"/>
        <p style="width: 90%; font-weight: bold;">${p.count}건의 신청내역이 있습니다.</p>
        <div class="my_apply_cont">
            <table class="my_apply_table">
                <tr>
                    <th>견적서번호</th> <th>공간유형</th> <th>공간선택</th> <th>평수</th> <th>내예산</th>
                    <th>진행상황</th> <th>신청일자</th> <th>마감일자</th>
                </tr>
                <c:if test="${fn:length(elist) == 0}">
                    <tr><td colspan="8"> 등록된 글이 없습니다.</td> </tr>
                </c:if>
                <c:if test="${fn:length(elist) != 0}">
                    <c:forEach var="e" items="${elist}">
                        <tr>
                            <td><a href="#" onclick="est_view('${e.est_num}')">${e.est_num}</a></td><%--번호--%>
                            <td>${e.est_zoning}</td><%--공간유형--%>
                            <td style="word-wrap: break-word; max-width : 200px;">${e.est_detail.substring(0, e.est_detail.length() - 1)}</td><%--공간선택--%>
                            <td>${e.est_areaP} 평</td><%--평수--%>
                            <td>${e.est_bud} 만원</td><%--예산--%>
                            <td style="
                                <c:if test="${e.est_check=='공사완료'}">color:blue</c:if>"
                            >${e.est_check}</td><%--진행상황(수락/거절)--%>
                            <td>${e.est_date.substring(0,10)}</td><%--신청일자--%>
                            <td>${e.est_dateEnd.substring(0,10)}</td><%--마감일자--%>
                        </tr>
                    </c:forEach>
                </c:if>
            </table>

            <!-- 쪽번호 출력 -->
            <div class="page_area">
                <c:if test="${p.page<=1}"><img src="/images/dozip/left-arrow.png"></c:if>
                <c:if test="${p.page>1}"><a href="/dozip/my_est2?page=${p.page-1}"><img src="/images/dozip/left-arrow.png"></a></c:if>

                <c:forEach var="page" begin="${p.startpage}" end="${p.endpage}" step="1">
                    <c:if test="${page==p.page}"><span style="color: #347844; font-weight: bold;">${page}</span></c:if>
                    <c:if test="${page!=p.page}"><a href="/dozip/my_est2?page=${page}">${page}</a></c:if>
                </c:forEach>

                <c:if test="${p.page>=p.maxpage}"><img src="/images/dozip/right-arrow.png"></c:if>
                <c:if test="${p.page<p.maxpage}"><a href="/dozip/my_est2?page=${p.page+1}"><img src="/images/dozip/right-arrow.png"></a></c:if>
            </div>
        </div>

        <div style="margin-top: 40px; width: 90%; margin-bottom: 10px;">
            <span style="font-weight: bold; margin-right: 10px;">입찰참여 업체 리스트 확인</span>
            <select id="selectNum">
                <c:if test="${estNum.size()==0}"><option value="0">견적서 번호를 선택해주세요.</option></c:if>
                <c:if test="${estNum.size()!=0}">
                    <option value="0">견적서 번호를 선택해주세요.</option>
                    <c:forEach var="n" items="${estNum}">
                        <option value="${n}">${n}</option>
                    </c:forEach>
                </c:if>
            </select>
            <span style="font-weight: bold; float:right; "><span id="count">0</span>건의 입찰내역이 있습니다.</span>
        </div>
        <div class="my_apply_cont">
            <table class="my_apply_table"id="print">
                <tr>
                    <th>업체명</th> <th>공사시작일</th> <th>공사종료일</th> <th>공사금액</th>
                    <th>설명</th> <th>신청일자</th> <th>상태</th> <th>선택</th>
                </tr>
            </table>

        </div>
    </div>
    <p id="my_est_text">견적신청을 통해 견적을 받아보세요!&nbsp;&nbsp;<a href="/dozip/apply">견적신청 하러가기</a></p>
</div>

<script>

    $('#selectNum').change(function(){
        var est_num = $('#selectNum').val();
        //alert("선택값"+est_num);

        $.getJSON("/dozip/my_est2/"+est_num, function(data){//json데이터를 get방식으로 처리,비동기식으로 가져온 데이터는 data매개변수에 저장
            var count = data.length;
            var result="<tr><th>업체명</th> <th>공사시작일</th> <th>공사종료일</th> <th>공사금액</th> <th>설명</th> <th>신청일자</th> <th>상태</th> <th>선택</th></tr>"

            $(data).each(function () {//each()함수로 반복
                result += "<tr><td>" + this.businessName + "</td>"
                    + "<td>" + this.bid_start.substring(0,10) + "</td>"
                    + "<td>" + this.bid_end.substring(0,10) + "</td>"
                    + "<td>" + this.bid_price + "만원</td>"
                    + "<td id='detail'>" + this.bid_detail + "</td>"
                    + "<td>" + this.bid_date.substring(0,10) + "</td>"
                    + "<td>" + this.bid_state + "</td>"
                    if(this.bid_state=='진행중') {
                        result += "<td><button type='button' id='permit_btn' class='permit' name='permit' value='" + this.bid_num + "'>수락</button>"
                        + "<button type='button' id='reject_btn' name='reject' value='" + this.bid_num + "'>거절</button></td></tr>"
                    }else{
                        result += "<td> - </td>"
                    }
            });

            $('#count').html(count);
            $('#print').html(result);//해당영역에 html()함수로 문자와 태그를 함께 변경 적용.
        });
    });

    $(document).on("click", "button[name='permit']", function (){
        let bid_num = $(this).val();
        //alert("bid_num" + bid_num);

        let result = confirm("선택하신 업체와 계약하시겠습니까?");

        if(result) {
            let formData = new FormData();
            formData.append("bid_num", bid_num);

            $.ajax({
                type: 'post',
                url: '/dozip/my_est2_select',//URL 매핑주소
                enctype: 'multipart/form-data',
                processData: false,
                contentType: false,
                cache: false,
                data: formData,
                success: function () {
                    location.replace("/dozip/my_est2");
                },
                error: function () {
                    alert('실패');
                }
            });
        }
    });

    // document.getElementById('reject_btn').onclick = function (){
    $(document).on("click", "button[name='reject']", function (){
        let bid_num = $('#reject_btn').val();

        let res = confirm("해당 업체와의 계약을 거절 하시겠습니까?");

        if(res) {
            $.ajax({
                url: '/dozip/my_bid_reject',
                type: 'post',
                data: {
                    bid_num: bid_num
                },
                success: function (data) {
                    location.reload();
                },
                error: function (error) {
                    alert(error);
                }
            })
        }
    })

    $( ".my_apply_table tr " ).on( "mouseover", function() {
        $( this ).css( "background-color", "#EEF1FF" );/*FFF8E6/ECF7FF/EEF1FF*/
    });
    $( ".my_apply_table tr " ).on( "mouseleave", function() {
        $( this ).css( "background-color", "white" );
    });
    function est_view(est_num){
        window.open('/dozip/my_est_view?est_num='+est_num,"_blank",'width=745, height=955, top=0, left=100, resizable=no')
    }
</script>
<%-- 하단 공통부분 --%>
<jsp:include page="./mypage_footer.jsp" />