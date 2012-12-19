//javascript functionz
var LEN = 1;
var ls = localStorage;

//dice?
function dice(x) {
   var randomnumber = Math.floor(Math.random() * (x - 1)) + 1;
   return randomnumber;
}

//function for initilizing actor list from localStorage
function init_ls_actors() {
   // Is there an appropriate value in localStorage?
   if (ls['initative']) {
      //pull the initative values from json
      //TODO need to add some sanity checks here
      var loaded = $.parseJSON(ls.initative);

      //get the length of the records, each record is 3 values
      var length = (parseInt(loaded.length) - 1) / 3;

      //basic debugging info
      console.log('Parsed ' + length + ' JSON records from localStorage');

      //foreach record, do stuff
      for (var i = 0; i < length; i++) {

         //if it isn't the first entry
         if (!(i == 0)) {
            //increment the LEN value (global), and stick a new record in
            LEN++;
            init_actor($('.actor:last-child'));
         } else {
            //don't increment LEN, just add a new value
            init_actor($('.entries>li'));
         }

         //init the values
         var name = loaded[1 + (i * 3)]['value'];
         var roll = loaded[2 + (i * 3)]['value'];
         var mod = loaded[3 + (i * 3)]['value'];
         var $this = $('#actor_' + (i + 1));


         //override 'd20' into a dice roll
         if (roll == 'd20') {
            roll = dice(20);
         }
         
         //move the values to the new record itself
         $this.find('.actor_name>input').val(name);
         $this.find('.roll').val(roll);
         $this.find('.mod').val(mod);

         //sum the things
         $this.find('.sum_field').val(parseInt(roll) + parseInt(mod));
      }
   } else {
      //no records? fine, start from scratch
      console.log('No records found in localStorage');
      init_actor($('.entries>li'));
   }
}

//function for making a new actor entry
function init_actor(source) {
   var ran = dice(20);
   var entry = "<li class='ui-state-default actor ui-corner-all' id='actor_" + LEN + "' style='display:none'><span class='actor_name'><input type='text' name='actor_" + LEN + "' id='actor_" + LEN + "'></span><span class='sum_div ui-state-highlight ui-corner-all' id='sum'><input type='button' class='sum_field' id='sum' value='" + ran + "'><div class='extra' style='display:none'><input type='text' name='actor_" + LEN + "' value='" + ran + "' class='roll' title='d20 roll'><a class='sum_button'/><input type='text' name='actor_" + LEN + "' value='0' class='mod' title='modifier'></div></span><span class='actor_control ui-state-hover ui-corner-all'><a name='add' class='add_actor' /><a name='remove' class='remove_actor' /></span></li>"

   //add the entry!
   $(source).after(entry);

   
   //there is a li#null in the list before everything starts
   //this is the target and interferes with formatting once others are set up.
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

   //the initative value is stored every time you type something
   $stuff.find('input').keyup(function() {
      ls.initative = JSON.stringify($('#input_init').serializeArray());
   });
}

$.fn.show_extra = function() {
   //opposite of hide_extra, just without summing the values
   $(this).unbind();
   $(this).button();
   $(this).disableSelection();
   $(this).click(function() {
      $(this).hide('fast');
      $(this).parents('.sum_div').find('.extra').show();
   })
}

$.fn.hide_extra = function() {
   
   //function for summing the roll and mod into .sum_field
   function sumRoll() {
      var sum = parseInt($(this).parent().find('.roll').val()) + parseInt($(this).parent().find('.mod').val());
      $(this).parents('.actor').find('.sum_field').val(sum);
   }

   //clean the binding first 
   $(this).unbind();

   //turn it into a button
   $(this).button({
      icons: {
         primary: 'ui-icon-plus'
      },
      text: false
   });

   sumRoll();

   //bind the click to hide the .extra
   $(this).click(
      function() {
         $(this).parents('.actor').find('.sum_field').show('fast');
         $(this).parents('.sum_div').find('.extra').hide();

         //override 'd20' into a d20 roll
         if ($(this).parent().find('.roll').val() == 'd20') {
            $(this).parent().find('.roll').val(dice(20))
         }
         //sum the #
         sumRoll();
         
         //store the stuff in the initative value
         ls.initative = JSON.stringify($('#input_init').serializeArray());
      }
   )//end click
}

$.fn.add_actor = function() {
   //initilize as a button
   $(this).button({
      icons: {
         primary: 'ui-icon-plusthick'
      },
      text: false
   });
   //clean the bindings
   $(this).unbind();
   
   $(this).click(function() {
      //increment LEN, this doesn't decrement
      LEN++;

      //make the actor via other function
      init_actor($(this).parents('.actor'));
   }); //end click
}

$.fn.remove_actor = function() {
   //init as button
   $(this).button({
      icons: {
         primary: 'ui-icon-minusthick'
      },
      text: false
   });
   
   //clean bindings
   $(this).unbind();
   $(this).click(function() {
      //if there is more than 1 actor
      if ($('#input_init').find(".actor").length > 1) {
         //hide the actor first
         $(this).parents('li.actor').hide('fast', function() {
            //then remove it
            $(this).remove();
            //and update the length/update the localStorage
            $('#len').val($('.actor').length);
            ls.initative = JSON.stringify($('#input_init').serializeArray());
         }); //end hide
      } //end if
   });  //end click
}

$.fn.sortAW = function() {
   var i = 1;
   //reorder the actors for appropriate sending
   $('.actor').each(function() {
      var name = 'actor_' + i;
      $(this).find(":text").attr("name", name);
      $(this).find(".roll").attr("name", name);
      $(this).find('.mod').attr("name", name);
      i++;
   })

   //reset the #len hidden value to something sane
   $('#len').val($(".actor").length);


   //serialize for sending
   var stuff = $('#input_init').serializeArray();
   ls['initative'] = JSON.stringify(stuff);
   //send data to same-script
   $.post("initative.pl", stuff, function(data) {
      //stick the data into the #sorted_entry div
      $("#sorted_entry").html(data);
      //custom tooltips?
      $("[title]").tooltip();
      //the sorted entries returned are accordioned to hide the mini-character sheet
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
      //the headers don't need to be selectable
      $('.sorted .active').disableSelection();
   }, 'html');
}



jQuery('#init_tabs').ready(function() {
   init_ls_actors();
   //set up the tabs
   //TODO this has to change, it is mostly pointless to have a tab system for this type thing
   $('#init_tabs').tabs({
      active: 0,
      heightStyle: 'fill',
      //ajax up some sorted values
      beforeActivate: function(event, ui) {
         if (ui.newTab.attr('id') == 'sorted') {
            $(this).sortAW();
         }
      }
   });

   //any .sortable things, go figure
   $('.sortable').sortable({
      axis: 'y',
      containment: '#entries',
      distance: 15
   });

   //customize tooltips
   $('[title]').tooltip();
});
