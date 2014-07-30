<%
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
Function jtbc_cms_module_list()
  Dim tmpstr, tmpastr, tmprstr, tmptstr
  tmpstr = ireplace("module.list", "tpl")
  tmpastr = ctemplate(tmpstr, "{$recurrence_ida}")
  sqlstr = "select * from " & ndatabase & " where " & cfname("hidden") & "=0 and " & cfname("lng") & "='" & nlng & "' order by " & cfname("time") & " desc"
  Dim jcutpage, jcuti
  Set jcutpage = New jtbc_cutpage
  jcutpage.perpage = npagesize
  jcutpage.sqlstr = sqlstr
  jcutpage.cutpage
  Set rs = jcutpage.pagers
  Dim tastr, ttstr
  For jcuti = 1 To npagesize
    If Not rs.EOF Then
      tmptstr = Replace(tmpastr, "{$topic}", htmlencode(get_str(rs(cfname("topic")))))
      tmptstr = Replace(tmptstr, "{$author}", htmlencode(get_str(rs(cfname("author")))))
      tmptstr = Replace(tmptstr, "{$content}", creplaces(encode_article(ubbcode(htmlencode(get_str(rs(cfname("content")))), 0))))
      tmptstr = Replace(tmptstr, "{$face}", get_num(rs(cfname("face")), 0))
      tmptstr = Replace(tmptstr, "{$sex}", get_num(rs(cfname("sex")), 0))
      tmptstr = Replace(tmptstr, "{$time}",  get_date(rs(cfname("time"))))
      tmptstr = Replace(tmptstr, "{$qq}", get_num(rs(cfname("qq")), 0))
      tmptstr = Replace(tmptstr, "{$email}", htmlencode(get_str(rs(cfname("email")))))
      tmptstr = Replace(tmptstr, "{$homepage}", htmlencode(get_str(rs(cfname("homepage")))))
      tmptstr = Replace(tmptstr, "{$authorip}", htmlencode(get_str(rs(cfname("authorip")))))
      tmptstr = Replace(tmptstr, "{$id}", get_num(rs(nidfield),0))
      tastr = ctemplate(tmptstr, "{$admin_reply}")
      If check_null(rs(cfname("reply"))) Then
        tmptstr = Replace(tmptstr, jtbc_cinfo, "")
      Else
        ttstr = replace(tastr, "{$replytime}", get_date(rs(cfname("replytime"))))
        ttstr = Replace(ttstr, "{$reply}", creplace(encode_article(ubbcode(htmlencode(get_str(rs(cfname("reply")))), 0))))
        tmptstr = Replace(tmptstr, jtbc_cinfo, ttstr)
      End If
      rs.movenext
      tmprstr = tmprstr & tmptstr
    End If
  Next
  tmpstr = Replace(tmpstr, "{$cpagestr}", jcutpage.pagestr)
  Set rs = Nothing
  Set jcutpage = Nothing
  tmpstr = Replace(tmpstr, jtbc_cinfo, tmprstr)
  Dim tstr_reply: tstr_reply = itake("config.reply", "lng")
  tmpstr = Replace(tmpstr, "{$str_reply}", tstr_reply)
  jtbc_cms_module_list = tmpstr
End Function

Function jtbc_cms_module_add()
  If CStr(nckcode) = CStr(request.querystring("nckcode")) Then
    Dim tmpstr: tmpstr = ireplace("module.add", "tpl")
    tmpstr = cvalhtml(tmpstr, nvalidate, "{$recurrence_valcode}")
    jtbc_cms_module_add = tmpstr
  Else
    Call imessage(itake("global.lng_public.sudd", "lng"), -1)
  End If
End Function

Function jtbc_cms_module_addfree()
  If CStr(nckcode) = CStr(request.querystring("nckcode")) Then
    Dim tmpstr: tmpstr = ireplace("module.addfree", "tpl")
    tmpstr = cvalhtml(tmpstr, nvalidate, "{$recurrence_valcode}")
    jtbc_cms_module_addfree = tmpstr
  Else
    Call imessage(itake("global.lng_public.sudd", "lng"), -1)
  End If
End Function

Function jtbc_cms_module()
  Select Case get_ctype(request.querystring("type"), ECtype)
    Case "add"
      jtbc_cms_module = jtbc_cms_module_add
    Case "addfree"
      jtbc_cms_module = jtbc_cms_module_addfree
    Case "list"
      jtbc_cms_module = jtbc_cms_module_list
    Case Else
      jtbc_cms_module = jtbc_cms_module_list
  End Select
End Function

Sub jtbc_cms_module_adddisp()
  ECtype = "add"
  If Not CStr(nckcode) = CStr(request.form("nckcode")) Then Call imessage(itake("global.lng_public.sudd", "lng"), -1)
  If Not ck_valcode() Then ErrStr = ErrStr & itake("global.lng_error.valcode", "lng") & spa
  Dim tmpchkstr, tmpcitem
  tmpchkstr = "author:" & itake("config.author", "lng") & ",topic:" & itake("config.topic", "lng") & ",content:" & itake("config.content", "lng")
  For Each tmpcitem In Split(tmpchkstr, ",")
    If check_null(request.Form(Split(tmpcitem, ":")(0))) Then
      ErrStr = ErrStr & replace(itake("global.lng_error.insert_empty", "lng"), "[]", "[" & Split(tmpcitem, ":")(1) & "]") & spa
    End If
  Next
  If check_null(ErrStr) Then
    sqlstr = "select * from " & ndatabase
    Set rs = server.CreateObject("adodb.recordset")
    rs.open sqlstr, conn, 1, 3
    rs.addnew
    rs(cfname("author")) = left_intercept(get_str(request.Form("author")), 50)
    rs(cfname("authorip")) = nuserip
    rs(cfname("sex")) = get_num(request.Form("sex"), 0)
    rs(cfname("qq")) = get_num(request.Form("qq"), 0)
    rs(cfname("face")) = get_num(request.Form("face"), 0)
    rs(cfname("email")) = left_intercept(get_str(request.Form("email")), 50)
    rs(cfname("homepage")) = left_intercept(get_str(request.Form("homepage")), 200)
    rs(cfname("topic")) = left_intercept(get_str(request.Form("topic")), 50)
    rs(cfname("content")) = left_intercept(get_str(request.Form("content")), 1000)
    rs(cfname("hidden")) = get_num(request.Form("hidden"), 0)
    rs(cfname("lng")) = nlng
    rs(cfname("time")) = Now()
    rs.update
    rs.Close
    Set rs = Nothing
    response.redirect nuri
  End If
End Sub

Sub jtbc_cms_module_adddispfree()
  ECtype = "add"
  If Not CStr(nckcode) = CStr(request.form("nckcode")) Then Call imessage(itake("global.lng_public.sudd", "lng"), -1)
  If Not ck_valcode() Then ErrStr = ErrStr & itake("global.lng_error.valcode", "lng") & spa
  Dim tmpchkstr, tmpcitem
  tmpchkstr = "author:" & itake("config.author", "lng") & ",topic:" & itake("config.topic", "lng") & ",content:" & itake("config.content", "lng")
  For Each tmpcitem In Split(tmpchkstr, ",")
    If check_null(request.Form(Split(tmpcitem, ":")(0))) Then
      ErrStr = ErrStr & replace(itake("global.lng_error.insert_empty", "lng"), "[]", "[" & Split(tmpcitem, ":")(1) & "]") & spa
    End If
  Next
  If check_null(ErrStr) Then
    sqlstr = "select * from " & ndatabase
    Set rs = server.CreateObject("adodb.recordset")
    rs.open sqlstr, conn, 1, 3
    rs.addnew
    rs(cfname("author")) = left_intercept(get_str(request.Form("author")), 50)
    rs(cfname("authorip")) = nuserip
    rs(cfname("sex")) = get_num(request.Form("sex"), 0)
    rs(cfname("qq")) = get_num(request.Form("qq"), 0)
    rs(cfname("face")) = get_num(request.Form("face"), 0)
    rs(cfname("email")) = left_intercept(get_str(request.Form("email")), 50)
    rs(cfname("homepage")) = left_intercept(get_str(request.Form("homepage")), 200)
    rs(cfname("topic")) = left_intercept(get_str(request.Form("topic")), 50)
    rs(cfname("content")) = left_intercept(get_str(request.Form("content")), 1000)
    rs(cfname("hidden")) = get_num(request.Form("hidden"), 0)
    rs(cfname("lng")) = nlng
    rs(cfname("time")) = Now()
    rs.update
    rs.Close
    Set rs = Nothing
	Response.Write("<script>alert('报名成功,请保持电话畅通');location.href='./?type=addfree&nckcode="+request.form("nckcode")+"';</script>")
  End If
End Sub

Sub jtbc_cms_module_action()
  Select Case request.querystring("action")
    Case "add"
      Call jtbc_cms_module_adddisp
	Case "addfree"
	  Call jtbc_cms_module_adddispfree
  End Select
End Sub
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
%>
