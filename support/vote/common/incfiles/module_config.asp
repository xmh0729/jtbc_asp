<%
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
Function jtbc_cms_module_view()
  Dim tid: tid = get_num(request.querystring("id"), 0)
  sqlstr = "select * from " & ndatabase & " where " & nidfield & "=" & tid
  Set rs = conn.Execute(sqlstr)
  If not rs.EOF Then
    Dim tmpstr, tmpastr, tmptstr, tmprstr
    tmpstr = itake("module.view", "tpl")
    tmpstr = replace(tmpstr, "{$vtopic}", htmlencode(get_str(rs(cfname("topic")))))
    Dim tdatabase, tidfield, tfpre
    tdatabase = cndatabase(cvgenre(ngenre), "data")
    tidfield = cnidfield(cvgenre(ngenre), "data")
    tfpre = cnfpre(cvgenre(ngenre), "data")
    Dim ti, tary, taryt, tacount
    ti = 0: tacount = 0
    Dim trs, tsqlstr
    Set trs = server.CreateObject("adodb.recordset")
    tsqlstr = "select * from " & tdatabase & " where " & cfnames(tfpre, "fid") & "=" & tid
    trs.open tsqlstr, conn, 1, 3
    redim tary(trs.recordcount - 1)
    redim taryt(trs.recordcount - 1)
    Do While Not trs.EOF
      tary(ti) = get_num(trs(cfnames(tfpre, "count")), 0)
      taryt(ti) = htmlencode(get_str(trs(cfnames(tfpre, "topic"))))
      tacount = tacount + trs(cfnames(tfpre, "count"))
      trs.movenext
      ti = ti + 1
    loop
    tmpastr = ctemplate(tmpstr, "{$recurrence_ida}")
    For ti = 0 to UBound(tary)
      tmptstr = Replace(tmpastr, "{$topic}", taryt(ti))
      tmptstr = Replace(tmptstr, "{$count}", tary(ti))
      tmptstr = Replace(tmptstr, "{$per}", cper(tary(ti), tacount))
      tmprstr = tmprstr & tmptstr
    Next
    tmpstr = Replace(tmpstr, jtbc_cinfo, tmprstr)
    tmpstr = creplace(tmpstr)
  End If
  Set rs = Nothing
  jtbc_cms_module_view = tmpstr
End Function

Function jtbc_cms_module()
  Select case request.querystring("type")
    Case "view"
      jtbc_cms_module = jtbc_cms_module_view
  End Select
End Function

Sub jtbc_cms_module_votedisp()
  Dim tid: tid = get_num(request.querystring("id"), 0)
  If get_num(request.cookies(appname & "vote")(CStr(tid)), 0) = 1 Then Call client_alert(itake("module.vote_failed", "lng"), -1)
  Dim tvotes: tvotes = get_str(request.form("votes"))
  If check_null(tvotes) Then Call client_alert(itake("module.vote_error6", "lng"), -1)
  sqlstr = "select * from " & ndatabase & " where " & nidfield & "=" & tid
  Set rs = conn.Execute(sqlstr)
  If not rs.EOF Then
    If rs(cfname("lock")) = 1 Then Call client_alert(itake("module.vote_error2", "lng"), -1)
    If DateDiff("d", rs(cfname("starttime")), Now()) < 0 Then Call client_alert(itake("module.vote_error3", "lng"), -1)
    If DateDiff("d", rs(cfname("endtime")), Now()) > 0 Then Call client_alert(itake("module.vote_error4", "lng"), -1)
    If rs(cfname("type")) = 0 Then
      tvotes = get_num(tvotes, 0)
      If tvotes = 0 Then Call client_alert(itake("module.vote_error0", "lng"), -1)
    Else
      tvotes = format_checkbox(tvotes)
      If Not cidary(tvotes) Then Call client_alert(itake("module.vote_error0", "lng"), -1)
    End If
  Else
    Call client_alert(itake("module.vote_error1", "lng"), -1)
  End If
  Set rs = Nothing
  Dim tdatabase, tidfield, tfpre
  tdatabase = cndatabase(cvgenre(ngenre), "voter")
  tidfield = cnidfield(cvgenre(ngenre), "voter")
  tfpre = cnfpre(cvgenre(ngenre), "voter")
  sqlstr = "select * from " & tdatabase & " where " & cfnames(tfpre, "fid") & "=" & tid & " and " & cfnames(tfpre, "ip") & "='" & nuserip & "'"
  Set rs = server.CreateObject("adodb.recordset")
  rs.open sqlstr, conn, 1, 3
  If Not rs.EOF Then
    Call client_alert(itake("module.vote_error5", "lng"), -1)
  Else
    rs.addnew
    rs(cfnames(tfpre, "fid")) = tid
    rs(cfnames(tfpre, "ip")) = nuserip
    rs(cfnames(tfpre, "username")) = nusername
    rs(cfnames(tfpre, "data")) = tvotes
    rs(cfnames(tfpre, "time")) = Now()
    rs.update
  End If
  Set rs = Nothing
  tdatabase = cndatabase(cvgenre(ngenre), "data")
  tidfield = cnidfield(cvgenre(ngenre), "data")
  tfpre = cnfpre(cvgenre(ngenre), "data")
  sqlstr = "update " & tdatabase & " set " & cfnames(tfpre, "count") & "=" & cfnames(tfpre, "count") & "+1 where " & cfnames(tfpre, "fid") & "=" & tid & " and " & tidfield & " in (" & tvotes & ")"
  If run_sqlstr(sqlstr) Then
    response.cookies(appname & "vote")(CStr(tid)) = "1"
    Call client_alert(itake("module.vote_succeed", "lng"), -1)
  Else
    Call client_alert(itake("module.vote_error0", "lng"), -1)
  End If
End Sub

Sub jtbc_cms_module_action()
  Select Case request.querystring("action")
    Case "vote"
      Call jtbc_cms_module_votedisp
  End Select
End Sub
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
%>
