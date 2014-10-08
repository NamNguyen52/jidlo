# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

var apiCall = function(){
	var surveyUniqueId = gon.uniqueid

	var url = 'localhost:3000/api' + surveyUniqueId + 'restaurants/top'

	$.get(url).done(function(data){
		$.("p#test").text(data)
	});
};

var apiTimer = function() {
	setInterval( function() {apiCall()}, 3000)	
};