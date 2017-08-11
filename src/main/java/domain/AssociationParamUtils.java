package domain;

import mydata.DataProcess.tuple;

public class AssociationParamUtils {

	public static String generateAttrFilterExpression(String quarter,String month,String death,String province,String type)
	{
		if(quarter.equals("all")&&month.equals("all")&&death.equals("all")&&province.equals("all")&&type.equals("all"))
		{
			return "all";
		}
		
		StringBuffer buffer = new StringBuffer();
		boolean check = false;
		if(!quarter.equals("all"))
		{
			check = true;
			String[] strs_quarter = quarter.split(",");
			buffer.append("(");
			for(int i=0;i<strs_quarter.length-1;i++)
			{
				buffer.append("(ATT4 is 'quarter_"+strs_quarter[i]+"') or");
			}
			buffer.append("(ATT4 is 'quarter_"+strs_quarter[strs_quarter.length-1]+"')");
			buffer.append(")");
		}
		if(!month.equals("all"))
		{
			if(check) buffer.append("and");
			String[] strs_month = month.split(",");
			buffer.append("(");
			for(int i=0;i<strs_month.length-1;i++)
			{
				buffer.append("(ATT5 is 'month_"+strs_month[i]+"') or");
			}
			buffer.append("(ATT5 is 'month_"+strs_month[strs_month.length-1]+"')");
			buffer.append(")");
			check = true;
		}
		if(!type.equals("all"))
		{
			if(check) buffer.append("and");
			String[] strs_type = type.split(",");
			buffer.append("(");
			for(int i=0;i<strs_type.length-1;i++)
			{
				buffer.append("(ATT6 is '"+strs_type[i]+"') or");
			}
			buffer.append("(ATT6 is '"+strs_type[strs_type.length-1]+"')");
			buffer.append(")");
			check = true;
		}
		if(!death.equals("all"))
		{
			if(check) buffer.append("and");
			String[] strs_death = death.split(",");
			buffer.append("(");
			for(int i=0;i<strs_death.length-1;i++)
			{
				buffer.append("(ATT3 is '"+strs_death[i]+"') or");
			}
			buffer.append("(ATT3 is '"+strs_death[strs_death.length-1]+"')");
			buffer.append(")");
			check = true;
		}
		if(!province.equals("all"))
		{
			if(check) buffer.append("and");
			String[] strs_province= province.split(",");
			buffer.append("(");
			for(int i=0;i<strs_province.length-1;i++)
			{
				buffer.append("(ATT2 is '"+strs_province[i]+"') or");
			}
			buffer.append("(ATT2 is '"+strs_province[strs_province.length-1]+"')");
			buffer.append(")");
			check = true;
		}
		System.out.println(buffer.toString());
		return buffer.toString();
	}
}
