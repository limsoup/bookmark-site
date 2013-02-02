// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


$(function() {
	//hide HTML-Request New Bookmark Links
	$('#add_bookmark_html').hide();
	//unhide Javascript-Request New Bookmark Links
	$('#add_bookmark_js').show();

	//---event handlers for bookmarks, need to add to other ones (maybe create a function)---
	$('.edit_bookmark_button').on('click', function(event){
		event.preventDefault();
		$(this).parents('.show_bookmark').first().hide().next().show();
	});
	$('.show_bookmark_button').on('click', function(event){
		event.preventDefault();
		$(this).parents('.edit_bookmark').first().hide().prev().show();
	});
	//so that input[remote=true] sends i
	$('.edit_bookmark').each( function(){
			$(this).find('input').data('params',$(this).next('input[type=hidden]').serialize());
		});
	$('.remove_bookmark').on('ajax:success', function(){
		$(this).parents('.bookmark').first().remove();
	});
	//---event handlers for bookmarks end---
});
