package com.highradius.internship;

import java.sql.*;


//This class frames the sql query to verify the username and password entered in the login form

class Login_Authenticator {
	public User authenticate(String username,String password)		//return an object of User class
	{
		User u=null;		
		try {
				Connection con=DatabaseConnection.initializeDatabase();
				String sql="SELECT * FROM user_details WHERE username = ? and password = ?";
				PreparedStatement ps=con.prepareStatement(sql);		// It is used to execute parameterized query.
				ps.setString(1,username);
				ps.setString(2,password);		//set the parameter using setter method
				
				//ResultSet Object points to the first row of the entire dataset received after executing the query
				ResultSet rs=ps.executeQuery();		
				if(rs.next())
				{
					u=new User();			//create User Object
					u.setUsername(rs.getString("username"));
					u.setOrder(rs.getString("order_range"));
					
				
				}
				else
				{
					u=null;
				}
			}catch(Exception e)
			{
					e.printStackTrace();
			}
		return u;	//return user object
	}

}
