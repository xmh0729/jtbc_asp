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
  sqlstr = "select * from " & ndatabase & " where " & cfname("recipients") & "='" & nusername & "' order by " & cfname("read") & " asc," & cfname("time") & " desc"
  Dim jcutpage, jcuti
  Set jcutpage = New jtbc_cutpage
  jcutpage.perpage = npagesize
  jcutpage.sqlstr = sqlstr
  jcutpage.cutpage
  Set rs = jcutpage.pagers
  For jcuti = 1 To npagesize
    If Not rs.EOF Then
      tmptstr = Replace(tmpastr, "{$read}", get_num(rs(cfname("read")), 0))
      tmptstr = Replace(tmptstr, "{$addresser}", htmlencode(get_str(rs(cfname("addresser")))))
      tmptstr = Replace(tmptstr, "{$topic}", htmlencode(get_str(rs(cfname("topic")))))
      tmptstr = Replace(tmptstr, "{$time}", get_date(rs(cfname("time"))))
      tmptstr = Replace(tmptstr, "{$len}", get_num(rs(cfname("len")), 0))
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

Function jtbc_cms_module_listb()
  Dim tmpstr, tmpastr, tmprstr, tmptstr
  tmpstr = itake("module.listb", "tpl")
  tmpastr = ctemplate(tmpstr, "{$recurrence_ida}")
  sqlstr = "select * from " & ndatabase & " where " & cfname("addresser") & "='" & nusername & "' order by " & cfname("time") & " desc"
  Dim jcutpage, jcuti
  Set jcutpage = New jtbc_cutpage
  jcutpage.perpage = npagesize
  jcutpage.sqlstr = sqlstr
  jcutpage.cutpage
  Set rs = jcutpage.pagers
  For jcuti = 1 To npagesize
    If Not rs.EOF Then
      tmptstr = Replace(tmpastr, "{$read}", get_num(rs(cfname("read")), 0))
      tmptstr = Replace(tmptstr, "{$recipients}", htmlencode(get_str(rs(cfname("recipients")))))
      tmptstr = Replace(tmptstr, "{$topic}", htmlencode(get_str(rs(cfname("topic")))))
      tmptstr = Replace(tmptstr, "{$time}", get_date(rs(cfname("time"))))
      tmptstr = Replace(tmptstr, "{$len}", get_num(rs(cfname("len")), 0))
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
  jtbc_cms_module_listb = tmpstr
End Function

Function jtbc_cms_module_detail()
  Dim tid, tmpstr
  tid = get_num(request.querystring("id"),0)
  Set rs = server.CreateObject("adodb.recordset")
  sqlstr = "select * from " & ndatabase & " where (" & cfname("recipients") & "='" & nusername & "' or " & cfname("addresser") & "='" & nusername & "') and " & nidfield & "=" & tid
  rs.open sqlstr, conn, 1, 3
  If not rs.EOF then
    If rs(cfname("read")) = 0 and rs(cfname("recipients")) = nusername Then
      rs(cfname("read")) = 1
      rs.update
    End If
    tmpstr = itake("module.detail", "tpl")
    tmpstr = replace(tmpstr, "{$topic}", htmlencode(get_str(rs(cfname("topic")))))
    tmpstr = replace(tmpstr, "{$content}", encode_article(ubbcode(htmlencode(get_str(rs(cfname("content")))), 0)))
    tmpstr = replace(tmpstr, "{$addresser}", htmlencode(get_str(rs(cfname("addresser")))))
    tmpstr = replace(tmpstr, "{$time}", get_date(rs(cfname("time"))))
    tmpstr = replace(tmpstr, "{$id}", get_num(rs(nidfield), 0))
    tmpstr = replace(tmpstr, "{$topicstr}", urlencode(get_str(rs(cfname("topic")))))
    tmpstr = replace(tmpstr, "{$addresserstr}", urlencode(get_str(rs(cfname("addresser")))))
    tmpstr = creplace(tmpstr)
    jtbc_cms_module_detail = tmpstr
  Else
    Call imessage(itake("manage.detail_error", "lng"), "0")
  End If
  Set rs = nothing
End Function

Function jtbc_cms_module_send()
  Dim tmpstr: tmpstr = ireplace("module.send", "tpl")
  jtbc_cms_module_send = tmpstr
End Function

Function jtbc_cms_module()
  Call isuserlogin("0")
  Select Case get_ctype(request.querystring("type"), ECtype)
    Case "send"
      jtbc_cms_module = jtbc_cms_module_send
    Case "detail"
      jtbc_cms_module = jtbc_cms_module_detail
    Case "list"
      jtbc_cms_module = jtbc_cms_module_list
    Case "listb"
      jtbc_cms_module = jtbc_cms_module_listb
    Case Else
      jtbc_cms_module = jtbc_cms_module_list
  End Select
End Function

Sub jtbc_cms_module_senddisp()
  ECtype = "send"
  Dim tbackurl: tbackurl = get_safecode(request.querystring("backurl"))
  Dim trecipients: trecipients = get_safecode(request.form("recipients"))
  Dim tuserstate: tuserstate = check_isuser(trecipients)
  If tuserstate = 0 Then ErrStr = ErrStr & itake("manage.recipients_error", "lng") & spa
  If tuserstate = 2 Then ErrStr = ErrStr & itake("manage.recipients_error2", "lng") & spa
  If count_user_message(trecipients) >= message_max Then ErrStr = ErrStr & ireplace("manage.recipients_error_max", "lng") & spa
  Dim tmpchkstr, tmpcitem
  tmpchkstr = "topic:" & itake("global.lng_config.topic", "lng") & ",content:" & itake("global.lng_config.content", "lng")
  For Each tmpcitem In Split(tmpchkstr, ",")
    If check_null(request.Form(Split(tmpcitem, ":")(0))) Then
      ErrStr = ErrStr & replace(itake("global.lng_error.insert_empty", "lng"), "[]", "[" & Split(tmpcitem, ":")(1) & "]") & spa
    End If
  Next
  If check_null(ErrStr) Then
    Set rs = server.CreateObject("adodb.recordset")
    sqlstr = "select * from " & ndatabase
    rs.open sqlstr, conn, 1, 3
    rs.addnew
    rs(cfname("topic")) = left_intercept(get_str(request.Form("topic")), 50)
    rs(cfname("content")) = left_intercept(get_str(request.Form("content")), 1000)
    rs(cfname("time")) = Now()
    rs(cfname("len")) = Len(left_intercept(get_str(request.Form("content")), 1000))
    rs(cfname("addresser")) = nusername
    rs(cfname("recipients")) = trecipients
    rs.update
    Set rs = Nothing
    Call imessage(itake("manage.send_succeed", "lng"), tbackurl)
  End If
End Sub

Sub jtbc_cms_module_controldisp()
  Dim tbackurl: tbackurl = get_safecode(request.querystring("backurl"))
  Dim tcid: tcid = get_safecode(request.Form("sel_id"))
  Dim totsql: totsql = " and " & cfname("recipients") & "='" & nusername & "'"
  Call dbase_delete(ndatabase, nidfield, tcid, totsql)
  response.redirect tbackurl
End Sub

Sub jtbc_cms_module_deletedisp()
  Dim tid: tid = get_num(request.querystring("id"), 0)
  Dim tbackurl: tbackurl = get_safecode(request.querystring("backurl"))
  Set rs = server.CreateObject("adodb.recordset")
  sqlstr = "select * from " & ndatabase & " where " & cfname("recipients") & "='" & nusername & "' and " & nidfield & "=" & tid
  rs.open sqlstr, conn, 1, 3
  If not rs.EOF Then
    rs.delete
    response.redirect "?type=list"
  Else
    Call imessage(itake("manage.delete_error", "lng"), tbackurl)
  End If
End Sub

Sub jtbc_cms_module_action()
  Call isuserlogin("0")
  Select Case request.querystring("action")
    Case "send"
      Call jtbc_cms_module_senddisp
    Case "control"
      Call jtbc_cms_module_controldisp
    Case "delete"
      Call jtbc_cms_module_deletedisp
  End Select
End Sub
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
%>
