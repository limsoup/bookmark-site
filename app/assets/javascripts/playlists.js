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
			$(this).parents('.bookmark').first().html(data).bookmarkSetup();
		});
		//when input changes
		this.find('input').on('change', function (){
			$(this).siblings().first().hide().next().show().next().show();
		});
		this.find('.reload_edit_bookmark_button').on('ajax:success', function(event, data, status, xhr){
			$(this).parents('.bookmark').first().html(data).bookmarkSetup();
		});
		this.find('.update_bookmark_button').on('click', function(){
			$(this).parents('form').submit();
		}).on('ajax:success', function(event, data, status, xhr){
			$(this).parents('.bookmark').first().html(data).bookmarkSetup();
		});
		//revert (show) or save (update)
		//
	};
})( jQuery );

$(function() {
	//hide HTML-Request New Bookmark Links
	$('#add_bookmark_html').hide();
	//unhide Javascript-Request New Bookmark Links
	$('#add_bookmark_js').show();

	//replaces bookmark div after update is successful on server's side
	$('.bookmark').bookmarkSetup();
});
