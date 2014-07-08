<%
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
Function jtbc_cms_admin_manage_run()
  Dim tmpsucc, tmpfail, font_red, font_green, html_kong
  tmpsucc = itake("manage.succeed", "lng")
  tmpfail = itake("manage.failed", "lng")
  font_red = itake("global.tpl_config.font_red", "tpl")
  font_green = itake("global.tpl_config.font_green", "tpl")
  html_kong = itake("global.tpl_config.html_kong", "tpl")
  dim tmpstr, tmpary, tmpi, tmprstr
  tmpstr = get_str(request.form("sqlstrs"))
  tmpary = split(tmpstr, vbcrlf)
  For tmpi = 0 to UBound(tmpary)
    If run_sqlstr(tmpary(tmpi)) Then
      tmprstr = tmprstr & htmlencode(tmpary(tmpi)) & html_kong & replace(font_green,"{$explain}",tmpsucc) & vbcrlf
    Else
      tmprstr = tmprstr & htmlencode(tmpary(tmpi)) & html_kong & replace(font_red,"{$explain}",tmpfail) & vbcrlf
    End If
  Next
  jtbc_cms_admin_manage_run = encode_art(tmprstr)
End Function

Sub jtbc_cms_admin_manage_form()
  Dim tmpstr, tmpastr
  tmpstr = ireplace("manage.form", "tpl")
  response.write tmpstr
End Sub

Sub jtbc_cms_admin_manage()
  Call jtbc_cms_admin_manage_form
End Sub
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
%>
