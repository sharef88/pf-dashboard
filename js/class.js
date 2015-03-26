//javascript functionz

//comprehensive group hiding and reordering functions
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

$.fn.loadStuff = function(){
   //click on the button?
   $(this).click(function() {
      //yes? go get stuff ajax style
      $.get("class.pl", 
         //set the stuff to send, arch_id and level
         {arch: $('#archlist').val(), level: $('#select_level').val()},
         function(data) {
            
            //special effects, hide the current info
            $('#classdata').hide('blind',function(){
               //once hidden, load that info into the stuff
               
               $(this).empty().append(data);
               //then show the stuff
               
               $(this).show('blind', function() {
                  //finally, bind the abilities with function
                  bindAbilities()
               });
            
            }); //end classdata hide
         }, "html");
   });
}


function bindAbilities() {
   $('#ability_info>.ability_info').each(function(){
      //store the id of the thing
      var abl = $(this).attr('id');

      //for each reference to the ability
      $('.'+abl).each(function(){
         //store the base color
         var out = $(this).css('color');

         //on hover, change color to gray, on not-hover, change back to stored base color
         $(this).hover(function() {
            $(this).css('color','gray');
         }, function() {
            $(this).css('color',out);
         })
         //change the cursor to be a pointer instead of a normal one
         $(this).css('cursor','pointer');

         //click binding
         $(this).click(function() {
            //hide all the option groups
            $("#ability_info > div").each(function(){
               $(this).hideOptionGroup();
            });
            //show the needed one
            $('#'+abl).showOptionGroup();
         }); //end click
      });
   });
}
//function for displaying the archtype list properly
$.fn.showArch = function() {
   $(this).change(function() {
      //reset to ----
      $('#0').showOptionGroup();

      //clear it all
      $("#archlist > optgroup").each(function(){
         $(this).hideOptionGroup();
      });

      //show the chosen one
      $("#"+$(this).val()).showOptionGroup();
      $("#archlist").removeAttr("disabled");
      $("#get_class").removeAttr("disabled");

      //if 0, then kill it all
      if($(this).val()=='0') {
         $('#archlist').val("0");
         $("#archlist").attr("disabled", "disabled");
         $("#get_class").attr("disabled", "disabled");
      }
   });
}

jQuery('#class_select').ready(function(){
   //setup the level selection to be a 1-20 level spinner
   $('.spinner').spinner({
      spin: function( event, ui ) {
         if ( ui.value > 20 ) {
            $( this ).spinner( "value", 1 );
            return false;
         } else if ( ui.value < 1 ) {
            $( this ).spinner( "value", 20 );
            return false;
         }
      }
   });
   
   $(' [title]' ).tooltip();

   //if get_class, load stuff!
   $('#get_class').loadStuff();

   //bind class to archtype windows
   $('#select_class').showArch();
   
   //trigger the archtype update
   $('#select_class').change();
});
