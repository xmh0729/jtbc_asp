<%
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
Function jtbc_cms_module_list()
  Dim tmpstr, tmpastr, tmprstr, tmptstr
  tmpstr = itake("module.list", "tpl")
  tmpastr = ctemplate(tmpstr, "{$recurrence_ida}")
  sqlstr = "select * from " & ndatabase & " where " & cfname("username") & "='" & nusername & "' order by " & cfname("time") & " desc"
  Dim jcutpage, jcuti
  Set jcutpage = New jtbc_cutpage
  jcutpage.perpage = npagesize
  jcutpage.sqlstr = sqlstr
  jcutpage.cutpage
  Set rs = jcutpage.pagers
  For jcuti = 1 To npagesize
    If Not rs.EOF Then
      tmptstr = Replace(tmpastr, "{$name}", htmlencode(get_str(rs(cfname("name")))))
      tmptstr = Replace(tmptstr, "{$time}", get_date(rs(cfname("time"))))
      tmptstr = Replace(tmptstr, "{$id}", get_num(rs(nidfield), 0))
      rs.movenext
      tmprstr = tmprstr & tmptstr
    End If
  Next
  tmpstr = Replace(tmpstr, "{$cpagestr}", jcutpage.pagestr)
  Set rs = Nothing
  Set jcutpage = Nothing
  tmpstr = Replace(tmpstr, jtbc_cinfo, tmprstr)
  tmpstr = creplace(tmpstr)
  jtbc_cms_module_list = tmpstr
End Function

Function jtbc_cms_module()
  Call isuserlogin("0")
  Select Case request.querystring("type")
    Case "list"
      jtbc_cms_module = jtbc_cms_module_list
    Case Else
      jtbc_cms_module = jtbc_cms_module_list
  End Select
End Function

Sub jtbc_cms_module_adddisp()
  Dim tname: tname = get_safecode(request.form("name"))
  Dim tbackurl: tbackurl = get_safecode(request.querystring("backurl"))
  If check_isuser(tname) = 0 Then Call imessage(itake("manage.add_error1", "lng"), tbackurl)
  Set rs = server.CreateObject("adodb.recordset")
  sqlstr = "select * from " & ndatabase & " where " & cfname("username") & "='" & nusername & "'"
  rs.open sqlstr, conn, 1, 3
  If rs.recordcount >= friend_max Then Call imessage(ireplace("manage.add_error2", "lng"), tbackurl)
  rs.addnew
  rs(cfname("name")) = tname
  rs(cfname("username")) = nusername
  rs(cfname("time")) = Now()
  rs.update
  Set rs = Nothing
  response.redirect tbackurl
End Sub

Sub jtbc_cms_module_controldisp
  Dim tbackurl: tbackurl = get_safecode(request.querystring("backurl"))
  Dim tcid: tcid = get_safecode(request.Form("sel_id"))
  Dim totsql: totsql = " and " & cfname("username") & "='" & nusername & "'"
  Call dbase_delete(ndatabase, nidfield, tcid, totsql)
  response.redirect tbackurl
End Sub

Sub jtbc_cms_module_action()
  Call isuserlogin("0")
  Select Case request.querystring("action")
    Case "add"
      Call jtbc_cms_module_adddisp
    Case "control"
      Call jtbc_cms_module_controldisp
  End Select
End Sub
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
%>
