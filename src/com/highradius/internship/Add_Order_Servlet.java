package com.highradius.internship;


import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


@WebServlet("/Add_Order_Servlet")
public class Add_Order_Servlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
   
    public Add_Order_Servlet() {
        super();
        // TODO Auto-generated constructor stub
    }

  //This servlet prepares and executes Sql Insert statement to insert a row in the database based on info obtained from ADD-Form
    
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String sql="INSERT INTO order_details VALUES(?,?,?,?,?,?,?,?)";
		
		//getting the fields from the Add form filled up
		int Order_ID = Integer.parseInt(request.getParameter("oid"));
		String Order_Date = request.getParameter("od");
		String Customer_Name = request.getParameter("cname");
		int Customer_ID = Integer.parseInt(request.getParameter("cnum"));
		int Order_Amount = Integer.parseInt(request.getParameter("oamt"));
		String Notes = request.getParameter("notes");
		String Approval_Status,Approved_By="";
		
		if(Order_Amount<=10000)		//if amount is less than 10,000 then it should be auto-approved
		{
			Approval_Status="Approved";
			Approved_By="David Lee";
		}
		else
			Approval_Status="Awaiting Approval";
		
		
		try {
			Connection con=DatabaseConnection.initializeDatabase();
			PreparedStatement ts=con.prepareStatement(sql);		//execute parameterized sql statement
			ts.setInt(1, Order_ID);
			ts.setString(2, Customer_Name);
			ts.setInt(3,Customer_ID);							//set the parameters
			ts.setInt(4, Order_Amount);
            ts.setString(5, Approval_Status);
			ts.setString(6, Approved_By);
			ts.setString(7,Notes);
			ts.setString(8, Order_Date);
			int i = ts.executeUpdate();							//used to execute DML statements
			if(i!=0)
				System.out.println("Data Inserted");			//checks whether atleast 1 row has been updated succesfully
			}catch(SQLException e) {
				e.printStackTrace();
			}catch(ClassNotFoundException e) {
				e.printStackTrace();
			}
			
		response.sendRedirect("Table_Servlet");					//redirects to Dashboard
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
