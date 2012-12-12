//javascript functionz
var len = 1
var ls = localStorage;
var sha = CryptoJS.SHA256;
var postData = {};

function dice(x) {
 var randomnumber=Math.floor(Math.random()*(parseInt(x)-1))+1;
 return randomnumber
}

$.fn.panel = function(side,width, height) {
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
	});
	$(this).hover(function() {
	// Do nothing
	}, function() {
		$(this).animate({
			right: width-2+'px'
		}, 800);
	});
};


$.fn.account = function() {
   $("a[data-url='login.pl']").attr('data-url','account.pl').attr('href','account.pl');
   $('#over_tabs').tabs('load',parseInt($("a[data-url='account.pl']").parents('li').index()));
   $('#logout').show()
   console.log('switched to account page');
}

$.fn.logout = function() {
   delete localStorage['session'];
   
   $("a[data-url='account.pl']").attr('data-url','login.pl').attr('href','login.pl');
   $('#over_tabs').tabs('load',parseInt($("a[data-url='login.pl']").parents('li').index()));
   $('#logout').hide();
   console.log('logged out, switched to login/register');
}



jQuery(document).ready(function(){
	$('#over_tabs').tabs({
		heightStyle: 'fill',
		load: function(event, ui) {
                	var id = '#'+ui.panel.id;
                        if (ui.tab.href != id) {
                        	ui.tab.href = id;
			}
		},                
		beforeLoad: function(event, ui) {
			$('#over_tabs').tabs('option',{ 
				ajaxOptions:{
					data: {session:ls.session},
					type: 'post'
					} 
				} 
			);
                       if (ls.session) { 
                           if ( $.inArray($.parseJSON(ls.session)[0], [200,201,202]) ) {
//                             $(this).account(); 
                           }
                        }
		},
		ajaxOptions: {
			type: 'post',
			data: {session: ls.session},
			error: function(xhr, status, index, anchor) {
				$(anchor.hash).html("Couldn't load this tab. Go yell at sharef about it!");
			}
		},
//		create: function(){$(this).tabs('load',1);}
	}).addClass( "ui-tabs-vertical ui-helper-clearfix" );
	$('#over_menu>li').removeClass( "ui-corner-top" )
	$('#over_menu>li').addClass( "ui-corner-left" )
        $('.over_tab_refresh').button({icons: {primary:'ui-icon-refresh'}, text: false }).click(function() {
		$(this).siblings('a').attr('href',$(this).siblings('a').data('url'));
		$('#over_tabs').tabs('load',parseInt($(this).parents('li').index()));
	});

	$('[title]' ).tooltip();
	$('#RightPanel').panel('right',-500,300);
        $('#logout').click(function(){$(this).logout()});
});
