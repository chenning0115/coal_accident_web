<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>  
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="en">
  <head>
    <%@ include file="../include/links.jsp" %>
    <!-- version 3 of echart -->
    <script src="${pageContext.request.contextPath}/resources/lib/echarts.min.js"></script>
  </head>
<body>
<%@ include file="../include/header.jsp" %>

<header class="jumbotron subhead">
  <div class="container">
    <h1>基于时间的分析</h1><h2>时间序列预测</h2>
    <p class="lead">提供基于时间的预测模型，可以对未来一段时间发生情况进行有效预测
  </div>
</header>


<div class="container">

<div id="daychart" style="height:400px">
</div>
</div>
<div class="container">
<div style="height:50px"></div>
</div>

<div class="container jumbotron">
<form class="form-inline">
<div class="row">
<div class="col-sm-2"></div>
  	<div class="form-group">
  	<label for="exampleInputName2" id="label_sign">间隔类型：</label>
  	<select id ="select_sign" class="form-control">
  		<option value="q">季</option>
  		<option value="m" selected = "selected">月</option>
  		<option value="d">天</option>
  		<option value="a">移动平均</option>
	</select>
	</div>
	<div class="form-group">
	<label for="inputText" class="control-label">移动平均法天数：</label>
      <input type="number" class="form-control" id="input_num" placeholder="0">
    </div>
	<button id="btn_getdata" type="submit" class="btn btn btn-primary">获取数据</button>
</div>
</form>
</div> 

<div class="container jumbotron">
      <!-- Example row of columns -->
      <div class="row">
        <div class="col-md-4">
           <div class="panel panel-default">
            <div class="panel-heading">
              <h3 class="panel-title">模型选择</h3>
            </div>
            <div class="panel-body">
              <div class="list-group">

            <a href="#" class="list-group-item">线性回归法预测</a>
            <a href="#" class="list-group-item active">神经网络法预测</a>
            
          </div>
            </div>
          </div>
          
        </div>
        <div class="col-md-4">
          <div class="panel panel-default">
            <div class="panel-heading">
              <h3 class="panel-title">参数选择</h3>
            </div>
            <div class="panel-body">
              
            </div>
          </div>
          
       </div>
        <div class="col-md-4">
          <div class="panel panel-default">
            <div class="panel-heading">
              <h3 class="panel-title">预测结果</h3>
            </div>
            <div class="panel-body">
              
            </div>
          </div>
          
       </div>
      </div>
     </div> 
     
<%@ include file="../include/timelinechart.jsp" %>
<script type="text/javascript">
$("#btn_getdata").click(function(){
	var para_num = $("#input_num").val();
	if(!para_num||para_num=="") para_num="0";
	var url_getdata = "predict/getdata?"+"sign="+$("#select_sign option:selected").val()+"&num="+para_num;
	
	$.get(url_getdata,function(data){timelinefun(data);})
	return false;
	});
$(document).ready(function(){$.get('predict/getdata?startdate=2010-01-01&enddate=2016-01-01&sign=m',function(data)
		{
	timelinefun(data);
});})
</script> 

<%@ include file="../include/footer.jsp" %>


</body>
</html>