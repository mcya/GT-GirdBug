<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/pages/common/common.jsp"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="">
    <meta name="author" content="Mosaddek">
    <meta name="keyword" content="FlatLab, Dashboard, Bootstrap, Admin, Template, Theme, Responsive, Fluid, Retina">
    <link rel="shortcut icon" href="img/favicon.png">

    <title>移动跟客系统</title>

    <jsp:include page="/pages/common/head.jsp"></jsp:include>
    <style type="text/css">
    	a.logo {
		    font-size: 21px;
		    color: #2e2e2e;
		    float: left;
		    margin-top: 10px; 
		    text-transform: uppercase;
		}
    </style>
</head>

  <body class="login-body">

    <div class="container">
      <header class="header white-bg">
          <!--logo start-->
          <a href="javascript:void(0)" class="logo"><img src="${path }/assets/img/logo.gif"></a>
          <!--logo end-->
      </header>

      <form class="form-signin"  id="submitForm" method="post" action="${path}/j_security_check" onkeyup="return keySubmit();">
        <h2 class="form-signin-heading">请输入您的登录信息</h2>
        <div class="login-wrap">
            <input type="text" class="form-control" placeholder="用户名" autofocus id="j_username" name="j_username" >
            <input type="password" class="form-control" placeholder="密码" id="j_password" name="j_password" >
            <label class="checkbox">
                <input type="checkbox" value="remember-me"> 自动登录
                <span class="pull-right">
                    <a data-toggle="modal" href="#myModal"> 忘记密码?</a>

                </span>
            </label>
            <button class="btn btn-lg btn-login btn-block" type="submit" onclick="submitCheck();">登录</button>

        </div>

      </form>

    </div>

    <!-- js placed at the end of the document so the pages load faster -->
    <script src="${path }/assets/js/jquery.js"></script>
    <script src="${path }/assets/js/bootstrap.min.js"></script>
	<script type="text/javascript">
			function keySubmit(){
				var e = e || window.event;
				if(e.keyCode === 13){
					if($("#j_password").val() == ''){
						$("#j_password").focus();
						return;
					}
					return submitCheck();
				}
			}
			function submitCheck(){
				if($("#j_username").val() == ''){
					alert("账号不能为空！");
					$("#j_username").focus();
					return false;
				}
				if($("#j_password").val() == ''){
					alert("密码不能为空！");
					$("#j_password").focus();
					return false;
				}
				loginCheck();
			}
			function loginCheck(){
				$.ajax({
					async: false, 
					url:'/eac-appcenter/public/login.action?method=loginCheck',
					type:'post',
					dataType:'json',
					data:{userName:$("#j_username").val(),password:$("#j_password").val()},
					success:function(data){
						if(data['success'] == true){
							$("#submitForm").submit();
						}else{
							alert(data['message']);
						}
					},
					error:function(stats){
						alert(stats)
					}
				});
			}
		</script>
  </body>
</html>
