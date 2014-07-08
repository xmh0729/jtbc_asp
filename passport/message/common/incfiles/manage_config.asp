<%
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
ncontrol = "select,delete"
Const nsearch = "topic,addresser,recipients,id"

Function manage_navigation()
  Dim tmpstr
  tmpstr = ireplace("manage.navigation", "tpl")
  manage_navigation = tmpstr
End Function

Sub jtbc_cms_admin_manage_list()
  Dim search_field, search_keyword
  search_field = get_safecode(request.querystring("field"))
  search_keyword = get_safecode(request.querystring("keyword"))
  Dim tmpstr, tmpastr, tmprstr, tmptstr
  tmpstr = itake("manage.list", "tpl")
  tmpastr = ctemplate(tmpstr, "{$recurrence_ida}")
  sqlstr = "select * from " & ndatabase & " where " & nidfield & ">0"
  If search_field = "topic" Then sqlstr = sqlstr & " and " & cfname("topic") & " like '%" & search_keyword & "%'"
  If search_field = "addresser" Then sqlstr = sqlstr & " and " & cfname("addresser") & " like '%" & search_keyword & "%'"
  If search_field = "recipients" Then sqlstr = sqlstr & " and " & cfname("recipients") & " like '%" & search_keyword & "%'"
  If search_field = "read" Then sqlstr = sqlstr & " and " & cfname("read") & "=" & get_num(search_keyword, 0)
  If search_field = "id" Then sqlstr = sqlstr & " and " & nidfield & "=" & get_num(search_keyword, 0)
  sqlstr = sqlstr & " order by " & ndatabase & "." & cfname("time") & " desc"
  Dim jcutpage, jcuti
  Set jcutpage = New jtbc_cutpage
  jcutpage.perpage = npagesize
  jcutpage.sqlstr = sqlstr
  jcutpage.cutpage
  Set rs = jcutpage.pagers
  Dim tmptopic, font_red
  If Not check_null(search_keyword) And search_field = "topic" Then font_red = itake("global.tpl_config.font_red", "tpl")
  For jcuti = 1 To npagesize
    If Not rs.EOF Then
      tmptopic = htmlencode(get_str(rs(cfname("topic"))))
      If Not check_null(font_red) Then font_red = Replace(font_red, "{$explain}", search_keyword): tmptopic = Replace(tmptopic, search_keyword, font_red)
      tmptstr = Replace(tmpastr, "{$topic}", tmptopic)
      tmptstr = Replace(tmptstr, "{$topicstr}", urlencode(get_str(rs(cfname("topic")))))
      tmptstr = Replace(tmptstr, "{$addresser}", htmlencode(get_str(rs(cfname("addresser")))))
      tmptstr = Replace(tmptstr, "{$recipients}", htmlencode(get_str(rs(cfname("recipients")))))
      tmptstr = Replace(tmptstr, "{$read}", get_num(rs(cfname("read")), 0))
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
  response.write tmpstr
End Sub

Sub jtbc_cms_admin_manage_add()
  Dim tmpstr: tmpstr = ireplace("manage.add", "tpl")
  response.write tmpstr
End Sub

Sub jtbc_cms_admin_manage_edit()
  Dim tid, tbackurl
  tid = get_num(request.querystring("id"), 0)
  tbackurl = get_safecode(request.querystring("backurl"))
  sqlstr = "select * from " & ndatabase & " where " & nidfield & "=" & tid
  Set rs = conn.Execute(sqlstr)
  If Not rs.EOF Then
    Dim tmpstr, tmpi, tmpfields, tmpfieldsvalue
    tmpstr = itake("manage.edit", "tpl")
    Dim tfieldscount: tfieldscount = rs.fields.Count - 1
    ReDim rsfields(tfieldscount, 1)
    For tmpi = 0 To tfieldscount
      tmpfields = rs.fields(tmpi).Name
      tmpfieldsvalue = get_str(rs(tmpfields))
      tmpfields = get_lrstr(tmpfields, "_", "rightr")
      rsfields(tmpi, 0) = tmpfields
      rsfields(tmpi, 1) = tmpfieldsvalue
      tmpstr = Replace(tmpstr, "{$" & tmpfields & "}", htmlencode(tmpfieldsvalue))
    Next
    tmpstr = Replace(tmpstr, "{$id}", get_str(rs(nidfield)))
    tmpstr = creplace(tmpstr)
    response.write tmpstr
  Else
    Call jtbc_cms_admin_msg(itake("global.lng_public.not_exist", "lng"), tbackurl, 0)
  End If
  Set rs = Nothing
End Sub

Sub jtbc_cms_admin_manage_adddisp()
  Dim tbackurl, ttopic, taddresser, tmode, trecipients1, trecipients2, tcontents, ttime, tread
  tbackurl = get_safecode(request.querystring("backurl"))
  ttopic = left_intercept(request.Form("topic"), 50)
  taddresser = left_intercept(request.Form("addresser"), 50)
  tmode = get_num(request.Form("mode"), 0)
  trecipients1 = left_intercept(request.Form("recipients1"), 1000)
  trecipients2 = left_intercept(request.Form("recipients2"), 50)
  tcontents = left_intercept(request.Form("content"), 1000)
  ttime = get_date(request.Form("time"))
  tread = get_num(request.Form("read"), 0)
  If tmode = 1 Then
    If check_null(trecipients1) Then
      Call jtbc_cms_admin_msg(itake("global.lng_public.add_failed", "lng"), tbackurl, 1)
    Else
      Dim tary: tary = split(trecipients1, ",")
      Dim ti
      Set rs = server.CreateObject("adodb.recordset")
      sqlstr = "select * from " & ndatabase
      rs.open sqlstr, conn, 1, 3
      For ti = 0 to UBound(tary)
        rs.addnew
        rs(cfname("topic")) = ttopic
        rs(cfname("content")) = tcontents
        rs(cfname("read")) = tread
        rs(cfname("time")) = ttime
        rs(cfname("len")) = Len(tcontents)
        rs(cfname("addresser")) = taddresser
        rs(cfname("recipients")) = Trim(tary(ti))
        rs.update
      Next
      rs.close
      Set rs = nothing
      Call jtbc_cms_admin_msg(itake("global.lng_public.add_succeed", "lng"), tbackurl, 1)
    End If
  ElseIf tmode = 2 Then
    trecipients2 = format_checkbox(trecipients2)
    If check_null(trecipients2) Or Not cidary(trecipients2) Then
      Call jtbc_cms_admin_msg(itake("global.lng_public.add_failed", "lng"), tbackurl, 1)
    Else
      Dim tdatabase, tidfield, tfpre
      tdatabase = cndatabase(userfolder, "0")
      tidfield = cnidfield(userfolder, "0")
      tfpre = cnfpre(userfolder, "0")
      Dim trs, tsqlstr
      tsqlstr = "select * from " & tdatabase & " where " & cfnames(tfpre, "utype") & " in (" & trecipients2 & ")"
      Set trs = conn.Execute(tsqlstr)
      Set rs = server.CreateObject("adodb.recordset")
      sqlstr = "select * from " & ndatabase
      rs.open sqlstr, conn, 1, 3
      Do While Not trs.EOF
        rs.addnew
        rs(cfname("topic")) = ttopic
        rs(cfname("content")) = tcontents
        rs(cfname("read")) = tread
        rs(cfname("time")) = ttime
        rs(cfname("len")) = Len(tcontents)
        rs(cfname("addresser")) = taddresser
        rs(cfname("recipients")) = trs(cfnames(tfpre, "username"))
        rs.update
        trs.movenext
        loop
      rs.close
      Set rs = nothing
      Set trs = Nothing
    End If
    Call jtbc_cms_admin_msg(itake("global.lng_public.add_succeed", "lng"), tbackurl, 1)
  Else
    Call jtbc_cms_admin_msg(itake("global.lng_public.add_failed", "lng"), tbackurl, 1)
  End If
End Sub

Sub jtbc_cms_admin_manage_editdisp()
  Dim tid, tbackurl
  tid = get_num(request.querystring("id"), 0)
  tbackurl = get_safecode(request.querystring("backurl"))
  Set rs = server.CreateObject("adodb.recordset")
  sqlstr = "select * from " & ndatabase & " where " & nidfield & "=" & tid
  rs.open sqlstr, conn, 1, 3
  If Not rs.EOF Then
    rs(cfname("topic")) = left_intercept(htmlencode(request.Form("topic")), 50)
    rs(cfname("addresser")) = left_intercept(htmlencode(request.Form("addresser")), 50)
    rs(cfname("recipients")) = left_intercept(htmlencode(request.Form("recipients")), 50)
    rs(cfname("content")) = left_intercept(htmlencode(request.Form("content")), 1000)
    rs(cfname("time")) = get_date(request.Form("name"))
    rs(cfname("read")) = get_num(request.Form("read"), 0)
    rs.Update
    Call jtbc_cms_admin_msg(itake("global.lng_public.edit_succeed", "lng"), tbackurl, 1)
  Else
    Call jtbc_cms_admin_msg(itake("global.lng_public.not_exist", "lng"), tbackurl, 0)
  End If
  rs.Close
  Set rs = Nothing
End Sub

Sub jtbc_cms_admin_manage_action()
  Select Case request.querystring("action")
    Case "add"
      Call jtbc_cms_admin_manage_adddisp()
    Case "edit"
      Call jtbc_cms_admin_manage_editdisp()
    Case "delete"
      Call jtbc_cms_admin_deletedisp()
    Case "control"
      Call jtbc_cms_admin_controldisp()
  End Select
End Sub

Sub jtbc_cms_admin_manage()
  Select Case request.querystring("type")
    Case "add"
      Call jtbc_cms_admin_manage_add()
    Case "edit"
      Call jtbc_cms_admin_manage_edit()
    Case Else
      Call jtbc_cms_admin_manage_list()
  End Select
End Sub
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
%>
