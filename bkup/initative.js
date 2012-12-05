//javascript functionz
var len = 1

function dice(x) {
 var randomnumber=Math.floor(Math.random()*(x-1))+1;
 return randomnumber
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
      $(this).parent().find('.sum_field').hide('blind');
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
      $(this).parents('.actor').find('.sum_field').show('blind');
      
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
    //Random number, simulating a d20 roll
    var RANDOM = dice(20);
    len++;
    // The actual new entry string, modified with the above values
    var entry = "<li class='ui-state-default actor ui-corner-all' id='actor_"+len+"' style='display:none'><span class='actor_name'><input type='text' name='actor_"+len+"' id='actor_"+len+"'></span><span class='sum_div ui-state-highlight ui-corner-all' id='sum'><input type='button' class='sum_field' id='sum' value='"+RANDOM+"'><span class='extra ui-state-highlight ui-corner-all'><input type='text' name='actor_"+len+"' value='"+RANDOM+"' class='roll' title='d20 roll'><a class='sum_button'/><input type='text' name='actor_"+len+"' value='0' class='mod' title='modifier'></span></span><span class='actor_control ui-state-hover ui-corner-all'><a name='add' class='add_actor' /><a name='remove' class='remove_actor' /></span></li>"


    //The source of the trigger, add this entry after it
    $(source).parents('.actor').after(entry);
  

    // set up the new entry's hooks
    $("#actor_"+len).find('.add_actor').add_actor();
    $("#actor_"+len).find('.remove_actor').remove_actor();
    $("#actor_"+len).find('.sum_field').show_extra();
    $("#actor_"+len).find('.sum_button').hide_extra();
    $("#actor_"+len).find('.actor_control').buttonset();
    $('li#actor_'+len).show('blind');
    $('#len').val($('.actor').length);
    $("#actor_"+len+' [title]' ).tooltip();
  })
  $(this).on('touchend', function(){ $(this).trigger('click') });
}

$.fn.remove_actor = function(){
  $(this).button({icons: {primary: 'ui-icon-minusthick'}, text: false});
  $(this).off();
  $(this).on('click', function(){
    if($('#input_init').find(".actor").length > 1) {
      $(this).parents('li.actor').remove();
      $('#len').val($('.actor').length);
    }
  })
  $(this).on('touchend', function(){ $(this).trigger('click') });

}

$.fn.sortAW = function(){
  $(this).on('click', function() {
    var i = 1;
    $('.actor').each(function(){
      var name = 'actor_'+i;
      $(this).find(":text").attr("name",name);
      $(this).find(".roll").attr("name",name);
      $(this).find('.mod').attr("name",name);
      i++;
    })
    $('#len').val($(".actor").length);
    var stuff = $('#input_init').serializeArray();
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
  })
}




jQuery(document).ready(function(){
var RANDOM = dice(20);
var entry = "<li class='ui-state-default actor ui-corner-all' id='actor_"+len+"'><span class='actor_name'><input type='text' name='actor_"+len+"' id='actor_"+len+"'></span><span class='sum_div ui-state-highlight ui-corner-all' id='sum'><input type='button' class='sum_field' id='sum' value='"+RANDOM+"'><span class='extra ui-state-highlight ui-corner-all'><input type='text' name='actor_"+len+"' value='"+RANDOM+"' class='roll' title='d20 roll'><a class='sum_button'/><input type='text' name='actor_"+len+"' value='0' class='mod' title='modifier'></span></span><span class='actor_control ui-state-hover ui-corner-all'><a name='add' class='add_actor' /><a name='remove' class='remove_actor' /></span></li>"

$('.entries').append(entry);
    // set up the new entry's hooks
    $("#actor_"+len).find('.add_actor').add_actor();
    $("#actor_"+len).find('.remove_actor').remove_actor();
    $("#actor_"+len).find('.sum_field').show_extra();
    $("#actor_"+len).find('.sum_button').hide_extra();
    $("#actor_"+len).find('.actor_control').buttonset();

  $('#init_tabs').tabs({active: 0, heightStyle:'fill'});
  $('#over_tabs').tabs({heightStyle: 'fill'}).addClass( "ui-tabs-vertical ui-helper-clearfix" );
  $('.over_menu').removeClass( "ui-corner-top" ).addClass( "ui-corner-left" )
  $('#tabs>ul,#tabs>ul *').each(function(){$(this).disableSelection();});
  $('.results').sortAW();
  $('.sortable').sortable({
    axis:'y',
    containment:'#entries',
    distance:15
  });
  $('[title]' ).tooltip();
});
