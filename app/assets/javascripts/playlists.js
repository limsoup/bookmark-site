// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


(function( $ ) {

	ubNameSel='input[name="user_bookmark[bookmark_url_attributes][id]"]';
	detail = $('#detail_bookmark_view');
	function findBookmarkInList(){
		return $('#bookmark_list_view').find(ubNameSel+'[value='+detail.find(ubNameSel).val()+']').parents('.bookmark');
	}
  $.fn.bookmarkSetup = function (){
  	this.on('click', function(event){
			event.preventDefault();
			$(this).css('background','#D2FFE2');
  		if($(this).find(ubNameSel).val() != detail.find(ubNameSel).val() ){
  			if(detail.children().length > 0) {
  				$(findBookmarkInList()).css('background','white');
  				detail.children().replaceWith($(this).find('.detail_bookmark').clone().show());
  			} else{
					detail.append($(this).find('.detail_bookmark').clone().show());
  			}
  		}
  	}).on('click','a.watch',function(event){
  		event.preventDefault();
  		//console.log($(this).parents('.bookmark').find('.modal'));
			$(this).parents('.bookmark').find('.modal').clone().appendTo('#modalHolder');
			$('#modalHolder').find('.modal').on('shown', function(){
				$(this).find('.modal-body').html($(this).find('.modal-body').data('embedcode'));
			}).on('hide', function(){
				$(this).find('.modal-body').children().remove();
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
	//--applies to show bookmark pages--

	//new bookmark modal link
	$('.new-bookmark-modal-link').on('click', function(event){
		event.preventDefault();
		$('#new-bookmark-modal-holder').find('.modal').clone().appendTo('#modalHolder');
		$('#modalHolder').find('.modal').modal('show');
	});

	$('#modalHolder').on('hidden',function(){
		$(this).children().remove();
	});


	$("#modalHolder").on('ajax:success', '.new-bookmark-modal form', function(event, data, status, xhr){
		//display success
		//if it's added to this playlist, add bookmark
		$('.hrspacer').after(jQuery.parseHTML(data.html+"<hr>"));
		$('.bookmark').first().bookmarkSetup();
		//if it's added to some other list, give choice between staying here or going to that list
		$(this).find('.alert-container-success').show();
		$(this).find('.form-buttons').hide();
		//console.log(data);
	}).on('close', '.new-bookmark-modal .alert', function(){
		$(this).after($(this).clone());
	}).on('closed', '.new-bookmark-modal .alert', function(){
		$('#modalHolder .new-bookmark-modal input[type=text]').val('');
		$('#modalHolder .new-bookmark-modal .alert-container-success').hide();
		//$('#modalHolder .new-bookmark-modal .alert-container-error').hide();
		$('#modalHolder .new-bookmark-modal .form-buttons').show();
	});

/*
	on('click','button[type=submit]' function(event){
		event.preventDefault();
		$("#new-bookmark-modal form").submit();
	})
*/

	//set event handlers for bookmarks in list
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
			$('.bookmark_list_view hr').show();
		}else{
			$('.bookmark').each( function(index){
				if ($(this).find('a').first().text().toLowerCase().search($(filterField).val().toLowerCase()) == -1){
					$(this).hide();
					$(this).prev().hide();
				}else{
					$(this).show();
					$(this).prev().show();
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
		}http://www.w3schools.com/jsref/jsref_substring.asp
		return false;
	});

	//--applies to pages where playlists can be edited--

	$('.remove_playlist').on('ajax:success', function (event, data, status, xhr){
		this.parents('.playlist_link').first().remove();
	});
	
	//--applies to playlist#show which has linkDrop
	if($('.new-bookmark-modal').length > 0){

		$('.container-fluid').on('dragenter dragover', function(e) {
			console.log(e);
			if (!document.hasFocus()) {
				$('#new-bookmark-modal-holder').find('.modal').clone().appendTo('#modalHolder');
				$('#modalHolder').find('.modal').modal('show');	
			}
			e.originalEvent.dataTransfer.dropEffect = 'copy';
		});

		$('body').on('dragover dragenter', '.modal-backdrop, .modal, .nav', function (e) {		
		  if (e.preventDefault){
		  	e.preventDefault(); // required by FF + Safari
		  }
		  //console.log(e);
		  //console.log(e.originalEvent.dataTransfer);
			e.originalEvent.dataTransfer.dropEffect = 'copy'; // tells the browser what drop effect is allowed here
			return false; // required by IE
		}).on('dragleave', function (e){
			//dismiss modal

		  //$(this).css('opacity','0.0');
			//$(this).css('z-index','-1');
			//$('.container-fluid').css('z-index','0');
		}).on('drop', function (e){
		  // $(this).css('opacity','0.0');
			if (e.preventDefault){
				e.preventDefault();
			}
			if (e.originalEvent.dataTransfer.types) {
				[].forEach.call(e.originalEvent.dataTransfer.types, function(type) {
					if(type == 'text/uri-list'){
						//console.log( e.originalEvent.dataTransfer.getData(type).toString());
						gUrl = e.originalEvent.dataTransfer.getData(type).toString();
						$('#modalHolder input[name="user_bookmark[bookmark_url_attributes][url]"]').attr('value', e.originalEvent.dataTransfer.getData(type).toString());
						// $('#linkDrop form').submit();
					}
				});
			}
		});
	}
	
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
