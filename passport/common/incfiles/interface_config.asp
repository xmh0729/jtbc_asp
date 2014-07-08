<%
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
Response.Expires = 0
Response.CacheControl = "no-cache"
Response.AddHeader "Pragma", "no-cache"

Call user_init()

Sub jtbc_cms_interface_login()
  Dim tmpstr
  If check_null(nusername) Then
    tmpstr = ireplace("global." & userfolder & ":api.jslogin_login", "tpl")
    tmpstr = cvalhtml(tmpstr, nvalidate, "{$recurrence_valcode}")
    response.write tmpstr
  Else
    Dim tmessage: tmessage = itake("global." & userfolder & ":api.message", "lng")
    Dim font_red: font_red = itake("global.tpl_config.font_red", "tpl")
    font_red = Replace(font_red, "{$explain}", count_user_message(nusername))
    tmessage = replace(tmessage, "[]", "[" & font_red & "]")
    tmpstr = ireplace("global." & userfolder & ":api.jslogin_logined", "tpl")
    tmpstr = replace(tmpstr, "{$message}", tmessage)
    response.write tmpstr
  End If
End Sub

Sub jtbc_cms_interface_nlogin()
  If Not ck_valcode() Then
    response.write "error1"
  Else
    response.cookies(appname & "user")("uname") = get_str(request.querystring("username"))
    response.cookies(appname & "user")("pword") = md5(get_str(request.querystring("password")), "2")
    If get_num(request.querystring("autologin"), 0) = 1 Then response.cookies(appname & "user").expires = Date + 365
    If check_userlogin Then
      response.write "ok"
    Else
      response.write "error2"
    End If
  End If
End Sub

Sub jtbc_cms_interface_check_username()
  Dim tusername: tusername = get_safecode(request.querystring("username"))
  If check_isuser(tusername) = 0 Then
    response.write "0"
  Else
    response.write "1"
  End If
End Sub

Sub jtbc_cms_interface
  Select Case request.querystring("type")
    Case "login"
      Call jtbc_cms_interface_login
    Case "nlogin"
      Call jtbc_cms_interface_nlogin
    Case "check_username"
      Call jtbc_cms_interface_check_username
  End select
End Sub
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
%>
