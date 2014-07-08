<%
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
Response.Expires = 0
Response.CacheControl = "no-cache"
Response.AddHeader "Pragma", "no-cache"

Call user_init()

Sub jtbc_cms_interface_quote()
  Dim tmpstr: tmpstr = "[quote]"
  Dim tsid: tsid = get_num(request.querystring("sid"), 0)
  Dim tid: tid = get_num(request.querystring("tid"), 0)
  If Not check_forum_popedom(tsid, 0) = 0 Then Exit Sub
  Call set_forum_ndatabase("topic")
  sqlstr = "select * from " & ndatabase & " where " & cfname("hidden") & "=0 and " & nidfield & "=" & tid
  Set rs = conn.Execute(sqlstr)
  If Not rs.EOF Then
    tmpstr = tmpstr & "[b]" & itake("config.topic_author", "lng") & " " & rs(cfname("author")) & " " & itake("config.releases", "lng") & " " & rs(cfname("time")) & "[/b]" & vbcrlf
    tmpstr = tmpstr & get_forum_content(rs(cfname("content_database")), tid)
  End If
  tmpstr = tmpstr & "[/quote]"
  Set rs = Nothing
  response.write tmpstr
End Sub

Sub jtbc_cms_interface_reply()
  Dim tsid: tsid = get_num(request.querystring("sid"), 0)
  Dim tid: tid = get_num(request.querystring("tid"), 0)
  If Not check_forum_popedom(tsid, 0) = 0 Then Exit Sub
  Call set_forum_ndatabase("topic")
  sqlstr = "select top 5 * from " & ndatabase & " where " & cfname("hidden") & "=0 and " & cfname("fid") & "=" & tid & " order by " & nidfield & " desc"
  Set rs = conn.Execute(sqlstr)
  If rs.EOF Then
    response.write itake("module.noreply", "lng")
  Else
    Dim tmpstr, tmpastr, tmptstr, tmprstr
    tmpstr = ireplace("interface.reply_list", "tpl")
    tmpastr = ctemplate(tmpstr, "{$recurrence_ida}")
    Do While Not rs.EOF
      tmptstr = Replace(tmpastr, "{$icon}", get_num(rs(cfname("icon")), 0))
      tmptstr = Replace(tmptstr, "{$content}", htmlencode(ileft(get_forum_content(rs(cfname("content_database")), get_num(rs(nidfield), 0)), 60)))
      tmptstr = Replace(tmptstr, "{$time}", get_date(rs(cfname("time"))))
      tmptstr = Replace(tmptstr, "{$author}", get_str(rs(cfname("author"))))
      tmprstr = tmprstr & tmptstr
      rs.movenext
    Loop
    tmpstr = Replace(tmpstr, jtbc_cinfo, tmprstr)
    response.write tmpstr
  End If
  Set rs = Nothing
End Sub

Sub jtbc_cms_interface
  Select Case request.querystring("type")
    Case "quote"
      Call jtbc_cms_interface_quote
    Case "reply"
      Call jtbc_cms_interface_reply
  End select
End Sub
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
%>
