<%
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
Function get_review_username(ByVal strname)
  If check_null(strname) Then
    get_review_username = itake("config.df_username", "lng")
  Else
    get_review_username = strname
  End If
End Function

Function jtbc_cms_module_list()
  Dim tfid: tfid = get_num(request.querystring("fid"), 0)
  Dim tmpstr, tmpastr, tmprstr, tmptstr
  tmpstr = ireplace("module.list", "tpl")
  tmpastr = ctemplate(tmpstr, "{$recurrence_ida}")
  sqlstr = "select * from " & ndatabase & " where " & cfname("hidden") & "=0 and " & cfname("fid") & "=" & tfid & " order by " & cfname("time") & " desc"
  Dim jcutpage, jcuti
  Set jcutpage = New jtbc_cutpage
  jcutpage.perpage = npagesize
  jcutpage.sqlstr = sqlstr
  jcutpage.cutpage
  Set rs = jcutpage.pagers
  Dim tastr, ttstr
  For jcuti = 1 To npagesize
    If Not rs.EOF Then
      tmptstr = Replace(tmpastr, "{$author}", htmlencode(get_str(rs(cfname("author")))))
      tmptstr = Replace(tmptstr, "{$authorip}", htmlencode(format_ip(get_str(rs(cfname("authorip"))), 2)))
      tmptstr = Replace(tmptstr, "{$content}", encode_article(ubbcode(htmlencode(get_str(rs(cfname("content")))), 0)))
      tmptstr = Replace(tmptstr, "{$time}",  get_date(rs(cfname("time"))))
      tmptstr = Replace(tmptstr, "{$id}", get_num(rs(nidfield),0))
      rs.movenext
      tmprstr = tmprstr & tmptstr
    End If
  Next
  tmpstr = Replace(tmpstr, "{$cpagestr}", jcutpage.pagestr)
  Set rs = Nothing
  Set jcutpage = Nothing
  tmpstr = Replace(tmpstr, jtbc_cinfo, tmprstr)
  jtbc_cms_module_list = tmpstr
End Function

Function jtbc_cms_module
  Select Case request.querystring("type")
    Case "list"
      jtbc_cms_module = jtbc_cms_module_list
    Case Else
      jtbc_cms_module = jtbc_cms_module_list
  End Select
End Function

Sub jtbc_cms_module_adddisp()
  Call jtbc_cms_web_noout
  Dim tbackurl: tbackurl = get_safecode(request.querystring("backurl"))
  Dim tkeyword, tfid
  tkeyword = get_str(request.querystring("keyword"))
  tfid = get_num(request.querystring("fid"), 0)
  Dim tauthor, tscontent
  tauthor = get_str(request.form("author"))
  tscontent = get_str(request.form("content"))
  If not (check_null(tscontent) or tfid = 0) Then
    Set rs = server.CreateObject("adodb.recordset")
    sqlstr = "select * from " & ndatabase
    rs.open sqlstr, conn, 1, 3
    rs.addnew
    rs(cfname("author")) = get_review_username(nusername)
    rs(cfname("authorip")) = nuserip
    rs(cfname("content")) = left_intercept(tscontent, 500)
    rs(cfname("time")) = Now()
    rs(cfname("keyword")) = tkeyword
    rs(cfname("fid")) = tfid
    rs.update
    Set rs = Nothing
  End If
  If not check_null(tbackurl) Then
    response.redirect tbackurl
  Else
    response.redirect "?type=list&keyword=" & tkeyword & "&fid=" & tfid
  End If
End Sub

Sub jtbc_cms_module_action()
  Select Case request.querystring("action")
    Case "add"
      Call jtbc_cms_module_adddisp
  End Select
End Sub
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
%>
