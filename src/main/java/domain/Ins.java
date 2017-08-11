package domain;

import java.io.Serializable;

public class Ins implements Serializable{

	private double lng;
	private double lat;
	private int val;
	
	public Ins()
	{
		
	}
	public Ins(double _lng,double _lat,int _val)
	{
		this.lat = _lat;
		this.lng = _lng;
		this.val = _val;
	}
	
	public double getLng()
	{
		return this.lng;
	}
	public double getLat()
	{
		return this.lat;
	}
	public double getVal()
	{
		return this.val;
	}
	public void setLng(double _lng)
	{
		this.lng = _lng;
	}
	public void setLat(double _lat)
	{
		this.lat = _lat;
	}
	public void setVal(int _val)
	{
		this.val = _val;
	}
}
