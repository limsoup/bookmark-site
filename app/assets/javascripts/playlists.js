// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


(function( $ ) {

	ubNameSel='input[name="user_bookmark[bookmark_url_attributes][id]"]';
	detail = $('#detail_bookmark_view');
  $.fn.bookmarkSetup = function (){
  	this.on('click', function(event){
			event.preventDefault();
  		if($(this).find(ubNameSel).val() != detail.find(ubNameSel).val() ){
  			if(detail.children().length > 0) {
  				detail.children().replaceWith($(this).find('.detail_bookmark').clone().show());
  			} else{
					detail.append($(this).find('.detail_bookmark').clone().show());
  			}
  		}
  	}).on('click','a.watch',function(event){
  		event.preventDefault();
  		console.log($(this).parents('.bookmark').find('.modal'));
			$(this).parents('.bookmark').find('.modal').clone().appendTo('#modalHolder');
			$('#modalHolder').find('.modal').on('shown', function(){
				$(this).find('.modal-body').html($(this).find('.modal-body').data('embedcode'));
			}).on('hide', function(){
				$(this).find('.modal-body').children().remove();
			}).on('hidden',function(){
				$(this).children().remove();
			});
			$('#modalHolder').find('.modal').modal('show');
			return false;
  	});
	};
	$.fn.cycle = function() {
		this.data('thumbindex', (this.data('thumbindex') % this.data('numthumbs'))  + 1);
		this.attr('src', this.data('thumb' + this.data('thumbindex')) );
	};

})( jQuery );


$(function() {
	//--applies to edit bookmark pages--

	//set event handlers for bookmarks

	$('.bookmark').bookmarkSetup();
	ubNameSel='input[name="user_bookmark[bookmark_url_attributes][id]"]';
	detail = $('#detail_bookmark_view');
	function findBookmarkInList(){
		return $('#bookmark_list_view').find(ubNameSel+'[value='+detail.find(ubNameSel).val()+']').parents('.bookmark');
	}

	$('#filter_uncategorized, #filter_bookmarks').on('keyup', function(event){
		filterField = this;
		if($(this).val() == ''){
			$('.bookmark').show();
		}else{
			$('.bookmark').each( function(index){
				if ($(this).find('a').first().text().toLowerCase().search($(filterField).val().toLowerCase()) == -1){
					$(this).hide();
				}else{
					$(this).show();
				}
			});
		}
		if(detail.children().length != 0){
			if($(findBookmarkInList()).css('display')=='none') {
				detail.children().remove();
				detail.parent().removeClass('detail_container_color');
			}
		}
	});

	//detail actions

	detail.on('click', 'a.collapse_link', function(event){
		event.preventDefault();
		detail.children().remove();
		//detail.parent().removeClass('detail_container_color');
	});

	detail.on('click', 'a.edit_link', function(event){
		event.preventDefault();
		if($(this).hasClass('active')){
			detail.find('.edit_bookmark_fields').hide();
		} else{
			detail.find('.edit_bookmark_fields').show();
		}
		if(detail.find('a.move_link').hasClass('active')){
			$(detail.find('a.move_link')).trigger('click');
		}
	});

	detail.on('click', 'a.move_link', function(event){
		event.preventDefault();
		if($(this).hasClass('active')){
			detail.find('.move_bookmark').hide();
		} else{
			detail.find('.move_bookmark').show();
		}
		if(detail.find('a.edit_link').hasClass('active')){
			$(detail.find('a.edit_link')).trigger('click');
		}
	});

	detail.on('click', 'a.watch_link', function(event){
		event.preventDefault();
		detail.find('.modal').clone().appendTo('#modalHolder');
		$('#modalHolder').find('.modal').on('shown', function(){
			$(this).find('.modal-body').html($(this).find('.modal-body').data('embedcode'));
		}).on('hide', function(){
			$('#modalHolder').find('.modal-body').children().remove();
		}).on('hidden',function(){
			$('#modalHolder').children().remove();
		});
		$('#modalHolder').find('.modal').modal('show');
	});

	detail.on('keyup','.edit_bookmark_fields input', function (){
		//hides the 'collapse', shows the 'reload' and 'save', and hides the 'move'
		detail.find('a.revert_link').show();
		detail.find('a.save_link').show();
		if(detail.find('a.move_link').hasClass('active')){
			$(detail.find('a.move_link')).trigger('click');
		}
		detail.find('a.edit_link').addClass('disabled');
	});

	detail.on('click', 'a.revert_link', function(event){
		event.preventDefault();
		detail.find('.edit_bookmark_fields').replaceWith($(findBookmarkInList()).find('.edit_bookmark_fields').clone().show());
		detail.find('a.revert_link').hide();
		detail.find('a.save_link').hide();
	});

	detail.on('click', 'a.save_link', function(){
		event.preventDefault();
		detail.find('form').submit();
	}).on('ajax:success', 'form', function(event, data, status, xhr){
		source = $(findBookmarkInList());
		$(findBookmarkInList()).html(data).bookmarkSetup();
		//copy the *contents* of the pane classes except the embed stuff
		detail.find('.show_bookmark_detail').html(source.find('.show_bookmark_detail').clone().children());
		detail.find('.edit_bookmark_fields').html(source.find('.edit_bookmark_fields').clone().children());
		detail.find('.move_bookmark').html(source.find('.move_bookmark').clone().children());
		//set the links right
		detail.find('a.revert_link').hide();
		detail.find('a.save_link').hide();
	});

	detail.on('ajax:success','a.remove_link', function(event){
		event.preventDefault();
		$(findBookmarkInList()).remove();
		detail.children().remove();
		detail.parent().removeClass('detail_container_color');
	});
	
	detail.on('ajax:before', '.move_bookmark_submit', function(event){
		var sendBack = {};
		sendBack.moveType = $(this).siblings('[name=user_bookmark_move]:checked').first().val();
		sendBack.destination = $(this).siblings('[name=user_bookmark_move_paste]').first().val();
		$(this).data('params',jQuery.param(sendBack));
	}).on('ajax:success', function(event, data, status, xhr){
		if(data["delete"] == true){
			$(findBookmarkInList()).remove();
			detail.children().remove();
			detail.parent().removeClass('detail_container_color');
		}
		return false;
	});

	//--applies to pages where playlists can be edited--

	$('.remove_playlist').on('ajax:success', function (event, data, status, xhr){
		this.parents('.playlist_link').first().remove();
	});
	
	//--applies to playlist#show which has linkDrop
	

	$('.container-fluid').on('dragover dragenter', function(e) {
		//raise zindex on enter main view
		$('#linkDrop').css('z-index','0');
	  $('#linkDrop').css('opacity','0.25');
		$(this).css('z-index','-1');
	  console.log('lol');
	});

	$('#linkDrop').on('dragover dragenter', function (e) {		
	  if (e.preventDefault){
	  	e.preventDefault(); // required by FF + Safari
	  }
		e.originalEvent.dataTransfer.dropEffect = 'copy'; // tells the browser what drop effect is allowed here
		return false; // required by IE
	}).on('dragleave', function (e){
	  $(this).css('opacity','0.0');
		$(this).css('z-index','-1');
		$('.container-fluid').css('z-index','-1');
	}).on('drop', function (e){
	  $(this).css('opacity','0.0');
		if (e.preventDefault){
			e.preventDefault();
		}
		if (e.originalEvent.dataTransfer.types) {
			[].forEach.call(e.originalEvent.dataTransfer.types, function(type) {
				if(type == 'text/uri-list'){
					console.log( e.originalEvent.dataTransfer.getData(type).toString());
					gUrl = e.originalEvent.dataTransfer.getData(type).toString();
					$('#linkDrop input[name="bookmark_url[url]"]').attr('value', e.originalEvent.dataTransfer.getData(type).toString());
					$('#linkDrop form').submit();
				}
			});
		}
	});
	
	var thumbnailIntervalId;
	$('#bookmark_list_view').on('mouseover', '.cycle' , function() {
		var tn = $(this);
		thumbnailIntervalId = setInterval(function(){
			tn.cycle();
		},1000); 
	}).on('mouseout', '.cycle', function() {
		clearInterval(thumbnailIntervalId);
	});

});
