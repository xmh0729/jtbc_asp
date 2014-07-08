<%
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
nurltype = 0
Const nsearch = "topic,sort,id"
ncontrol = "select,hidden,good,delete"
Dim ncttype: ncttype = get_num(request.querystring("htype"), -1)
If ncttype = -1 Then ncttype = 0
Dim slng: slng = get_safecode(request.querystring("slng"))
If check_null(slng) Then slng = nlng

Function manage_navigation()
  Dim tmpstr
  tmpstr = ireplace("manage.navigation", "tpl")
  manage_navigation = tmpstr
End Function

Function manage_batch_menu()
  Dim tmpstr
  tmpstr = ireplace("manage.batch_menu", "tpl")
  manage_batch_menu = tmpstr
End Function

Sub jtbc_cms_admin_manage_list()
  Dim classid, search_field, search_keyword
  classid = get_num(request.querystring("classid"), 0)
  search_field = get_safecode(request.querystring("field"))
  search_keyword = get_safecode(request.querystring("keyword"))
  sqlstr = "select * from " & ndatabase & "," & sort_database & " where " & ndatabase & "." & cfname("class") & "=" & sort_database & "." & sort_idfield & " and " & sort_database & "." & cfnames(sort_fpre, "lng") & "='" & slng & "' and " & sort_database & "." & cfnames(sort_fpre, "genre") & "='" & ngenre & "'"
  If Not classid = 0 Then
    If nclstype = 0 Then
      sqlstr = sqlstr & " and " & ndatabase & "." & cfname("class") & "=" & classid
    Else
      sqlstr = sqlstr & " and " & ndatabase & "." & cfname("cls") & " like '%|" & classid & "|%'"
    End If
  End If
  If search_field = "topic" Then sqlstr = sqlstr & " and " & ndatabase & "." & cfname("topic") & " like '%" & search_keyword & "%'"
  If search_field = "sort" Then sqlstr = sqlstr & " and " & sort_database & "." & cfnames(sort_fpre, "sort") & " like '%" & search_keyword & "%'"
  If search_field = "id" Then sqlstr = sqlstr & " and " & ndatabase & "." & nidfield & "=" & get_num(search_keyword, 0)
  If search_field = "hidden" Then sqlstr = sqlstr & " and " & ndatabase & "." & cfname("hidden") & "=" & get_num(search_keyword, 0)
  If search_field = "good" Then sqlstr = sqlstr & " and " & ndatabase & "." & cfname("good") & "=" & get_num(search_keyword, 0)
  sqlstr = sqlstr & " order by " & ndatabase & "." & cfname("time") & " desc"
  Dim tmpstr, tmpastr, tmprstr, tmptstr
  tmpstr = itake("manage.list", "tpl")
  tmpastr = ctemplate(tmpstr, "{$recurrence_ida}")
  Dim jcutpage, jcuti
  Set jcutpage = New jtbc_cutpage
  jcutpage.perpage = npagesize
  jcutpage.sqlstr = sqlstr
  jcutpage.cutpage
  Set rs = jcutpage.pagers
  Dim tmptopic, font_disabled, postfix_good, font_red
  font_disabled = itake("global.tpl_config.font_disabled", "tpl")
  postfix_good = ireplace("global.tpl_config.postfix_good", "tpl")
  If Not check_null(search_keyword) And search_field = "topic" Then font_red = itake("global.tpl_config.font_red", "tpl")
  For jcuti = 1 To npagesize
    If Not rs.EOF Then
      tmptopic = htmlencode(get_str(rs(cfname("topic"))))
      If Not check_null(font_red) Then font_red = Replace(font_red, "{$explain}", search_keyword): tmptopic = Replace(tmptopic, search_keyword, font_red)
      If rs(cfname("hidden")) = 1 Then tmptopic = Replace(font_disabled, "{$explain}", tmptopic)
      If rs(cfname("good")) = 1 Then tmptopic = tmptopic & postfix_good
      tmptstr = Replace(tmpastr, "{$topic}", tmptopic)
      tmptstr = Replace(tmptstr, "{$topicstr}", urlencode(get_str(rs(cfname("topic")))))
      tmptstr = Replace(tmptstr, "{$sort}", htmlencode(get_str(rs(cfnames(sort_fpre, "sort")))))
      tmptstr = Replace(tmptstr, "{$classid}", get_num(rs(cfname("class")), 0))
      tmptstr = Replace(tmptstr, "{$time}", get_date(rs(cfname("time"))))
      tmptstr = Replace(tmptstr, "{$id}", get_num(rs(nidfield), 0))
      rs.movenext
      tmprstr = tmprstr & tmptstr
    End If
  Next
  tmpstr = Replace(tmpstr, "{$cpagestr}", jcutpage.pagestr)
  tmpstr = Replace(tmpstr, "{$nav_sort}", nav_sort(ngenre, slng, "?slng=" & slng & "&classid=", classid))
  tmpstr = Replace(tmpstr, "{$nav_sort_child}", nav_sort_child(ngenre, slng, "?slng=" & slng & "&classid=", classid, 6))
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

Sub jtbc_cms_admin_manage_displace()
  Select Case request.querystring("mtype")
    Case "batch_shift"
      Call jtbc_cms_admin_manage_batch_shift
    Case "batch_delete"
      Call jtbc_cms_admin_manage_batch_delete
    Case Else
      Call jtbc_cms_admin_manage_batch_shift
  End Select
End Sub

Sub jtbc_cms_admin_manage_batch_shift()
  Dim tmpstr
  tmpstr = ireplace("manage.batch_shift", "tpl")
  response.write tmpstr
End Sub

Sub jtbc_cms_admin_manage_batch_delete()
  Dim tmpstr
  tmpstr = ireplace("manage.batch_delete", "tpl")
  response.write tmpstr
End Sub

Sub jtbc_cms_admin_manage_adddisp()
  Dim tmpclass, tmpimage, tcontent_images_list, tbackurl
  tmpclass = get_num(request.Form("sort"), 0)
  tmpimage = left_intercept(get_str(request.Form("image")), 250)
  tcontent_images_list = left_intercept(get_str(request.Form("content_images_list")), 10000)
  tbackurl = get_safecode(request.querystring("backurl"))
  If tmpclass = 0 Then Call client_alert(Replace(itake("global.lng_public.insert_empty", "lng"), "[]", "[" & itake("global.lng_config.sort", "lng") & "]"), -1)
  Set rs = server.CreateObject("adodb.recordset")
  sqlstr = "select * from " & ndatabase
  rs.open sqlstr, conn, 1, 3
  rs.addnew
  rs(cfname("topic")) = left_intercept(get_str(request.Form("topic")), 50)
  rs(cfname("cls")) = get_sort_cls(tmpclass)
  rs(cfname("class")) = tmpclass
  rs(cfname("scont")) = left_intercept(get_str(request.Form("scont")), 10000)
  rs(cfname("image")) = tmpimage
  rs(cfname("content")) = left_intercept(get_str(request.Form("content")), 100000)
  rs(cfname("cttype")) = get_num(request.Form("cttype"), 0)
  rs(cfname("content_images_list")) = tcontent_images_list
  rs(cfname("size")) = get_num(request.Form("size"), 0)
  rs(cfname("runco")) = left_intercept(format_checkbox(get_str(request.Form("runco"))), 200)
  rs(cfname("star")) = get_num(request.Form("star"), 0)
  rs(cfname("accredit")) = get_num(request.Form("accredit"), 0)
  rs(cfname("lng")) = get_num(request.Form("lng"), 0)
  rs(cfname("link")) = left_intercept(get_str(request.Form("link")), 200)
  rs(cfname("author")) = left_intercept(get_str(request.Form("author")), 50)
  rs(cfname("url1")) = left_intercept(get_str(request.Form("url1")), 200)
  rs(cfname("url_count1")) = get_num(request.Form("url_count1"), 0)
  rs(cfname("url2")) = left_intercept(get_str(request.Form("url2")), 200)
  rs(cfname("url_count2")) = get_num(request.Form("url_count2"), 0)
  rs(cfname("url3")) = left_intercept(get_str(request.Form("url3")), 200)
  rs(cfname("url_count3")) = get_num(request.Form("url_count3"), 0)
  rs(cfname("url4")) = left_intercept(get_str(request.Form("url4")), 200)
  rs(cfname("url_count4")) = get_num(request.Form("url_count4"), 0)
  rs(cfname("url5")) = left_intercept(get_str(request.Form("url5")), 200)
  rs(cfname("url_count5")) = get_num(request.Form("url_count5"), 0)
  rs(cfname("hidden")) = get_num(request.Form("hidden"), 0)
  rs(cfname("good")) = get_num(request.Form("good"), 0)
  rs(cfname("time")) = Now()
  rs.Update
  Dim upfid: upfid = rs(nidfield)
  If get_num(upfid, 0) = 0 Then upfid = get_topid(ndatabase, nidfield)
  Call upload_update_database_note(ngenre, tmpimage, "image", upfid)
  Call upload_update_database_note(ngenre, tcontent_images_list, "content_images", upfid)
  Call jtbc_cms_admin_msg(itake("global.lng_public.add_succeed", "lng"), tbackurl, 1)
  rs.Close
  Set rs = Nothing
End Sub

Sub jtbc_cms_admin_manage_editdisp()
  Dim tid, tcontent_images_list, tbackurl
  Dim tmpclass, tmpimage
  tmpclass = get_num(request.Form("sort"), 0)
  If tmpclass = 0 Then Call client_alert(Replace(itake("global.lng_public.insert_empty", "lng"), "[]", "[" & itake("global.lng_config.sort", "lng") & "]"), -1)
  tmpimage = left_intercept(get_str(request.Form("image")), 250)
  tcontent_images_list = left_intercept(get_str(request.Form("content_images_list")), 10000)
  tid = get_num(request.querystring("id"), 0)
  tbackurl = get_safecode(request.querystring("backurl"))
  Set rs = server.CreateObject("adodb.recordset")
  sqlstr = "select * from " & ndatabase & " where " & nidfield & "=" & tid
  rs.open sqlstr, conn, 1, 3
  If Not rs.EOF Then
    rs(cfname("topic")) = left_intercept(get_str(request.Form("topic")), 50)
    rs(cfname("cls")) = get_sort_cls(tmpclass)
    rs(cfname("class")) = tmpclass
    rs(cfname("scont")) = left_intercept(get_str(request.Form("scont")), 10000)
    rs(cfname("image")) = tmpimage
    rs(cfname("content")) = left_intercept(get_str(request.Form("content")), 100000)
    rs(cfname("cttype")) = get_num(request.Form("cttype"), 0)
    rs(cfname("content_images_list")) = tcontent_images_list
    rs(cfname("size")) = get_num(request.Form("size"), 0)
    rs(cfname("runco")) = left_intercept(format_checkbox(get_str(request.Form("runco"))), 200)
    rs(cfname("star")) = get_num(request.Form("star"), 0)
    rs(cfname("accredit")) = get_num(request.Form("accredit"), 0)
    rs(cfname("lng")) = get_num(request.Form("lng"), 0)
    rs(cfname("link")) = left_intercept(get_str(request.Form("link")), 200)
    rs(cfname("author")) = left_intercept(get_str(request.Form("author")), 50)
    rs(cfname("url1")) = left_intercept(get_str(request.Form("url1")), 200)
    rs(cfname("url_count1")) = get_num(request.Form("url_count1"), 0)
    rs(cfname("url2")) = left_intercept(get_str(request.Form("url2")), 200)
    rs(cfname("url_count2")) = get_num(request.Form("url_count2"), 0)
    rs(cfname("url3")) = left_intercept(get_str(request.Form("url3")), 200)
    rs(cfname("url_count3")) = get_num(request.Form("url_count3"), 0)
    rs(cfname("url4")) = left_intercept(get_str(request.Form("url4")), 200)
    rs(cfname("url_count4")) = get_num(request.Form("url_count4"), 0)
    rs(cfname("url5")) = left_intercept(get_str(request.Form("url5")), 200)
    rs(cfname("url_count5")) = get_num(request.Form("url_count5"), 0)
    rs(cfname("hidden")) = get_num(request.Form("hidden"), 0)
    rs(cfname("good")) = get_num(request.Form("good"), 0)
    rs(cfname("time")) = get_date(request.Form("time"))
    rs(cfname("count")) = get_num(request.Form("count"), 0)
    rs.Update
    Dim upfid: upfid = rs(nidfield)
    Call upload_update_database_note(ngenre, tmpimage, "image", upfid)
    Call upload_update_database_note(ngenre, tcontent_images_list, "content_images", upfid)
    Call jtbc_cms_admin_msg(itake("global.lng_public.edit_succeed", "lng"), tbackurl, 1)
  Else
    Call jtbc_cms_admin_msg(itake("global.lng_public.not_exist", "lng"), tbackurl, 1)
  End If
  rs.Close
  Set rs = Nothing
End Sub

Sub jtbc_cms_admin_manage_batch_controldisp()
  Dim tbackurl: tbackurl = get_safecode(request.querystring("backurl"))
  Dim classid, search_field, search_keyword
  classid = get_num(request.querystring("classid"), 0)
  search_field = get_safecode(request.querystring("field"))
  search_keyword = get_safecode(request.querystring("keyword"))
  sqlstr = "select * from " & ndatabase & "," & sort_database & " where " & ndatabase & "." & cfname("class") & "=" & sort_database & "." & sort_idfield & " and " & sort_database & "." & cfnames(sort_fpre, "lng") & "='" & slng & "' and " & sort_database & "." & cfnames(sort_fpre, "genre") & "='" & ngenre & "'"
  If Not classid = 0 Then
    If nclstype = 0 Then
      sqlstr = sqlstr & " and " & ndatabase & "." & cfname("class") & "=" & classid
    Else
      sqlstr = sqlstr & " and " & ndatabase & "." & cfname("cls") & " like '%|" & classid & "|%'"
    End If
  End If
  If search_field = "topic" Then sqlstr = sqlstr & " and " & ndatabase & "." & cfname("topic") & " like '%" & search_keyword & "%'"
  If search_field = "sort" Then sqlstr = sqlstr & " and " & sort_database & "." & cfnames(sort_fpre, "sort") & " like '%" & search_keyword & "%'"
  If search_field = "id" Then sqlstr = sqlstr & " and " & ndatabase & "." & nidfield & "=" & get_num(search_keyword, 0)
  If search_field = "hidden" Then sqlstr = sqlstr & " and " & ndatabase & "." & cfname("hidden") & "=" & get_num(search_keyword, 0)
  If search_field = "good" Then sqlstr = sqlstr & " and " & ndatabase & "." & cfname("good") & "=" & get_num(search_keyword, 0)
  sqlstr = sqlstr & " order by " & ndatabase & "." & cfname("time") & " desc"
  Dim tbth_type, tbth_sort
  tbth_type = get_safecode(request.form("bth_type"))
  tbth_sort = get_num(request.form("bth_sort"), 0)
  Call jtbc_cms_admin_batch_controldisp(sqlstr, tbth_type, "class=" & tbth_sort, tbackurl)
End Sub

Sub jtbc_cms_admin_manage_action()
  Select Case request.querystring("action")
    Case "add"
      Call jtbc_cms_admin_manage_adddisp
    Case "edit"
      Call jtbc_cms_admin_manage_editdisp
    Case "batch_control"
      Call jtbc_cms_admin_manage_batch_controldisp
    Case "delete"
      Call jtbc_cms_admin_deletedisp
    Case "control"
      Call jtbc_cms_admin_controldisp
    Case "batch_shift"
      Call jtbc_cms_admin_batch_shiftdisp
    Case "batch_delete"
      Call jtbc_cms_admin_batch_deletedisp
    Case "upload"
      Call upload_files
  End Select
End Sub

Sub jtbc_cms_admin_manage()
  Select Case request.querystring("type")
    Case "add"
      Call jtbc_cms_admin_manage_add
    Case "edit"
      Call jtbc_cms_admin_manage_edit
    Case "displace"
      Call jtbc_cms_admin_manage_displace
    Case "upload"
      Call upload_files_html("upload_html")
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
