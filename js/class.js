//javascript functionz

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
    $.get("class.pl", {arch: $('#archlist').val(), level: $('#select_level').val()},
      function(data){
        //special effects, hide the current info
        $('#classdata').hide('blind',function(){
          //once hidden, load that info into the stuff
          $(this).empty().append(data);
          //then show the stuff
          $(this).show('blind', function() {
            bindAbilities()
          });
        });
    }, "html");
  });
}


function bindAbilities() {
  $('#ability_info>.ability_info').each(function(){
    var abl = $(this).attr('id');
    $('.'+abl).each(function(){
      var out = $(this).css('color');
      $(this).hover(function() {
        $(this).css('color','gray');
      }, function() {
        $(this).css('color',out);
      })
      $(this).css('cursor','pointer');
      $(this).click(function() {
        $("#ability_info > div").each(function(){
          $(this).hideOptionGroup();
        });
        $('#'+abl).showOptionGroup();
      });
    });
  });
}
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
    enableArch();

    //if 0, then kill it all
    if($(this).val()=='0') {
      $('#archlist').val("0");
      disableArch();
    }
  });
}



function showArch(opt) {
  //reset to ----
  $('#0').showOptionGroup();

  //clear it all
  $("#archlist > optgroup").each(function(){
  $(this).hideOptionGroup();
  });

  //show the chosen one
  $("#"+opt).showOptionGroup();
  enableArch();
  
  //if 0, then kill it all
  if(opt=='0') {
    $('#archlist').val("0");
    disableArch();
  }  
}

function disableArch() {
  $("#archlist").attr("disabled", "disabled");
  $("#get_class").attr("disabled", "disabled");
}


jQuery(document).ready(function(){
  showArch('0');
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
  $("#select_class").val('0');
  $(' [title]' ).tooltip();
  $('#get_class').loadStuff();
  $('#select_class').showArch();
});


function enableArch() {
  $("#archlist").removeAttr("disabled");
  $("#get_class").removeAttr("disabled");
}
