<%
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
Function jtbc_cms_module_list()
  Dim classid, classids
  classid = get_num(request.querystring("classid"),0)
  classids = get_sortids(ngenre, nlng)
  Dim tmpstr, tmpastr, tmprstr, tmptstr
  tmpstr = itake("module.list", "tpl")
  tmpastr = ctemplate(tmpstr, "{$recurrence_ida}")
  sqlstr = "select top " & nlisttopx & " * from " & ndatabase & " where " & cfname("hidden") & "=0"
  If Not classid = 0 Then
    If cinstr(classids, classid, ",") Then
      If nclstype = 0 Then
        sqlstr = sqlstr & " and " & cfname("class") & "=" & classid
      Else
        sqlstr = sqlstr & " and " & cfname("cls") & " like '%|" & classid & "|%'"
      End If
      Call cntitle(get_sorttext(ngenre, nlng, classid))
    End If
  Else
    If cidary(classids) Then sqlstr = sqlstr & " and " & cfname("class") & " in (" & classids & ")"
  End If
  sqlstr = sqlstr & " order by " & cfname("top") & " desc," & cfname("time") & " desc"
  Dim jcutpage, jcuti
  Set jcutpage = New jtbc_cutpage
  jcutpage.perpage = npagesize
  jcutpage.sqlstr = sqlstr
  jcutpage.cutpage
  Set rs = jcutpage.pagers
  For jcuti = 1 To npagesize
    If Not rs.EOF Then
      tmptstr = Replace(tmpastr, "{$topic}", icoloration(htmlencode(get_str(rs(cfname("topic")))), "b=" & get_num(rs(cfname("topic_b")), 0) & ";color=" & get_safecode(rs(cfname("topic_color")))))
      tmptstr = Replace(tmptstr, "{$image}",  htmlencode(get_str(rs(cfname("image")))))
      tmptstr = Replace(tmptstr, "{$time}",  get_date(rs(cfname("time"))))
      tmptstr = Replace(tmptstr, "{$count}", get_num(rs(cfname("count")), 0))
      tmptstr = Replace(tmptstr, "{$good}", get_num(rs(cfname("good")), 0))
      tmptstr = Replace(tmptstr, "{$id}", get_num(rs(nidfield), 0))
      rs.movenext
      tmprstr = tmprstr & tmptstr
    End If
  Next
  tmpstr = Replace(tmpstr, "{$cpagestr}", jcutpage.pagestr)
  tmpstr = Replace(tmpstr, "{$class}", classid)
  Set rs = Nothing
  Set jcutpage = Nothing
  tmpstr = Replace(tmpstr, jtbc_cinfo, tmprstr)
  tmpstr = creplace(tmpstr)
  jtbc_cms_module_list = tmpstr
End Function

Function jtbc_cms_module_detail()
  Dim tid, tmpstr
  tid = get_num(request.querystring("id"),0)
  sqlstr = "select * from " & ndatabase & " where " & nidfield & "=" & tid & " and " & cfname("hidden") & "=0"
  Set rs = conn.Execute(sqlstr)
  If Not rs.eof Then
    Dim ttpoic: ttpoic = htmlencode(get_str(rs(cfname("topic"))))
    Call cntitle(ttpoic)
    tmpstr = itake("module.detail", "tpl")
    tmpstr = Replace(tmpstr, "{$id}", get_num(rs(nidfield), 0))
    tmpstr = Replace(tmpstr, "{$topic}", ttpoic)
    tmpstr = Replace(tmpstr, "{$content}", encode_content(cutepage_content(rs(cfname("content")), rs(cfname("cp_note")), rs(cfname("cp_mode")), rs(cfname("cp_type")), rs(cfname("cp_num"))), rs(cfname("cttype"))))
    tmpstr = Replace(tmpstr, "{$time}", get_date(rs(cfname("time"))))
    tmpstr = Replace(tmpstr, "{$count}", get_num(rs(cfname("count")), 0))
    tmpstr = Replace(tmpstr, "{$page_sel}", cutepage_content_page_sel(rs(cfname("content")), rs(cfname("cp_note")), rs(cfname("cp_mode")), rs(cfname("cp_type")), rs(cfname("cp_num")), "folder=" & ncreatefolder & ";filetype=" & ncreatefiletype & ";time=" & rs(cfname("time")) & ";"))
    tmpstr = Replace(tmpstr, "{$class}", get_num(rs(cfname("class")), 0))
    tmpstr = creplace(tmpstr)
  End If
  Set rs = Nothing
  jtbc_cms_module_detail = tmpstr
End Function

Function jtbc_cms_module_index()
  Dim tmpstr: tmpstr = ireplace("module.index", "tpl")
  If check_null(tmpstr) Then tmpstr = jtbc_cms_module_list
  jtbc_cms_module_index = tmpstr
End Function

Function jtbc_cms_module
  Select case request.querystring("type")
    Case "list"
      jtbc_cms_module = jtbc_cms_module_list
    Case "detail"
      jtbc_cms_module = jtbc_cms_module_detail
    Case "index"
      jtbc_cms_module = jtbc_cms_module_index
    Case Else
      jtbc_cms_module = jtbc_cms_module_index
  End Select
End Function
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
%>
