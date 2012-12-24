//loaded with account.pl

//make account tabs, always have more options
$('#account_tabs').ready(function() {
   $('#account_tabs').tabs({
    active: 0,
    heightStyle: 'fill',
  });
});

$('#account_personal').ready(function() {
   $('#gender').buttonset();
   $('.account_control>input').button();
   $(this).find('form').submit(function() {
      console.log('omg submitted!');
      return false;
   });
});

//make the token_tables an accordion.... simple?
$('#token_tables').ready(function() {
   $('#token_tables').accordion({
   heightStyle: 'content',
   collapsible: true
   });
});

