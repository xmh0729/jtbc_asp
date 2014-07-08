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
  sqlstr = sqlstr & " order by " & cfname("time") & " desc"
  Dim tlimitless: tlimitless = itake("config.limitless", "lng")
  Dim jcutpage, jcuti
  Set jcutpage = New jtbc_cutpage
  jcutpage.perpage = npagesize
  jcutpage.sqlstr = sqlstr
  jcutpage.cutpage
  Set rs = jcutpage.pagers
  For jcuti = 1 To npagesize
    If Not rs.EOF Then
      tmptstr = Replace(tmpastr, "{$image}", htmlencode(get_str(rs(cfname("image")))))
      tmptstr = Replace(tmptstr, "{$snum}", htmlencode(get_str(rs(cfname("snum")))))
      tmptstr = Replace(tmptstr, "{$topic}", htmlencode(get_str(rs(cfname("topic")))))
      tmptstr = Replace(tmptstr, "{$price}", get_num(rs(cfname("price")), 0))
      tmptstr = Replace(tmptstr, "{$wprice}", get_num(rs(cfname("wprice")), 0))
      tmptstr = Replace(tmptstr, "{$unit}", htmlencode(get_str(rs(cfname("unit")))))
      tmptstr = Replace(tmptstr, "{$id}", get_num(rs(nidfield), 0))
      If get_num(rs(cfname("limit")), 0) = 1 Then
        tmptstr = replace(tmptstr, "{$limitstr}", get_num(rs(cfname("limitnum")), 0) & " " & htmlencode(get_str(rs(cfname("unit")))))
      Else
        tmptstr = replace(tmptstr, "{$limitstr}", tlimitless)
      End If
      tmprstr = tmprstr & tmptstr
      rs.movenext
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
  tid = get_num(request.querystring("id"), 0)
  sqlstr = "select * from " & ndatabase & " where " & nidfield & "=" & tid & " and " & cfname("hidden") & "=0"
  Set rs = conn.Execute(sqlstr)
  If Not rs.EOF Then
    Dim ttpoic: ttpoic = htmlencode(get_str(rs(cfname("topic"))))
    Call cntitle(ttpoic)
    tmpstr = itake("module.detail", "tpl")
    tmpstr = Replace(tmpstr, "{$id}", get_num(rs(nidfield), 0))
    tmpstr = Replace(tmpstr, "{$topic}", ttpoic)
    tmpstr = Replace(tmpstr, "{$image}", htmlencode(get_str(rs(cfname("image")))))
    tmpstr = Replace(tmpstr, "{$snum}", htmlencode(get_str(rs(cfname("snum")))))
    tmpstr = Replace(tmpstr, "{$price}", get_num(rs(cfname("price")), 0))
    tmpstr = Replace(tmpstr, "{$wprice}", get_num(rs(cfname("wprice")), 0))
    tmpstr = Replace(tmpstr, "{$content}", encode_content(get_str(rs(cfname("content"))), get_num(rs(cfname("cttype")), 0)))
    tmpstr = Replace(tmpstr, "{$time}", get_date(rs(cfname("time"))))
    tmpstr = Replace(tmpstr, "{$count}", get_num(rs(cfname("count")), 0))
    tmpstr = Replace(tmpstr, "{$class}", get_num(rs(cfname("class")), 0))
    tmpstr = Replace(tmpstr, "{$unit}", htmlencode(get_str(rs(cfname("unit")))))
    If get_num(rs(cfname("limit")), 0) = 1 Then
      tmpstr = replace(tmpstr, "{$limitnum}", get_num(rs(cfname("limitnum")), 0))
      tmpstr = replace(tmpstr, "{$limitstr}", get_num(rs(cfname("limitnum")), 0) & " " & htmlencode(get_str(rs(cfname("unit")))))
    Else
      Dim tlimitless: tlimitless = itake("config.limitless", "lng")
      tmpstr = replace(tmpstr, "{$limitnum}", -1)
      tmpstr = replace(tmpstr, "{$limitstr}", tlimitless)
    End If
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

Function jtbc_cms_module()
  Select Case request.querystring("type")
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
