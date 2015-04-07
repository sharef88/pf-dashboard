<html>
<%
Set Mail=CreateObject("CDO.Message")
Mail.Subject="test email"
Mail.From="andy@makingtecheasy.com"
Mail.To="andy@orbanos.org"
Mail.ReplyTo ="andy@makingtecheasy.com"
Mail.HTMLBody = "<h1>This is a test message.</h1>"
Mail.Send
set Mail=nothing
%>
</html>
