<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
	<title>Patient Portal</title>
	<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
	<link rel="icon" href="./static/icon.png"/>
	<style>
	th,td{
		text-align:center;
	}
	</style>
</head>
<body style="background:url(./static/patientBgimg.jpeg); background-attachment: fixed;background-size:100vw 100vh; background-repeat:no-repeat;">
	<div style="display:none;" id="alt" class="alert alert-success alert-dismissible fade show" role="alert">
	  <strong>Success!!</strong> You will get updated soon.
	  <button type="button" onclick="hide()" class="close">
	    <span aria-hidden="true">&times;</span>
	  </button>
	</div>
	<div class="container" style="margin-left:0px; width:62%;">
	<div class="m-5" style="border-radius:5px;">
	<div align="center" class="bg-info">
	    <h3 class="mb-0 p-3">COVID HelpLine</h3>
	  </div>
	<div class="bg-light p-4" >
	  <div class="mb-3">
	    <label>Enter phone number :&nbsp;</label>
		<input class="form-control form-control-sm" type="number" name="phone" id="phone" style="display:inline-block; width:300px;margin-top:25px;"/>
	  </div>
	  <div class="mb-3">
	    <label>Enter Address :&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
		<input class="form-control form-control-sm" type="text" name="addr" id="addr" style="display:inline-block; width:300px;margin-top:25px;"/>
	  </div>
	  <div class="mb-3">
	   <label>Enter Oxygen Levels :&nbsp;&nbsp;</label>
		<input class="form-control form-control-sm" type="text" name="vital" id="vital" style="display:inline-block; width:300px;margin-top:25px;"/>
	</div>
	  <div class="mb-3">
	    <label>Enter Heart Rate :&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
		<input class="form-control form-control-sm" type="text" name="hr" id="hr" style="display:inline-block; width:300px;margin-top:25px;"/>
	</div>
	  <div class="mb-3">
	    <label>Enter Blood Pressure :&nbsp;</label>
		<input class="form-control form-control-sm" type="text" name="bp" id="bp" style="display:inline-block; width:300px;margin-top:25px;"/>
	</div>
	  <button onclick="sendVitals();" class="btn btn-success btn-sm">Submit</button>
	</div>
	</div>
	<br/>
		<table id="example" class="table">
			<thead class="bg-light">
				<tr style="border: 2px solid black">
					<th>Doctor</th>
					<th>Medicine</th>
					<th>Description</th>
				</tr>
			</thead>
			<tbody  style="background:white;border: 2px solid black">
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
		websocket.onmessage=function processVital(vital){
			var jsonData=JSON.parse(vital.data);
			if(jsonData.message!=null)
			{
				var details=jsonData.message.split(',');
				var row=document.getElementById('example').insertRow();
				if(details.length>2)
				{
					row.innerHTML="<td>"+details[0]+"</td><td>"+details[1]+"</td><td>"+details[2]+"</td>";		
				}
				else
				{
					alert(details[0]+" has summoned an ambulance");
					row.innerHTML="<td>"+details[0]+"</td><td></td><td>"+details[1]+"</td>";		
				}
			}
		}
		function hide(){
			document.getElementById("alt").style.display="none";
		}
		function sendVitals()
		{
			/*console.log(vital.value);
			System.out.println(bp.value);
			System.out.println(hr.value);*/
			let s0=vital.value+"`"+bp.value+"`"+hr.value+"`"+addr.value+"`"+phone.value;
			//console.log(s0);
			websocket.send(s0);
			/*websocket.send(bp.value);
			websocket.send(hr.value);
			websocket.send(addr.value);
			websocket.send(phone.value);*/
			vital.value=bp.value=hr.value=addr.value=phone.value="";
			document.getElementById("alt").style.display="block";
		}
	</script>
</body>
</html>