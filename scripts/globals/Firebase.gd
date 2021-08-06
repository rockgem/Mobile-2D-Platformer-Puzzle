extends Node
# SINGLETON ----------------- !!

const API_KEY = "AIzaSyAzIC3nsN_5ZB0OLYfBhphjTveu-me_bIM"
const FIREBASE_URL = "https://balarila-d9c3a.firebaseio.com"

var token = ""


func postData(name, score, http: HTTPRequest):
	var body = {
		"name": name,
		"score": score,
		"returnSecureToken": true,
	}
	
	var err = http.request(FIREBASE_URL, [], false, HTTPClient.METHOD_POST, to_json(body))
	var result = yield(http, "request_completed") as Array
	
	print(result)
	if result [1] == 200:
		print("success")


func getData():
	pass
