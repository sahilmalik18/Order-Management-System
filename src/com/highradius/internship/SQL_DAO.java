package com.highradius.internship;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import java.util.ArrayList;
import java.util.List;


/*This class/Java file frames the query based on pagination, search value (if any) and executes the query and returns the
  Result Set obtained */

public class SQL_DAO {
	
	private int noOfRecords;
	
	public SQL_DAO() {}
	
	/* offset-Record no. to start from(exclusive)
	   noOfRecords- no. of records to display as per pagination criteria
	   active_status- Whether the search field is active or not 
	   search- it contains the search value (null or as entered by the user)  
	 */
	
	public List<Result_Set> viewAllRecord(int offset,int noOfRecords,String order,int active_status, String search){
		String sql;
		if(active_status==1)  //user has activated the search field
		{
			//based on level and search value, the query is framed.
			if(order.equals("<=10,000"))
				sql="SELECT SQL_CALC_FOUND_ROWS * FROM order_details WHERE Order_Id LIKE ?  LIMIT "+ offset +","+noOfRecords;
			else if(order.equals(">10,000 and <=50,000"))
				sql="SELECT SQL_CALC_FOUND_ROWS * FROM order_details WHERE Order_Amount >=10000 AND Order_Amount <50000 AND Order_Id LIKE ? LIMIT "+ offset +","+noOfRecords;
			else
				sql="SELECT SQL_CALC_FOUND_ROWS * FROM order_details WHERE Order_Amount >=50000 AND Order_Id LIKE ? LIMIT "+ offset +","+noOfRecords;
			
		}
		else     //search field is not active
		{
		
			//based on level, the query is framed.
			if(order.equals("<=10,000"))
				sql="SELECT SQL_CALC_FOUND_ROWS * FROM order_details LIMIT "+ offset +","+noOfRecords;
			else if(order.equals(">10,000 and <=50,000"))
				sql="SELECT SQL_CALC_FOUND_ROWS * FROM order_details WHERE Order_Amount >=10000 AND Order_Amount <50000 LIMIT "+ offset +","+noOfRecords;
			else
				sql="SELECT SQL_CALC_FOUND_ROWS * FROM order_details WHERE Order_Amount >=50000 LIMIT "+ offset +","+noOfRecords;
		}
			
			
		//prepare the result set
		List<Result_Set> list=new ArrayList<Result_Set>();
		Result_Set res=null;
		try {
			Connection con=DatabaseConnection.initializeDatabase();
			PreparedStatement ts=con.prepareStatement(sql);	// It is used to execute parameterized query.
			if(active_status==1)		//if search field is active, then set the parameter of search
			{
				ts.setString(1,"%"+search+"%");		//set the parameter using setter method
			}
			ResultSet rs=ts.executeQuery();			//query is executed and stored in Object of ResultSet using setters
			while(rs.next()) {
				res=new Result_Set();
				res.setOrder_ID(rs.getInt("Order_ID"));
				res.setCustomer_Name(rs.getString("Customer_Name"));
				res.setCustomer_ID(rs.getInt("Customer_ID"));
				res.setOrder_Amount(rs.getInt("Order_Amount"));
				res.setApproval_Status(rs.getString("Approval_Status"));
				res.setApproved_By(rs.getString("Approved_By"));
				res.setNotes(rs.getString("Notes"));
				res.setOrder_Date(rs.getString("Order_Date"));;
				list.add(res);
			}
			rs.close();
			sql="SELECT FOUND_ROWS()";		//to detect total no. of rows obtained when query is executed exempting the LIMIT
			PreparedStatement ps=con.prepareStatement(sql);
			rs=ps.executeQuery();	//execute statements that returns tabular data, It returns an object of the class ResultSet
			if(rs.next())
				this.noOfRecords=rs.getInt(1);
		}catch(SQLException e) {
			e.printStackTrace();
		}catch(ClassNotFoundException e) {
			e.printStackTrace();
		}
		return list;
			
		}
	
	public int getNoOfRecords(){			//returns total no. of records
		return noOfRecords;
	}
}
