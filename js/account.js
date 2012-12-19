//loaded with account.pl

//make account tabs, always have more options
$('#account_tabs').ready(function() {
   $('#account_tabs').tabs({
    active: 0,
    heightStyle: 'fill',
  });
});

//make the token_tables an accordion.... simple?
$('#token_tables').ready(function() {
   $('#token_tables').accordion({
   heightStyle: 'content',
   collapsible: true
   });
});

