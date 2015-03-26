var len = 1
var ls = localStorage;
var sha = CryptoJS.SHA256;

//dice, what else?
function dice(x) {
   var randomnumber=Math.floor(Math.random()*(parseInt(x)-1))+1;
   return randomnumber
}

//function for initilizing a side panel, still needs some work
$.fn.panel = function(side, width, height) {
   var $this = $(this);
   $(this).css('width',-width+'px');
   $(this).css(side,width-2+'px');
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
      'right' : '0px'
      }, 900);
   }, function() {
      //do nothing
   });
   $(this).hover(function() {
      // Do nothing
   }, function() {
      $(this).animate({
         right: width-2+'px'
      }, 800);
   });
};

//function for switching to the account page if properly logged in.
$.fn.account = function() {
   //override the tabs ajax data, doesn't auto-refresh
   $('#over_tabs').tabs('option',{
      ajaxOptions:{
         data: {session: ls.session},
         type: 'post'
      }
   });

   $("a[data-url='login.pl']").attr('data-url','account.pl').attr('href','account.pl').html('Account');
   $('#over_tabs').tabs('load',parseInt($("a[data-url='account.pl']").parents('li').index()));
   $('#logout').show()
   console.log('switched to account page');
}

//function for switching back to the login page from account, while clearing the session value
$.fn.logout = function() {
   ls.session="[307]";

   //override the tab-ajax info, as it doesn't aut-refresh
   $('#over_tabs').tabs('option',{
      ajaxOptions:{
         data: {session: ls.session},
         type: 'post'
      }
   });
   //clear the name from the logout area
   $('#logout>span').html('');

   //switch the href of the tab to login.pl, and force-reload it
   $("a[data-url='account.pl']").attr('data-url','login.pl').attr('href','login.pl').html('Login');
   $('#over_tabs').tabs('load',parseInt($("a[data-url='login.pl']").parents('li').index()));
   
   //hide logout button
   $('#logout').hide();
   console.log('logged out, switched to login/register');
}



jQuery(document).ready(function(){
   $('#over_tabs').tabs({
      heightStyle: 'fill',
      load: function(event, ui) {
         //when a tab is loaded, switch the href to the anchor so as to not reload the page
         var id = '#'+ui.panel.id;
         if (ui.tab.href != id) {
            ui.tab.href = id;
         }
      },                
      beforeLoad: function(event, ui) {
         // before loading, refresh the ajax data
         $('#over_tabs').tabs('option',{ 
            ajaxOptions:{
               data: {session: ls.session},
               type: 'post'
            } 
         });
      },
      ajaxOptions: {
         //ajax options, use post, set up ajax data, a basic error function
         type: 'post',
         data: {session: ls.session},
         error: function(xhr, status, index, anchor) {
            $(anchor.hash).html("Couldn't load this tab. Go yell at sharef about it!");
         }
      },
   }).addClass( "ui-tabs-vertical ui-helper-clearfix" );

   //vertical tab styling
   $('#over_menu>li').removeClass( "ui-corner-top" )
   $('#over_menu>li').addClass( "ui-corner-left" )
   
   //Make the refresh buttons actually refresh
   $('.over_tab_refresh').button({
      icons: {
         primary:'ui-icon-refresh'
      }, 
      text: false 
   }).click(function() {
      //the original url is stored in data-url on the <a>
      $(this).siblings('a').attr('href',$(this).siblings('a').data('url'));
      $('#over_tabs').tabs('load',parseInt($(this).parents('li').index()));
   });
   
   //custom color all tooltips that are loaded
   $('[title]' ).tooltip();

   //initilize the right panel
   $('#RightPanel').panel('right',-500,300);

   //initilize the logout button
   $('#logout>a').button().click(
      function() {
         $(this).logout()
      }
   );
});
