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

function loginVerify(event, ui) {
	var label2 = $(ui.tab).find('a').data('url');
	var label = label2 ? label2 : $(ui.tab).data('url');
	//console.log(label);
	if ( label == 'login.pl' ) {
		if ( ! ls['token'] ) {
		//	label2 ? $(ui.tab).find('a').html('Login') : $(ui.tab).html('Login');
		} else {
		//	label2 ? $(ui.tab).find('a').html('Account') : $(ui.tab).html('Account');
		postData['token'] = ls.token;
		}
	}
}

jQuery(document).ready(function(){
	$('#over_tabs').tabs({
		heightStyle: 'fill',
		activate: function(event, ui) {
                	var id = '#'+ui.newPanel.id;
                        if (ui.newTab.href != id) {
                        	ui.newTab.href = id;
			}
		},                
		beforeLoad: function(event, ui) {
			$('#over_tabs').tabs('option',{ 
				ajaxOptions:{
					data: {token:ls.token},
					type: 'post'
					} 
				} 
			);
		},
		ajaxOptions: {
			type: 'post',
			data: {token: ls.token},
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
});
