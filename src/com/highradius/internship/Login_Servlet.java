package com.highradius.internship;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


@WebServlet("/Login_Servlet")
public class Login_Servlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    
    public Login_Servlet() {
        super();
        // TODO Auto-generated constructor stub
    }

//This servlet is used to get the parameters from the login form and authenticate with the database given	
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		//getting the fields
		String username = request.getParameter("name");
		String password = request.getParameter("pass");

		//authentication

		Login_Authenticator authenticator=new Login_Authenticator();  //Object of Login_Authenticator class where authentication takes place
		User u=authenticator.authenticate(username,password); //return an object of valid user if it matches with database 
		RequestDispatcher rd=null;
		if(u!=null)
		{										//if valid user, then redirected to Dashboard page and Session is started
		   rd=request.getRequestDispatcher("Table_Servlet");
		   HttpSession s=request.getSession();
		   s.setAttribute("currentUser",u);
		 
		 
		}
		else {									//not valid user, so it will be redirected to login page with an error message.

		request.setAttribute("errorMessage", "Invalid user or password");
		rd=request.getRequestDispatcher("/index.jsp");
		}
		rd.forward(request,response);
	}
}


