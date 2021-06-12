<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@page import="java.sql.*" %>
    <%@page import="com.highradius.internship.*" %>
    <%@page import="com.highradius.internship.Result_Set" %>
    <%@page import="java.util.*"%>
    
    <!-- To access details of the User of the Current Session  -->
    <%
    User u=(User)session.getAttribute("currentUser");
    if(u==null)
    {
    	response.sendRedirect("index.html");
    }
    %>

<%
	 ArrayList<Result_Set> list = (ArrayList<Result_Set>)request.getAttribute("tablelist");   //List of Result Set obtained after running a SQL query
	 int cp=(int)request.getAttribute("currentPage");  //Get the current page no. shown in the dashboard 
	 int tp=(int)request.getAttribute("noOfPages");    //total no. of pages based on pagination & total no. of records to be shown
	 int cust=(int)request.getAttribute("CustomersCount"); //range of rows presently shown in the dashboard 
	 int st=(int)request.getAttribute("start");   //starting record number
	 int lr=(int)request.getAttribute("leftRec");  //how many records are to be shown
	 String sv=(String)request.getAttribute("search");  //search value from the search text box 
%>


<!DOCTYPE html>
<html>
<head>

<title>Manager_Dashboard</title>
<link rel="stylesheet" href="css/manager_dash.css">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet"/>

<!--Contains CSS of the entire body font, Previous and Next buttons , Accept and Reject Buttons and Search text box-->
<style>					
body{

   font-family:roboto;
}
	
a {
  text-decoration: none;
  display: inline-block;
  padding: 8px 16px;
}
	
.previous {
  background-color:  #EFF9FD;
  color:  #00BFFF;
}
	
.next {
  background-color:  #EFF9FD;
  color:  #00BFFF;
}
	
.round {
  border-radius: 20%;
}
	
.Custt{
	float:right;
	font-size:14px;
	padding-right:10px;
	padding-top:10px;
	
}

input[type=text].search
{
	float:right;
	position:absolute;  	  
	width: 190px;
	box-sizing: border-box;
	border: 0px solid #ccc;
	border-radius: 6px;
	font-size: 14px;
	background-color: #EFF9FD;
	padding: 10px 18px 10px 10px;
	-webkit-transition: width 0.4s ease-in-out;
	transition: width 0.4s ease-in-out;
}
		
	
#cp
{
	display:inline-block;
	width:3%;
	height:35px;
	background:#EFF9FD;
	text-align:center;
	border-radius:6px;
	border:none;
	color:black;
	font-family:roboto;
	font-size:16px;
}
	
.button-app
{
    width:100%;
	height:28px;
	padding:5px 5px 5px 5px;
	padding-left:7px;
	padding-right:7px;
	background:#FC7500;
	border-radius:6px;
	color:white;
	border:none;
	font-size:16px;
	text-align:center;
	cursor:pointer;
}
	
.button-rej 
{
	width:100%;
	height:28px;
	padding-left:18px;
	padding-right:18px;
	background:#FC7500;
	border-radius:6px;
	color:white;
	border:none;
	font-size:16px;
	text-align:center;
	cursor:pointer;
}
	
.button-app[disabled],.button-rej[disabled]	
{
	background:grey;
	cursor:default;
}

form 
{
	font-size:16px;
	display:inline-block;
}

</style>
</head>
<body>

	<!-- The logos of the Dashboard Page -->
	
	<div class="row">
		<div class="col">
		<img src="./images/hrc-logo.svg" width="90%" height="10%"/>
		</div>
		<div class="col">
		<img src="./images/abc-logo.png" width="100%" height="10%"/>
		</div>
	</div>
	
	<!-- Creating the Grid UI, Here the box represents the grey back and Box-in represents the White card  -->
	
	<div class="box">
		<div class="box-in">
			<div class="but" style="display:inline;">
			
										<!-- Form of Approve Button redirecting to a Servlet with hidden value=1 and Order_ID -->	
				<form action="Accept_Reject_Servlet">
					<input type="submit" class="button-app" id="button-app" disabled value="APPROVE">
					<input type="hidden" name="oid-app" id="oid-app">
					<input type="hidden" name="option" id="option" value="1">
				</form>
				
										<!-- Form of Search box redirecting to a Servlet with hidden value=2 and Order_ID -->
				<form action="Accept_Reject_Servlet">
					<input type="submit" class="button-rej" id="button-rej" disabled value="REJECT">
					<input type="hidden" name="oid-rej" id="oid-rej">
					<input type="hidden" name="option" id="option" value="2">
				</form>
				
									 	<!-- Form of Search box redirecting to a Servlet -->
				<form action="Table_Servlet">
					<input class="search" type="text" onchange="this.form.submit()" id="search" name="search" placeholder="&#xF002;  Search Order_ID" 
					       style="font-family:roboto, FontAwesome; position:absolute; top:116px; right:45px;"/>
				</form>
			</div>
			<br><br>
			
																		<!--  Creating the GRID UI -->
			<div class="table">
				<table id="customer_head">
					<tr>
						<th>&nbsp;</th>
						<th>Order ID</th>
						<th>Customer Name</th>
						<th>Customer ID</th>
						<th>Order Amount</th>
						<th>Approval Status</th>
						<th>Approved By</th>
						<th>Notes</th>
						<th>Order Date</th>
						
					</tr>
																	<!-- Iterating through the Result_Set and fitting into the GRID -->
					  <%	
		  		    int i=0; //marking the rownumber useful for checkbox
		  			// Iterating through list
					if(request.getAttribute("tablelist") != null)  
					{
						Iterator<Result_Set>iterator = list.iterator();  // Iterator interface
						
						while(iterator.hasNext())  // iterate through all the data until the last record
						{
							Result_Set res = iterator.next();
							i++;
						%>
						<!-- Assigning ID to checkBox to easily identify on click -->
						
						<tr class="rowclass">				
								<td><input type="checkbox" class="check" onclick='markRow(<%=i%>)'/></td>
								<td><%=res.getOrder_ID()%></td>
								<td><%=res.getCustomer_Name() %></td>
								<td><%=res.getCustomer_ID() %></td>
								<td><%=res.getOrder_Amount() %></td>
								<td><%=res.getApproval_Status()%></td>
								<td><%=res.getApproved_By() %></td>
								<td><%=res.getNotes()%></td>
								<td><%=res.getOrder_Date()%></td>
						</tr>
						<%
						}
					}
					%>
				</table>
				<br>
				
				<!-- st - Number of the starting record of the current page 
					 lr - Number of records being shown in the page
					 cust - Total no. of customers or records for a particular query
					 cp - Current Page No. 
					 tp- Total No. of pages / Last Page no. 
					 sv - Search value (if any)
				 -->
				
				<!--  showing customers range -->
				<div class="Custt">Customers <%=st+1%>-<%=lr%> of <%=cust%> </div>	
				
				
				<!-- previous and next buttons -->
		    	<div class="prev-next">
   		 	
		   		 							<!-- This is for << button  -->
		   		 	<%if (sv==null)
		   		 	{%>                   
		   		 		<a href="Table_Servlet?page=1" class="previous round">&laquo;</a>
		   		 	<%}
		   		 	else
		   		 	{%>
		   		 		<a href="Table_Servlet?page=1&search=<%=sv%>" class="previous round">&laquo;</a>
		   		 	<%} %>	
		   		 	
		   		 							<!-- This is for < button  -->
		   		 		
		   		   	<%if (cp>1)				 
		   		   	{
		   		   		if(sv==null)
		   		   		{%>					
				 			<a href="Table_Servlet?page=<%=cp-1%>" class="previous round">&#8249;</a>
				 		<%}
		   		   		else
		   		   		{%>
				 			<a href="Table_Servlet?page=<%=cp-1%>&search=<%=sv%>" class="previous round">&#8249;</a>
				 		<%}
		   		   	}
		   		   	else
		   		   	{
				 		if(sv==null)
				 		{%>
				 			<a href="Table_Servlet?page=1" class="previous round">&#8249;</a>
				 		<%}
				 		else
				 		{%>
				 		    <a href="Table_Servlet?page=1&search=<%=sv%>" class="previous round">&#8249;</a>
				 		<%}
				 	}%>
				 		
				 	
				 	
				 	
				 	Page <button id="cp"><%= cp%></button> of <%= tp%>
				 	
				 	
				 				 						<!-- This is for > button  -->
				 	<%if (cp<tp) 
				 	{					
				 		if(sv==null)
				 		{%>	
				 			<a href="Table_Servlet?page=<%=cp+1%>" class="next round">&#8250;</a>
				 		<%}
				 		else
				 		{%>
				 			<a href="Table_Servlet?page=<%=cp+1%>&search=<%=sv%>" class="next round">&#8250;</a>
				 		<%}
				 	}
				 	else
				 	{
				 		if(sv==null)
				 		{%>
				 			<a href="Table_Servlet?page=<%=tp%>" class="next round">&#8250;</a>
				 		<%}
				 		else
				 		{%>
				 			<a href="Table_Servlet?page=<%=tp%>&search=<%=sv%>" class="next round">&#8250;</a>
				 		<%}
				 	}%>
				 		
				 		
				 										 
				 										 <!-- This is for >> button  -->
				 	<%if (sv==null)
				 	{%>
				 		<a href="Table_Servlet?page=<%=tp%>" class="next round">&raquo;</a>  
				 	<%}
				 	else
				 	{%>
				 		<a href="Table_Servlet?page=<%=tp%>&search=<%=sv%>" class="next round">&raquo;</a>  
				 	<%} 
				 	%>	
		    	</div>
			</div>
		</div>
	</div>
	
	
	<script>
   		
	  // check if the search field is empty or not
		if(<%=sv%>!=null)
		{
    		document.getElementById('search').value=<%=sv%>; //if not we will show the searched value in the box 
    	}
	
		//script for checkbox
   		function markRow(rowNumber) 
   		{
   				 
       			var row = document.getElementsByClassName('rowclass');
       			var checkboxes = document.getElementsByClassName('check');
       			
       			
       			if(checkboxes[rowNumber-1].checked==false)		//uncheck the checkbox
       			{
       				 if((rowNumber-1)%2!=0)
       					 row[rowNumber-1].style = "background-color: transparent";
        			    else
        			    	row[rowNumber-1].style = "background-color:#EFF9FD";
       				
       				document.getElementById("button-app").disabled = true;
       				document.getElementById("button-rej").disabled = true;
       				return;
       			}
       			
       			
       			//else clear everything
       			for (var i = 0; i < row.length; i++) {
       			    if(i%2!=0)
       					row[i].style = "background-color: transparent";
       			    else
       			    	row[i].style = "background-color: #EFF9FD";
       			  }

       		     for (var i = 0; i < checkboxes.length; i++) {
       			    checkboxes[i].checked = false;
       			  }
       			
       		     // check the checkbox and color the row
       			 checkboxes[rowNumber-1].checked = true;
       		     row[rowNumber-1].style = "background-color: #ffd17a";
       		     
				let app_status=(row[rowNumber-1].getElementsByTagName('td')[5]).textContent;
				
				//checking if the status is already approved or rejected, then showing an alert box and disabling both the buttons
				
   	    		if(app_status != "Awaiting Approval") 
   	    		{
   	    			alert("Already " + app_status+" !");
   	    			document.getElementById("button-app").disabled = true;
   	       		  	document.getElementById("button-rej").disabled = true;
					return;
   	    		}
				
				//if all good, enabling both the buttons 
				document.getElementById("button-app").disabled = false;
       		  	document.getElementById("button-rej").disabled = false;
       		  	
       		  	//setting the Order-Id to be sent to the servlet when any of the buttons is pressed
       		 	document.getElementById("oid-app").value=(row[rowNumber-1].getElementsByTagName('td')[1]).textContent;
       		 	document.getElementById("oid-rej").value=(row[rowNumber-1].getElementsByTagName('td')[1]).textContent;
     		}
   	
   		</script>
	
</body>
</html>