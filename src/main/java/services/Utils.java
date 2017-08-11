package services;


import java.io.BufferedReader;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.util.HashMap;

import org.eclipse.jdt.internal.compiler.ast.ThisReference;
import org.json.JSONWriter;

import data.LRInstances;

public class Utils {

	private static LRInstances lrInstances = null;
	private static LRInstances lrInstances_association = null;
	private static LRInstances lrInstances_classify = null;
	private static int count = 0;
	private static HashMap<String, String> provincemap = null; 
	
	public static LRInstances getLrInstances()
	{
		if(lrInstances==null)
		{
			try {
				lrInstances = LRInstances.loadfromDB("jdbc:postgresql://localhost:5432/postgres", "postgres", "postgres", "select * from coalmineaccidents");
				//lrInstances = LRInstances.loadfromfile(Utils.class.getClassLoader().getResource("/meikuang5.csv").getPath());
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			lrInstances.setsign_attr_date(3);
			lrInstances.setsign_attr_geolon(1);
			lrInstances.setsign_attr_geolat(2);
		}
		else {
			count++;
		}
		System.out.println("count="+count);
		
		return lrInstances;
	}
	
	public static LRInstances getLrInstances_association()
	{
		if(lrInstances_association==null)
		{
			try {
				lrInstances_association = LRInstances.loadfromfile(Utils.class.getClassLoader().getResource("/test.csv").getPath());
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		return lrInstances_association;
	}
	public static LRInstances getLrInstances_classify()
	{
		if(lrInstances_classify==null)
		{
			try {
				lrInstances_classify = LRInstances.loadfromDB("jdbc:postgresql://localhost:5432/postgres", "postgres", "postgres", "select * from coalmineclassify");
				lrInstances_classify.setsign_attr_date(3);
				lrInstances_classify.setsign_attr_geolon(1);
				lrInstances_classify.setsign_attr_geolat(2);
			} catch (Exception e) {
				// TODO: handle exception
				e.printStackTrace();
			}
		}
		return lrInstances_classify;
	}
	
	public static HashMap<String, String> getProvinceMap()
	{
		if(provincemap==null)
		{
			provincemap = new HashMap<>();
			try{
				BufferedReader reader = new BufferedReader(new InputStreamReader(new FileInputStream(new File(Utils.class.getClassLoader().getResource("/provincemap").getPath()))));
				String line = null;
				while((line = reader.readLine())!=null)
				{
					String[] strs = line.split(",");
					provincemap.put(strs[0], strs[1]);
				}
			}catch(Exception e)
			{
				e.printStackTrace();
			}
		}
		return provincemap;
	}
	
	public static String LRInstances2GeoJson(LRInstances lrInstances,int index_sign)
	{
		ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
		PrintWriter printer = new PrintWriter(new OutputStreamWriter(outputStream));
		JSONWriter writer = new JSONWriter(printer) ;
		writer.object().key("type").value("FeatureCollection").key("features").array();
		int count_row = lrInstances.getSize();
		for(int i=0;i<count_row;i++)
		{
			try{
				int sign = (int)lrInstances.getValue(i, index_sign); 
				//if(sign<=mindeath) continue;
			
				int id = (int) lrInstances.getValue(i,0);
				double lng = lrInstances.GetValueofgeo_lon(i);
				double lat = lrInstances.GetValueofgeo_lat(i);
				String description = lrInstances.getDescription(i);
				writer.object()
				.key("type").value("feature")
				.key("id").value(id)
				.key("properties")
					.object().key("description").value(description).key("sign").value(sign).endObject()
				.key("geometry")
					.object().key("type").value("Point").key("coordinates")
						.array().value(lng).value(lat).endArray()
					.endObject()
				.endObject();
				
			}catch(Exception e)
		 	{
			 	e.printStackTrace();
			}
		}
		writer.endArray().endObject();
		try {
			printer.flush();
			String data = outputStream.toString("UTF-8");
			return data;
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return null;
		}
		
	}
	
	
	
}
