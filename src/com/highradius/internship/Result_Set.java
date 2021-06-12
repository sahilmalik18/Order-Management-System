package com.highradius.internship;

//This class/Java file aims to store each row as an object of Result_Set and multiple rows as a list of Objects.
//consists of getter and setter methods for each column

public class Result_Set {
	public int Order_ID;
	public String Customer_Name;
	public int Customer_ID;
	public int Order_Amount;
	public String Approval_Status;
	public String Approved_By;
	public String Notes;
	public String Order_Date;
	   
	public int getOrder_ID() {
	return Order_ID;
	}
	public void setOrder_ID(int order_ID) {
	this.Order_ID = order_ID;
	}
	
	
	public String getCustomer_Name() {
	return Customer_Name;
	}
	public void setCustomer_Name(String customer_Name) {
	this.Customer_Name = customer_Name;
	}
	
	
	public int getCustomer_ID() {
	return Customer_ID;
	}
	public void setCustomer_ID(int customer_ID) {
	this.Customer_ID = customer_ID;
	}
	
	
	public int getOrder_Amount() {
	return Order_Amount;
	}
	public void setOrder_Amount(int order_Amount) {
	this.Order_Amount = order_Amount;
	}
	
	
	public String getApproval_Status() {
	return Approval_Status;
	}
	public void setApproval_Status(String approval_Status) {
	this.Approval_Status = approval_Status;
	}
	
	
	public String getApproved_By() {
	return Approved_By;
	}
	public void setApproved_By(String approved_By) {
		if(approved_By!=null)
			this.Approved_By = approved_By;
		else
			this.Approved_By="";
	}
	
	
	public String getNotes() {
	return Notes;
	}
	public void setNotes(String notes) {
		if(notes!=null)
			this.Notes = notes;
		else
			this.Notes="";
	}
	
	public String getOrder_Date() {
	return Order_Date;
	}
	public void setOrder_Date(String order_date) {
	this.Order_Date = order_date;
	}
}
