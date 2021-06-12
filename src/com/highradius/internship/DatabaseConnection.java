package com.highradius.internship;
import java.sql.Connection; 
import java.sql.DriverManager; 
import java.sql.SQLException; 


//This class initializes a connection with the mySQL database using JDBC 
//JDBC stands for Java Database Connectivity. It's a Java API to connect and execute the query with the database

public class DatabaseConnection {
	private static Connection con= null;
	protected static Connection initializeDatabase() 
	        throws SQLException, ClassNotFoundException 
	    { 
			// Initialize all the information regarding
	       // Database Connection
	       if(con!=null)
	        return con;
	        String dbDriver = "com.mysql.jdbc.Driver"; 
	        String dbURL = "jdbc:mysql:// localhost:3306/"; 
	        String dbName = "winter_internship"; 
	        String dbUsername = "root"; 
	        String dbPassword = "kiit"; 
	  
	        Class.forName(dbDriver); 
	        Connection con = DriverManager.getConnection(dbURL + dbName, 
	                                                     dbUsername,  
	                                                     dbPassword); 
	        return con; 
	    } 
}
