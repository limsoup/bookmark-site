$(function() {
	$('#create_temp_link').on('ajax:success', function(event, data, status, xhr){
		$(this).val('success');
	});
});
