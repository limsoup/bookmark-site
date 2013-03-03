$(function() {
	$('.options a').tooltip({});
	$('#add-anchor-link').on('click', function(){
		$('#add-links-container').delay(200).effect("highlight", {color:"#FFD2AD"}, 2000);
	});
	$('#signing-anchor-link').on('click', function(){
		$('#signup-container').delay(75).effect("highlight", {color:"#FFD2AD"}, 2000);
	});

	$('.signup-modal-link').on('click', function(event){
		event.preventDefault();
		$('#signup-modal-holder').find('.modal').clone().appendTo('#modalHolder');
		$('#modalHolder').find('.modal').modal('show');
	});

	$("#modalHolder").on('ajax:success', '#signup-modal form', function(event, data, status, xhr){
		//display success
		//if it's added to this playlist, add bookmark
		//if it's added to some other list, give choice between staying here or going to that list
		$(this).find('.alert-container-success').show();
		$(this).find('.form-buttons').hide();
		//disable form
		//redirect to form page
	})

});

