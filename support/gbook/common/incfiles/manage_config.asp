<%
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
Const nsearch = "topic,id"
ncontrol = "select,hidden,delete"
Dim slng: slng = get_safecode(request.querystring("slng"))
If check_null(slng) Then slng = nlng

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
  sqlstr = "select * from " & ndatabase & " where " & cfname("lng") & "='" & slng & "'"
  If search_field = "topic" Then sqlstr = sqlstr & " and " & cfname("topic") & " like '%" & search_keyword & "%'"
  If search_field = "id" Then sqlstr = sqlstr & " and " & nidfield & "=" & get_num(search_keyword, 0)
  If search_field = "hidden" Then sqlstr = sqlstr & " and " & cfname("hidden") & "=" & get_num(search_keyword, 0)
  sqlstr = sqlstr & " order by " & cfname("time") & " desc"
  Dim jcutpage, jcuti
  Set jcutpage = New jtbc_cutpage
  jcutpage.perpage = npagesize
  jcutpage.sqlstr = sqlstr
  jcutpage.cutpage
  Set rs = jcutpage.pagers
  Dim tmptopic, font_disabled, font_red
  font_disabled = itake("global.tpl_config.font_disabled", "tpl")
  If Not check_null(search_keyword) And search_field = "topic" Then font_red = itake("global.tpl_config.font_red", "tpl")
  For jcuti = 1 To npagesize
    If Not rs.EOF Then
      tmptopic = htmlencode(get_str(rs(cfname("topic"))))
      If Not check_null(font_red) Then font_red = Replace(font_red, "{$explain}", search_keyword): tmptopic = Replace(tmptopic, search_keyword, font_red)
      If rs(cfname("hidden")) = 1 Then tmptopic = Replace(font_disabled, "{$explain}", tmptopic)
      tmptstr = Replace(tmpastr, "{$topic}", tmptopic)
      tmptstr = Replace(tmptstr, "{$topicstr}", urlencode(get_str(rs(cfname("topic")))))
      tmptstr = Replace(tmptstr, "{$author}", htmlencode(get_str(rs(cfname("author")))))
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
  Dim tbackurl: tbackurl = get_safecode(request.querystring("backurl"))
  Set rs = server.CreateObject("adodb.recordset")
  sqlstr = "select * from " & ndatabase
  rs.open sqlstr, conn, 1, 3
  rs.addnew
  rs(cfname("author")) = left_intercept(get_str(request.Form("author")), 50)
  rs(cfname("authorip")) = nuserip
  rs(cfname("sex")) = get_num(request.Form("sex"), 0)
  rs(cfname("qq")) = get_num(request.Form("qq"), 0)
  rs(cfname("face")) = get_num(request.Form("face"), 0)
  rs(cfname("email")) = left_intercept(get_str(request.Form("email")), 50)
  rs(cfname("homepage")) = left_intercept(get_str(request.Form("homepage")), 200)
  rs(cfname("topic")) = left_intercept(get_str(request.Form("topic")), 50)
  rs(cfname("content")) = left_intercept(get_str(request.Form("content")), 100000)
  rs(cfname("hidden")) = get_num(request.Form("hidden"), 0)
  rs(cfname("lng")) = slng
  rs(cfname("time")) = Now()
  rs.Update
  Call jtbc_cms_admin_msg(itake("global.lng_public.add_succeed", "lng"), tbackurl, 1)
  rs.Close
  Set rs = Nothing
End Sub

Sub jtbc_cms_admin_manage_editdisp()
  Dim tid, tbackurl
  tid = get_num(request.querystring("id"), 0)
  tbackurl = get_safecode(request.querystring("backurl"))
  Set rs = server.CreateObject("adodb.recordset")
  sqlstr = "select * from " & ndatabase & " where " & nidfield & "=" & tid
  rs.open sqlstr, conn, 1, 3
  If Not rs.EOF Then
    rs(cfname("author")) = left_intercept(get_str(request.Form("author")), 50)
    rs(cfname("sex")) = get_num(request.Form("sex"), 0)
    rs(cfname("qq")) = get_num(request.Form("qq"), 0)
    rs(cfname("face")) = get_num(request.Form("face"), 0)
    rs(cfname("email")) = left_intercept(get_str(request.Form("email")), 50)
    rs(cfname("homepage")) = left_intercept(get_str(request.Form("homepage")), 200)
    rs(cfname("topic")) = left_intercept(get_str(request.Form("topic")), 50)
    rs(cfname("content")) = left_intercept(get_str(request.Form("content")), 100000)
    rs(cfname("hidden")) = get_num(request.Form("hidden"), 0)
    rs(cfname("time")) = get_date(request.Form("time"))
    rs(cfname("reply")) = left_intercept(get_str(request.Form("reply")), 100000)
    rs(cfname("replytime")) = get_date(request.Form("replytime"))
    rs.Update
    Call jtbc_cms_admin_msg(itake("global.lng_public.edit_succeed", "lng"), tbackurl, 1)
  Else
    Call jtbc_cms_admin_msg(itake("global.lng_public.not_exist", "lng"), tbackurl, 1)
  End If
  rs.Close
  Set rs = Nothing
End Sub

Sub jtbc_cms_admin_manage_action()
  Select Case request.querystring("action")
    Case "add"
      Call jtbc_cms_admin_manage_adddisp
    Case "edit"
      Call jtbc_cms_admin_manage_editdisp
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
