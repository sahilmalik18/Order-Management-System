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
import javax.servlet.http.HttpSession;


@WebServlet("/Accept_Reject_Servlet")
public class Accept_Reject_Servlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
 
    public Accept_Reject_Servlet() {
        super();
        // TODO Auto-generated constructor stub
    }

//This Servlet uses sql query to update a row based on whether an order has been Accepted or Rejected

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String Approved_By;
		String Approval_Status;
		int Order_ID;
		
		int opt=Integer.parseInt(request.getParameter("option"));		//get the option of accept or reject
		//1 for approved and 2 for reject
		
		if(opt==1)		
		{
			Approval_Status="Approved";
			Order_ID=Integer.parseInt(request.getParameter("oid-app"));
		}
		else
		{
			Approval_Status="Rejected";
			Order_ID=Integer.parseInt(request.getParameter("oid-rej"));
		}
		
		HttpSession s= request.getSession(false);		//get the details of the current user so that it can be used to fill in 
		User u=(User)s.getAttribute("currentUser");     // Approved_By column
		
		Approved_By=u.getUsername();
		
		String sql="UPDATE order_details SET Approval_Status=?, Approved_By=? WHERE Order_ID=?";
		
		try {
			Connection con=DatabaseConnection.initializeDatabase();
			PreparedStatement ts=con.prepareStatement(sql);			//execute parameterized sql statements
			ts.setInt(3, Order_ID);
            ts.setString(1, Approval_Status);					//set the parameters
			ts.setString(2, Approved_By);
			
			int i = ts.executeUpdate();						//used to execute DML statements
			if(i!=0)
				System.out.println("Data Updated");			//checks whether atleast 1 row has been updated succesfully
			}catch(SQLException e) {
				e.printStackTrace();
			}catch(ClassNotFoundException e) {
				e.printStackTrace();
			}
			
		response.sendRedirect("Table_Servlet");				//redirects to Dashboard
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
