$(function() {
	$('#add-anchor-link').on('click', function(){
		$('#add-links-container').delay(200).effect("highlight", {color:"#FFD2AD"}, 2000);
	});
	$('#signing-anchor-link').on('click', function(){
		$('#signup-container').delay(75).effect("highlight", {color:"#FFD2AD"}, 2000);
	});

	// $('.signup-modal-link').on('click', function(event){
	// 	event.preventDefault();
	// 	$('#signup-modal-holder').find('.modal').clone().appendTo('#modalHolder');
	// 	$('#modalHolder').find('.modal').modal('show');
	// });

	// $('.signup-modal-link').on('ajax:success', function(event, data, status, xhr){
	// 	$('#modalHolder').html(data);
	// 	$('#modalHolder').find('.modal').modal('show');
	// });

	$('#signup-modal-link').on('click', function(event){
		event.preventDefault();
		$('#signup-modal-holder').find('.modal').clone().appendTo('#modalHolder');
		$('#modalHolder').find('.modal').modal('show');
	});

	$("#modalHolder").on('ajax:success', '.signup-modal form', function(event, data, status, xhr){
		//display success
		//if it's added to this playlist, add bookmark
		//if it's added to some other list, give choice between staying here or going to that list
		$(this).find('.form-buttons').hide();
		console.log(data);
		if(data.success == "true")
		{
			$(this).find('.alert-container-success').show();
		} else {
			errorHTML = "";
			jQuery.each(data.errors, function(index, value){
				errorHTML += "<div class=\"alert alert-error\">"+value+"</div>";
			});
			//errorHTML += "</ul>"
			$(this).find('.alert-container-error').append(errorHTML);
			$(this).find('.alert-container-error').show();
		}
		//disable form
		//redirect to form page
	}).on('close', '.signup-modal form .alert', function(){
		$(this).after($(this).clone());
		$(this).parent().find('div').each(function(index){
			if(index > 1) {
				$(this).remove();
				console.log($(this).text());
			}
		});
	}).on('closed', '.signup-modal .alert', function(){
		//$('#modalHolder #signup-modal input[type=text]').val('');
		//$('#modalHolder #signup-modal input[type=password]').val('');
		$('#modalHolder .signup-modal .alert-container-success').hide();
		$('#modalHolder .signup-modal .alert-container-error').hide();
		$('#modalHolder .signup-modal .form-buttons').show();
	});
	$('.options a').tooltip({});
	if($('#temp-acct-popover-holder').length != 0){
		setTimeout(function() {
			$("#temp-acct-popover-holder").popover('show').next().on('click', function(){
				$("#temp-acct-popover-holder").popover('hide');
			});
			$('#temp-acct-popover-holder+.popover').effect("highlight", {color:"#FF4D60"}, 1000);
			$('#temp-acct-popover-holder+.popover').css('left',$('#temp-acct-popover-holder+.popover').position().left*1.8+'px');
		},1000);
	}
});


