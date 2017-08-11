<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>  
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">
    <link rel="shortcut icon" href="../../assets/ico/favicon.ico">

    <title>煤矿安全事故统计系统</title>

	<!-- Le styles -->
    <link href="${pageContext.request.contextPath}/resources/css/bootstrap.css" rel="stylesheet">
    <style type="text/css">
      body {
        padding-top: 60px;
        padding-bottom: 40px;
      }
    </style>
    <link href="${pageContext.request.contextPath}/resources/css/bootstrap-responsive.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/resources/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- ECharts单文件引入 -->
    <script src="${pageContext.request.contextPath}/resources/lib/jquery-1.7.1.min.js"></script>
    <script src="${pageContext.request.contextPath}/resources/lib/echarts-all.js"></script>
    <!-- Custom styles for this template -->
    <link href="jumbotron.css" rel="stylesheet">

  </head>

    <body>
    <div class="navbar-wrapper">
      <div class="container">

        <div class="navbar navbar-inverse navbar-fixed-top" role="navigation">
          <div class="container">
            <div class="navbar-header">
              <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
                <span class="sr-only">Toggle navigation</span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
              </button>
              <a class="navbar-brand" href="#">煤矿安全统计系统</a>
            </div>
            <div class="navbar-collapse collapse">
              <ul class="nav navbar-nav">
                <li class="active"><a href="#">Home</a></li>
                <li><a href="#about">About</a></li>
                <li><a href="#contact">Contact</a></li>
                <li class="dropdown">
                  <a href="#" class="dropdown-toggle" data-toggle="dropdown">Dropdown <b class="caret"></b></a>
                  <ul class="dropdown-menu">
                    <li><a href="#">Action</a></li>
                    <li><a href="#">Another action</a></li>
                    <li><a href="#">Something else here</a></li>
                    <li class="divider"></li>
                    <li class="dropdown-header">Nav header</li>
                    <li><a href="#">Separated link</a></li>
                    <li><a href="#">One more separated link</a></li>
                  </ul>
                </li>
              </ul>
            </div>
          </div>
        </div>

      </div>
    </div>

    <!-- Main jumbotron for a primary marketing message or call to action -->
    <div >
        <div id="main" style="height:500px" class="jumbotron"></div>
        
    </div>

    <div class="container">
      <!-- Example row of columns -->
      <div class="row">
        <div class="col-md-4">
          <h2>基于时间统计分析</h2>
          <p>提供基于时间的统计分析与可视化功能，包括年、季度、月、日以及均线统计与可视化功能</p>
          <p><a class="btn btn-default" href="#" role="button">View details &raquo;</a></p>
        </div>
        <div class="col-md-4">
          <h2>基于空间统计分析</h2>
          <p>提供基于空间的统计分析功能，包括省、市、县等不同层次的统计分析功能 </p>
          <p><a class="btn btn-default" href="#" role="button">View details &raquo;</a></p>
       </div>
        <div class="col-md-4">
          <h2>数据挖掘分析</h2>
          <p>当前仅提供关联挖掘分析功能，其他功能待续...</p>
          <p><a class="btn btn-default" href="#" role="button">View details &raquo;</a></p>
        </div>
      </div>
      
      <hr class="featurette-divider">

      <div class="row featurette">
        <div class="col-md-5">
          <img class="featurette-image img-responsive" data-src="holder.js/500x500/auto" alt="Generic placeholder image">
        </div>
        <div class="col-md-7">
          <h2 class="featurette-heading">Oh yeah, it's that good. <span class="text-muted">See for yourself.</span></h2>
          <p class="lead">Donec ullamcorper nulla non metus auctor fringilla. Vestibulum id ligula porta felis euismod semper. Praesent commodo cursus magna, vel scelerisque nisl consectetur. Fusce dapibus, tellus ac cursus commodo.</p>
        </div>
      </div>

      <hr class="featurette-divider">

      <div class="row featurette">
        <div class="col-md-7">
          <h2 class="featurette-heading">And lastly, this one. <span class="text-muted">Checkmate.</span></h2>
          <p class="lead">Donec ullamcorper nulla non metus auctor fringilla. Vestibulum id ligula porta felis euismod semper. Praesent commodo cursus magna, vel scelerisque nisl consectetur. Fusce dapibus, tellus ac cursus commodo.</p>
        </div>
        <div class="col-md-5">
          <img class="featurette-image img-responsive" data-src="holder.js/500x500/auto" alt="Generic placeholder image">
        </div>
      </div>

      <hr class="featurette-divider">

      <!-- FOOTER -->
      <footer>
        <p class="pull-right"><a href="#">Back to top</a></p>
        <p>&copy; 2016 chenning@PKU; <a href="#">coalmine</a>  <a href="#">Beijing China</a></p>
      </footer>

    </div><!-- /.container -->

	<script type="text/javascript">
        // 基于准备好的dom，初始化echarts图表
        var myChart = echarts.init(document.getElementById('main')); 
        
        var placeList = [
                         <c:forEach items="${list}" var="ins" varStatus="vs">  
                         {val:${ins.val} ,geoCoord:[${ins.lng},${ins.lat}]},
                         </c:forEach>
                     ]
                     option = {
                         backgroundColor: '#1b1b1b',
                         color: [
                             'rgba(255, 255, 255, 0.8)',
                             'rgba(14, 241, 242, 0.8)',
                             'rgba(255, 255, 0, 0.8)'
                         ],
                         title : {
                             text: '2007-2016 中国煤矿安全事故图',
                             subtext: '数据来源：国家安监总局',
                             x:'center',
                             textStyle : {
                                 color: '#fff'
                             }
                         },
                         legend: {
                             orient: 'vertical',
                             x:'left',
                             data:['特别重大事故','重大事故','较大事故'],
                             textStyle : {
                                 color: '#fff'
                             }
                         },
                         roamController: {
                             show: true,
                             x: 'right',
                             mapTypeControl: {
                                 'china': true
                             }
                         },
                         toolbox: {
                             show : true,
                             orient : 'vertical',
                             x: 'right',
                             y: 'center',
                             feature : {
                                 mark : {show: true},
                                 dataView : {show: true, readOnly: false},
                                 restore : {show: true},
                                 saveAsImage : {show: true}
                             }
                         },
                         series : [
                             {
                                 name: '弱',
                                 type: 'map',
                                 roam: 'move',
                                 mapType: 'china',
                                 itemStyle:{
                                     normal:{
                                         borderColor:'rgba(100,149,237,1)',
                                         borderWidth:1.5,
                                         areaStyle:{
                                             color: '#1b1b1b'
                                         }
                                     }
                                 },
                                 data : [],
                                 markPoint : {
                                     symbolSize: 3,
                                     large: true,
                                     effect : {
                                         show: true
                                     },
                                     data : (function(){
                                         var data = [];
                                         var len = placeList.length;
                                         var geoCoord
                                         while(len--) {
                                             geoCoord = placeList[len].geoCoord;
                                             var tempval = placeList[len].val;
                                             if(tempval<10 && tempval>=3)
                                            	 {
                                            	 data.push({
                                                     value : tempval,
                                                     geoCoord : [geoCoord[0],geoCoord[1]]
                                                 })
                                            	 }
                                         }
                                         return data;
                                     })()
                                 }
                             },
                             
                             {
                                 name: '中',
                                 type: 'map',
                                 mapType: 'china',
                                 roam: 'move',
                                 data : [],
                                 markPoint : {
                                     symbolSize: 3,
                                     large: true,
                                     effect : {
                                         show: true
                                     },
                                     data : (function(){
                                         var data = [];
                                         var len = placeList.length;
                                         var geoCoord
                                         while(len--) {
                                             geoCoord = placeList[len].geoCoord;
                                             var tempval = placeList[len].val;
                                             if(tempval>=10 && tempval<30)
                                                 {
                                                 data.push({
                                                     value : tempval,
                                                     geoCoord : [geoCoord[0],geoCoord[1]]
                                                 })
                                                 }
                                         }
                                         return data;
                                     })()
                                 }
                             },

                             {
                                 name: '强',
                                 type: 'map',
                                 roam: 'move',
                                 mapType: 'china',
                                 hoverable: false,
                                 data : [],
                                 markPoint : {
                                     symbol : 'diamond',
                                     symbolSize: 3,
                                     large: true,
                                     effect : {
                                         show: true
                                     },
                                     data : (function(){
                                         var data = [];
                                         var len = placeList.length;
                                         var geoCoord
                                         while(len--) {
                                             geoCoord = placeList[len].geoCoord;
                                             var tempval = placeList[len].val;
                                             if(tempval>=30)
                                                 {
                                                 data.push({
                                                     value : tempval,
                                                     geoCoord : [geoCoord[0],geoCoord[1]]
                                                 })
                                                 }
                                         }
                                         return data;
                                     })()
                                 }
                             }
                             
                         ]
                     };
                                         

        // 为echarts对象加载数据 
        myChart.setOption(option);
    </script>

    <!-- Bootstrap core JavaScript
    ================================================== -->
    <!-- Placed at the end of the document so the pages load faster -->
   
    <script src="${pageContext.request.contextPath}/resources/js/bootstrap.min.js"></script>
    <script src="${pageContext.request.contextPath}/resources/js/bootstrap.js"></script>
    
  </body>
</html>
