<%
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
Function jtbc_cms_module_list()
  Dim tshgenre: tshgenre = get_safecode(request.querystring("genre"))
  Dim tshfield: tshfield = get_safecode(request.querystring("field"))
  If not (cinstr(nsearch_genre, tshgenre, ",") and cinstr(nsearch_field, tshfield, ",")) Then Call imessage(itake("module.condition_error", "lng"), -1)
  Dim tshkeyword: tshkeyword = get_safecode(request.querystring("keyword"))
  If check_null(tshkeyword) Then Call imessage(itake("module.keyword_error", "lng"), -1)
  Dim tshi, tshkeywords: tshkeywords = split(tshkeyword, " ")
  If UBound(tshkeywords) >= 5 Then Call imessage(itake("module.complex_error", "lng"), -1)
  Dim tbaseurl: tbaseurl = get_actual_route(tshgenre) & "/"
  Dim turltype: turltype = get_num(get_value(tshgenre & ".nurltype"), 0)
  Dim tcreatefolder: tcreatefolder = get_str(get_value(tshgenre & ".ncreatefolder"))
  Dim tcreatefiletype: tcreatefiletype = get_str(get_value(tshgenre & ".ncreatefiletype"))
  Dim tdatabase, tidfield, tfpre
  tdatabase = get_str(get_value(tshgenre & ".ndatabase"))
  tidfield = get_str(get_value(tshgenre & ".nidfield"))
  tfpre = get_str(get_value(tshgenre & ".nfpre"))
  Dim tfont_red, font_red: font_red = itake("global.tpl_config.font_red", "tpl")
  Dim tmpstr, tmpastr, tmprstr, tmptstr
  tmpstr = itake("module.list", "tpl")
  tmpastr = ctemplate(tmpstr, "{$recurrence_ida}")
  sqlstr = "select * from " & tdatabase & " where " & cfnames(tfpre, "hidden") & "=0"
  For tshi = 0 to UBound(tshkeywords)
    sqlstr = sqlstr & " and " & cfnames(tfpre, tshfield) & " like '%" & tshkeywords(tshi) & "%'"
  Next
  sqlstr = sqlstr & " order by " & cfnames(tfpre, "time") & " desc"
  Dim jcutpage, jcuti
  Set jcutpage = New jtbc_cutpage
  jcutpage.perpage = npagesize
  jcutpage.sqlstr = sqlstr
  jcutpage.cutpage
  Set rs = jcutpage.pagers
  dim tmptopic, postfix_good
  postfix_good = ireplace("global.tpl_config.postfix_good", "tpl")
  For jcuti = 1 To npagesize
    If Not rs.EOF Then
      tmptopic = htmlencode(get_str(rs(cfnames(tfpre, "topic"))))
      If tshfield = "topic" and UBound(tshkeywords) = 0 Then
        tfont_red = Replace(font_red, "{$explain}", tshkeywords(0))
        tmptopic = Replace(tmptopic, tshkeywords(0), tfont_red)
      End If
      if rs(cfnames(tfpre, "good")) = 1 then tmptopic = tmptopic & postfix_good
      tmptstr = Replace(tmpastr, "{$topic}", tmptopic)
      tmptstr = Replace(tmptstr, "{$time}",  get_date(rs(cfnames(tfpre, "time"))))
      tmptstr = Replace(tmptstr, "{$id}", get_num(rs(tidfield),0))
      tmptstr = Replace(tmptstr, "{$count}", get_num(rs(cfnames(tfpre, "count")),0))
      rs.movenext
      tmprstr = tmprstr & tmptstr
    End If
  Next
  tmpstr = Replace(tmpstr, "{$cpagestr}", jcutpage.pagestr)
  Set rs = Nothing
  Set jcutpage = Nothing
  tmpstr = Replace(tmpstr, jtbc_cinfo, tmprstr)
  tmpstr = Replace(tmpstr, "{$baseurl}", tbaseurl)
  tmpstr = Replace(tmpstr, "{$urltype}", turltype)
  tmpstr = Replace(tmpstr, "{$createfolder}", tcreatefolder)
  tmpstr = Replace(tmpstr, "{$createfiletype}", tcreatefiletype)
  tmpstr = creplace(tmpstr)
  jtbc_cms_module_list = tmpstr
End Function

Function jtbc_cms_module
  Select case request.querystring("type")
    Case "list"
      jtbc_cms_module = jtbc_cms_module_list
    Case Else
      jtbc_cms_module = jtbc_cms_module_list
  End Select
End Function
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
%>
