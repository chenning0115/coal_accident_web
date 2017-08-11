<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>  
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="en">
  <head>
    <%@ include file="../include/links.jsp" %>
    <!-- version 3 of echart -->
    <script src="${pageContext.request.contextPath}/resources/lib/echarts.min.js"></script>
    <script src="${pageContext.request.contextPath}/resources/lib/dataTable.min.js"></script>
    <link href="${pageContext.request.contextPath}/resources/css/dataTable.css" rel="stylesheet">
  </head>
<body>
<%@ include file="../include/header.jsp" %>

<header class="jumbotron subhead">
  <div class="container">
    <h1>数据挖掘分析</h1> <h3>关联规则挖掘分析</h3>
    <p class="lead">当前仅提供关联挖掘分析功能，其他功能待续...
  </div>
</header>

<div class="container jumbotron">
      <!-- Example row of columns -->
<form id="form_param" class="form-horizontal">
      <div class="row">
        <div>
           <div class="panel panel-default">
            <div class="panel-heading">
              <h3 class="panel-title">第一步：过滤参数选择</h3>
            </div>
            <div class="panel-body"> 
  <div class="form-group">
    <label for="inputText" class="col-sm-2 control-label">季度</label>
    <div class="col-sm-10">
      <input type="text" class="form-control" id="quarter" placeholder="1,2,3,4">
    </div>
  </div>
  <div class="form-group">
    <label for="inputText" class="col-sm-2 control-label">月份</label>
    <div class="col-sm-10">
      <input type="text" class="form-control" id="month" placeholder="1,2,3,4,5,6,7,8,9,10,11,12">
    </div>
  </div>
  <div class="form-group">
    <label for="inputText" class="col-sm-2 control-label">严重程度</label>
    <div class="col-sm-10">
      <input type="text" class="form-control" id="death" placeholder="veryserious,serious,relativeserious,general">
    </div>
  </div>
  <div class="form-group">
    <label for="inputText" class="col-sm-2 control-label">省份</label>
    <div class="col-sm-10">
      <input type="text" class="form-control" id="province" placeholder="guizhou,shanxi3,shanxi">
    </div>
  </div>
  <div class="form-group">
    <label for="inputText" class="col-sm-2 control-label">类型</label>
    <div class="col-sm-10">
      <input type="text" class="form-control" id="type" placeholder="dingban,shuizai,huozai,fangpao,wasi,yunshu,jidian,qita">
    </div>
  </div>

            </div>
          </div>
       </div>
       
      </div>
       <div class="row">
           <div class="panel panel-default">
            <div class="panel-heading">
              <h3 class="panel-title">第二步：不参与挖掘的属性选择</h3>
            </div>
            <div class="panel-body">
            <div class="form-group">
    <label for="inputText" class="col-sm-2 control-label">不参与挖掘属性索引</label>
    <div class="col-sm-10">
      <input type="text" class="form-control" id="notinclude" placeholder="province=2,death=3,season=4,month=5,type=6 (default 2,5)">
    </div>
  </div>
    
            </div> 
        </div>
        </div>
        
         <div class="row">
           <div class="panel panel-default">
            <div class="panel-heading">
              <h3 class="panel-title">第三步：Aprior算法参数选择</h3>
            </div>
            <div class="panel-body">
            <div class="form-group">
    <label for="inputText" class="col-sm-2 control-label">最小支持度上限</label>
    <div class="col-sm-10">
      <input type="text" class="form-control" id="uppersupport" placeholder="开始迭代的最小支持度 (default 1.0)">
    </div>
  </div>
  <div class="form-group">
  <label for="inputText" class="col-sm-2 control-label">最小支持度下限</label>
    <div class="col-sm-10">
      <input type="text" class="form-control" id="lowersupport" placeholder="结束迭代的最小支持度 (default 0.1)">
    </div>
  </div>
  <div class="form-group">
  <label for="inputText" class="col-sm-2 control-label">支持度迭代间隔</label>
    <div class="col-sm-10">
      <input type="text" class="form-control" id="delt" placeholder="支持度每次变化的间隔 (default 0.05)">
    </div>
  </div>
    <div class="form-group">
  <label for="inputText" class="col-sm-2 control-label">度量标准</label>
    <div class="col-sm-10">
      <input type="text" class="form-control" id="metrictype" placeholder="置信度(confidence=0)，提升度(lift=1)，杠杆率(leverage=2)，确信度(conviction=3) (default 0)">
    </div>
  </div>
  <div class="form-group">
  <label for="inputText" class="col-sm-2 control-label">最小度量阈值</label>
    <div class="col-sm-10">
      <input type="text" class="form-control" id="minmetric" placeholder=" (default 0.1)">
    </div>
  </div>
  <div class="form-group">
  <label for="inputText" class="col-sm-2 control-label">要输出的规则数目</label>
    <div class="col-sm-10">
      <input type="text" class="form-control" id="numrules" placeholder="(default 100)">
    </div>
  </div>
            </div> 
        </div>
        </div>
        
        <div class="row">
           <div class="panel panel-default">
            <div class="panel-heading">
              <h3 class="panel-title">第四步：规则筛选</h3>
            </div>
            <div class="panel-body">
            <div class="row">
   <div class="form-group">
  <label for="inputText" class="col-sm-2 control-label">前提集项数</label>
    <div class="col-sm-10">
      <input type="number" class="form-control" id="premisenum" placeholder=" (default -1)">
    </div>
  </div>
  <div class="form-group">
  <label for="inputText" class="col-sm-2 control-label">结果集项数</label>
    <div class="col-sm-10">
      <input type="number" class="form-control" id="consequensenum" placeholder="(default -1)">
    </div>
  </div>
  <div class="row">
  	<div class="col-sm-10"></div>
  	<div class="col-sm-2">
  		<button id="btn_run" type="submit" class="btn btn-success">运行算法</button>
  	</div>
  </div>
</div>
    
            </div> 
        </div>
        </div>
        
 </form>
</div> 

<div class="container jumbotron">
 <div class="row">
           <div class="panel panel-default">
            <div class="panel-heading">
              <h3 class="panel-title">关联挖掘结果规则</h3>
            </div>
            <div class="panel-body">
            <table id="ruletable" class="display" cellspacing="0" width="100%">
        <thead>
            <tr>
            	<th>序号</th>
                <th>前提</th>
                <th>结果</th>
                <th>置信度</th>
                <th>提升度</th>
                <th>杠杆率</th>
                <th>确信度</th>
            </tr>
        </thead>
        <tfoot>
            <tr>
            <th>序号</th>
                <th>前提</th>
                <th>结果</th>
                <th>置信度</th>
                <th>提升度</th>
                <th>杠杆率</th>
                <th>确信度</th>
            </tr>
        </tfoot>
    </table>
            </div> 
        </div>
        </div>
</div>
<script>
$("#btn_run").click(function() {
	var para_quarter = $("#quarter").val();
	if(!para_quarter||para_quarter=="") para_quarter="all";
	var para_month = $("#month").val();
	if(!para_month||para_month=="") para_month="all";
	var para_death = $("#death").val();
	if(!para_death||para_death=="") para_death="all";
	var para_province = $("#province").val();
	if(!para_province||para_province=="") para_province="all";
	var para_type =$("#type").val();
	if(!para_type||para_type=="") para_type="all";
	
	var para_notinclude = $("#notinclude").val();
	if(!para_notinclude||(para_notinclude=="")) para_notinclude="2,5";
	var para_uppersupport = $("#uppersupport").val();
	if(!para_uppersupport||(para_uppersupport=="")) para_uppersupport = "1.0";
	var para_lowersupport = $("#lowersupport").val();
	if(!para_lowersupport||(para_lowersupport=="")) para_lowersupport = "0.1";
	var para_delt = $("#delt").val();
	if(!para_delt||para_delt=="") para_delt = "0.01";
	var para_metrictype = $("#metrictype").val();
	if(!para_metrictype||(para_metrictype=="")) para_metrictype = "0";
	var para_minmetric = $("#minmetric").val();
	if(!para_minmetric||(para_minmetric=="")) para_minmetric="0.05";
	var para_numrules = $("#numrules").val();
	if(!para_numrules||para_numrules=="") para_numrules = "100";
	var para_premisenum = $("#premisenum").val();
	if(!para_premisenum||para_premisenum=="") para_premisenum="-1";
	var para_consequencenum = $("consequensenum").val();
	if(!para_consequencenum||para_consequencenum=="") para_consequencenum="-1";
    $('#ruletable').DataTable( {
    	"destroy": true,
        "ajax":{
        	url:"datamining/arrays.txt",
        	type:"POST",
        	data:{
        		"quarter":para_quarter,
        		"month":para_month,
        		"death":para_death,
        		"province":para_province,
        		"type":para_type,
        		"notinclude":para_notinclude,
                "uppersupport":para_uppersupport,
                "lowersupport":para_lowersupport,
                "delt":para_delt,
                "metrictype":para_metrictype,
                "minmetric":para_minmetric,
                "numrules":para_numrules,
                "premisenum":para_premisenum,
                "consequensenum":para_consequencenum
        	}
        }
    } );
    return false;
});
$(document).ready(function() {
   
    return false;
});
</script>
<%@ include file="../include/footer.jsp" %> 


</body>
</html>