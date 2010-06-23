// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
var NewTrail = new Object()
window.NewTrail = NewTrail;

NewTrail.check_validity = function(formData, jqForm, options) {
	if ($('#new_trail')[0].trail_place.value == NewTrail.default_place_value	){
		$("#place_tag_error").text("Please enter a place name");
		$("#trail_place").addClass('input_error');
		NewTrail.preloader_hide();
		return false;
	}else if ($('#new_trail')[0].trail_place.value.length<4){
		$("#place_tag_error").text("Minimum 4 chars long");
		return false;
	}else{
		if (NewTrail.logged_in) NewTrail.preloader_show("saving");
		else NewTrail.preloader_show("going to twitter");
		
		return true;
	}
}

NewTrail.preloader_show = function(text) {
	$(".preloader").addClass("preloader_active");
	$(".preloader").text(text);
}
NewTrail.preloader_hide = function() {
	$(".preloader").removeClass("preloader_active");
	$(".preloader").text("");
}

NewTrail.proccess_response = function(responseText, statusText, xhr, $form) {
	if (statusText != "success"){
		alert("sorry en error has occured, please try again");
		NewTrail.preloader_hide();
		return
	}
	var info = "";
	try{info = eval("eval("+responseText+")");}catch(e){}
	if(info!="" && info.success==true ) {
		NewTrail.preloader_show("loading place");
		window.location = info.redirect_to;
	}else{
		$("#new_trail_wrapper").html(responseText);
	}
}

NewTrail.init_form = function (logged_in){
	NewTrail.default_place_value = "place_name";
	NewTrail.logged_in = logged_in;

	if (!NewTrail.logged_in) {
		$('#new_trail').attr("action","/session/new_save");
		$('#new_trail').attr("onsubmit","return NewTrail.check_validity('',this,'');");
	}else{
		//Ajaxify form
		NewTrail.options = { 
			beforeSubmit: NewTrail.check_validity,
			success: NewTrail.proccess_response 
		};
	  $('#new_trail').ajaxForm(NewTrail.options); 
	}

	$(function() {
		$('#trail_date').datepicker({
			changeMonth: true,
			changeYear: true,
      showTime: true,
			constrainInput: true,
		});
	});
	
	
	// replace spaces with _ on place
	$('#trail_place').keyup(function() {
	  $('#trail_place').val($('#trail_place').val().replace(/\s/gi,"_"));
	});
	
	$(function() {
		$("#trail_place").autocomplete({
			source: function(request, response) {
				$.ajax({
					url: "/places/",
					dataType: "xml",
					data: {
						featureClass: "P",
						style: "full",
						maxRows: 12,
						q: request.term
					},
					success: function(data) {
						response($.map($(data).find('record'), function(record) {
							var name = $(record).find('name').text();
							name = name=="" ? "" : " ("+name+")"
							return {
								label: $(record).find('tag').text()+ name,
								value: $(record).find('tag').text()
							}
						}))
					}
				})
			},
			minLength: 1,
			select: function(event, ui) {
				$("#data_add_member").val(ui.item ? ("Selected: " + ui.item.label) : "Nothing selected, input was " + this.value);
			},
			open: function() {
				$(this).removeClass("ui-corner-all").addClass("ui-corner-top");
			},
			close: function() {
				$(this).removeClass("ui-corner-top").addClass("ui-corner-all");
			}
		});

	});	
	
	//set default place value
	try{
		if ($('#trail_place').val() == "") $('#trail_place').val(NewTrail.default_place_value);
	}catch(e){alert(e)}
}




//********************************************/
// GMAPS
//********************************************/

var gmap = new Object()
window.gmap = gmap;

gmap.map;
gmap.marker;
gmap.marker_draggable = true;

gmap.geocodePosition = function(pos) {
  gmap.geocoder.geocode({
    latLng: pos
  }, function(responses) {
    if (responses && responses.length > 0) {
      gmap.updateMarkerAddress(responses[0].formatted_address);
    } else {
      // gmap.updateMarkerAddress('Cannot determine address at this location.');
    }
  });
}

gmap.updateMarkerPosition = function(latLng) {
	try{
		$("#place_long").val(latLng.lng());
		$("#place_lat").val(latLng.lat());
	}catch(e){}
}

gmap.updateMarkerAddress = function(str) {
	try{
		$('#place_address').val(str);
	}catch(e){}
}

gmap.initialize = function() {
	var latLng = new google.maps.LatLng(gmap.lat,gmap.long);
	gmap.map = new google.maps.Map(document.getElementById('mapCanvas'), {
	  zoom: 16,
	  center: latLng,
	  mapTypeId: google.maps.MapTypeId.ROADMAP
	});
	// map.addControl(new GSmallMapControl());
	
	var marker_options = {
		position: latLng,
		title: gmap.place_tag,
		map: gmap.map,
		draggable: gmap.marker_draggable
	}
	gmap.marker = new google.maps.Marker(marker_options);
	
	// map.addOverlay(new GMarker(point, markerOptions));

	// Update current position info.
	// updateMarkerPosition(latLng);
	// geocodePosition(latLng);

	// Add dragging event listeners.
	google.maps.event.addListener(gmap.marker, 'dragstart', function() {
	});

	google.maps.event.addListener(gmap.marker, 'drag', function() {
	  gmap.updateMarkerPosition(gmap.marker.getPosition());
	});

	google.maps.event.addListener(gmap.marker, 'dragend', function() {
	  gmap.geocodePosition(gmap.marker.getPosition());
	});
}
