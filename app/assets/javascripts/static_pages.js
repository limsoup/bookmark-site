$(function() {
	$('.options a').tooltip({});
	$('#add-anchor-link').on('click', function(){
		$('#add-links-container').delay(200).effect("highlight", {color:"#FFD2AD"}, 2000);
	});
	$('#signing-anchor-link').on('click', function(){
		$('#signup-container').delay(75).effect("highlight", {color:"#FFD2AD"}, 2000);
	});
});

