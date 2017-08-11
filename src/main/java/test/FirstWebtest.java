package test;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.tomcat.util.log.UserDataHelper.Mode;
import org.springframework.http.HttpRequest;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import data.AttrFilterByExpression;
import data.ILRFilter;
import data.LRInstances;
import data.Utils;
import domain.AssociationParamUtils;
import domain.Ins;
import domain.LineandBarParam;
import domain.TimeHeatmapParam;
import domain.TimeseriesSelectParam;
import services.AssociationMining;
import services.SpaceClassify;
import services.SpaceService;
import services.TimeSeriseService;
import statistics.space.SpaceStatistics;
import statistics.space.SpaceStatistics.tuple;
import statistics.timeserise.TimeSeriseStatistics;

@Controller
public class FirstWebtest {

	@RequestMapping(value = "/home")
	public String sayhello(Model model)
	{
		ArrayList<Ins> list = new ArrayList<Ins>();
		LRInstances lrInstances;
		try {
			lrInstances = services.Utils.getLrInstances();
			for(int i =0;i<lrInstances.getSize();i++)
			{
				Ins temp = new Ins(lrInstances.GetValueofgeo_lon(i), lrInstances.GetValueofgeo_lat(i), (int)lrInstances.getValue(i, 4));
				if(temp.getVal()>=0)
				list.add(temp);
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		model.addAttribute("list", list);
		
		return "homepage";
	}
	
	@RequestMapping(value = "/timeserise")
	public String TimeSerisecontrol(HttpServletRequest request,Model model)
	{
		LRInstances lrInstances = TimeSeriseService.Filterlrins(request.getParameter("type"), request.getParameter("pro"),services.Utils.getLrInstances());
		System.out.println("filtered size = "+ lrInstances.getSize());
		if(lrInstances.getSize()==0) return "TimeSerise";
		TimeSeriseService ts = new TimeSeriseService(lrInstances);
		Set<String> set_pro = services.Utils.getProvinceMap().keySet();
		String[] provincenames = (String[]) set_pro.toArray(new String[]{});
		ts.all_year_sta();
		TimeHeatmapParam heatmapParam = ts.all_yearmonth_sta();
		ts.monthandquartesta();
		LineandBarParam monthsum = ts.all_monthsum();
		LineandBarParam quartersum = ts.all_quartersum();
		TimeseriesSelectParam selectParam = new TimeseriesSelectParam(request.getParameter("pro"), request.getParameter("type"));
		model.addAttribute("array_year_count", ts.get_all_year_count());
		model.addAttribute("array_year_death", ts.get_all_year_death());
		model.addAttribute("heatmapparam", heatmapParam);
		model.addAttribute("lineandbarparam_month", monthsum);
		model.addAttribute("lineandbarparam_quarter", quartersum);
		model.addAttribute("provincenames", provincenames);
		model.addAttribute("selectparam",selectParam);
		return "TimeSerise"; 
	}
	
	@RequestMapping(value="/timeserise/predict/getdata")
	public void getTimeserisedaydate(HttpServletRequest request,java.io.Writer writer)
	{
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
		try{
			//Date startdate = dateFormat.parse(request.getParameter("startdate"));
			//Date enddate = dateFormat.parse(request.getParameter("enddate"));
			String sign = request.getParameter("sign");
			int num = 0;
			try {
				num = Integer.parseInt(request.getParameter("num"));
			} catch (Exception e) {
				// TODO: handle exception
				num=0;
			}
			TimeSeriseService ts = new TimeSeriseService(services.Utils.getLrInstances());
			PrintWriter writer2 = new PrintWriter(writer);
			String result = ts.all_daysta(sign,num);
			System.out.println(result);
			writer2.println(result);
			writer2.flush();
			writer2.close();
		}catch(Exception e)
		{
			e.printStackTrace();
		}
		
	}
	
	@RequestMapping(value="/timeserise/predict")
	public String Timeserisepredictcontrol()
	{

		return "timeserise_predict";
	}
	
	@RequestMapping(value="/spaceandstyle")
	public String SpaceandStyle(Model model)
	{
		
		return "spacestyle";
	}
	
	@RequestMapping(value="/spacestyle/getspacedata.json")
	public void getSpaceData(HttpServletRequest request,java.io.Writer writer)
	{
		LRInstances lrInstances = null;
		String heattype = request.getParameter("heattype");
		if(heattype==null||heattype.equals("all"))
		{
			lrInstances = services.Utils.getLrInstances();
		}
		else{
			String[] strs = heattype.split(",");
			StringBuffer buffer = new StringBuffer();
			for(int i=0;i<strs.length-1;i++)
			{
				buffer.append("(ATT7 is '"+strs[i]+"') or");
			}
			buffer.append("(ATT7 is '"+strs[strs.length-1]+"')");
			System.out.println(buffer.toString());
			ILRFilter filter = new AttrFilterByExpression(services.Utils.getLrInstances(), buffer.toString());
			lrInstances = filter.LRProcess(services.Utils.getLrInstances());
		}
		String geojson = services.Utils.LRInstances2GeoJson(lrInstances,4);
		try{
			PrintWriter writer2 = new PrintWriter(writer);
			writer2.println(geojson);
			//System.out.println(geojson);
			writer2.flush();
		}catch(Exception e)
		{
			e.printStackTrace();
		}
	}
	@RequestMapping(value="/spacestyle/gettypedata")
	public void getspacetypeData(HttpServletRequest request,HttpSession session,java.io.Writer writer)
	{
		try{
			HashMap<String, String> map = services.Utils.getProvinceMap();
			PrintWriter writer2 = new PrintWriter(writer);
			String[] strs = request.getParameter("pro").split(",");
			StringBuffer buffer = new StringBuffer();
			for(int i=0;i<strs.length-1;i++)
			{
				buffer.append("NAME_1='"+map.get(strs[i])+"' OR ");
			}
			buffer.append("NAME_1='"+map.get(strs[strs.length-1])+"'");
			System.out.println(buffer.toString());
			
			SpaceService spaceService = new SpaceService(services.Utils.getLrInstances());
			String str_result = spaceService.spacestawithtimeandtype(buffer.toString());
			
			writer2.println(str_result);
			writer2.flush();
		}catch(Exception e)
		{
			e.printStackTrace();
		}
	}
	
	
	
	@RequestMapping(value="/datamining/arrays.txt")
	public void datamining_association(HttpServletRequest request,java.io.Writer writer)
	{
		try{
			String assopara1 = AssociationParamUtils.generateAttrFilterExpression(request.getParameter("quarter"),
					request.getParameter("month"),request.getParameter("death"), request.getParameter("province"), request.getParameter("type"));
			
			LRInstances lrInstances = services.Utils.getLrInstances_association();
			AssociationMining associationMining = new AssociationMining(lrInstances,assopara1,"1,"+request.getParameter("notinclude"));
			double upper = Double.parseDouble(request.getParameter("uppersupport"));
			double lower = Double.parseDouble(request.getParameter("lowersupport"));
			double delt = Double.parseDouble(request.getParameter("delt"));
			double minmetric = Double.parseDouble(request.getParameter("minmetric"));
			int metrictype = Integer.parseInt(request.getParameter("metrictype"));
			int numrules = Integer.parseInt(request.getParameter("numrules"));
			String result = associationMining.RunApriori(upper,lower,delt, metrictype,minmetric,numrules);
			writer.write(result);
			writer.flush();
			writer.close();
		}catch(Exception e)
		{
			e.printStackTrace();
		}
		
		
	}
	@RequestMapping(value="/spacestyle/spacecluster")
	public String spaceCluter(Model model)
	{
		return "spacecluter";
		
	}
	@RequestMapping(value="/spacestyle/spacecluster/getclassifydata")
	public void getSpaceClassifyData(HttpServletRequest request,HttpSession session,java.io.Writer writer)
	{
		System.out.println(request.getParameter("para_r"));
		double r = Double.parseDouble(request.getParameter("para_r"));
		int minptsasnoise = Integer.parseInt(request.getParameter("para_minptsasnoise"));
		int numclass = Integer.parseInt(request.getParameter("para_numclass"));
		SpaceClassify spaceClassify = new SpaceClassify(services.Utils.getLrInstances());
		LRInstances resultins = spaceClassify.FastSearchClassify(r, minptsasnoise, numclass);
		session.setAttribute("cur_classified_lrinstances",resultins);
		String geojson = services.Utils.LRInstances2GeoJson(resultins,7);
		try{
			PrintWriter writer2 = new PrintWriter(writer);
			writer2.println(geojson);
			//System.out.println(geojson);
			writer2.flush();
		}catch(Exception e)
		{
			e.printStackTrace();
		}
	}
	
	
	@RequestMapping(value="/spacestyle/spacecluster/gettypedata_classnumber")
	public void getspacetypeDatabyclassnumber(HttpServletRequest request,HttpSession session,java.io.Writer writer)
	{
		try{
			LRInstances lrInstances = (LRInstances)session.getAttribute("cur_classified_lrinstances");
			System.out.println("classified_lrins num = "+lrInstances.getSize());
			PrintWriter writer2 = new PrintWriter(writer);
			String[] strs = request.getParameter("classnumber").split(",");
			StringBuffer buffer = new StringBuffer();
			for(int i=0;i<strs.length-1;i++)
			{
				buffer.append("(ATT8 = "+strs[i]+") or");
			}
			buffer.append("(ATT8 = "+strs[strs.length-1]+")");
			System.out.println(buffer.toString());
			ILRFilter filter = new AttrFilterByExpression(lrInstances, buffer.toString());
			SpaceClassify spaceClassify = new SpaceClassify(filter.LRProcess(lrInstances));
			
			String str_result = spaceClassify.classifiedwithtimeandtype();
			
			writer2.println(str_result);
			writer2.flush();
		}catch(Exception e)
		{
			e.printStackTrace();
		}
	}
	
	@RequestMapping(value="/datamining")
	public String DataMining(Model model)
	{
		return "datamining";
	}
	
}
