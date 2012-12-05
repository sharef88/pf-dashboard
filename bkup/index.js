//javascript functionz
var len = 1

function dice(x) {
 var randomnumber=Math.floor(Math.random()*(x-1))+1;
 return randomnumber
}

function init_actor(source) {
  var RANDOM = dice(20);
  var entry = "<li class='ui-state-default actor ui-corner-all' id='actor_"+len+"' style='display:none'><span class='actor_name'><input type='text' name='actor_"+len+"' id='actor_"+len+"'></span><span class='sum_div ui-state-highlight ui-corner-all' id='sum'><input type='button' class='sum_field' id='sum' value='"+RANDOM+"'><div class='extra'><input type='text' name='actor_"+len+"' value='"+RANDOM+"' class='roll' title='d20 roll'><a class='sum_button'/><input type='text' name='actor_"+len+"' value='0' class='mod' title='modifier'></div></span><span class='actor_control ui-state-hover ui-corner-all'><a name='add' class='add_actor' /><a name='remove' class='remove_actor' /></span></li>"

  $(source).after(entry);
  if ($('.actor').length == 1) {
    $('.entries>#null').remove();
  }

  // set up the new entry's hooks
  var $stuff = $("#actor_"+len);
  $stuff.find('.add_actor').add_actor();
  $stuff.find('.remove_actor').remove_actor();
  $stuff.find('.sum_field').show_extra();
  $stuff.find('.sum_button').hide_extra();
  $stuff.find('.actor_control').buttonset();
  $stuff.show('fast');
  $('#len').val($('.actor').length);
  $stuff.find(' [title]' ).tooltip();
  var $extra = $stuff.find('.extra');
  var $button = $extra.find('.sum_button');
}

$.fn.hideOptionGroup = function() {
 $(this).hide();
 $(this).children().each(function(){
   $(this).attr("disabled", "disabled").removeAttr("selected");
 });
 $(this).appendTo($(this).parent());

}

$.fn.showOptionGroup = function() {
 $(this).show();    
 $(this).children().each(function(){
   $(this).removeAttr("disabled" );
 });
 $(this).prependTo($(this).parent());
 $(this).parent().animate({scrollTop:0},0);
 $(this).parent().val($(this).children(':first').val());
}

$.fn.show_extra = function(){
  $(this).unbind();
  $(this).button();
  $(this).disableSelection();
  $(this).click(
    function(){
      $(this).hide('fast');
    }
  )
}
$.fn.hide_extra = function(){
  $(this).unbind();
  $(this).button({icons: {primary:'ui-icon-plus'}, text: false});
  var sum = parseInt($(this).parent().find('.roll').val())+parseInt($(this).parent().find('.mod').val());
  $(this).parents('.actor').find('.sum_field').val(sum);

  $(this).click(
    function(){
      $(this).parents('.actor').find('.sum_field').show('fast');
      
      //sum the #
      var sum = parseInt($(this).parent().find('.roll').val())+parseInt($(this).parent().find('.mod').val());
      $(this).parents('.actor').find('.sum_field').val(sum);
    })
}



$.fn.add_actor = function(){
  $(this).button({icons: {primary:'ui-icon-plusthick'}, text: false});
  $(this).off();
  $(this).unbind();
  var source = $(this);
  $(this).on('click', function() {
    len++;
    init_actor($(source).parents('.actor'));
  

  })
  $(this).on('touchend', function(){ $(this).trigger('click') });
}

$.fn.remove_actor = function(){
  $(this).button({icons: {primary: 'ui-icon-minusthick'}, text: false});
  $(this).off();
  $(this).on('click', function(){
    if($('#input_init').find(".actor").length > 1) {
      $(this).parents('li.actor').hide('fast', function() { $(this).remove()});
//      $(this).parents('li.actor').remove();
      $('#len').val($('.actor').length);
    }
  })
  $(this).on('touchend', function(){ $(this).trigger('click') });

}

$.fn.sortAW = function(){
  var i = 1;
  $('.actor').each(function(){
    var name = 'actor_'+i;
    $(this).find(":text").attr("name",name);
    $(this).find(".roll").attr("name",name);
    $(this).find('.mod').attr("name",name);
    i++;
  })
  $('#len').val($(".actor").length);


  //serialize for sending
  var stuff = $('#input_init').serializeArray();
  //send data to same-script
  $.post("initative.pl",stuff,
   function(data) {
     $("#sorted_entry").html(data);
     $("[title]").tooltip();
     $('.sorted')
       .accordion({
         collapsible:true, 
         active: false,
         header: ".active"
       })
       .sortable({
         axis:'y', 
         containment:'#sorted_entry',
         handle: ".active",
         distance: 10
       });
     $('.sorted .active').disableSelection();
    }, 'html');
}

$.fn.panel = function(side,width, height) {
        var $this = $(this);
	$(this).css('width',-width+'px');
	$(this).css(side,width+'px');
	$(this).css('height',height+'px');
	$(this).css('position','fixed');
	$(this).css('z-index','200');
	$(this).css('padding-'+side,'0');
	$(this).css('font-size','2em');
	$(this).css('top','30%');
        $(this).css('z-index','200');
	
	
	$(this).find('.panel_handle').disableSelection();
	$(this).find('.panel_handle').hover(function() {
		$this.stop(true, false).animate({
			'right': '0px'
		}, 900);
	}, function() {
		//$(this).noConflict();
	});
	$(this).hover(function() {
	// Do nothing
	}, function() {
		//$(this).noConflict();
		$(this).animate({
			right: width+'px'
		}, 800);
	});
};


jQuery(document).ready(function(){

	init_actor($('.entries>li'));

	$('#init_tabs').tabs({
		active: 0,
		heightStyle:'fill',
		beforeActivate: function(event, ui) {
			if (ui.newTab.attr('id') == 'sorted'){
				$(this).sortAW();
			}
		}
	});
	
	$('#over_tabs').tabs({
		heightStyle: 'fill',
		load: function(event, ui) {
                	var id = '#'+ui.panel.id;
                        if (ui.tab.href != id) {
                        	ui.tab.href = id;
			}
		}                
	}).addClass( "ui-tabs-vertical ui-helper-clearfix" );
	
	$('#over_menu>li').removeClass( "ui-corner-top" )
	$('#over_menu>li').addClass( "ui-corner-left" )
	$('#tabs>ul, #tabs>ul *').each(function(){$(this).disableSelection();});
	$('.sortable').sortable({
		axis:'y',
		containment:'#entries',
		distance:15
	});
	$('[title]' ).tooltip();
	$('#RightPanel').panel('right',-500,300);
});
