//javascript functionz
var LEN = 1;
var ls = localStorage;

function dice(x) {
  var randomnumber = Math.floor(Math.random() * (x - 1)) + 1;
  return randomnumber;
}


function init_ls_actors() {
  // Is there an appropriate value in localStorage?
  if (ls['initative']) {
    var loaded = $.parseJSON(ls.initative);
    var length = (parseInt(loaded.length) - 1) / 3;
    console.log('Parsed ' + length + ' JSON records from localStorage');
    for (var i = 0; i < length; i++) {
      if (!(i == 0)) {
	LEN++;
	init_actor($('.actor:last-child'));
      } else {
	init_actor($('.entries>li'));
      }
      var name = loaded[1 + (i * 3)]['value'];
      var roll = loaded[2 + (i * 3)]['value'];
      if (roll == 'd20') {
	roll = dice(20);
      }
      var mod = loaded[3 + (i * 3)]['value'];
      var $this = $('#actor_' + (i + 1));
      $this.find('.actor_name>input').val(name);
      $this.find('.roll').val(roll);
      $this.find('.mod').val(mod);
      $this.find('.sum_field').val(parseInt(roll) + parseInt(mod));
    }
  } else {
    console.log('No records found in localStorage');
    init_actor($('.entries>li'));
  }
}


function init_actor(source) {
  var ran = dice(20);
  var entry = "<li class='ui-state-default actor ui-corner-all' id='actor_" + LEN + "' style='display:none'><span class='actor_name'><input type='text' name='actor_" + LEN + "' id='actor_" + LEN + "'></span><span class='sum_div ui-state-highlight ui-corner-all' id='sum'><input type='button' class='sum_field' id='sum' value='" + ran + "'><div class='extra' style='display:none'><input type='text' name='actor_" + LEN + "' value='" + ran + "' class='roll' title='d20 roll'><a class='sum_button'/><input type='text' name='actor_" + LEN + "' value='0' class='mod' title='modifier'></div></span><span class='actor_control ui-state-hover ui-corner-all'><a name='add' class='add_actor' /><a name='remove' class='remove_actor' /></span></li>"

  $(source).after(entry);
  if ($('.actor').length == 1) {
    $('.entries>#null').remove();
  }

  // set up the new entry's hooks
  var $stuff = $("#actor_" + LEN);
  $stuff.find('.add_actor').add_actor();
  $stuff.find('.remove_actor').remove_actor();
  $stuff.find('.sum_field').show_extra();
  $stuff.find('.sum_button').hide_extra();
  $stuff.find('.actor_control').buttonset();
  $stuff.show('fast');
  $('#len').val($('.actor').length);
  $stuff.find(' [title]').tooltip();
  $stuff.find('input').keyup(function() {
    ls['initative'] = JSON.stringify($('#input_init').serializeArray());
  });
}

$.fn.hideOptionGroup = function() {
  $(this).hide();
  $(this).children().each(function() {
    $(this).attr("disabled", "disabled").removeAttr("selected");
  });
  $(this).appendTo($(this).parent());

}

$.fn.showOptionGroup = function() {
  $(this).show();
  $(this).children().each(function() {
    $(this).removeAttr("disabled");
  });
  $(this).prependTo($(this).parent());
  $(this).parent().animate({
    scrollTop: 0
  }, 0);
  $(this).parent().val($(this).children(':first').val());
}

$.fn.show_extra = function() {
  $(this).unbind();
  $(this).button();
  $(this).disableSelection();
  $(this).click(

  function() {
    $(this).hide('fast');
    $(this).parents('.sum_div').find('.extra').show();
  })
}
$.fn.hide_extra = function() {
  $(this).unbind();
  $(this).button({
    icons: {
      primary: 'ui-icon-plus'
    },
    text: false
  });
  var sum = parseInt($(this).parent().find('.roll').val()) + parseInt($(this).parent().find('.mod').val());
  $(this).parents('.actor').find('.sum_field').val(sum);

  $(this).click(
    function() {
      $(this).parents('.actor').find('.sum_field').show('fast');
      $(this).parents('.sum_div').find('.extra').hide();
      if ($(this).parent().find('.roll').val() == 'd20') {
        $(this).parent().find('.roll').val(dice(20))
      }
      //sum the #
      var sum = parseInt($(this).parent().find('.roll').val()) + parseInt($(this).parent().find('.mod').val());
     $(this).parents('.actor').find('.sum_field').val(sum);
     ls['initative'] = JSON.stringify($('#input_init').serializeArray());
    }
  )
}



$.fn.add_actor = function() {
  $(this).button({
    icons: {
      primary: 'ui-icon-plusthick'
    },
    text: false
  });
  $(this).off();
  $(this).unbind();
  var source = $(this);
  $(this).on('click', function() {
    LEN++;
    init_actor($(source).parents('.actor'));


  })
  //  $(this).on('touchend', function(){ $(this).trigger('click') });
}

$.fn.remove_actor = function() {
  $(this).button({
    icons: {
      primary: 'ui-icon-minusthick'
    },
    text: false
  });
  $(this).off();
  $(this).on('click', function() {
    if ($('#input_init').find(".actor").length > 1) {
      $(this).parents('li.actor').hide('fast', function() {
	$(this).remove();
	$('#len').val($('.actor').length);
	ls['initative'] = JSON.stringify($('#input_init').serializeArray());
      });
    }
  })
  $(this).on('touchend', function() {
    $(this).trigger('click')
  });

}

$.fn.sortAW = function() {
  var i = 1;
  $('.actor').each(function() {
    var name = 'actor_' + i;
    $(this).find(":text").attr("name", name);
    $(this).find(".roll").attr("name", name);
    $(this).find('.mod').attr("name", name);
    i++;
  })
  $('#len').val($(".actor").length);


  //serialize for sending
  var stuff = $('#input_init').serializeArray();
  ls['initative'] = JSON.stringify(stuff);
  //send data to same-script
  $.post("initative.pl", stuff, function(data) {
    $("#sorted_entry").html(data);
    $("[title]").tooltip();
    $('.sorted').accordion({
      collapsible: true,
      active: false,
      header: ".active"
    }) //Set up the active init count as an accordion, showing extra data with a click
    .sortable({
      axis: 'y',
      containment: '#sorted_entry',
      handle: ".active",
      distance: 10
    });
    $('.sorted .active').disableSelection();
  }, 'html');
}



jQuery('#init_tabs').ready(function() {

  init_ls_actors();
  $('#init_tabs').tabs({
    active: 0,
    heightStyle: 'fill',
    beforeActivate: function(event, ui) {
      if (ui.newTab.attr('id') == 'sorted') {
	$(this).sortAW();
      }
    }
  });

  $('.sortable').sortable({
    axis: 'y',
    containment: '#entries',
    distance: 15
  });
  $('[title]').tooltip();
});