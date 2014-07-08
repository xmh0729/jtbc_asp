<%
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
Function jtbc_cms_module_detail()
  Dim tid: tid = get_num(request.querystring("id"),0)
  Dim tmpstr, tmpastr, tmprstr, tmptstr
  tmpstr = itake("module.detail", "tpl")
  tmpastr = ctemplate(tmpstr, "{$recurrence_ida}")
  sqlstr = "select top " & nlisttopx & " * from " & ndatabase & " where " & cfname("hidden") & "=0 and " & cfname("lng") & "='" & nlng & "' order by " & cfname("time") & " desc"
  Set rs = conn.Execute(sqlstr)
  Do While not rs.EOF
    tmptstr = Replace(tmpastr, "{$topic}", htmlencode(get_str(rs(cfname("topic")))))
    tmptstr = Replace(tmptstr, "{$time}",  get_date(rs(cfname("time"))))
    tmptstr = Replace(tmptstr, "{$count}", get_num(rs(cfname("count")),0))
    tmptstr = Replace(tmptstr, "{$id}", get_num(rs(nidfield),0))
    tmprstr = tmprstr & tmptstr
    rs.movenext
  Loop
  Set rs = Nothing
  tmpstr = Replace(tmpstr, jtbc_cinfo, tmprstr)
  sqlstr = "select * from " & ndatabase & " where " & nidfield & "=" & tid & " and " & cfname("hidden") & "=0"
  Set rs = conn.Execute(sqlstr)
  If rs.EOF Then
    sqlstr = "select top 1 * from " & ndatabase & " where " & cfname("hidden") & "=0 and " & cfname("lng") & "='" & nlng & "'"
    Set rs = conn.Execute(sqlstr)
  End If
  If not rs.EOF Then
    Dim ttpoic: ttpoic = htmlencode(get_str(rs(cfname("topic"))))
    Call cntitle(ttpoic)
    tmpstr = Replace(tmpstr, "{$id}", get_num(rs(nidfield), 0))
    tmpstr = Replace(tmpstr, "{$topic}", ttpoic)
    tmpstr = Replace(tmpstr, "{$content}", encode_content(cutepage_content(rs(cfname("content")), rs(cfname("cp_note")), rs(cfname("cp_mode")), rs(cfname("cp_type")), rs(cfname("cp_num"))), rs(cfname("cttype"))))
    tmpstr = Replace(tmpstr, "{$time}", get_date(rs(cfname("time"))))
    tmpstr = Replace(tmpstr, "{$count}", get_num(rs(cfname("count")), 0))
    tmpstr = Replace(tmpstr, "{$page_sel}", cutepage_content_page_sel(rs(cfname("content")), rs(cfname("cp_note")), rs(cfname("cp_mode")), rs(cfname("cp_type")), rs(cfname("cp_num")), "folder=" & ncreatefolder & ";filetype=" & ncreatefiletype & ";time=" & rs(cfname("time")) & ";"))
    tmpstr = creplace(tmpstr)
  Else
    Call imessage(itake("module.sudd", "lng"), "0")
  End If
  Set rs = Nothing
  jtbc_cms_module_detail = tmpstr
End Function

Function jtbc_cms_module_index()
  Dim tmpstr: tmpstr = ireplace("module.index", "tpl")
  If check_null(tmpstr) Then tmpstr = jtbc_cms_module_detail
  jtbc_cms_module_index = tmpstr
End Function

Function jtbc_cms_module
  Select case request.querystring("type")
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