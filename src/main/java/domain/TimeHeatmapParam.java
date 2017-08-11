package domain;


public class TimeHeatmapParam {

	private String str_row;
	private String str_col;
	private String str_data;
	private int max;
	private int min;
	
	public TimeHeatmapParam()
	{
		
	}
	public TimeHeatmapParam(String _str_row,String _str_col,String _str_data,int _max,int _min)
	{
		this.str_row = _str_row;
		this.str_col = _str_col;
		this.str_data = _str_data;
		this.max = _max;
		this.min = _min;
	}
	public void setMax(int _max)
	{
		this.max = _max;
	}
	public void setMin(int _min)
	{
		this.min =_min;
	}
	public int getMax()
	{
		return this.max;
		
	}
	public int getMin()
	{
		return this.min;
	}
	public void setStr_row(String _str_row)
	{
		this.str_row = _str_row;
	}
	public void setStr_col(String _str_col)
	{
		this.str_col = _str_col;
	}
	public void setStr_data(String _str_data)
	{
		this.str_data = str_data;
	}
	public String getStr_row()
	{
		return this.str_row;
	}
	public String getStr_col()
	{
		return this.str_col;
	}
	public String getStr_data()
	{
		return this.str_data;
	}
}
