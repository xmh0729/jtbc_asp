<%
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
ncontrol = "select,lock,delete"
Const nsearch = "username,id"

Function manage_navigation()
  Dim tmpstr
  tmpstr = ireplace("manage.navigation", "tpl")
  manage_navigation = tmpstr
End Function

Sub jtbc_cms_admin_manage_list()
  Dim search_field, search_keyword
  search_field = get_safecode(request.querystring("field"))
  search_keyword = get_safecode(request.querystring("keyword"))
  sqlstr = "select * from " & ndatabase & " where " & nidfield & ">0"
  If search_field = "username" Then sqlstr = sqlstr & " and " & cfname("username") & " like '%" & search_keyword & "%'"
  If search_field = "id" Then sqlstr = sqlstr & " and " & nidfield & "=" & get_num(search_keyword, 0)
  If search_field = "lock" Then sqlstr = sqlstr & " and " & cfname("lock") & "=" & get_num(search_keyword, 0)
  If search_field = "utype" Then sqlstr = sqlstr & " and " & cfname("utype") & "=" & get_num(search_keyword, 0)
  sqlstr = sqlstr & " order by " & nidfield & " desc"
  Dim tmpstr, tmpastr, tmptstr
  tmpstr = itake("manage.list", "tpl")
  tmpastr = ctemplate(tmpstr, "{$recurrence_ida}")
  Dim tmpary, tmprstr
  tmpary = get_xinfo_ary("sel_group.all", "sel")
  If IsArray(tmpary) Then
    Dim tmpi, thspan, tstr0, tstr1
    For tmpi = 0 To UBound(tmpary)
      tstr0 = tmpary(tmpi, 0)
      tstr1 = tmpary(tmpi, 1)
      If Not tstr0 = "" Then
        thspan = "group" & tstr0
        tmptstr = Replace(tmpastr, "{$topic}", tstr1)
        tmptstr = Replace(tmptstr, "{$ahref}", "?keyword=" & tstr0 & "&field=utype&hspan=" & thspan)
        tmptstr = Replace(tmptstr, "{$hspan}", thspan)
      End If
      tmprstr = tmprstr & tmptstr
    Next
  End If
  tmpstr = Replace(tmpstr, jtbc_cinfo, tmprstr)
  tmprstr = ""
  tmpastr = ctemplate(tmpstr, "{$recurrence_idb}")
  Dim jcutpage, jcuti
  Set jcutpage = New jtbc_cutpage
  jcutpage.perpage = npagesize
  jcutpage.sqlstr = sqlstr
  jcutpage.cutpage
  Set rs = jcutpage.pagers
  Dim tmpusername, font_disabled
  font_disabled = itake("global.tpl_config.font_disabled", "tpl")
  For jcuti = 1 To npagesize
    If Not rs.EOF Then
      tmpusername = htmlencode(get_str(rs(cfname("username"))))
      If rs(cfname("lock")) = 1 Then tmpusername = Replace(font_disabled, "{$explain}", tmpusername)
      tmptstr = Replace(tmpastr, "{$username}", tmpusername)
      tmptstr = Replace(tmptstr, "{$usernamestr}", urlencode(get_str(rs(cfname("username")))))
      tmptstr = Replace(tmptstr, "{$email}", htmlencode(get_str(rs(cfname("email")))))
      tmptstr = Replace(tmptstr, "{$sex}", itake("global.sel_sex." & get_str(rs(cfname("sex"))), "sel"))
      tmptstr = Replace(tmptstr, "{$old}", htmlencode(get_str(rs(cfname("old")))))
      tmptstr = Replace(tmptstr, "{$time}", get_date(rs(cfname("time"))))
      tmptstr = Replace(tmptstr, "{$group}", itake("sel_group." & get_str(rs(cfname("utype"))), "sel"))
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
  Dim tbackurl, tmpusername
  tbackurl = get_safecode(request.querystring("backurl"))
  tmpusername = left_intercept(htmlencode(request.Form("username")), 50)
  Set rs = server.CreateObject("adodb.recordset")
  sqlstr = "select * from " & ndatabase & " where " & cfname("username") & "='" & tmpusername & "'"
  rs.open sqlstr, conn, 1, 3
  If Not rs.EOF Then
    Call jtbc_cms_admin_msg(itake("global.lng_public.exist", "lng"), tbackurl, 1)
  Else
    rs.addnew
    rs(cfname("username")) = tmpusername
    rs(cfname("password")) = md5(request.Form("password"), 2)
    rs(cfname("email")) = left_intercept(htmlencode(request.Form("email")), 50)
    rs(cfname("city")) = left_intercept(htmlencode(request.Form("city")), 50)
    rs(cfname("sex")) = left_intercept(htmlencode(request.Form("sex")), 50)
    rs(cfname("old")) = left_intercept(htmlencode(request.Form("old")), 50)
    rs(cfname("name")) = left_intercept(htmlencode(request.Form("name")), 50)
    rs(cfname("qq")) = get_num(request.Form("qq"), 0)
    rs(cfname("msn")) = left_intercept(htmlencode(request.Form("msn")), 50)
    rs(cfname("phone")) = left_intercept(htmlencode(request.Form("phone")), 50)
    rs(cfname("homepage")) = left_intercept(htmlencode(request.Form("homepage")), 50)
    rs(cfname("code")) = left_intercept(htmlencode(request.Form("code")), 50)
    rs(cfname("address")) = left_intercept(htmlencode(request.Form("address")), 50)
    rs(cfname("emoney")) = get_num(request.Form("emoney"), 0)
    rs(cfname("integral")) = get_num(request.Form("integral"), 0)
    rs(cfname("utype")) = get_num(request.Form("utype"), 0)
    rs(cfname("lock")) = get_num(request.Form("lock"), 0)
    rs(cfname("forum_admin")) = get_num(request.Form("forum_admin"), 0)
    rs(cfname("face")) = get_num(request.Form("face"), 0)
    rs(cfname("face_u")) = get_num(request.Form("face_u"), 0)
    rs(cfname("face_url")) = left_intercept(get_str(request.Form("face_url")), 255)
    rs(cfname("face_width")) = get_num(request.Form("face_width"), 0)
    rs(cfname("face_height")) = get_num(request.Form("face_height"), 0)
    rs(cfname("sign")) = left_intercept(get_str(request.Form("sign")), 100)
    rs(cfname("time")) = Now()
    rs.Update
    Call jtbc_cms_admin_msg(itake("global.lng_public.add_succeed", "lng"), tbackurl, 1)
  End If
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
    If Not check_null(request.Form("password")) Then rs(cfname("password")) = md5(request.Form("password"), 2)
    rs(cfname("email")) = left_intercept(htmlencode(request.Form("email")), 50)
    rs(cfname("city")) = left_intercept(htmlencode(request.Form("city")), 50)
    rs(cfname("sex")) = left_intercept(htmlencode(request.Form("sex")), 50)
    rs(cfname("old")) = left_intercept(htmlencode(request.Form("old")), 50)
    rs(cfname("name")) = left_intercept(htmlencode(request.Form("name")), 50)
    rs(cfname("qq")) = get_num(request.Form("qq"), 0)
    rs(cfname("msn")) = left_intercept(htmlencode(request.Form("msn")), 50)
    rs(cfname("phone")) = left_intercept(htmlencode(request.Form("phone")), 50)
    rs(cfname("homepage")) = left_intercept(htmlencode(request.Form("homepage")), 50)
    rs(cfname("code")) = left_intercept(htmlencode(request.Form("code")), 50)
    rs(cfname("address")) = left_intercept(htmlencode(request.Form("address")), 50)
    rs(cfname("emoney")) = get_num(request.Form("emoney"), 0)
    rs(cfname("integral")) = get_num(request.Form("integral"), 0)
    rs(cfname("utype")) = get_num(request.Form("utype"), 0)
    rs(cfname("lock")) = get_num(request.Form("lock"), 0)
    rs(cfname("forum_admin")) = get_num(request.Form("forum_admin"), 0)
    rs(cfname("face")) = get_num(request.Form("face"), 0)
    rs(cfname("face_u")) = get_num(request.Form("face_u"), 0)
    rs(cfname("face_url")) = left_intercept(get_str(request.Form("face_url")), 255)
    rs(cfname("face_width")) = get_num(request.Form("face_width"), 0)
    rs(cfname("face_height")) = get_num(request.Form("face_height"), 0)
    rs(cfname("sign")) = left_intercept(get_str(request.Form("sign")), 100)
    rs.Update
    Call jtbc_cms_admin_msg(itake("global.lng_public.edit_succeed", "lng"), tbackurl, 1)
  Else
    Call jtbc_cms_admin_msg(itake("global.lng_public.not_exist", "lng"), tbackurl, 0)
  End If
  rs.Close
  Set rs = Nothing
End Sub

Sub jtbc_cms_admin_manage_batch_controldisp()
  Dim tbackurl: tbackurl = get_safecode(request.querystring("backurl"))
  Dim search_field, search_keyword
  search_field = get_safecode(request.querystring("field"))
  search_keyword = get_safecode(request.querystring("keyword"))
  sqlstr = "select * from " & ndatabase & " where " & nidfield & ">0"
  If search_field = "username" Then sqlstr = sqlstr & " and " & cfname("username") & " like '%" & search_keyword & "%'"
  If search_field = "id" Then sqlstr = sqlstr & " and " & nidfield & "=" & get_num(search_keyword, 0)
  If search_field = "lock" Then sqlstr = sqlstr & " and " & cfname("lock") & "=" & get_num(search_keyword, 0)
  If search_field = "utype" Then sqlstr = sqlstr & " and " & cfname("utype") & "=" & get_num(search_keyword, 0)
  sqlstr = sqlstr & " order by " & nidfield & " desc"
  Dim tbth_type, tbth_group
  tbth_type = get_safecode(request.form("bth_type"))
  tbth_group = get_num(request.form("bth_group"), 0)
  Call jtbc_cms_admin_batch_controldisp(sqlstr, tbth_type, "utype=" & tbth_group, tbackurl)
End Sub

Sub jtbc_cms_admin_manage_action()
  Select Case request.querystring("action")
    Case "add"
      Call jtbc_cms_admin_manage_adddisp()
    Case "edit"
      Call jtbc_cms_admin_manage_editdisp()
    Case "batch_control"
      Call jtbc_cms_admin_manage_batch_controldisp()
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
