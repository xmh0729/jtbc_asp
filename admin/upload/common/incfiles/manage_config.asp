<%
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
ndatabase = get_str(get_value("common.upload.ndatabase"))
nidfield = get_str(get_value("common.upload.nidfield"))
nfpre = get_str(get_value("common.upload.nfpre"))
ncontrol = "select,delete"
Const nsearch = "genre,filename,id"

Function manage_navigation()
  Dim tmpstr
  tmpstr = ireplace("manage.navigation", "tpl")
  manage_navigation = tmpstr
End Function

Sub jtbc_cms_admin_manage_list()
  Dim search_field, search_keyword
  search_field = get_safecode(request.querystring("field"))
  search_keyword = get_safecode(request.querystring("keyword"))
  Dim tmpstr, tmpastr
  tmpstr = itake("manage.list", "tpl")
  tmpastr = ctemplate(tmpstr, "{$recurrence_ida}")
  Dim tmprstr, tmptstr
  sqlstr = "select * from " & ndatabase & " where " & nidfield & ">0"
  If search_field = "filename" Then sqlstr = sqlstr & " and " & cfname("filename") & " like '%" & search_keyword & "%'"
  If search_field = "genre" Then sqlstr = sqlstr & " and " & cfname("genre") & " like '%" & search_keyword & "%'"
  If search_field = "valid" Then sqlstr = sqlstr & " and " & cfname("valid") & "=" & get_num(search_keyword, 0)
  If search_field = "id" Then sqlstr = sqlstr & " and " & nidfield & "=" & get_num(search_keyword, 0)
  sqlstr = sqlstr & " order by " & nidfield & " desc"
  Dim jcutpage, jcuti
  Set jcutpage = New jtbc_cutpage
  jcutpage.perpage = npagesize
  jcutpage.sqlstr = sqlstr
  jcutpage.cutpage
  Set rs = jcutpage.pagers
  Dim font_disabled, font_red, font_reds, teffective, tnoneffective, tnoneffective1, tnoneffective2
  font_disabled = itake("global.tpl_config.font_disabled", "tpl")
  font_reds = itake("global.tpl_config.font_red", "tpl")
  teffective = itake("manage.effective", "lng")
  tnoneffective = itake("manage.noneffective", "lng")
  tnoneffective1 = itake("manage.noneffective1", "lng")
  tnoneffective2 = itake("manage.noneffective2", "lng")
  If Not check_null(search_keyword) And search_field = "filename" Then font_red = itake("global.tpl_config.font_red", "tpl")
  Dim tstate, tfilename
  For jcuti = 1 To npagesize
    If Not rs.EOF Then
      If rs(cfname("valid")) = 1 Then
        tstate = Replace(font_reds, "{$explain}", teffective)
      Else
        If rs(cfname("voidreason")) = 1 Then
          tstate = Replace(font_disabled, "{$explain}", tnoneffective1)
        ElseIf rs(cfname("voidreason")) = 2 Then
          tstate = Replace(font_disabled, "{$explain}", tnoneffective2)
        Else
          tstate = Replace(font_disabled, "{$explain}", tnoneffective)
        End If
      End if
      tfilename = get_str(rs(cfname("filename")))
      tfilename = get_lrstr(tfilename, "/", "right")
      If Not check_null(font_red) Then font_red = Replace(font_red, "{$explain}", search_keyword): tfilename = Replace(tfilename, search_keyword, font_red)
      tmptstr = Replace(tmpastr, "{$filename}", tfilename)
      tmptstr = Replace(tmptstr, "{$true_filename}", get_str(rs(cfname("filename"))))
      tmptstr = Replace(tmptstr, "{$user}", get_str(rs(cfname("user"))))
      tmptstr = Replace(tmptstr, "{$genre}", get_str(rs(cfname("genre"))))
      tmptstr = Replace(tmptstr, "{$time}", get_date(rs(cfname("time"))))
      tmptstr = Replace(tmptstr, "{$validity}", tstate)
      tmptstr = Replace(tmptstr, "{$id}", rs(nidfield))
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

Sub jtbc_cms_admin_manage_controldisp()
  Dim cid, cbackurl
  cbackurl = get_safecode(request.querystring("backurl"))
  cid = get_safecode(request.Form("sel_id"))
  cid = format_checkbox(cid)
  If check_null(cid) or get_str(request.Form("control")) <> "delete" Then Exit Sub
  Dim trs, tsqlstr
  Set trs = server.CreateObject("adodb.recordset")
  Dim tfilename
  If cidary(cid) Then
    tsqlstr = "select * from " & ndatabase & " where " & nidfield & " in (" & cid & ")"
    trs.open tsqlstr, conn, 1, 3
    Dim ti, tib, tic
    ti = 0: tib = 0: tic = 0
    Do while Not trs.EOF
      tfilename = trs(cfname("filename"))
      If Not Left(tfilename, 1) = "/" Then tfilename = get_actual_route(trs(cfname("genre"))) & "/" & tfilename
      If delete_file(tfilename) Then
        tib = tib + 1
      Else
        tic = tic + 1
      End If
      trs.delete
      ti = ti + 1
    trs.movenext
    loop
  End If
  Set trs = Nothing
  Dim tdelete_info: tdelete_info = itake("manage.delete_info", "lng")
  tdelete_info = replace(tdelete_info, "[ti]", ti)
  tdelete_info = replace(tdelete_info, "[tib]", tib)
  tdelete_info = replace(tdelete_info, "[tic]", tic)
  Call jtbc_cms_admin_msg(tdelete_info, cbackurl, 1)
End Sub

Sub jtbc_cms_admin_manage_action()
  Select Case request.querystring("action")
    Case "control"
      Call jtbc_cms_admin_manage_controldisp
  End Select
End Sub

Sub jtbc_cms_admin_manage()
  Call jtbc_cms_admin_manage_list
End Sub
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
%>
