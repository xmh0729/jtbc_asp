<%
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
Const emailtpsend = 0

Function email_send(ByVal strsendname, ByVal strsubject, ByVal strbody, ByVal strstandby)
  On Error Resume Next
  email_send = true
  Dim tstrcharset, tstrfromname, tstrserver, tstrusername, tstrpassword
  tstrcharset = get_str(get_value("common.mail.smtpcharset"))
  tstrfromname = get_str(get_value("common.mail.smtpfromname"))
  tstrserver = get_str(get_value("common.mail.smtpserver"))
  tstrusername = get_str(get_value("common.mail.smtpusername"))
  tstrpassword = get_str(get_value("common.mail.smtppassword"))

  Select Case emailtpsend
    Case 0
      Dim teobj: Set teobj = Server.CreateObject("JMail.Message") 
      teobj.silent = true
      teobj.Logging = true
      teobj.ContentType = "text/html; Charset=" & tstrcharset
      teobj.Charset = tstrcharset
      teobj.MailServerUserName = get_str(tstrusername)
      teobj.MailServerPassword = get_str(tstrpassword)
      teobj.From = get_str(tstrusername)
      teobj.FromName = get_str(tstrfromname)
      teobj.AddRecipient (get_str(strsendname))
      teobj.Subject = get_str(strsubject)
      teobj.Body = get_str(strbody)
      teobj.Send (get_str(tstrserver))
      Set teobj = Nothing
  End Select
  If Err Then email_send = false
End Function
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
%>
