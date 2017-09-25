/// <reference types="aws-sdk" />

const TABLE_NAME = "user_subscribe";
const USER_ID = "test_user_uuid";

function Unauthenticated_Login() {
	AWS.config.region = REGION;
	
	AWS.config.credentials = new AWS.CognitoIdentityCredentials({
		IdentityPoolId: POOL_ID,
	});

	AWS.config.credentials.get(function(){
		var accessKeyId = AWS.config.credentials.accessKeyId;
		var secretAccessKey = AWS.config.credentials.secretAccessKey;
		var sessionToken = AWS.config.credentials.sessionToken;
	});
}

function Get_User_Subscription() {
	var dynamodb = new AWS.DynamoDB({region: REGION});

	var scan_subscription = {
		TableName: TABLE_NAME,
		FilterExpression: "user_id = :id_value",
		ProjectionExpression: "user_id, user_subscription",
		ExpressionAttributeValues: {
			":id_value": {"S": USER_ID}
		}
	};
	dynamodb.scan(scan_subscription, function (err, data) {
		if (err)
			console.log(err, err.stack);
		else
			Show_User_Subscription(data);
	});
}

function Create_Site_Select() {
	var select_title = document.createElement("select");
	select_title.className = "subscription-select";
	var option_title_1 = document.createElement("option");
	option_title_1.value = "1";
	var text_title_1 = document.createTextNode("AWS-News");
	option_title_1.appendChild(text_title_1);
	var option_title_0 = document.createElement("option");
	option_title_0.value = "0";
	var text_title_0 = document.createTextNode("Others");
	option_title_0.appendChild(text_title_0);
	select_title.appendChild(option_title_1);
	select_title.appendChild(option_title_0);

	return select_title;
}

function Create_Keyword(contain) {
	var input_title = document.createElement("input");
	input_title.className = "subscription-input";
	input_title.value = contain;

	return input_title;
}

function Create_Delete_Button() {
	var button_title = document.createElement("button");
	button_title.type = "button";
	button_title.className = "btn btn-danger";
	text_title = document.createTextNode("Delete");
	button_title.appendChild(text_title);
	
	return button_title;
}

function Show_User_Subscription(data) {
	var subscription_list = document.getElementById("subscription-list");

	for (var key in data.Items[0].user_subscription.M) {
		var div_box = document.createElement("div");
		div_box.className = "subscription-box";

		var div_1 = document.createElement("div");
		div_1.className = "col-md-3 column";
		var div_2 = document.createElement("div");
		div_2.className = "col-md-6 column";
		var div_3 = document.createElement("div");
		div_3.className = "col-md-3 column";

		div_1.appendChild(Create_Site_Select());
		div_box.appendChild(div_1);
		div_2.appendChild(Create_Keyword(data.Items[0].user_subscription.M[key].S));
		div_box.appendChild(div_2);
		div_3.appendChild(Create_Delete_Button());
		div_box.appendChild(div_3);

		subscription_list.appendChild(div_box);
	}
}

function Submit_User_Subscription() {
	var subscription_select = document.getElementsByClassName("subscription-select");
	var subscription_input = document.getElementsByClassName("subscription-input");

	var index = subscription_select[0].selectedIndex;
	var text = subscription_select[0].options[index].text;
	var value = subscription_input[0].value;
	
	var dynamodb = new AWS.DynamoDB({region: REGION});
	var submit_subscription = {
		TableName: TABLE_NAME,
		Item : {
        	'user_id': {
            	'S': USER_ID
            },
			'user_subscription': {
				'M': {
					'AWS-News': {
						'S': value
					}
				}
			}
		}
	};
	dynamodb.putItem(submit_subscription, function (err, data) {
		if (err)
			console.log(err, err.stack);
		else
			alert("Update Successfully!");
	});
}

