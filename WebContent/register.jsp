
<!DOCTYPE html>
<html>
<head>
    <style>
        body{
            margin: 12% 0 0 38%;
            background-color:#fff9d4; 
            width:70%;
		}
        input{
            float:right;
        }
    </style>
</head>

<body>
<h2>Enter your information to register: </h2>
<form name="newCust" action="validateReg.jsp" method="get">
    <div style='width:30%'>
        First Name: <input type="text" name="fn"/></br>
        Last Name: <input type="text" name="ln"/></br>
        Email: <input type="email" name="email"/></br>
        Phone Number:<input type="tel" name="tel"/></br>
        Address: <input type="text" name="addr"/></br>
        City: <input type="text" name="ct"/></br>
        State: <input type="text" name="st"/></br>
        Postal Code<input type="text" name="pc"/></br>
        Country: <input type="text" name="ctr"/></br>
        Your username:<input type="text" name="uname"/></br>
        Your password:<input type="text" name="pw"/></br></br>
        <input type="submit" name="Submit">
    </div>  
</form>
</body>
</html>