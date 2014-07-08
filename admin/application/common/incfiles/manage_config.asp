<%
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
Sub jtbc_cms_admin_manage_list()
  Dim tmpstr, tmpastr
  tmpstr = ireplace("manage.list", "tpl")
  tmpastr = ctemplate(tmpstr, "{$recurrence_ida}")
  Dim tmprstr, tmptstr
  Dim tmpa, app, tmpi
  Set tmpa = application.Contents
  For Each app In tmpa
    tmptstr = Replace(tmpastr, "{$name}", htmlencode(app))
    tmprstr = tmprstr & tmptstr
  Next
  tmpstr = Replace(tmpstr, jtbc_cinfo, tmprstr)
  Set tmpa = Nothing
  response.write tmpstr
End Sub

Sub jtbc_cms_admin_manage_detail()
  On Error Resume Next
  Dim tmpstr, tmpastr
  tmpstr = ireplace("manage.detail", "tpl")
  tmpastr = ctemplate(tmpstr, "{$recurrence_ida}")
  Dim tmprstr, tmptstr
  Dim tmpa, app, tmpi
  app = application(request.querystring("app"))
  If IsArray(app) Then
    If UBound(app, 2) = 1 Then
      tmpa = UBound(app)
      For tmpi = 0 To tmpa
        tmptstr = Replace(tmpastr, "{$valuea}", htmlencode(app(tmpi, 0)))
        tmptstr = Replace(tmptstr, "{$valueb}", htmlencode(app(tmpi, 1)))
        tmprstr = tmprstr & tmptstr
      Next
    Else
      tmptstr = Replace(tmpastr, "{$valuea}", htmlencode(request.querystring("app")))
      tmptstr = Replace(tmptstr, "{$valueb}", "Array")
      tmprstr = tmprstr & tmptstr
    End If
  Else
    tmptstr = Replace(tmpastr, "{$valuea}", htmlencode(request.querystring("app")))
    tmptstr = Replace(tmptstr, "{$valueb}", htmlencode(app))
    tmprstr = tmprstr & tmptstr
  End If
  tmpstr = Replace(tmpstr, jtbc_cinfo, tmprstr)
  response.write tmpstr
End Sub

Sub jtbc_cms_admin_manage_delete()
  Dim tmpstr
  tmpstr = get_safecode(request.querystring("app"))
  Call remove_application(tmpstr)
  response.redirect "?"
End Sub

Sub jtbc_cms_admin_manage_removeall()
  Call remove_application("")
  response.redirect "?"
End Sub

Sub jtbc_cms_admin_manage_action()
  Select Case request.querystring("action")
    Case "delete"
      Call jtbc_cms_admin_manage_delete
    Case "removeall"
      Call jtbc_cms_admin_manage_removeall
  End Select
End Sub

Sub jtbc_cms_admin_manage()
  Select Case request.querystring("type")
    Case "detail"
      Call jtbc_cms_admin_manage_detail
    Case Else
      Call jtbc_cms_admin_manage_list
  End Select
End Sub
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
%>
