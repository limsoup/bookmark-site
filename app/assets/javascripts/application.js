// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require_tree .



$(function() {


	$('.info-pane-button').on('click', function(){
		//scroll to anchor
		$('#info-pane').slideToggle().delay(1000).next().next('hr').toggle();
		$('.info-pane-button').parent().toggle();
		if($('#detail_bookmark_view_container').css('position')=='fixed'){
			$('#detail_bookmark_view_container').css('position','absolute')
		}else{
			$('#detail_bookmark_view_container').css('position','fixed')
		}
		//$('body').toggleClass('open');
	});

	$('#login-btn').on('click',function(){
		$(this).hide();
		$('#nav-login').show();
	});

	if($('#introduction').length != 0) {
		$('.info-pane-button').first().delay(1500).trigger('click');
	}

	if($('.countdown').length != 0){
		setInterval(function(){
			if ($('.countdown').text() > '0'){
				$('.countdown').text( (parseInt($('.countdown').text())-1).toString() );
			} else {
				window.location = '/welcome';
			}
		},1000);
	}
	
});