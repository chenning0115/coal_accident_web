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
    <h1>基于时间的分析</h1><h2>基于时间的统计分析</h2>
    <p class="lead">提供基于时间的统计分析与可视化功能，包括年、季度、月、日以及均线统计与可视化功能
  </div>
</header>

  <div class="container">

<div class="row">

<div class="col-md-7">
<div class="panel panel-default">
            <div class="panel-heading">
              <h3 class="panel-title">当前所选参数</h3>
            </div>
            <div class="panel-body">
              <span class="label label-default">省份：${selectparam.select_pro}</span>
				<span class="label label-primary">类型：${selectparam.select_type}</span>
            </div>
          </div>
</div>
<div class="col-md-5">
<form class="form-inline">
 	<div class="panel panel-default">
            <div class="panel-heading">
              <h3 class="panel-title">参数选择</h3>
            </div>
            <div class="panel-body">
            <label for="exampleInputName2">省份</label>
              <select id="pro" class="form-control">
              <option>all</option>
  			<c:forEach items="${provincenames}" var="pro" varStatus="vs">  
  						
        	             <option> ${pro} </option>
        	                         </c:forEach>
  		
	</select>
	<label for="exampleInputName2">类型</label>
  	<select id="type" class="form-control">
  		<option>all</option>
  		<option>dingban</option>
  		<option>wasi</option>
  		<option>yunshu</option>
  		<option>shuizai</option>
  		<option>huozai</option>
  		<option>fangpao</option>
  		<option>jidian</option>
  		<option>qita</option>
	</select>
	
  	<button id ="btn_getdata" type="submit" class="btn btn btn-primary">获取数据</button>
            </div>
          </div>
          </form>
 </div>
  	
  	
  	</div>

</div>
<div class="container jumbotron">

<div class="row-fluid">
      <div class="col-md-8">
       <div id="yearchart" style="height:400px"></div>
       </div>
       <div class="col-md-4">
       <h2>年统计量</h2>
       <p class="lead">本图表通过对所选数据集进行年统计，表示年发生量或年死亡数，通过该图可以得出给定地区给定类别的煤矿安全事故发生的总体变化规律，从宏观上
       对事故发生规律进行刻画</p>
       </div>
</div>
</div>
<div class="container jumbotron">
<div class="row-fluid">
      <div class="col-md-4">
      <h2>时间密度图</h2>
      <p class="lead">本图表通过对所选数据集进行月度统计，并且以月份为横轴，年份为纵轴对数据集进行刻画，该图每一行（每年的各个月份）的数据进行了归一化（0-100）处理，
      一次横向观察没有意义，可以通过纵向观察，得出煤矿事故发生的月份统计规律</p>
       </div>
       <div class="col-md-8">
       <div id="timeheatmap" style="height:600px"></div>
       </div>
</div>

</div>


<div class="container jumbotron">
<div class="row-fluid">
      <div class="col-md-6">
      <h3>月累计规律</h3>
      <div id ="monthsum" style="height:400px"></div>
       </div>
       <div class="col-md-6" >
        <h3>季度累计规律</h3>
       <div id="quartersum" style="height:400px"></div>
       </div>
</div>
</div>

<div class="container">
      <!-- Jumbotron -->
      <div class="jumbotron">
        <h3>基于时间序列数据的预测分析</h3>
        <p class="lead">提供基于时间的预测模型，可以对未来一段时间发生情况进行有效预测.</p>
        <p><a class="btn btn-lg btn-success" href="/coaltest/timeserise/predict" role="button">预测分析</a></p>
      </div>
</div>
<script type="text/javascript">
        // 基于准备好的dom，初始化echarts图表
        var myChart = echarts.init(document.getElementById('yearchart')); 
        option = {
        	    tooltip : {
        	        trigger: 'axis'
        	    },
        	    toolbox: {
        	        show : true,
        	        orient:'vertical',
        	        feature : {
        	            mark : {show: true},
        	            dataView : {show: true, readOnly: false},
        	            magicType: {show: true, type: ['line', 'bar']},
        	            restore : {show: true},
        	            saveAsImage : {show: true}
        	        }
        	    },
        	    calculable : true,
        	    legend: {
        	    	
        	        data:['事故数','死亡人数']
        	    },
        	    xAxis : [
        	        {
        	            type : 'category',
        	            data : ['2000','2001','2002','2003','2004','2005','2006','2007','2008',
        	                    '2009','2010','2011','2012','2013','2014','2015','2016']
        	        }
        	    ],
        	    yAxis : [
        	        {
        	            type : 'value',
        	            name : '事故数',
        	            axisLabel : {
        	                formatter: '{value} 件'
        	            }
        	        },
        	        {
        	            type : 'value',
        	            name : '死亡人数',
        	            axisLabel : {
        	                formatter: '{value} 人'
        	            }
        	        }
        	    ],
        	    series : [
        	        {
        	            name:'事故数',
        	            type:'line',
        	            data:[
        	                <c:forEach items="${array_year_count}" var="ins" varStatus="vs">  
        	                ${ins},
        	                         </c:forEach>
        	            ]
        	        },
        	        {
        	            name:'死亡人数',
        	            type:'bar',
        	            yAxisIndex: 1,
        	            data:[
        	            <c:forEach items="${array_year_death}" var="ins" varStatus="vs">  
        	            ${ins},
        	                         </c:forEach>
        	            ]
        	        }
        	    ]
        	};
        	                    
        // 为echarts对象加载数据 
        myChart.setOption(option);
        </script>
        <script type="text/javascript">
        var myChart = echarts.init(document.getElementById('monthsum'));
        <%@ include file="../include/lineandbarchart.jsp" %>
        myChart.setOption(option);
        </script>
        <script type="text/javascript">
        var myChart = echarts.init(document.getElementById('quartersum'));
        <%@ include file="../include/lineandbarchart_quarter.jsp" %>
        myChart.setOption(option);
        </script>
        
        
        
        <script type="text/javascript">
        $("#btn_getdata").click(function(){
        	var url = "timeserise?pro="+$("#pro").val()+"&type="+$("#type").val();
        	//alert(url);
        	window.location.href=url;
        	return false;
        })
        </script>
        
        
<%@ include file="../include/TimeHeatmap.jsp" %>
<%@ include file="../include/footer.jsp" %>

</body>
</html>