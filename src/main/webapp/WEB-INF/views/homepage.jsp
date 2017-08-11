<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>  
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="en">
  <head>
    <%@ include file="../include/links.jsp" %>
    <!-- version 2 of echart -->
    <script src="${pageContext.request.contextPath}/resources/lib/echarts-all.js"></script>
  </head>
  
<!-- NAVBAR
================================================== -->
  <body>
    <%@ include file="../include/header.jsp" %>
   
    <!-- Main jumbotron for a primary marketing message or call to action -->
    <div >
        <div id="main" style="height:500px" class="jumbotron"></div>
        
    </div>

    <div class="container">
      <!-- Example row of columns -->
      <div class="row">
        <div class="col-md-4">
          <h2>基于时间的分析</h2>
          <p>提供基于时间的统计分析与可视化功能，包括年、季度、月、日以及均线统计与可视化功能</p>
          <p><a class="btn btn-default" href="timeserise" role="button">View details &raquo;</a></p>
        </div>
        <div class="col-md-4">
          <h2>基于空间的分析</h2>
          <p>提供基于空间的统计分析功能，包括省、市、县等不同层次的统计分析功能 </p>
          <p><a class="btn btn-default" href="spaceandstyle" role="button">View details &raquo;</a></p>
       </div>
        <div class="col-md-4">
          <h2>数据挖掘分析</h2>
          <p>当前仅提供关联挖掘分析功能</p><p>其他功能待续...</p>
          <p><a class="btn btn-default" href="datamining" role="button">View details &raquo;</a></p>
        </div>
      </div>
     </div> 

      <%@ include file="../include/footer.jsp" %>

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
    <script src="${pageContext.request.contextPath}/resources/js/docs.min.js"></script>
  </body>
</html>