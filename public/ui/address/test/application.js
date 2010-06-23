// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
var NewTrail = new Object()
window.NewTrail = NewTrail;

NewTrail.check_validity = function(formData, jqForm, options) {
	if ($('#new_trail')[0].trail_place.value == NewTrail.default_place_value	){
		alert("please enter the name of the place your going to");
		NewTrail.preloader_hide();
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

	// setup date form picker
	$('#trail_date').datetime({
		userLang	: 'en',
		americanMode: true,
	});
	
	// replace spaces with _ on place
	$('#trail_place').keyup(function() {
	  $('#trail_place').val($('#trail_place').val().replace(/\s/gi,"_"));
	});
	
	$("#trail_place").autocomplete("/places/lookfor", {
		width: 260,
		highlight: false,
		selectFirst: false
	});
	
	//set default place value
	try{
		if ($('#trail_place').val() == "") $('#trail_place').val(NewTrail.default_place_value);
	}catch(e){alert(e)}
}
