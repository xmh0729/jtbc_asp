<%
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
ncontrol = "select,delete"
Const nsearch = "username,id"

Function navigation()
  Dim tmpstr
  tmpstr = ireplace("manage.navigation", "tpl")
  navigation = tmpstr
End Function

Sub jtbc_cms_admin_manage_list()
  Dim search_field, search_keyword
  search_field = get_safecode(request.querystring("field"))
  search_keyword = get_safecode(request.querystring("keyword"))
  Dim tmpstr, tmpastr
  tmpstr = ireplace("manage.list", "tpl")
  tmpastr = ctemplate(tmpstr, "{$recurrence_ida}")
  Dim tmprstr, tmptstr
  sqlstr = "select * from " & ndatabase & " where " & nidfield & ">0"
  If search_field = "username" Then sqlstr = sqlstr & " and " & cfname("name") & " like '%" & search_keyword & "%'"
  If search_field = "id" Then sqlstr = sqlstr & " and " & nidfield & "=" & get_num(search_keyword, 0)
  If search_field = "islogin" Then sqlstr = sqlstr & " and " & cfname("islogin") & "=" & get_num(search_keyword, 0)
  sqlstr = sqlstr & " order by " & nidfield & " desc"
  Dim jcutpage, jcuti
  Set jcutpage = New jtbc_cutpage
  jcutpage.perpage = npagesize
  jcutpage.sqlstr = sqlstr
  jcutpage.cutpage
  Set rs = jcutpage.pagers
  Dim font_disabled, tmpyes, tmpno
  font_disabled = itake("global.tpl_config.font_disabled", "tpl")
  tmpyes = itake("global.lng_config.yes", "lng")
  tmpno = itake("global.lng_config.no", "lng")
  Dim tmpusername, tmpislogin
  For jcuti = 1 To npagesize
    If Not rs.EOF Then
      tmpislogin = tmpyes
      tmpusername = rs(cfname("name"))
      If rs(cfname("islogin")) = 0 Then
        tmpusername = Replace(font_disabled, "{$explain}", tmpusername)
        tmpislogin = tmpno
      End if
      tmptstr = Replace(tmpastr, "{$username}", tmpusername)
      tmptstr = Replace(tmptstr, "{$usernamestr}", rs(cfname("name")))
      tmptstr = Replace(tmptstr, "{$time}", rs(cfname("time")))
      tmptstr = Replace(tmptstr, "{$ip}", rs(cfname("ip")))
      tmptstr = Replace(tmptstr, "{$islogin}", tmpislogin)
      tmptstr = Replace(tmptstr, "{$id}", rs(nidfield))
      rs.movenext
      tmprstr = tmprstr & tmptstr
    End If
  Next
  tmpstr = Replace(tmpstr, "{$cpagestr}", jcutpage.pagestr)
  Set rs = Nothing
  Set jcutpage = Nothing
  tmpstr = Replace(tmpstr, jtbc_cinfo, tmprstr)
  response.write tmpstr
End Sub

Sub jtbc_cms_admin_manage_action()
  Select Case request.querystring("action")
    Case "delete"
      Call jtbc_cms_admin_deletedisp
    Case "control"
      Call jtbc_cms_admin_controldisp
  End Select
End Sub

Sub jtbc_cms_admin_manage()
  Call jtbc_cms_admin_manage_list
End Sub
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
%>
