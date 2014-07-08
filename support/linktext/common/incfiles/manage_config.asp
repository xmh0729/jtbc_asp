<%
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
Const nsearch = "topic,keyword"
Const njspath = "common/js/"
ncontrol = "select,delete"

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
  If search_field = "keyword" Then sqlstr = sqlstr & " and " & cfname("keyword") & " like '%" & search_keyword & "%'"
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
      tmptstr = Replace(tmptstr, "{$keyword}", htmlencode(get_str(rs(cfname("keyword")))))
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
  Dim tmpstr
  tmpstr = ireplace("manage.add", "tpl")
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
  Dim tmptopic, tbackurl
  tmptopic = get_str(request.Form("topic"))
  tbackurl = get_safecode(request.querystring("backurl"))
  If check_null(tmptopic) Then Call client_alert(Replace(itake("global.lng_public.insert_empty", "lng"), "[]", "[" & itake("global.lng_config.topic", "lng") & "]"), -1)
  Set rs = server.CreateObject("adodb.recordset")
  sqlstr = "select * from " & ndatabase
  rs.open sqlstr, conn, 1, 3
  rs.addnew
  rs(cfname("topic")) = left_intercept(tmptopic, 50)
  rs(cfname("url")) = left_intercept(get_str(request.Form("url")), 200)
  rs(cfname("keyword")) = left_intercept(get_str(request.Form("keyword")), 50)
  rs(cfname("intro")) = left_intercept(get_str(request.Form("intro")), 200)
  rs(cfname("time")) = get_date(request.Form("time"))
  rs.Update
  Call jtbc_cms_admin_msg(itake("global.lng_public.add_succeed", "lng"), tbackurl, 1)
  rs.Close
  Set rs = Nothing
End Sub

Sub jtbc_cms_admin_manage_editdisp()
  Dim tid, tbackurl
  Dim tmptopic
  tmptopic = get_str(request.Form("topic"))
  If check_null(tmptopic) Then Call client_alert(Replace(itake("global.lng_public.insert_empty", "lng"), "[]", "[" & itake("global.lng_config.topic", "lng") & "]"), -1)
  tid = get_num(request.querystring("id"), 0)
  tbackurl = get_safecode(request.querystring("backurl"))
  Set rs = server.CreateObject("adodb.recordset")
  sqlstr = "select * from " & ndatabase & " where " & nidfield & "=" & tid
  rs.open sqlstr, conn, 1, 3
  If Not rs.EOF Then
    rs(cfname("topic")) = left_intercept(tmptopic, 50)
    rs(cfname("url")) = left_intercept(get_str(request.Form("url")), 200)
    rs(cfname("keyword")) = left_intercept(get_str(request.Form("keyword")), 50)
    rs(cfname("intro")) = left_intercept(get_str(request.Form("intro")), 200)
    rs(cfname("time")) = get_date(request.Form("time"))
    rs.Update
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
  Dim search_field, search_keyword
  search_field = get_safecode(request.querystring("field"))
  search_keyword = get_safecode(request.querystring("keyword"))
  sqlstr = "select * from " & ndatabase & " where " & nidfield & ">0"
  If search_field = "topic" Then sqlstr = sqlstr & " and " & cfname("topic") & " like '%" & search_keyword & "%'"
  If search_field = "keyword" Then sqlstr = sqlstr & " and " & cfname("keyword") & " like '%" & search_keyword & "%'"
  sqlstr = sqlstr & " order by " & ndatabase & "." & cfname("time") & " desc"
  Set rs = conn.Execute(sqlstr)
  Dim tmpstr, tmpastr, tmprstr, tmptstr
  tmpstr = itake("linktext." & tjstpl, "tpl")
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

Sub jtbc_cms_admin_manage_action()
  Select Case request.querystring("action")
    Case "add"
      Call jtbc_cms_admin_manage_adddisp
    Case "edit"
      Call jtbc_cms_admin_manage_editdisp
    Case "createjs"
      Call jtbc_cms_admin_manage_createjsdisp
    Case "delete"
      Call jtbc_cms_admin_deletedisp
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
