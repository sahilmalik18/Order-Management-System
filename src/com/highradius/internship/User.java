package com.highradius.internship;

//This is a User class used for Storing and retrieving the details of the User of the Current Session using Getter and Setter methods.

public class User {
	String username,order_quant;
    public User()
    {
    	
    }
    
    public User(String username,String order) {
    	this.username=username;
       	this.order_quant=order;
    }
    
    
    public String getUsername() {
    	return username;
    }
    
    public void setUsername(String username)
    {
    	this.username=username;
    }
    
     
    public String getOrder() {
    	return order_quant;
    }
    
    public void setOrder(String order)
    {
    	this.order_quant=order;
    }
    
    
}