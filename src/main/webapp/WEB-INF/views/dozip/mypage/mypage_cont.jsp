<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<jsp:include page="./mypage_header.jsp" />
<%-- 상단 공통부분 끝 --%>
<style>
    #my_contract_list { width: 99%; margin: 20px auto; }
    .my_contract_wrap { width:100%; display: flex; justify-content:space-between; flex-direction: column; align-items: center; }
    .my_contract_cont { width: 90%; }
    .my_contract_table th { background-color: #f7f7f7; font-size: 0.9rem; height: 30px; border-bottom: 1px solid #B3B9BE; border-top: 2px solid #2b2a29; }
    .my_contract_table { width: 100%; text-align: center; border-collapse: collapse; }
    .my_contract_table td { border-bottom: 1px solid #B3B9BE; padding: 10px 0; font-size: 0.8rem; }
    .contract_info { width: 100%; text-align: left; margin-left: 30px; }
    .contract_info>ul>li { list-style: none; padding-left: 10px; }
    .page_area{ text-align:center; margin-top: 10px; margin-bottom: 100px; }
</style>

<%-- 견적신청내역 --%>
<div class="mypage_body" id="my_contract_list">
    <div class="my_contract_wrap">
        <div class="contract_info">
            <p style="font-size: 1.7rem; font-weight: bold; margin: 0;">내 계약내역 확인</p>
            <ul style="padding:0px;">
                <li style="font-size: 0.8rem; margin-bottom: 7px;"><img src="/images/dozip/blt_check_red.jpg"/>&nbsp;고객님의 계약진행 내역을 확인할 수 있습니다.</li>
                <li style="font-size: 0.8rem; margin-bottom: 7px;"><img src="/images/dozip/blt_check_red.jpg"/>&nbsp;<b style="color: #347844; font-size: 0.9rem; background-color: beige">'계약서 작성하기 → 계약번호를 눌러서 상세내용 확인 → 결제진행'</b> 순서로 진행해주세요.</li>
                <li style="font-size: 0.8rem; margin-bottom: 7px;"><img src="/images/dozip/blt_check_red.jpg"/>&nbsp;계약번호를 클릭하면 자세한 내용을 확인 할 수 있습니다.</li>
                <li style="font-size: 0.8rem;"><img src="/images/dozip/blt_check_red.jpg"/>&nbsp;기한에 맞춰 결제를 진행해주십시오.</li>
            </ul>
        </div>
        <hr style="width: 100%; border:0px; border-top: #7f8c8d double;"/>
        <p style="width: 90%; font-weight: bold;">${p.count}건의 계약내역이 있습니다.</p>
        <div class="my_contract_cont">
            <table class="my_contract_table">
                <tr>
                    <th>계약번호</th> <th>업체명</th> <th>공사내용</th> <th>공사시작일</th> <th>공사종료일</th>
                    <th>총금액</th> <th>진행상태</th> <th>계약서</th>
                </tr>
                <c:if test="${fn:length(clist) == 0}">
                    <tr><td colspan="8"> 등록된 글이 없습니다.</td> </tr>
                </c:if>
                <c:if test="${fn:length(clist) != 0}">
                    <c:forEach var="c" items="${clist}">
                        <tr>
                            <c:if test="${c.customer_number == ' '}">
                                <td id="num"><a href="#" onclick="pop();">${c.cont_no}</a></td><%--계약번호--%>
                            </c:if>
                            <c:if test="${c.customer_number != ' '}">
                                <td id="num"><a href="/dozip/my_contD?cont_no=${c.cont_no}">${c.cont_no}</a></td><%--계약번호--%>
                            </c:if>
                            <td>${c.businessName}</td><%--업체명--%>
                            <td style="word-wrap: break-word; max-width : 300px;">${c.cont_title.substring(0, c.cont_title.length() - 2)})</td><%--공사내용--%>
                            <td>${c.cont_start.substring(0,10)}</td><%--시작일--%>
                            <td>${c.cont_end.substring(0,10)}</td><%--종료일--%>
                            <td>${c.cont_total} 만원</td><%--총금액--%>
                            <td>
                                <c:if test="${c.customer_number == ' '}"><span style="color: red; font-weight: bold">계약요청</span></c:if>
                                <c:if test="${c.customer_number != ' '&&c.pay_state!='잔금결제완료'}">계약완료</c:if>
                                <c:if test="${c.customer_number != ' '&&c.pay_state=='잔금결제완료'}"><span style="color: blue; font-weight: bold">공사완료</span></c:if>
                            </td><%--진행상태--%>
                            <td>
                                <c:if test="${c.customer_number == ' '}">
                                    <button type="button" style="background-color: #FF0033; border:none; color: white;" onclick="cont_view('${c.cont_no}')">작성하기</button>
                                </c:if>
                                <c:if test="${c.customer_number != ' '}">
                                    <button type="button" style="background-color: #3333FF; border:none; color: white;" onclick="cont_view('${c.cont_no}')">확인하기</button>
                                </c:if>
                            </td><%--계약서--%>
                        </tr>
                    </c:forEach>
                </c:if>
            </table>

            <!-- 쪽번호 출력 -->
            <div class="page_area">
                <c:if test="${p.page<=1}"><img src="/images/dozip/left-arrow.png"></c:if>
                <c:if test="${p.page>1}"><a href="/dozip/my_cont?page=${p.page-1}"><img src="/images/dozip/left-arrow.png"></a></c:if>

                <c:forEach var="page" begin="${p.startpage}" end="${p.endpage}" step="1">
                    <c:if test="${page==p.page}"><span style="color: #347844; font-weight: bold;">${page}</span></c:if>
                    <c:if test="${page!=p.page}"><a href="/dozip/my_cont?page=${page}">${page}</a></c:if>
                </c:forEach>

                <c:if test="${p.page>=p.maxpage}"><img src="/images/dozip/right-arrow.png"></c:if>
                <c:if test="${p.page<p.maxpage}"><a href="/dozip/my_cont?page=${p.page+1}"><img src="/images/dozip/right-arrow.png"></a></c:if>
            </div>
        </div>
    </div>
</div>

<script>
    function cont_view(cont_no){
        window.open('/dozip/my_cont_view?cont_no='+cont_no,"_blank",'width=745, height=955, top=0, left=100, resizable=no')
    }
    function pop(){
        alert("계약을 먼저 완료하고 이용해주세요.");
    }

    $( ".my_contract_table tr" ).on( "mouseover", function() {
        $( this ).css( "background-color", "#EEF1FF" );/*FFF8E6/ECF7FF/EEF1FF*/
    });
    $( ".my_contract_table tr" ).on( "mouseleave", function() {
        $( this ).css( "background-color", "white" );
    });
</script>
<%-- 하단 공통부분 --%>
<jsp:include page="./mypage_footer.jsp" />