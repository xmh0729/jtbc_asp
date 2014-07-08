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
  Dim jcutpage, jcuti
  Set jcutpage = New jtbc_cutpage
  jcutpage.perpage = npagesize
  jcutpage.sqlstr = sqlstr
  jcutpage.cutpage
  Set rs = jcutpage.pagers
  For jcuti = 1 To npagesize
    If Not rs.EOF Then
      tmptstr = Replace(tmpastr, "{$topic}", htmlencode(get_str(rs(cfname("topic")))))
      tmptstr = Replace(tmptstr, "{$time}",  format_date(get_date(rs(cfname("time"))), 1))
      tmptstr = Replace(tmptstr, "{$star}", get_num(rs(cfname("star")),0))
      tmptstr = Replace(tmptstr, "{$size}", csize(get_num(rs(cfname("size")),0)))
      tmptstr = Replace(tmptstr, "{$scont}",  encode_art(htmlencode(get_str(rs(cfname("scont"))))))
      tmptstr = Replace(tmptstr, "{$lng}", itake("sel_lng." & get_num(rs(cfname("lng")),0), "sel"))
      tmptstr = Replace(tmptstr, "{$accredit}", itake("sel_accredit." & get_num(rs(cfname("accredit")),0), "sel"))
      tmptstr = Replace(tmptstr, "{$runco}",  htmlencode(get_str(rs(cfname("runco")))))
      tmptstr = Replace(tmptstr, "{$count}", get_num(rs(cfname("count")),0))
      tmptstr = Replace(tmptstr, "{$good}", get_num(rs(cfname("good")),0))
      tmptstr = Replace(tmptstr, "{$id}", get_num(rs(nidfield),0))
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
  If not rs.EOF Then
    Dim ttpoic: ttpoic = htmlencode(get_str(rs(cfname("topic"))))
    Call cntitle(ttpoic)
    tmpstr = itake("module.detail", "tpl")
    tmpstr = Replace(tmpstr, "{$id}", get_num(rs(nidfield), 0))
    tmpstr = Replace(tmpstr, "{$topic}", ttpoic)
    tmpstr = Replace(tmpstr, "{$image}",  htmlencode(get_str(rs(cfname("image")))))
    tmpstr = Replace(tmpstr, "{$time}",  format_date(get_date(rs(cfname("time"))), 1))
    tmpstr = Replace(tmpstr, "{$star}", get_num(rs(cfname("star")),0))
    tmpstr = Replace(tmpstr, "{$size}", csize(get_num(rs(cfname("size")),0)))
    tmpstr = Replace(tmpstr, "{$scont}",  encode_art(htmlencode(get_str(rs(cfname("scont"))))))
    tmpstr = Replace(tmpstr, "{$lng}", itake("sel_lng." & get_num(rs(cfname("lng")),0), "sel"))
    tmpstr = Replace(tmpstr, "{$accredit}", itake("sel_accredit." & get_num(rs(cfname("accredit")),0), "sel"))
    tmpstr = Replace(tmpstr, "{$link}", htmlencode(get_str(rs(cfname("link")))))
    tmpstr = Replace(tmpstr, "{$author}", htmlencode(get_str(rs(cfname("author")))))
    tmpstr = Replace(tmpstr, "{$runco}", htmlencode(get_str(rs(cfname("runco")))))
    tmpstr = replace(tmpstr, "{$content}", encode_content(rs(cfname("content")), rs(cfname("cttype"))))
    tmpstr = Replace(tmpstr, "{$id}", get_num(rs(nidfield),0))
    tmpstr = Replace(tmpstr, "{$count}", get_num(rs(cfname("count")),0))
    tmpstr = Replace(tmpstr, "{$class}", get_num(rs(cfname("class")),0))
    Dim turl, tdownurl: tdownurl = itake("config.url", "lng")
    Dim ti, tmpastr, tmprstr, tmptstr
    tmpastr = ctemplate(tmpstr, "{$recurrence_ida}")
    For ti = 1 to 5
      tmptstr = tmpastr
      turl = get_str(rs(cfname("url" & ti)))
      If not check_null(turl) Then
        tmptstr = Replace(tmptstr, "{$downurl}", tdownurl & "[" & ti & "]")
        tmptstr = Replace(tmptstr, "{$downhref}", nuri & "?action=download&id=" & get_num(rs(nidfield),0) & "&did=" & ti)
        tmprstr = tmprstr & tmptstr
      End If
    Next
    tmpstr = Replace(tmpstr, jtbc_cinfo, tmprstr)
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

Sub jtbc_cms_module_downloaddisp
  Dim tid, tdid, turl
  tid = get_num(request.querystring("id"), 0)
  tdid = get_num(request.querystring("did"), 0)
  sqlstr = "select * from " & ndatabase & " where " & nidfield & "=" & tid
  Set rs = server.CreateObject("adodb.recordset")
  rs.open sqlstr, conn, 1, 3
  If not rs.EOF Then
    If tdid >= 1 and tdid <= 5 Then
      turl = get_str(rs(cfname("url" & tdid)))
      If not check_null(turl) Then
        rs(cfname("url_count" & tdid)) = rs(cfname("url_count" & tdid)) + 1
        rs.update
        response.redirect turl
      End If
    End If
  End If
  Set rs = Nothing
  Call imessage(itake("module.download_error", "lng"), "0")
End Sub

Sub jtbc_cms_module_action()
  Select Case request.querystring("action")
    Case "download"
      Call jtbc_cms_module_downloaddisp
  End Select
End Sub
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
%>
