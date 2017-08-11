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
    <h1>基于空间和类别的分析</h1><h2>密度地图与空间聚类分析</h2>
    <p class="lead">对事故的地理分布进行深入挖掘，从而获取事故发生的空间分布规律
  </div>
</header>
 <div id="map" class="map"><div id="info"></div></div>
      
       <div class="container jumbotron">
      <!-- Example row of columns -->
<form id="form_param" class="form-horizontal">
        <div class="row">
           <div class="panel panel-default">
            <div class="panel-heading">
              <h3 class="panel-title">按类别生成热力地图</h3>
            </div>
            <div class="panel-body">
            <div class="row">
  <div class="form-group">
    <label for="inputText" class="col-sm-2 control-label">需要统计的类别标签</label>
    <div class="col-sm-10">
      <input type="text" class="form-control" id="input_heattype" placeholder="dingban,wasi,shuizai,huozai,fangpao,yunshu,jidian,qita(default all)">
    </div>
  </div>
  <div class="row">
  	<div class="col-sm-10"></div>
  	<div class="col-sm-2">
  		<button id="btn_density" type="submit" class="btn btn-success">转换为密度图</button>
  	</div>
  </div>
</div>
    
            </div> 
        </div>
        </div>
        
 </form>
</div> 
      
<div class="container jumbotron">
      <!-- Example row of columns -->
<form id="form_param" class="form-horizontal">
        <div class="row">
           <div class="panel panel-default">
            <div class="panel-heading">
              <h3 class="panel-title">基于FastSearch思想的空间聚类分析</h3>
            </div>
            <div class="panel-body">
            <div class="row">
   <div class="form-group">
    <label for="inputText" class="col-sm-2 control-label">密度半径</label>
    <div class="col-sm-10">
      <input type="text" class="form-control" id="input_r" placeholder="0.0001">
    </div>
  </div>
  <div class="form-group">
    <label for="inputText" class="col-sm-2 control-label">噪音点密度阈值</label>
    <div class="col-sm-10">
      <input type="text" class="form-control" id="input_minptsasnoise" placeholder="0">
    </div>
  </div>
  <div class="form-group">
    <label for="inputText" class="col-sm-2 control-label">期望类簇数目</label>
    <div class="col-sm-10">
      <input type="text" class="form-control" id="input_classnum" placeholder="15">
    </div>
  </div>
  <div class="row">
  	<div class="col-sm-8"></div>
  	<div class="col-sm-2">
  		
  	</div>
  	<div class="col-sm-2">
  		<button id="btn_class" type="submit" class="btn btn-success">运行聚类算法</button>
  	</div>
  </div>
</div>
    
            </div> 
        </div>
        </div>
        
 </form>
</div> 
      
      
      
      <div class="container jumbotron">
      <!-- Example row of columns -->
<form id="form_param" class="form-horizontal">
        <div class="row">
           <div class="panel panel-default">
            <div class="panel-heading">
              <h3 class="panel-title">对空间聚类结果进行进一步分析</h3>
            </div>
            <div class="panel-body">
            <div class="row">
  <div class="form-group">
    <label for="inputText" class="col-sm-2 control-label">需要统计的类别标签</label>
    <div class="col-sm-10">
      <input type="text" class="form-control" id="input_classstaclassnumber" placeholder="0">
    </div>
  </div>
  <div class="row">
  	<div class="col-sm-10"></div>
  	<div class="col-sm-2">
  		<button id="btn_statype" type="submit" class="btn btn-success">进行类别统计</button>
  	</div>
  </div>
</div>
    
            </div> 
        </div>
        </div>
        
 </form>
</div> 
<div class="row">
        <div class="col-md-6">
         <dir id="radarchart" style="height:400px"></dir>
        </div>
        <div class="col-md-6">
          <dir id="piechart" style="height:400px"></dir>
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
<script type="text/javascript">
var radarChart = echarts.init(document.getElementById('radarchart'));  
var piechart = echarts.init(document.getElementById('piechart')); 

function getRandomValue(min, max) {
    return  (min + Math.round(Math.random() * 1000) % (max - min));
       
}
function getRandomRGB()
{
	return "rgba("+getRandomValue(50, 255)+","+getRandomValue(50, 255)+","+getRandomValue(50, 255)+",0.4)";
}

	var styleCache = {};
	var noisestyle = new ol.style.Style({
	      image: new ol.style.Circle({
	        radius: 1,
	        fill: new ol.style.Fill({
	          color:  'rgba(0, 0, 0, 0.3)',
	        }),
	        stroke: new ol.style.Stroke({
	          color:  'rgba(0, 0, 0, 0.3)',
	          width: 1
	        })
	      })
	    });
	styleCache['-2'] = noisestyle;
	var styleFunction = function(feature) {
		var des = feature.get('description');
	    var sign = feature.get('sign');
	    var radius = sign;
	  var style = styleCache[radius];
	  if (!style) {
		  var rgbcol = getRandomRGB();
	    style = new ol.style.Style({
	      image: new ol.style.Circle({
	        radius: 3,
	        fill: new ol.style.Fill({
	          color: rgbcol
	        }),
	        stroke: new ol.style.Stroke({
	          color: rgbcol,
	          width: 1
	        })
	      })
	    });
	    styleCache[radius] = style;
	  }
	  return style;
	};

	
    
    
	var vector_heatmap = new ol.layer.Heatmap(
   		 {
   			 blur: 6,
   		     radius: 3
   		 }
    );
	var vector = new ol.layer.Vector({
	    style: styleFunction
	  });
	var raster = new ol.layer.Tile({
	  source: new ol.source.Stamen({
	    layer: 'toner'
	  })
	});

	var map = new ol.Map({
	  layers: [baidu_layer],
	  target: 'map',
	  renderer: 'canvas',
	  view: new ol.View({
	    center: ol.proj.fromLonLat([108, 34]),
	    zoom: 4
	  })
	});

		
		var vectorSource_data= new ol.source.Vector({
	          url: 'getspacedata.json',
	          format: new ol.format.GeoJSON({
	            extractStyles: false
	          })  });
		vector_heatmap.setSource(vectorSource_data);
		map.addLayer(vector_heatmap);
		map.addLayer(vector);
		
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
		
</script>

<script type="text/javascript">
	$("#btn_class").click(function(){
		var para_r = $("#input_r").val();
		if(!para_r||para_r=="") para_r="0.0001";
		var para_minptsasnoise = $("#input_minptsasnoise").val();
		if(!para_minptsasnoise||para_minptsasnoise=="") para_minptsasnoise="0";
		var para_numclass = $("#input_classnum").val();
		if(!para_numclass||para_numclass=="") para_numclass="15";
		var classifyurl = 'spacecluster/getclassifydata?'+"para_r="+para_r+"&para_minptsasnoise="+para_minptsasnoise+
				"&para_numclass="+para_numclass;
		//alert(classifyurl);
		var vectorSource_data= new ol.source.Vector({
	    url: classifyurl,
	    format: new ol.format.GeoJSON({
	      extractStyles: false
	    })  });
		vector_heatmap.setSource(null);
		vector.setSource(vectorSource_data);
		map.addLayer(vector);
		return false;
	});
	
	$("#btn_density").click(function(){
		
		var para_heattype = $("#input_heattype").val();
		if(!para_heattype||para_heattype=="") para_heattype="all";
		var densityurl = "getspacedata.json?heattype="+para_heattype;
		 var vectorSource_data= new ol.source.Vector({
	          url: densityurl,
	          format: new ol.format.GeoJSON({
	            extractStyles: false
	          })  });
		 vector_heatmap.setSource(vectorSource_data);
		 vector.setSource(null);
		 return false;
	})
	
	$("#btn_statype").click(function(){
		var para_sta = $("#input_classstaclassnumber").val();
		if(!para_sta||para_sta=="") para_sta="0";
		var classifyurl = 'spacecluster/gettypedata_classnumber?'+"classnumber="+para_sta;
		radarChart.showLoading();
		piechart.showLoading();
        $.get(classifyurl,function(data)
      			{
      				radarfun(data);
      				piefun(data);
      			});
        return false;
	})
</script>

<%@ include file="../include/radarchart.jsp" %>
<%@ include file="../include/piechart.jsp" %>
<%@ include file="../include/footer.jsp" %>

</body>
</html>