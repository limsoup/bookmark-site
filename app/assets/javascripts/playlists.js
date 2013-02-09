// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


(function( $ ) {
  $.fn.bookmarkSetup = function (){
		this.find('a.edit_bookmark_button').on('click', function(event){
			event.preventDefault();
			$(this).parents('.show_bookmark').first().hide().next().show();
		});
		this.find('a.show_bookmark_button').on('click', function(event){
			event.preventDefault();
			$(this).parents('.edit_bookmark').first().hide().prev().show();
		});
		this.find('a.remove_bookmark').on('ajax:success', function(){
			$(this).parents('.bookmark').first().remove();
		});
		this.find('form').on('ajax:success', function(event, data, status, xhr){
			if($(this).is(event.target))
			{
				$(this).parents('.bookmark').first().html(data).bookmarkSetup();
			}
		});
		//when edit fields input changes
		this.find('input.edit_bookmark_fields').on('change', function (){
			$(this).parent().siblings().first().hide().next().show().next().show().next('.move_bookmark').hide(); 
			//hides the 'collapse', shows the 'reveal' and 'save', and hides the 'move'
		});
		//revert (show) or save (update)
		this.find('.reload_edit_bookmark_button').on('ajax:success', function(event, data, status, xhr){
			$(this).parents('.bookmark').first().html(data).bookmarkSetup();
		});
		this.find('.update_bookmark_button').on('click', function(){
			$(this).parents('form').submit();
		}).on('ajax:success', function(event, data, status, xhr){
			$(this).parents('.bookmark').first().html(data).bookmarkSetup();
		});
		//move bookmark
		this.find('.move_bookmark_submit').on('ajax:before', function(event){
			var sendBack = {};
			sendBack.moveType = $(this).siblings('[name=user_bookmark_move]:checked').first().val();
			sendBack.destination = $(this).siblings('[name=user_bookmark_move_paste]').first().val();
			$(this).data('params',jQuery.param(sendBack));
		}).on('ajax:success', function(event, data, status, xhr){
			console.log('lol');
			console.log(data);
			if(data["delete"] == true)
			{
				console.log('data');
				console.log(data);
				$(this).parents('.bookmark').first().remove();
			}
			return false;
		});
	};
})( jQuery );




$(function() {
	//--applies to edit playlist pages--
	//hide HTML-Request New Bookmark Links
	$('#add_bookmark_html').hide();
	//unhide Javascript-Request New Bookmark Links
	$('#add_bookmark_js').show();
	//replaces bookmark div after update is successful on server's side
	$('.bookmark').bookmarkSetup();
	//--applies to pages where playlists can be edited--
	$('.remove_playlist').on('ajax:success', function (event, data, status, xhr){
		this.parents('.playlist_link').first().remove();
	});
});
