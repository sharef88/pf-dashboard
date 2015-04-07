<%
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Freeware from Seiretto.com
' available at http://asp.thedemosite.co.uk
'
' DON'T forget to change the mail_to email address below!!!
'    and thats all you need to change.
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Dim error
error = 0
For Each f In Request.Form
If Request.Form(f) = "" Then 
error = 1
End If
Next
If error=1 Then
response.redirect "error.html"
Else
Dim f, emsg, mail_to, r, o, c, other
mail_to = "andy@orbanos.org"
fline = "_______________________________________________________________________"& vbNewLine 
hline = vbNewLine & "_____________________________________"& vbNewLine 
emsg = ""

For Each f In Request.Form
If mid(f,1,1)<>"S" = True Then 'do not save if input name starts with S
emsg = emsg & f & " = " & Trim(Request.Form(f)) & hline
End If
Next

Set objNewMail = Server.CreateObject("CDONTS.NewMail")
    objNewMail.From = Request("Email Address")
    objNewMail.Subject = "Message from contact page (version: 1.0)"
    objNewMail.To = mail_to
    objNewMail.Body = emsg & fline
    objNewMail.Send
    Set objNewMail = Nothing

response.redirect "thankyou.html"
End if
%>
