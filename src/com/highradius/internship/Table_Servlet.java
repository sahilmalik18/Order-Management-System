package com.highradius.internship;
import java.io.IOException;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/Table_Servlet")
public class Table_Servlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
   
    public Table_Servlet() {
        super();
        // TODO Auto-generated constructor stub
    }
    
    /*This Servlet accepts Page number and Search value(if any) and provides the ResultSet according to the query based on level of  
	user and pagination properties*/
    
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String search = request.getParameter("search");             //get the search value
		
		//defining pagination rules
		int page=1;
		int recordsPerPage=10;
		
		if(request.getParameter("page")!=null)						//get the page no. to display
			page=Integer.parseInt(request.getParameter("page"));
		HttpSession s = request.getSession(false);
		System.out.println(s);
		User u=(User)s.getAttribute("currentUser");					//get the details of user to know the level
		
		SQL_DAO dao=new SQL_DAO();						//Object of SQL_DAO class for accessing its method
		List<Result_Set> list;							//List of Result Set to be returned 
		
		int offset=(page-1)*recordsPerPage;				//starting Row number
		
		
		if(search!=null)   //it can be either a searched value or empty when the user erases from search    
		{
			if(search.isEmpty())   //equivalent to original dashboard page where search is null
				{
				   list= dao.viewAllRecord(offset,recordsPerPage,u.getOrder(),0,search);
				   search=null;
				}
			else
				list= dao.viewAllRecord(offset,recordsPerPage,u.getOrder(),1,search);
		}
		
		else   //search parameter is null i.e. search parameter hasn't been passed into the servlet
		{
			list= dao.viewAllRecord(offset,recordsPerPage,u.getOrder(),0,search);
		}
		
		
		int noOfRecords=dao.getNoOfRecords();	//fetches total no. of Records obtained from the query
		
		int noOfPages=(int)Math.ceil(noOfRecords*1.0/recordsPerPage); //calculating no. of pages
		int shownRec=page*recordsPerPage;  //no. of records to be shown in the page
		
		if(shownRec>noOfRecords)		//checking if no. of records to be shown in the page is exceeding total no. of actual records
		{
			shownRec=noOfRecords;
		}
		
		//setting attributes to the fields which need to be accessed in the Dashboard JSP files.
		request.setAttribute("search", search);
		request.setAttribute("tablelist",list);
		request.setAttribute("noOfPages",noOfPages);
		request.setAttribute("currentPage",page);
		request.setAttribute("start", offset);
		request.setAttribute("CustomersCount", noOfRecords);
		request.setAttribute("leftRec", shownRec);

		//Based on the user level and order-range, the user is directed to either of the dashboards.
		if(u.getOrder().equals("<=10,000")) {
			RequestDispatcher view=request.getRequestDispatcher("User_Dashboard.jsp");  //interface that helps to redirect to any servlet,url,jsp
			view.forward(request, response);
		}else {
			RequestDispatcher view=request.getRequestDispatcher("Manager_Dashboard.jsp");
			view.forward(request, response);
		}
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
