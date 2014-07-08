<%
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
Const nsearch = "topic"
Const njspath = "common/js/"
ncontrol = "select,lock"

Function change_support_vote_type(strers)
  If strers = 0 Then
    change_support_vote_type = "radio"
  Else
    change_support_vote_type = "checkbox"
  End If
End Function

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
      tmptstr = Replace(tmptstr, "{$time}", get_date(rs(cfname("time"))))
      tmptstr = Replace(tmptstr, "{$type}", get_num(rs(cfname("type")), 0))
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
  Dim tmpstr
  tmpstr = ireplace("manage.add", "tpl")
  response.write tmpstr
End Sub

Sub jtbc_cms_admin_manage_edit()
  Dim tid, tbackurl
  tid = get_num(request.querystring("id"), 0)
  tbackurl = get_safecode(request.querystring("backurl"))
  Dim tdatabase, tidfield, tfpre
  tdatabase = cndatabase(cvgenre(ngenre), "data")
  tidfield = cnidfield(cvgenre(ngenre), "data")
  tfpre = cnfpre(cvgenre(ngenre), "data")
  Dim trs, tsqlstr
  tsqlstr = "select * from " & tdatabase & " where " & cfnames(tfpre, "fid") & "=" & tid
  Set trs = conn.Execute(tsqlstr)
  Dim tmpstr, tmpastr, tmptstr, tmprstr
  tmpstr = ireplace("manage.edit", "tpl")
  tmpastr = ctemplate(tmpstr, "{$recurrence_ida}")
  Do While Not trs.EOF
    tmptstr = Replace(tmpastr, "{$topic}", htmlencode(get_str(trs(cfnames(tfpre, "topic")))))
    tmptstr = Replace(tmptstr, "{$count}", get_num(trs(cfnames(tfpre, "count")), 0))
    tmptstr = Replace(tmptstr, "{$vid}", get_num(trs(cfnames(tfpre, "vid")), 0))
    tmprstr = tmprstr & tmptstr
    trs.movenext
  loop
  tmpstr = Replace(tmpstr, jtbc_cinfo, tmprstr)
  Set trs = Nothing
  sqlstr = "select * from " & ndatabase & " where " & nidfield & "=" & tid
  Set rs = conn.Execute(sqlstr)
  If Not rs.EOF Then
    Dim tmpi, tmpfields, tmpfieldsvalue
    For tmpi = 0 To rs.fields.Count - 1
      tmpfields = rs.fields(tmpi).Name
      tmpfieldsvalue = get_str(rs(tmpfields))
      tmpstr = Replace(tmpstr, "{$" & Replace(tmpfields, nfpre, "") & "}", htmlencode(tmpfieldsvalue))
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
  Dim tmptopic, tbackurl, tcount
  tmptopic = get_str(request.Form("topic"))
  tbackurl = get_safecode(request.querystring("backurl"))
  tcount = CInt(get_num(request.Form("count"), 0))
  If tcount <= 0 Then Call client_alert(itake("manage.add_count_error", "lng"), tbackurl)
  If check_null(tmptopic) Then Call client_alert(Replace(itake("global.lng_public.insert_empty", "lng"), "[]", "[" & itake("global.lng_config.topic", "lng") & "]"), tbackurl)
  Set rs = server.CreateObject("adodb.recordset")
  sqlstr = "select * from " & ndatabase
  rs.open sqlstr, conn, 1, 3
  rs.addnew
  rs(cfname("topic")) = left_intercept(tmptopic, 50)
  rs(cfname("type")) = get_num(request.Form("type"), 0)
  rs(cfname("count")) = tcount
  rs(cfname("starttime")) = get_date(request.Form("starttime"))
  rs(cfname("endtime")) = get_date(request.Form("endtime"))
  rs(cfname("lock")) = get_num(request.Form("lock"), 0)
  rs(cfname("time")) = Now()
  rs.Update
  Dim tvid: tvid = rs(nidfield)
  If get_num(tvid, 0) = 0 Then tvid = get_topid(ndatabase, nidfield)
  Dim tdatabase, tidfield, tfpre
  tdatabase = cndatabase(cvgenre(ngenre), "data")
  tidfield = cnidfield(cvgenre(ngenre), "data")
  tfpre = cnfpre(cvgenre(ngenre), "data")
  Dim ti, trs, tsqlstr
  Set trs = server.CreateObject("adodb.recordset")
  tsqlstr = "select * from " & tdatabase
  trs.open tsqlstr, conn, 1, 3
  For ti = 1 to tcount
    trs.addnew
    trs(cfnames(tfpre, "topic")) = left_intercept(get_str(request.form("option" & ti)), 50)
    trs(cfnames(tfpre, "count")) = get_num(request.form("count" & ti), 0)
    trs(cfnames(tfpre, "fid")) = tvid
    trs(cfnames(tfpre, "vid")) = ti
    trs.update
  Next
  trs.Close
  Set trs = Nothing
  Call jtbc_cms_admin_msg(itake("global.lng_public.add_succeed", "lng"), tbackurl, 1)
  rs.Close
  Set rs = Nothing
End Sub

Sub jtbc_cms_admin_manage_editdisp()
  Dim tid, tbackurl, tcount
  Dim tmptopic: tmptopic = get_str(request.Form("topic"))
  If check_null(tmptopic) Then Call client_alert(Replace(itake("global.lng_public.insert_empty", "lng"), "[]", "[" & itake("global.lng_config.topic", "lng") & "]"), -1)
  tid = get_num(request.querystring("id"), 0)
  tbackurl = get_safecode(request.querystring("backurl"))
  tcount = CInt(get_num(request.Form("count"), 0))
  Set rs = server.CreateObject("adodb.recordset")
  sqlstr = "select * from " & ndatabase & " where " & nidfield & "=" & tid
  rs.open sqlstr, conn, 1, 3
  If Not rs.EOF Then
    Dim tycount: tycount = rs(cfname("count"))
    rs(cfname("topic")) = left_intercept(tmptopic, 50)
    rs(cfname("type")) = get_num(request.Form("type"), 0)
    rs(cfname("count")) = tcount
    rs(cfname("starttime")) = get_date(request.Form("starttime"))
    rs(cfname("endtime")) = get_date(request.Form("endtime"))
    rs(cfname("lock")) = get_num(request.Form("lock"), 0)
    rs(cfname("time")) = get_date(request.Form("time"))
    rs.Update
    Dim tvid: tvid = rs(nidfield)
    Dim tdatabase, tidfield, tfpre
    tdatabase = cndatabase(cvgenre(ngenre), "data")
    tidfield = cnidfield(cvgenre(ngenre), "data")
    tfpre = cnfpre(cvgenre(ngenre), "data")
    Dim ti, trs, tsqlstr
    Set trs = server.CreateObject("adodb.recordset")
    For ti = 1 to tcount
      tsqlstr = "select * from " & tdatabase & " where " & cfnames(tfpre, "fid") & "=" & tvid & " and " & cfnames(tfpre, "vid") & "=" & ti
      trs.open tsqlstr, conn, 1, 3
      If Not trs.EOF Then
        trs(cfnames(tfpre, "topic")) = left_intercept(get_str(request.form("option" & ti)), 50)
        trs(cfnames(tfpre, "count")) = get_num(request.form("count" & ti), 0)
        trs.update
      Else
        trs.addnew
        trs(cfnames(tfpre, "topic")) = left_intercept(get_str(request.form("option" & ti)), 50)
        trs(cfnames(tfpre, "count")) = get_num(request.form("count" & ti), 0)
        trs(cfnames(tfpre, "fid")) = tvid
        trs(cfnames(tfpre, "vid")) = ti
        trs.update
      End If
      trs.Close
    Next
    Set trs = Nothing
    If tycount > tcount Then
      Dim tvi, tmyvid
      For tvi = tcount to tycount
        tmyvid = tmyvid & tvi & ","
      Next
      tmyvid = get_lrstr(tmyvid, ",", "rightr")
      If Not check_null(tmyvid) Then tmyvid = Left(tmyvid, Len(tmyvid) - 1)
      If Not check_null(tmyvid) Then Call dbase_delete(tdatabase, cfnames(tfpre, "vid"), tmyvid, "0")
    End If
    Call jtbc_cms_admin_msg(itake("global.lng_public.edit_succeed", "lng"), tbackurl, 1)
  Else
    Call jtbc_cms_admin_msg(itake("global.lng_public.not_exist", "lng"), tbackurl, 1)
  End If
  rs.Close
  Set rs = Nothing
End Sub

Sub jtbc_cms_admin_manage_createjsdisp()
  Dim tjsname: tjsname = get_safecode(request.form("jsname"))
  If check_null(tjsname) Then tjsname = "noname"
  Dim tjsrow: tjsrow = get_num(request.form("jsrow"), 0)
  If tjsrow < 1 Then tjsrow = 1
  Dim tjstpl: tjstpl = get_safecode(request.form("jstpl"))
  Dim tbackurl: tbackurl = get_safecode(request.querystring("backurl"))
  Dim tid: tid = get_num(request.querystring("id"), 0)
  Dim tmpstr, tmpastr, tmprstr, tmptstr
  tmpstr = itake("vote." & tjstpl, "tpl")
  sqlstr = "select * from " & ndatabase & " where " & nidfield & "=" & tid
  Set rs = conn.Execute(sqlstr)
  If Not rs.EOF Then
    tmpstr = Replace(tmpstr, "{$vtopic}", htmlencode(rs(cfname("topic"))))
    tmpstr = Replace(tmpstr, "{$type}", htmlencode(rs(cfname("type"))))
    tmpstr = Replace(tmpstr, "{$vid}", get_num(rs(nidfield), 0))
  End If
  Set rs = Nothing
  ndatabase = cndatabase(cvgenre(ngenre), "data")
  nidfield = cnidfield(cvgenre(ngenre), "data")
  nfpre = cnfpre(cvgenre(ngenre), "data")
  sqlstr = "select * from " & ndatabase & " where " & cfname("fid") & "=" & tid
  Set rs = conn.Execute(sqlstr)
  If check_null(tmpstr) Then Exit Sub
  Dim tmpstra, tmpstrb
  tmpstra = ctemplate(tmpstr, "{$}")
  tmpstrb = ctemplate(tmpstra, "{$$}")
  Dim tmpi, tmpc, tmpstrc, tmpstrd, tmpstre, tmpsort, tmpfields, tmpfieldsvalue
  tmpc = 0
  Do While Not rs.EOF
    If Not tmpc = 0 And tmpc Mod tjsrow = 0 Then
      tmpstrc = tmpstrc & Replace(tmpstra, jtbc_cinfo, tmpstre)
      tmpstrd = ""
      tmpstre = ""
    End If
    tmpstrd = tmpstrb
    For tmpi = 0 To rs.fields.Count - 1
      tmpfields = rs.fields(tmpi).Name
      tmpfieldsvalue = get_str(rs(tmpfields))
      tmpfields = get_lrstr(tmpfields, "_", "rightr")
      tmpstrd = Replace(tmpstrd, "{$" & tmpfields & "}", htmlencode(tmpfieldsvalue))
    Next
    tmpstrd = Replace(tmpstrd, "{$id}", rs(nidfield))
    tmpstre = tmpstre & tmpstrd
    tmpc = tmpc + 1
    rs.movenext
  Loop
  Set rs = nothing
  If Not tmpstre = "" Then tmpstrc = tmpstrc & Replace(tmpstra, jtbc_cinfo, tmpstre)
  tmpstrc = Replace(tmpstr, jtbc_cinfo, tmpstrc)
  tmpstrc = creplace(tmpstrc)
  tmpstrc = split(tmpstrc, chr(10))
  Dim toutstr
  For tmpi = 0 To ubound(tmpstrc)
    If not check_null(tmpstrc(tmpi)) Then toutstr = toutstr & "document.write('" & tmpstrc(tmpi) & "');" & vbcrlf
  Next
  If save_file_text(njspath & tjsname & ".js", toutstr) Then
    Call jtbc_cms_admin_msg(itake("global.lng_public.succeed", "lng"), tbackurl, 1)
  Else
    Call jtbc_cms_admin_msg(itake("global.lng_public.sudd", "lng"), tbackurl, 1)
  End If
End Sub

Sub jtbc_cms_admin_manage_deletedisp()
  Dim dsid, dbackurl, dnotice, dnoticestr
  dnotice = itake("global.lng_public.delete_notice", "lng")
  dnoticestr = get_safecode(request.querystring("noticestr"))
  dnotice = Replace(dnotice, "[]", "[" & htmlencode(dnoticestr) & "]")
  dbackurl = get_safecode(request.querystring("backurl"))
  Call manage_confirm(dnotice, dbackurl)
  dsid = get_num(request.querystring("id"), 0)
  Call dbase_delete(ndatabase, nidfield, dsid, "0")
  Dim tdatabase, tidfield, tfpre
  tdatabase = cndatabase(cvgenre(ngenre), "data")
  tidfield = cnidfield(cvgenre(ngenre), "data")
  tfpre = cnfpre(cvgenre(ngenre), "data")
  Call dbase_delete(tdatabase, cfnames(tfpre, "fid"), dsid, "0")
  tdatabase = cndatabase(cvgenre(ngenre), "voter")
  tidfield = cnidfield(cvgenre(ngenre), "voter")
  tfpre = cnfpre(cvgenre(ngenre), "voter")
  Call dbase_delete(tdatabase, cfnames(tfpre, "fid"), dsid, "0")
  response.redirect dbackurl
End Sub

Sub jtbc_cms_admin_manage_action()
  Select Case request.querystring("action")
    Case "add"
      Call jtbc_cms_admin_manage_adddisp
    Case "edit"
      Call jtbc_cms_admin_manage_editdisp
    Case "createjs"
      Call jtbc_cms_admin_manage_createjsdisp
    Case "delete"
      Call jtbc_cms_admin_manage_deletedisp
    Case "control"
      Call jtbc_cms_admin_controldisp
  End Select
End Sub

Sub jtbc_cms_admin_manage()
  Select Case request.querystring("type")
    Case "add"
      Call jtbc_cms_admin_manage_add
    Case "edit"
      Call jtbc_cms_admin_manage_edit
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
