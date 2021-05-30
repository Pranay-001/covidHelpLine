<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
	<title>Ambulance Portal</title>
	<link rel="icon" href="./static/icon.png"/>
	<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
	<style>
		body{
			background:url("./static/ambulanceBgimg.jpg");
			background-attachment: fixed;
			background-size:100vw 100vh; 
		background-repeat:no-repeat;
		}
		td{
			color:white;
		}
		
		th,td{
			text-align:center;
		}
	</style>
</head>
<body>
	<div class="container">
		<label style="margin-top:30px; width:100%; color:red;"><marquee>**You Will be Notified when a patient requires ambulance**</marquee></label>
		<table id="example" class="table" style="margin-top:30px;">
			<thead class="bg-light">
				<tr style="border: 2px solid black">
					<th>Patient Name</th>
					<th>Phone</th>
					<th>Address</th>
					<th>Description</th>
					<th> Attended </th>
				</tr>
			</thead>
			<tbody style="border: 2px solid black">
				<tr>
				</tr>
			</tbody>
		</table>
	</div>

	<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
	<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
	<script>
		var websocket=new WebSocket("ws://localhost:8080/covidHelpLine/VitalCheckEndPoint");
		var id=1;
		websocket.onmessage=function processMessage(message){
			var jsonData=JSON.parse(message.data);		
			if(jsonData.message!=null)
			{
				var details=jsonData.message.split(',');
				var values=details[0].split("|");
				var row=document.getElementById('example').insertRow();
				row.innerHTML="<tr id="+id+"><td>"+values[0]+"</td><td>"+values[2]+"</td><td>"+values[1]+"</td><td>"+details[1]+"</td><td><input onclick=attended("+id+") type='checkbox'/></tr>";
				row.style.background="rgba(255,0,0,0.8)";
				id++;
				alert(values[0]+" requires an ambulance");
			}
		}
		function attended(p_id){
			let ele=document.getElementById("example").rows[p_id+1].childNodes[4];
			if(ele.getElementsByTagName("input")[0].checked)		document.getElementById("example").rows[p_id+1].style.background="rgba(146, 228, 91, 0.8)";
			else document.getElementById("example").rows[p_id+1].style.background="rgba(255,0,0,0.8)";
		}
	</script>
</body>
</html>