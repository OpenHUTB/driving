//calculatePrice.js : JavaScript code to calculate the price of a bond.
function calculatePrice() 
{
	var cp = parseFloat(document.getElementById('coupon_payment_value').value);
	var np = parseFloat(document.getElementById('num_payments_value').value);
	var ir = parseFloat(document.getElementById('interest_rate_value').value);
	var vm = parseFloat(document.getElementById('facevalue_value').value);

	// A new XMLHttpRequest object
	var request = new XMLHttpRequest();
	//Use MPS RESTful API to specify URL
	var url = "http://localhost:9910/BondTools/pricecalc";
	
	//Use MPS RESTful API to specify params using JSON
	var params = { "nargout":1,
				   "rhs": [vm, cp, ir, np] };

	document.getElementById("request").innerHTML = "URL: " + url + "<br>"
			+ "Method: POST <br>" + "Data:" + JSON.stringify(params);

	request.open("POST", url);

	//Use MPS RESTful API to set Content-Type
	request.setRequestHeader("Content-Type", "application/json");

	request.onload = function()
	{   //Use MPS RESTful API to check HTTP Status
		if (request.status == 200) 
		{
			// Deserialization: Converting text back into JSON object
			// Response from server is deserialized 
			var result = JSON.parse(request.responseText);
			
			//Use MPS RESTful API to retrieve response in "lhs"
			if('lhs' in result)
			{  document.getElementById("error").innerHTML = "" ;
			   document.getElementById("price_of_bond_value").innerHTML = "Bond Price: " + result.lhs[0].mwdata; }
			else { document.getElementById("error").innerHTML = "Error: " + result.error.message; }
		}
		else { document.getElementById("error").innerHTML = "Error:" + request.statusText; }
		document.getElementById("response").innerHTML = "Status: " + request.status + "<br>"
				+ "Status message: " + request.statusText + "<br>" +
				"Response text: " + request.responseText;
	}
	//Serialization: Converting JSON object to text prior to sending request
	request.send(JSON.stringify(params)); 
}

//Get value from slider element of "document" using its ID and update the value field
//The "document" interface represent any web page loaded in the browser and
//serves as an entry point into the web page's content.
function printValue(sliderID, valueID) {
	var x = document.getElementById(valueID);
	var y = document.getElementById(sliderID);
	x.value = y.value;
}
//Execute JavaScript and calculate price of bond when slider is moved
function updatePrice(sliderID, valueID) {
	printValue(sliderID, valueID);
	calculatePrice();
}