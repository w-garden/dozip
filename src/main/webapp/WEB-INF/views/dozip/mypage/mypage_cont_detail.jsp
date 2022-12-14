<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<jsp:include page="./mypage_header.jsp" />
<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
<%-- 상단 공통부분 끝 --%>
<link rel = "stylesheet" type = "text/css" href = "/css/dozip/cont.css"/>

<style>
    #my_contract_list { width: 99%; margin: 20px auto; }
    .my_contract_wrap { width:100%; display: flex; justify-content:space-between; flex-direction: column; align-items: center; }
    .contract_info { width: 100%; text-align: left; margin-left: 30px; }
    .contract_info>ul>li { list-style: none; padding-left: 10px; }

</style>

<%-- 견적신청내역 --%>
<div class="mypage_body" id="my_contract_list">
    <div class="my_contract_wrap">
        <div class="contract_info">
            <p style="font-size: 1.7rem; font-weight: bold; margin: 0;">계약번호 : ${c.cont_no} </p>
            <ul style="padding:0px;">
                <li style="font-size: 0.8rem; margin-bottom: 7px;"><img src="/images/dozip/blt_check_red.jpg"/>&nbsp;고객님의 공사진행 내역을 확인할 수 있습니다.</li>
            </ul>
        </div>
        <hr style="width: 100%; border:0px; border-top: #7f8c8d double;"/>

        <%-- 상세내용 불러옴 --%>
        <div class="follow_title_wrap">
            <p id="follow_title">현재진행상태</p>
            <%--<div class="progress_bar"><div class="progress"></div></div><p id="progress_percent">45%</p>--%>
        </div>
        <div class="my_contract_info2">
            <table>
                <tr>
                    <th>대기중</th><th rowspan="2" class="next_arrow">>></th>
                    <th>계약완료</th><th rowspan="2" class="next_arrow">>></th>
                    <th>공사중</th><th rowspan="2" class="next_arrow">>></th><th>공사완료</th>
                </tr>
                <tr>
                    <td>0</td>
                    <td><c:if test="${p.pay_state=='계약금요청'||p.pay_state=='계약금결제완료'||p.pay_state=='중도금요청'}"><span style="color: blue">1</span></c:if><c:if test="${p.pay_state!='계약금결제완료'&&p.pay_state!='중도금요청'&&p.pay_state!='계약금요청'}">0</c:if></td>
                    <td><c:if test="${p.pay_state=='중도금결제완료'||p.pay_state=='잔금요청'}"><span style="color: blue">1</span></c:if><c:if test="${p.pay_state!='중도금결제완료'&&p.pay_state!='잔금요청'}">0</c:if></td>
                    <td><c:if test="${p.pay_state=='잔금결제완료'}"><span style="color: blue">1</span></c:if><c:if test="${p.pay_state!='잔금결제완료'}">0</c:if></td>
                </tr>
            </table>
        </div>

        <div class="ppp">
            <div class="my_contract_cont2">
                <p>요약내용</p>
                <div class="contract_summary">
                    <table id="contract_summary_table">
                        <tr>
                            <th class="cst_th" style="min-width: 100px;">업체명</th> <th class="cst_th">:&nbsp;</th> <td class="cst_td">${c.businessName}</td>
                        </tr>
                        <tr>
                            <th class="cst_th">공사일정</th> <th class="cst_th">:&nbsp;</th> <td class="cst_td">${c.cont_start.substring(0,10)} - ${c.cont_end.substring(0,10)}</td>
                        </tr>
                        <tr>
                            <th class="cst_th">공사금액</th> <th class="cst_th">:&nbsp;</th> <td class="cst_td" id="totalPay">${c.cont_total}</td>
                        </tr>
                        <tr>
                            <th class="cst_th">공간유형</th> <th class="cst_th">:&nbsp;</th> <td class="cst_td">${c.cont_title.substring(0, c.cont_title.length() - 2)})</td>
                        </tr>
                        <tr>
                            <th class="cst_th">평수</th> <th class="cst_th">:&nbsp;</th> <td class="cst_td">${c.cont_area}평(${e.est_areaM}m<sup>2</sup>)</td>
                        </tr>
                    </table>
                    <div class="contract_view_wrap">
                        <button id="apply_view" onclick="est_view('${c.est_num}')">신청서 확인하기</button>
                        <button id="contract_view" onclick="cont_view('${c.cont_no}')">계약서 확인하기</button>
                    </div>
                </div>
            </div>
            <div class="contract_pay">
                <p style="margin-left: 10px;">결제내역</p>
                <div class="contarct_pay_wrap">
                    <table class="contarct_pay_table">
                        <tr style="height: 40px;">
                            <th colspan="3" class="cpt_th1">&nbsp;총 금액&nbsp;&nbsp;&nbsp;<span id="total_pay">${c.cont_total}</span></th> <th class="cpt_th1">요청일</th> <th class="cpt_th1">결제일</th>
                        </tr>
                        <tr>
                            <th class="cpt_th">계약금</th> <th class="cpt_th">:</th>
                            <td class="cpt_td" id="cost1">${c.cont_cost1}</td>
                            <td class="cpt_td">${c.cont_date1.substring(0,10)}</td>
                            <td class="cpt_td" id="pday1">${p.pay_date1.substring(0,10)}</td>
                        </tr>
                        <tr>
                            <th class="cpt_th">중도금</th> <th class="cpt_th">:</th>
                            <td class="cpt_td" id="cost2">${c.cont_cost2}</td>
                            <td class="cpt_td">${c.cont_date2.substring(0,10)}</td>
                            <td class="cpt_td" id="pday2">${p.pay_date2.substring(0,10)}</td>
                        </tr>
                        <tr>
                            <th class="cpt_th">잔금</th> <th class="cpt_th">:</th>
                            <td class="cpt_td" id="cost3">${c.cont_cost3}</td>
                            <td class="cpt_td">${c.cont_date3.substring(0,10)}</td>
                            <td class="cpt_td" id="pday3">${p.pay_date3.substring(0,10)}</td>
                        </tr>
                    </table>
                    <div class="pay_wrap">
                        <select name="pay_select" id="pay_select" style="width: 25%;">
                            <option value="0" selected>결제선택</option>
                            <c:if test="${p.pay_date1!=null}"><option value="done" disabled>계약금지불완료</option></c:if>
                            <c:if test="${p.pay_date1==null}"><option value="${c.cont_cost1}">계약금</option></c:if>
                            <c:if test="${p.pay_date2!=null}"><option value="done" disabled>중도금지불완료</option></c:if>
                            <c:if test="${p.pay_date2==null}"><option value="${c.cont_cost2}">중도금</option></c:if>
                            <c:if test="${p.pay_date3!=null}"><option value="done" disabled>잔금지불완료</option></c:if>
                            <c:if test="${p.pay_date3==null}"><option value="${c.cont_cost3}">잔금</option></c:if>
                        </select>
                        <span id="select_cost" style="margin-left: 10px; font-weight: bold; font-size: 1.3rem;"> - 원</span>
                        <button type="button" id="pay_btn" onclick="pay_view('${c.cont_no}')" disabled>결제하기</button>
                    </div>
                </div>
            </div>
        </div>
        <%-- 상세내용 불러옴 --%>
        <div id="cancel_box"><button type="button" id="cancel" onclick="cancel()">계약취소하기</button></div>

    </div>
</div>

<script>
    $('#pay_select').change(function(){
        let check = $('#pay_select option:selected').val();
        if(check==0){
            $("#pay_btn").prop("disabled", true);
        }else{
            $("#pay_btn").prop("disabled", false);
        }
    });

    function cont_view(cont_no){
        window.open('/dozip/my_cont_view?cont_no='+cont_no,"_blank",'width=745, height=955, top=0, left=100, resizable=no')
    }
    function est_view(est_num){
        window.open('/dozip/my_est_view?est_num='+est_num,"_blank",'width=745, height=955, top=0, left=100, resizable=no')
    }
    function pay_view(cont_no){
        let contNo = cont_no;
        let check = $('#pay_select option:selected').text();
        let pday1 = $('#pday1').text(); let pday2 = $('#pday2').text(); let pday3 = $('#pday3').text();
        if(check=="계약금" && pday1 == "" && pday2=="" && pday3==""){pop_view(contNo);}
        else if(check=="중도금" && pday2 == "" && pday1!="" && pday3==""){pop_view(contNo);}
        else if(check=="잔금" && pday3 == "" && pday1!="" && pday2!=""){pop_view(contNo);}
        else {
            swal("순서대로 결제를 진행해주십시오.");
        }
    }
    function pop_view(cont_no){
        let cost = $('#pay_select option:selected').val();
        let name = $('#pay_select option:selected').text();
        window.open('/dozip/pay_view?cont_no='+cont_no+'&name='+name+'&cost='+cost,"_blank",'width=500, height=500, top=0, left=100, resizable=no')
    }

    function change(str){
        let inMoney = $(str).text();
        let outMoney = (parseInt(inMoney)*10000).toString().replace(/\B(?<!\.\d*)(?=(\d{3})+(?!\d))/g, ",");
        return outMoney+" 원";
    }

    $(document).ready(function(){
        $('#cost1').text(change('#cost1'));
        $('#cost2').text(change('#cost2'));
        $('#cost3').text(change('#cost3'));
        $('#total_pay').text(change('#total_pay'));
        $('#totalPay').text(change('#totalPay'));
    })

    document.getElementById('pay_select').onchange = function (){
        let cost = $('#pay_select option:selected').val();
        let cost2 = ((cost)*10000).toString().replace(/\B(?<!\.\d*)(?=(\d{3})+(?!\d))/g, ",");
        $('#select_cost').text(cost2+" 원");
    }

    function cancel(){
        let res = confirm("계약을 취소하시겠습니까?");
        if(res){
            history.back();
        }
    }
</script>

<%-- 하단 공통부분 --%>
<jsp:include page="./mypage_footer.jsp" />