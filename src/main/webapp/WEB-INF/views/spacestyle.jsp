<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>  
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="en">
  <head>
    <%@ include file="../include/links.jsp" %>
    <!-- version 3 of echart -->
    <script src="${pageContext.request.contextPath}/resources/lib/echarts.min.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/ol.css" type="text/css">
    <style>
       #map {
        position: relative;
      }
      #info {
        position: absolute;
        height: 1px;
        width: 1px;
        z-index: 100;
      }
      .tooltip.in {
        opacity: 1;
      }
      .tooltip.top .tooltip-arrow {
        border-top-color: white;
      }
      .tooltip-inner {
        border: 2px solid white;
      }
      .ol-dragbox {
        background-color: rgba(255,255,255,0.4);
        border-color: rgba(100,150,0,1);
      }
    </style>
    <script src="${pageContext.request.contextPath}/resources/lib/openlayer.js" type="text/javascript"></script>
    <title>OpenLayers 3 example</title>
  </head>
<body>
<%@ include file="../include/header.jsp" %>

<header class="jumbotron subhead">
  <div class="container">
    <h1>基于空间和类型的分析</h1>
    <p class="lead">提供基于空间的统计分析功能，包括省、市、县等不同层次的统计分析功能
  </div>
</header> 
   <div id="map" class="map"><div id="info"></div></div>
   <div id ="info2" class="alert alert-info" role="alert">贵州</div>

<div class="container">
      <div class="row">
        <div class="col-md-6">
         <dir id="radarchart" style="height:400px"></dir>
        </div> 
        <div class="col-md-6">
          <dir id="piechart" style="height:400px"></dir>
       </div>
      </div>
 </div>
     <div class="container">
      <!-- Jumbotron -->
      <div class="jumbotron">
        <h3>热力地图与空间聚类分析</h3>
        <p class="lead">对事故的地理分布进行深入挖掘，从而获取事故发生的空间分布规律.</p>
        <p><a class="btn btn-lg btn-success" href="spacestyle/spacecluster" role="button">预测分析</a></p>
      </div>
</div>
<script type="text/javascript">
    var projection = ol.proj.get("EPSG:3857");
    var resolutions = [];
    for(var i=0; i<19; i++){
        resolutions[i] = Math.pow(2, 18-i);
    }
    var tilegrid  = new ol.tilegrid.TileGrid({
        origin: [0,0],
        resolutions: resolutions
    });

    var baidu_source = new ol.source.TileImage({
        projection: projection,
        tileGrid: tilegrid,
        tileUrlFunction: function(tileCoord, pixelRatio, proj){
            if(!tileCoord){
                return "";
            }
            var z = tileCoord[0];
            var x = tileCoord[1];
            var y = tileCoord[2];

            if(x<0){
                x = "M"+(-x);
            }
            if(y<0){
                y = "M"+(-y);
            }

            return "http://online3.map.bdimg.com/onlinelabel/?qt=tile&x="+x+"&y="+y+"&z="+z+"&styles=pl&udt=20151021&scaler=1&p=1";
        }
    });

    var baidu_layer = new ol.layer.Tile({
        source: baidu_source
    });

   
</script>
    <script>
    var radarChart = echarts.init(document.getElementById('radarchart'));  
    var piechart = echarts.init(document.getElementById('piechart'));  
    
    
      var styleCache = {};
      var styleFunction = function(feature) {
        // 2012_Earthquakes_Mag5.kml stores the magnitude of each earthquake in a
        // standards-violating <magnitude> tag in each Placemark.  We extract it from
        // the Placemark's name instead.
        var des = feature.get('description');
        var death = feature.get('sign');
        var radius = death;
        if(radius>10) radius = 10;
        var style = styleCache[radius];
        if (!style) {
          style = new ol.style.Style({
            image: new ol.style.Circle({
              radius: radius,
              fill: new ol.style.Fill({
                color: 'rgba(0,0, 0, 0.3)'
              }),
              stroke: new ol.style.Stroke({
                color: 'rgba(255,0, 0, 0.3)',
                width: 1
              })
            })
          });
          styleCache[radius] = style;
        }
        return style;
      };

      var vectorSource_china = new ol.source.Vector({
          url: 'resources/data/china.json',
          format: new ol.format.GeoJSON()
        });

      var vectorSource_data= new ol.source.Vector({
          url: 'spacestyle/getspacedata.json',
          format: new ol.format.GeoJSON({
            extractStyles: false
          })  });
      var vector_china = new ol.layer.Vector(
    	{source: vectorSource_china }
      )
     var vector_heatmap = new ol.layer.Heatmap(
    		 {
    			 source: vectorSource_data,
    			 blur: 6,
    		     radius: 3
    		 }
    		 
     );
      
      var vector = new ol.layer.Vector({
        source: vectorSource_data,
        style: styleFunction
      });

      var raster = new ol.layer.Tile({
        source: new ol.source.Stamen({
          layer: 'toner'
        })
      });

      var map = new ol.Map({
        layers: [baidu_layer,vector_china,vector],
        target: 'map',
        renderer: 'canvas',
        view: new ol.View({
          center: ol.proj.fromLonLat([108, 34]),
          zoom: 4
        })
      });

      var info = $('#info');
      info.tooltip({
          animation: false,
          trigger: 'manual'
        });

      var displayFeatureInfo = function(pixel) {
        info.css({
          left: pixel[0] + 'px',
          top: (pixel[1] - 15) + 'px'
        });
        var feature = map.forEachFeatureAtPixel(pixel, function(feature) {
          return feature;
        });
        if (feature) {
          info.tooltip('hide')
              .attr('data-original-title', feature.get('description'))
              .tooltip('fixTitle')
              .tooltip('show');
        } else {
          info.tooltip('hide');
        }
      };

      map.on('pointermove', function(evt) {
        displayFeatureInfo(map.getEventPixel(evt.originalEvent));
      });

      map.on('click', function(evt) {
        selectedFeatures.clear();
        infoBox.innerHTML = '&nbsp;';
      });

   // a normal select interaction to handle click
      var select = new ol.interaction.Select();
      map.addInteraction(select);

      var selectedFeatures = select.getFeatures();

      // a DragBox interaction used to select features by drawing boxes
      var dragBox = new ol.interaction.DragBox({
        condition: ol.events.condition.platformModifierKeyOnly
      });

      map.addInteraction(dragBox);

      var infoBox = document.getElementById('info2');

      dragBox.on('boxend', function() {
        // features that intersect the box are added to the collection of
        // selected features, and their names are displayed in the "info"
        // div
        var info = [];
        var extent = dragBox.getGeometry().getExtent();
        vectorSource_china.forEachFeatureIntersectingExtent(extent, function(feature) {
          selectedFeatures.push(feature);
          info.push(feature.get('name'));
        });
        if (info.length > 0) {
          var str_select = info.join(',');
          infoBox.innerHTML = str_select;
          radarChart.showLoading();
		  piechart.showLoading();
          $.get('spacestyle/gettypedata?&pro='+str_select,function(data)
        			{
        				radarfun(data);
        				piefun(data);
        			});
        }
      });

      // clear selection when drawing a new box and when clicking on the map
      dragBox.on('boxstart', function() {
        selectedFeatures.clear();
        infoBox.innerHTML = '&nbsp;';
      });
      $(document).ready(function(){
    	  radarChart.showLoading();
		  piechart.showLoading();
    	  $.get('spacestyle/gettypedata?&pro=贵州',function(data)
      			{
      				radarfun(data);
      				piefun(data);
      			});
    	}); 
    </script>


     
   
<%@ include file="../include/radarchart.jsp" %>
<%@ include file="../include/piechart.jsp" %>
<%@ include file="../include/footer.jsp" %>


</body>
</html>