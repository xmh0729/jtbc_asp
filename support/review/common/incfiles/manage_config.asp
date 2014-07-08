<%
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
Const nsearch = "author,content,keyword,id"
ncontrol = "select,hidden,delete"
Const ncttype = 1

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
  If search_field = "author" Then sqlstr = sqlstr & " and " & cfname("author") & " like '%" & search_keyword & "%'"
  If search_field = "content" Then sqlstr = sqlstr & " and " & cfname("content") & " like '%" & search_keyword & "%'"
  If search_field = "keyword" Then sqlstr = sqlstr & " and " & cfname("keyword") & " like '%" & search_keyword & "%'"
  If search_field = "id" Then sqlstr = sqlstr & " and " & nidfield & "=" & get_num(search_keyword, 0)
  If search_field = "hidden" Then sqlstr = sqlstr & " and " & ndatabase & "." & cfname("hidden") & "=" & get_num(search_keyword, 0)
  sqlstr = sqlstr & " order by " & cfname("time") & " desc"
  Dim jcutpage, jcuti
  Set jcutpage = New jtbc_cutpage
  jcutpage.perpage = npagesize
  jcutpage.sqlstr = sqlstr
  jcutpage.cutpage
  Set rs = jcutpage.pagers
  Dim tmpauthor, font_disabled
  font_disabled = itake("global.tpl_config.font_disabled", "tpl")
  For jcuti = 1 To npagesize
    If Not rs.EOF Then
      tmpauthor = htmlencode(get_str(rs(cfname("author"))))
      If rs(cfname("hidden")) = 1 Then tmpauthor = Replace(font_disabled, "{$explain}", tmpauthor)
      tmptstr = Replace(tmpastr, "{$author}", tmpauthor)
      tmptstr = Replace(tmptstr, "{$authorstr}", urlencode(get_str(rs(cfname("author")))))
      tmptstr = Replace(tmptstr, "{$authorip}", htmlencode(get_str(rs(cfname("authorip")))))
      tmptstr = Replace(tmptstr, "{$time}", get_date(rs(cfname("time"))))
      tmptstr = Replace(tmptstr, "{$keyword}", htmlencode(get_str(rs(cfname("keyword")))))
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
  rs(cfname("authorip")) = left_intercept(get_str(request.Form("authorip")), 50)
  rs(cfname("content")) = left_intercept(get_str(request.Form("content")), 500)
  rs(cfname("time")) = get_date(request.Form("time"))
  rs(cfname("keyword")) = left_intercept(get_str(request.Form("keyword")), 50)
  rs(cfname("fid")) = get_num(request.Form("fid"), 0)
  rs(cfname("hidden")) = get_num(request.Form("hidden"), 0)
  rs.Update
  Call jtbc_cms_admin_msg(itake("global.lng_public.add_succeed", "lng"), tbackurl, 1)
  rs.Close
  Set rs = Nothing
End Sub

Sub jtbc_cms_admin_manage_editdisp()
  Dim tid: tid = get_num(request.querystring("id"), 0)
  Dim tbackurl: tbackurl = get_safecode(request.querystring("backurl"))
  Set rs = server.CreateObject("adodb.recordset")
  sqlstr = "select * from " & ndatabase & " where " & nidfield & "=" & tid
  rs.open sqlstr, conn, 1, 3
  If Not rs.EOF Then
    rs(cfname("author")) = left_intercept(get_str(request.Form("author")), 50)
    rs(cfname("authorip")) = left_intercept(get_str(request.Form("authorip")), 50)
    rs(cfname("content")) = left_intercept(get_str(request.Form("content")), 500)
    rs(cfname("time")) = get_date(request.Form("time"))
    rs(cfname("keyword")) = left_intercept(get_str(request.Form("keyword")), 50)
    rs(cfname("fid")) = get_num(request.Form("fid"), 0)
    rs(cfname("hidden")) = get_num(request.Form("hidden"), 0)
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
