$.fn.login = function() {
   var stuff = $('#login').serializeArray();
   stuff[2]['value']=sha(stuff[2]['value']);
   if ( stuff[0]['name'] == 'register' ) {
      stuff[3]['value']=sha(stuff[3]['value']);
   }
   $.post('login.pl', stuff,
      function(data) {
         //var token=$.parseJSON(data);
         var token = data[0][0] ? data[0] : data;
         //[code,token,time]

         switch(token[0]) {
            case 200:
            //token accepted, logged in
            break;
         case 202:
            //login successful, new token
            ls.token = JSON.stringify(token);
            break;
         case 201:
            //Registration successful
            break;
         case 401:
            //wrong password
            break;
         case 404:
        //user doesn't exist
        break;
         case 409:
           //could not register, collision
           break;
         default:
            console.log('Status code not recognized');
            break;
         } 
      }
   );
}




jQuery(document).ready( function() {

   $("#login_control>input").button();
   //login, function, yes?
   $('#login').submit(
      function() { 
         $(this).login();

         //kill the default submit function
         return false;
      }
   );

   //buttonset, jqueryui the system radio buttons (pathfinder/gram)
   $('#register_system > div').buttonset();

   //TODO: trolololol, should send stuff to server, needs a function
   $('#forgot_password').click(function() { alert("Guess you should have written it down then eh?") });

   //verify that the verification password matches the first password
   $('#login_password>input').change(function() { $('#register_password>input').attr('pattern',$('#login_password>input').val()); });

   //I'm too lazy to stick the diabled attribute into the original generated code, this is shorter anyway  
   $('#register_div input').each(function() {
      $(this).attr('disabled','disabled');
   })

   //it defaults to 'Account'  change it to be an appropriate thing
   $('#over_menu a[data-url="login.pl"]').html('Login');

   //Switch between register and login mode, disable/enable the inputs to cut down on the mess.
   $('#register').toggle(
      function() {
         $('#register_div').show('fast');
         //button re-label
         $('#login_control>input').val('Register');
         //the title? change it!
         $('#login_div h3').html('Register');
         //can't forget a password that isn't set
         $('#forgot_password').hide();
         //change the supah secret hidden value to switch the cgi-perl scripts mode
         $('#login_div>form>input[type=hidden]').attr('name','register');
         //enable all the values
         $('#register_div input').each(function() {
            $(this).removeAttr('disabled');
         })
         // change the tabs label
         $('#over_menu a[data-url="login.pl"]').html('Register');

         // change the register link
         $('#login_tab #register').html('Back');
      }, 
      function() {
         // reset everything that was above 
         $('#register_div').hide('fast');
         $('#login_control>input').val('Login');
         $('#login_div h3').empty().append('Login');
         $('#forgot_password').show();
         $('#login_div>form>input[type=hidden]').attr('name','login');
         $('#register_div input').each(function() {
            $(this).attr('disabled','disabled');
         })
         $('#over_menu a[data-url="login.pl"]').html('Login');
         $('#login_tab #register').html('Register');
      }
   );
})
