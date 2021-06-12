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


@WebServlet("/Edit_Order_Servlet")
public class Edit_Order_Servlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    
    public Edit_Order_Servlet() {
        super();
        // TODO Auto-generated constructor stub
    }

//This servlet prepares and executes Sql Update statement to edit any row in the database based on info obtained from Edit-Form
    
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String sql="UPDATE order_details SET Order_Amount=?,Notes=?,Approval_Status=?,Approved_By=? WHERE Order_ID=?";
		
		//getting the fields from the Edit-Form
		int Order_ID = Integer.parseInt(request.getParameter("oid-edit"));
		int Order_Amount = Integer.parseInt(request.getParameter("oamt-edit"));
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
			PreparedStatement ts=con.prepareStatement(sql); //execute parameterized sql statement
			ts.setInt(5, Order_ID);
			ts.setInt(1, Order_Amount);					//set the parameters
            ts.setString(3, Approval_Status);
			ts.setString(4, Approved_By);
			ts.setString(2,Notes);
			int i = ts.executeUpdate();			//used to execute DML statements
			if(i!=0)
				System.out.println("Data Updated");		//checks whether atleast 1 row has been updated succesfully
			}catch(SQLException e) {
				e.printStackTrace();
			}catch(ClassNotFoundException e) {
				e.printStackTrace();
			}
			
		response.sendRedirect("Table_Servlet");	//redirects to Dashboard
	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
