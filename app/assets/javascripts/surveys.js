// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://coffeescript.org/


var apiCall = function() {
	var surveyUniqueId = gon.uniqueid

	var urll = 'localhost:3000/api/' + surveyUniqueId + '/restaurants/top'

	$.get({url: urll, dataType: 'jsonp'}).done(function(data){
		$("p#test").text(data)
	});
};

var apiTimer = function() {
	setInterval( function() {apiCall()}, 5000)	
};

$('#title').ready(function() { apiTimer();});

//apiTimer()




/*

var getSomeZen = function() {
	var url = "https://api.github.com/zen"
	var token = "0eda8ed1478a1709223b74e65df0c8f20b03ccab"

	$.get(url, {access_token: token}).done(function(data) {
		$("p#test").text(data);
	});
};

var timer = function() {
    setInterval(function() {getSomeZen()}, 5000);
};

$('#title').ready(function() {timer();});

*/