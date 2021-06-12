<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>

	<%@page import="java.sql.*"%>
	<%@page import="com.highradius.internship.*"%>
    <%@page import="com.highradius.internship.Result_Set" %>
    <%@page import="java.util.List" %>
    <%@page import="java.util.*"%>
	
	 <!-- To access details of the User of the Current Session  -->
	<%
	User u=(User)session.getAttribute("currentUser");
	System.out.println(u);
	if(u==null)
	{
		response.sendRedirect("index.jsp");
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

<title>User Dashboard</title>
<link rel="stylesheet" href="css/user_dash.css">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet"/>

<!--Contains CSS of the entire body font, Add and Edit buttons, Previous and Next Buttons, Search text box, Add and Edit popup forms-->

<style>
body
{
	font-family:roboto;
}

input[type="checkbox"]
{
     background: darkorange;
     border: darkorange 1px solid;
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
	
.Custt
{
	float:right;
	font-size:14px;
	padding-right:5px;
	padding-top:10px;

}
	
.popup,.popup-edit
{
	background: rgba(0,0,0,0.3);
	width:100%;
	height:100%;
	position:absolute;
	top:0;
	left:0;
	justify-content:center;
	align-items:center;
	text-align:center;
}
	
.popup-content,.popup-content-edit
{
	height:300px;
	width:500px;
	background:#fff;
	padding:20px;
	border-radius:5px;
	position:relative;
}

h3 
{
	margin: 0;
  	text-align:left;
  	padding-bottom: 7px;
	position: relative;
	border-bottom: 2px solid #ccc;
}
	
h3:before 
{
   position: absolute;
   background: darkorange;
   height: 2px;
   content: '';
   width: 120px;
   bottom: -2px;
   left: 0;
}
	
label
{
    display: inline-block;
    width: 150px;
}
	
input[type=text],input[type=number] 
{
  display: inline-block;
  border:none;
  border-bottom: 2px solid #D3D3D3;
}

input[type=text].search
{
	float:right; 	  
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
	
input[type=submit]
{
	width:100px;
	background:#ff6700;
	padding-top:4px;
	padding-bottom:4px;
	border-radius:6px;
	color:white;
	border-color:white;
	font-size:14px;
	position:absolute;
	left:225px;
}

.close,.close-edit
{
	position:absolute;
	top:0;
	right:14px;
	font-size:30px;
	transform: rotate(45deg);
	cursor:pointer;
}
	
.button-edit 
{
    width:9%;
	height:28px;
	background:#ff6700;
	border-radius:6px;
	color:white;
	text-align:center;
	border:none;
	font-size:16px;
	text-align:center;
	cursor:pointer;
}
	
.button-edit[disabled]	
{
	background:grey;
	cursor:default;
}
	
button.butta
{
	display:inline-block;
	width:9%;
	height:28px;
	background-color:#ff6700;
	text-align:center;
	border-radius:6px;
	border:none;
	color:white;
	cursor:pointer;
	font-size:16px;
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
			<div class="but">         <!-- Add and Edit buttons -->
				
				<button class="butta" id="button" >ADD</button>
				 
				<button type="button" class="button-edit" id="button-edit" disabled onclick="Editform()">EDIT</button>
				
											    <!-- Form of Search box redirecting to a Servlet -->
				<form action="Table_Servlet">	
					<input class="search" type="text" onchange="this.form.submit()" id="search" name="search" placeholder="&#xF002;  Search Order_ID" 
					       style="font-family:roboto, FontAwesome; position:absolute; top:116px; right:45px;"/>
				</form>
				
			</div>
			<br>												<!--  Pop-up form display for ADD Button -->
			<div class="popup" style="display:none">		
    			<div class="popup-content">
	    			<div class="close">+</div>					<!--  Redirects to Add_Order Servlet -->
	    			<h3 style="color:grey">ADD ORDER</h3><br>
	    			<form action="Add_Order_Servlet" style="font-size:15px; color:grey; text-align:left; padding-left:100px">
	    				<label>Order ID</label><input type="number" name="oid" id="oid" required><br><br>
	    				<label>Order Date</label><input type="text" name="od" id="od" required><br><br>
	    				<label>Customer Name</label><input type="text" name="cname" id="cname" required><br><br>
	    				<label>Customer Number</label><input type="number" name="cnum" id="cnum" required><br><br>
	    				<label>Order Amount</label><input type="number" name="oamt" id="oamt" required><br><br>
	    				<label>Notes</label><input type="text" name="notes" id="notes" required><br><br>
	    				<input type="submit" value="ADD">
	    				
	    		   </form>
 				</div>
   		 	</div>
   		 	
   		 	<div class="popup-edit" style="display:none">		<!--  Pop-up form display for EDIT Button -->
	    		<div class="popup-content-edit">
	    			<div class="close-edit">+</div>					<!--  Redirects to Edit_Order Servlet -->
	    			<h3 style="color:grey">EDIT ORDER</h3><br><br>
	    			<form action="Edit_Order_Servlet" style="font-size:15px; color:grey; text-align:left; padding-left:100px">
	    				<label>Order ID</label><input type="text" name="oid-edit" id="oid-edit" readonly><br><br>
	    				<label>Order Amount</label><input type="text" name="oamt-edit" id="oamt-edit" value="0" 
	    					   onchange="myFunction(this.value)" required><br><br>
	    				<label>Notes</label><input type="text" name="notes" id="notes" required><br><br>
	    				<label>Approval_By</label><input type="text" name="aby" id="aby" readonly><br><br><br>
	    				<input type="submit" value="SUBMIT">
	    		   </form>
	    		</div>
   		 	</div>
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
													<!-- Iterating through the ResultSet and fitting into the GRID -->
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
								<td><input type="checkbox" class="check" onclick='markRow(<%=i%>)' style="background:darkorange; border: darkorange 1px solid; "/></td>
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
	
   		
   		//script for ADD Button
		document.getElementById('button').addEventListener('click',function()
		{
			document.querySelector('.popup').style.display='flex';
		});
	
		document.querySelector('.close').addEventListener('click',function()
		{
			document.querySelector('.popup').style.display='none';
		});
		
		
		//script for Edit button 
		function Editform()
		{
			document.querySelector('.popup-edit').style.display='flex';
		}
	
		document.querySelector('.close-edit').addEventListener('click',function()
				{
		document.querySelector('.popup-edit').style.display='none';
		});
		
		
		//script for checkbox 
		function markRow(rowNumber) 
		{
				 
    			var row = document.getElementsByClassName('rowclass');
    			var checkboxes = document.getElementsByClassName('check');
    			
    			
    			if(checkboxes[rowNumber-1].checked==false)             //unchecking the check box
    			{
    				 if((rowNumber-1)%2!=0)
    					 row[rowNumber-1].style = "background-color: transparent";
     			    else
     			    	row[rowNumber-1].style = "background-color:#EFF9FD";
    				
    				document.getElementById("button-edit").disabled = true;
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
    		     document.getElementById("button-edit").disabled = false;
    		     
	    		//script for auto-filling Order Id
	    	  	document.getElementById('oid-edit').value = (row[rowNumber-1].getElementsByTagName('td')[1]).textContent;
	    	    
  		}
		
		//script for auto filling Approval By based on amount
		function myFunction(val) 
		{
			if(val<=10000)
				document.getElementById('aby').value="David Lee";
			else if(val<=50000)
				document.getElementById('aby').value="Laura Smith";
			else
				document.getElementById('aby').value="Matthew Vance";
		}
		    	
	</script>
	
</body>
</html>