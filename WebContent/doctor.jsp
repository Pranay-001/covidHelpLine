<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
	<title>Doctor Portal</title>
	<link rel="icon" href="./static/icon.png"/>
	<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
</head>
<style>
	.btn{
		margin:0 5px;
	}
	.btn:hover{
		box-shadow:3px 3px 8px #888888;
	}
	.hide{
		display:none;
	}
	.show{
		display:inline-block;
	}
	body{
		background:url("./static/doctorBgimg.jpg");
		background-attachment: fixed;
		background-size:100vw 100vh; 
		background-repeat:no-repeat;
	}
	.table{
		width:80%;
	}
	.btn{
		margin:0px 2px;
	}
	th,td{
		text-align:center;
	}
</style>
<body>
	<div style="margin-left:20px;" class="container">
		
		<label style="margin-top:30px; width:100%; color:red;"><marquee>**Patient Status will be displayed in the table below**</marquee></label>
		<table id="example" class="table" style="margin-top:30px;">
			<thead class="bg-light">
				<tr style="border: 2px solid black">
					<th >Patient Name</th>
					<th >Oxygen Levels</th>
					<th >Blood Pressure</th>
					<th >Heart Rate</th>
					<th >Actions</th>
				</tr>
			</thead>
			<tbody style="background:white;border: 2px solid black">
				<tr>
				</tr>
			</tbody>
		</table>
	</div>
	<div class="modal fade" id="exampleModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
	  <div class="modal-dialog" role="document">
	    <div class="modal-content">
	      <div class="modal-header">
	        <h5 class="modal-title" id="exampleModalLabel">Online Prescription</h5>
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
	          <span aria-hidden="true">&times;</span>
	        </button>
	      </div>
	      <div class="modal-body">
	        <label>Medicine Name</label>
	        <input type="text" class="form-control" id="medicine_name" style="margin:10px 0;" required>
	        <label>Description</label>
	        <textarea id="medicine_description" class="form-control" required></textarea>
	      </div>
	      <div class="modal-footer">
	        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
	        <button type="button" class="btn btn-success" id="submit_btn">Submit</button>
	      </div>
	    </div>
	  </div>
	</div>
	<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
	<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
	<script>	
		var websocket=new WebSocket("ws://localhost:8080/covidHelpLine/VitalCheckEndPoint");
		var id=0;
		websocket.onmessage=function processVital(vital){
			var jsonData=JSON.parse(vital.data);
			if(jsonData.message!=null)
				{
					var details=jsonData.message.split(',');
					var values=details[1].split("`");
					var row=document.getElementById('example').insertRow();
					row.innerHTML="<tr>"+"<td>"+details[0]+"</td><td>"+values[0]+"</td><td>"+values[1]+"</td><td>"+values[2]+"</td><td><button class=\"btn btn-danger btn-sm mb-1\" onclick=\"sendInstructions('"+details[0]+"|"+values[3]+"|"+values[4]+"','ambulance',"+id+")\">Summon Ambulance</button><button type=\"button\" class=\"btn btn-primary btn-sm mb-1\" onclick=\"sendInstructions('"+details[0]+"','medication',"+id+")\">Suggest Medication</button></td>"+"</tr>";
					id++;
				}
		}
		function sendInstructions(username,message,p_id)
		{
			console.log(p_id);
			
			if(message=='medication')
			{
				$('#exampleModal').modal('show');	
				document.getElementById("submit_btn").addEventListener("click",function(){
					var medicine=medicine_name.value;
					var description=medicine_description.value;
					websocket.send(username+','+message+','+medicine+','+description);
					medicine_name.value="";
					medicine_description.value="";
					$('#exampleModal').modal('hide');
					afterEffects(p_id);
				});
			}
			else
			{
				websocket.send(username+','+message);	
				afterEffects(p_id);
			}
		}
		function afterEffects(p_id){
			var ele=document.getElementById("example").rows[p_id+2]
			ele.style.cursor="not-allowed";
			var childs=ele.getElementsByTagName("td")[4]["childNodes"];
			childs[0].disabled=childs[1].disabled=true;
			childs[0].style.pointerEvents =childs[1].style.pointerEvents = "none";
			ele.style.background="rgba(146, 228, 91, 0.8)";
		}
	</script>
</body>
</html>