<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>아이디/비밀번호 찾기</title>
	<link rel="stylesheet" type="text/css" href="/css/dozip/login.css" />
	<script src="/js/dozip/jquery.js"></script>
	<script src="/js/dozip/member.js"></script>

	<script>
		function on_find_id() {
			$('.find_pwd').hide();
			$('.find_id').show();
		}
		
		function on_find_pw() {
			$('.find_id').hide();
			$('.find_pwd').show();
		}
	</script>
</head>
<body>
<div class="find_wrap">
	<div id="find_select">
		<button class="select_btn"  type="button" onclick="on_find_id()" >아이디 찾기</button>
		<button class="select_btn"  type="button"  onclick="on_find_pw()">비밀번호 찾기</button>
	</div>

	<%--아이디 찾기--%>
	<form class="find_id">
	<table style="width:100%;">
	<tr><td style="height:70px;">
		<input class="find_id_input"  type="text" name="mem_name2"  id="mem_name2" placeholder="이름" oninput="name_check2();" />		
		<br/><span class="namecheck2"></span>
	</td></tr>
	<tr><td style="height:70px;">
		<input class="find_id_input" type="text" name="mem_tel2" id="mem_tel2"  placeholder="전화번호" oninput="tel_check2();"/>
		<br/><span class="telcheck2"></span>
	</td></tr>
	</table>
		<button id="find_id_btn" type="button" disabled>아이디 찾기</button>
	</form>

	<%--비밀번호 찾기--%>
	<form class="find_pwd"  style="display: none;">
	<table style="width:100%;">
	<tr><td style="height:70px;">
		<input class="find_pwd_input"  type="text" name="mem_id" id="mem_id" placeholder="아이디" oninput="id_check2();"/>
		<br/><span class="idcheck"></span>
	</td></tr>
	<tr><td style="height:70px;">
		<input class="find_pwd_input" type="text" name="mem_name" id="mem_name" placeholder="이름" oninput="name_check();"/>
		<br/><span class="namecheck"></span>
	</td></tr>
	<tr><td style="height:70px;">
		<input class="find_pwd_input" type="text" name="mem_tel" id="mem_tel" placeholder="전화번호" oninput="tel_check();"/>
		<br/><span class="telcheck"></span>
	</td></tr>
	<tr><td style="height:70px;">
		<input class="find_pwd_input"  type="text"  name="mem_email"  id="mem_email" placeholder="이메일주소를 입력해주세요" oninput="email_check();" style="width: 26%;"/>
		<span>@</span>
		<input class="find_pwd_input"  type="text"  name="mem_domain"  id="mem_domain" placeholder="도메인주소를 입력해주세요" oninput="email_check();" style="width: 26%;"/>
		<select name="domain_list" id="domain_list" onchange="changeSelect(this.value);" onclick="email_check();">
			<option selected>직접입력</option>
			<option value="naver.com">naver.com</option>
			<option value="daum.net">daum.net</option>
			<option value="gmail.com">gamil.com</option>
		</select>
		<br/><span class="emailcheck"></span>
	</td></tr>
	</table>
		<p id="find_pwd_info">※비밀번호 찾기를 누르면 임시번호를 메일주소로 보내드립니다.</p>
		<button id="find_pwd_btn" type="button" >비밀번호 찾기</button>
	</form>
	
	<div class="find_info">
		<button type="button" onclick="history.go(-1)">← 로그인 화면으로 돌아가기</button>
	</div>
</div>

<script>
	document.getElementById("find_id_btn").onclick = function() {
		var mem_name = $.trim($('#mem_name2').val());
		var mem_tel = $.trim($('#mem_tel2').val());

		$.ajax({
			url : '/dozip/find_id',
			type : 'post',
			data : {
				mem_name : mem_name,
				mem_tel : mem_tel
			},
			success : function(data) {
				if(data != null){
					alert("고객님의 아이디는 "+data+" 입니다.");
					location='/dozip/id_login';
				}else{
					alert('입력하신 정보와 일치하는 아이디가 없습니다.');
					history.back();
				}
			},
			error:function(error){
				alert(error);
			}
		});
	}

	document.getElementById("find_pwd_btn").onclick = function() {
		function params_list() {
			var params = {};  //배열 선언
			var data = $(".find_pwd").serializeArray(); //폼태그에 있는 데이터 담기

			$.each(data, function () { //반복문
				var name = $.trim(this.name);  //name 변수에 this.data 의 name 파라미터 값
				var value = $.trim(this.value);  //value 변수에 this.data 의 value 값
				params[name] = value; //params 배열에 키, 값 쌍으로 저장
			});
			return params;
		}

		$.ajax({
			url : '/dozip/find_pwd',
			type : 'post',
			data : {
				data:JSON.stringify(params_list())
			},
			success : function(data) {
				if(data.res==1){
					alert(data.message);
					location="/dozip/id_login";
				}else if(data.res==2){
					alert(data.message);
					history.back();
				}else {
					alert(data.message);
					history.back();
				}
			},
			error:function(error){
				alert("실패했습니다.");
			}
		});
	}
</script>
</body>
</html>