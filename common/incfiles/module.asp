<%
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
Function irss(ByVal ixml, ByVal itpl, ByVal ivars)
  Dim ttopx, trnum, ttnum, thtml
  ttopx = get_num(get_strvalue(ivars, "topx"), 0)
  trnum = get_num(get_strvalue(ivars, "rnum"), 0)
  ttnum = get_num(get_strvalue(ivars, "tnum"), 0)
  thtml = get_num(get_strvalue(ivars, "html"), 0)
  If ttopx = 0 or ttnum = 0 Then Exit Function
  If trnum = 0 Then trnum = 1
  Dim tmpstr, tmpastr, tmprstr, tmptstr
  tmpstr = itake("global.tpl_transfer." & itpl, "tpl")
  If check_null(tmpstr) Then Exit Function
  Dim tmpstra, tmpstrb
  tmpstra = ctemplate(tmpstr, "{$}")
  tmpstrb = ctemplate(tmpstra, "{$$}")
  Dim tmpi, tmpc, tmpstrc, tmpstrd, tmpstre
  tmpc = 0
  Dim ti: ti = 0
  Dim tobjxml, tobjitem
  Set tobjxml = server.CreateObject("microsoft.xmldom")
  tobjxml.Load (server.MapPath(ixml))
  Set tobjitem = tobjxml.documentelement.selectNodes("/rss/channel/item")
  Dim titem, tcitem
  Dim tnodename, ttext
  For each titem in tobjitem
    ti = ti + 1
    If ti <= ttopx Then
      If Not tmpc = 0 And tmpc Mod trnum = 0 Then
        tmpstrc = tmpstrc & Replace(tmpstra, jtbc_cinfo, tmpstre)
        tmpstrd = ""
        tmpstre = ""
      End If
      tmpstrd = tmpstrb
      For each tcitem in titem.childNodes
        tnodename = tcitem.nodeName
        ttext = tcitem.Text
        If tnodename = "title" and strlength(ttext) > ttnum Then ttext = ileft(ttext, ttnum) & ".."
        If not thtml = 1 Then ttext = htmlencode2(ttext)
        tmpstrd = Replace(tmpstrd, "{$" & tnodename & "}", ttext)
      Next
      tmpstre = tmpstre & tmpstrd
      tmpc = tmpc + 1
    End If
  Next
  If Not tmpstre = "" Then tmpstrc = tmpstrc & Replace(tmpstra, jtbc_cinfo, tmpstre)
  tmpstrc = Replace(tmpstr, jtbc_cinfo, tmpstrc)
  tmpstrc = creplace(tmpstrc)
  Set tobjitem = Nothing
  Set tobjxml = Nothing
  irss = tmpstrc
End Function

Function itransfer(ByVal itype, ByVal itpl, ByVal ivars)
  Dim tgenre, ttopx, trnum, tcls, tclass
  Dim ttnum, thtml, tbid, tbsql, tosql, tbaseurl
  Dim tdatabase, tidfield, tfpre
  tgenre = get_str(get_strvalue(ivars, "genre"))
  ttopx = get_num(get_strvalue(ivars, "topx"), 0)
  trnum = get_num(get_strvalue(ivars, "rnum"), 0)
  ttnum = get_num(get_strvalue(ivars, "tnum"), 0)
  tcls = get_num(get_strvalue(ivars, "cls"), 0)
  tclass = get_num(get_strvalue(ivars, "class"), 0)
  thtml = get_num(get_strvalue(ivars, "html"), 0)
  tbid = get_num(get_strvalue(ivars, "bid"), 0)
  tbsql = get_str(get_strvalue(ivars, "bsql"))
  tosql = get_str(get_strvalue(ivars, "osql"))
  tosql = replace(tosql, "#", "'")
  tbaseurl = get_str(get_strvalue(ivars, "baseurl"))
  tdatabase = get_str(get_strvalue(ivars, "database"))
  tidfield = get_str(get_strvalue(ivars, "idfield"))
  tfpre = get_str(get_strvalue(ivars, "fpre"))
  If ttopx = 0 or ttnum = 0 Then Exit Function
  If trnum = 0 Then trnum = 1
  If check_null(tbaseurl) Then
    If Not check_null(tgenre) And Not tgenre = ngenre Then tbaseurl = get_actual_route(tgenre) & "/"
  End If
  If check_null(tgenre) Then tgenre = ngenre
  Dim turltype: turltype = get_num(get_value(cvgenre(tgenre) & ".nurltype"), 0)
  Dim tcreatefolder: tcreatefolder = get_str(get_value(cvgenre(tgenre) & ".ncreatefolder"))
  Dim tcreatefiletype: tcreatefiletype = get_str(get_value(cvgenre(tgenre) & ".ncreatefiletype"))
  If check_null(tdatabase) Then tdatabase = get_str(get_value(cvgenre(tgenre) & ".ndatabase"))
  If check_null(tidfield) Then tidfield = get_str(get_value(cvgenre(tgenre) & ".nidfield"))
  If check_null(tfpre) Then tfpre = get_str(get_value(cvgenre(tgenre) & ".nfpre"))
  If check_null(tdatabase) Then Exit Function
  Dim trs, tsqlstr, tsqlorder
  If check_null(tbsql) Then
    Select Case itype
      Case "all"
        tsqlstr = "select top " & ttopx & " * from " & tdatabase & " where 1=1" 
        tsqlorder =" order by " & tidfield & " desc"
      Case "top"
        tsqlstr = "select top " & ttopx & " * from " & tdatabase & " where " & tfpre & "hidden=0" 
        tsqlorder =" order by " & tidfield & " desc"
      Case "hot"
        tsqlstr = "select top " & ttopx & " * from " & tdatabase & " where " & tfpre & "hidden=0" 
        tsqlorder =" order by " & tfpre & "count desc"
      Case "new"
        tsqlstr = "select top " & ttopx & " * from " & tdatabase & " where " & tfpre & "hidden=0" 
        tsqlorder =" order by " & tfpre & "time desc"
      Case "good"
        tsqlstr = "select top " & ttopx & " * from " & tdatabase & " where " & tfpre & "hidden=0 and " & tfpre & "good=1" 
        tsqlorder =" order by " & tidfield & " desc"
      Case "up"
        tsqlstr = "select top " & ttopx & " * from " & tdatabase & " where " & tfpre & "hidden=0 and " & tidfield & ">" & tbid
        tsqlorder =" order by " & tidfield & " asc"
      Case "down"
        tsqlstr = "select top " & ttopx & " * from " & tdatabase & " where " & tfpre & "hidden=0 and " & tidfield & "<" & tbid
        tsqlorder =" order by " & tidfield & " desc"
      Case Else
        tsqlstr = "select top " & ttopx & " * from " & tdatabase & " where " & tfpre & "hidden=0" 
        tsqlorder =" order by " & tidfield & " desc"
    End Select
    If not tcls = 0 Then tsqlstr = tsqlstr & " and " & tfpre & "cls like '%|" & tcls & "|%'"
    If not tclass = 0 Then tsqlstr = tsqlstr & " and " & tfpre & "class=" & tclass
    If not check_null(tosql) Then tsqlstr = tsqlstr & tosql
    tsqlstr = tsqlstr & tsqlorder
  Else
    tsqlstr = tbsql
  End If
  Set trs = conn.Execute(tsqlstr)
  If not trs.EOF Then
    Dim tfieldscount: tfieldscount = trs.fields.Count - 1
    Dim tmpstr, tmpastr, tmprstr, tmptstr
    tmpstr = itake("global.tpl_transfer." & itpl, "tpl")
    If check_null(tmpstr) Then Exit Function
    Dim tmpstra, tmpstrb
    tmpstra = ctemplate(tmpstr, "{$}")
    tmpstrb = ctemplate(tmpstra, "{$$}")
    Dim tmpi, tmpc, tmpstrc, tmpstrd, tmpstre, tmpsort, tmpfields, tmpfieldsvalue
    tmpc = 0
    Do While Not trs.EOF
      If Not tmpc = 0 And tmpc Mod trnum = 0 Then
        tmpstrc = tmpstrc & Replace(tmpstra, jtbc_cinfo, tmpstre)
        tmpstrd = ""
        tmpstre = ""
      End If
      tmpstrd = tmpstrb
      ReDim rstfields(tfieldscount, 1)
      For tmpi = 0 To tfieldscount
        tmpfields = trs.fields(tmpi).Name
        tmpfieldsvalue = get_str(trs(tmpfields))
        tmpfields = get_lrstr(tmpfields, "_", "rightr")
        rstfields(tmpi, 0) = tmpfields
        rstfields(tmpi, 1) = tmpfieldsvalue
        If tmpfields = "topic" Then
          If strlength(tmpfieldsvalue) > ttnum Then tmpfieldsvalue = ileft(tmpfieldsvalue, ttnum) & ".."
        End If
        If not thtml = 1 Then tmpfieldsvalue = htmlencode2(tmpfieldsvalue)
        tmpstrd = Replace(tmpstrd, "{$" & tmpfields & "}", tmpfieldsvalue)
      Next
      tmpstrd = Replace(tmpstrd, "{$id}", trs(tidfield))
      tmpstrd = Replace(tmpstrd, "{$baseurl}", tbaseurl)
      tmpstrd = Replace(tmpstrd, "{$urltype}", turltype)
      tmpstrd = Replace(tmpstrd, "{$createfolder}", tcreatefolder)
      tmpstrd = Replace(tmpstrd, "{$createfiletype}", tcreatefiletype)
      tmpstre = tmpstre & creplace(tmpstrd)
      trs.movenext
      tmpc = tmpc + 1
      If tmpc >= ttopx Then Exit Do
    Loop
    Set trs = Nothing
    If Not tmpstre = "" Then tmpstrc = tmpstrc & Replace(tmpstra, jtbc_cinfo, tmpstre)
    tmpstrc = Replace(tmpstr, jtbc_cinfo, tmpstrc)
    tmpstrc = creplace(tmpstrc)
    itransfer = tmpstrc
  End If
End Function

Function inavigation(ByVal strers, ByVal strclass)
  Dim tpl_href: tpl_href = itake("global.tpl_config.a_href_self","tpl")
  Dim tmpstr: tmpstr = itake("global.module.channel_title","lng")
  Dim toutstr, trs, tsqlstr
  toutstr = replace_template(tpl_href, "{$explain}" & spa & "{$value}", tmpstr & spa & get_actual_route("./"))
  If not nroute = "root" Then
    Dim tstr1, tstr2
    If instr(strers, ":") > 0 Then
      Dim tmpary: tmpary = split(strers, ":")
      tstr1 = tmpary(0)
      If not check_null(tmpary(1)) Then
        tstr2 = ngenre & "/" & tmpary(1)
      Else
        tstr2 = ""
      End If
    Else
      tstr1 = strers
      tstr2 = ngenre
    End If
    If not check_null(tstr1) Then
      tmpstr = itake(tstr1 & ".channel_title","lng")
      If not check_null(tstr2) Then
        toutstr = toutstr & navspstr & replace_template(tpl_href, "{$explain}" & spa & "{$value}", tmpstr & spa & get_actual_route(tstr2))
      Else
        toutstr = toutstr & navspstr & tmpstr
      End If
    End If
    Dim tclass, tfid
    tclass = get_num(strclass, 0)
    Dim tbaseurl: tbaseurl = get_actual_route(ngenre) & "/"
    Dim turltype: turltype = get_num(get_value(ngenre & ".nurltype"), 0)
    Dim tcreatefolder: tcreatefolder = get_str(get_value(ngenre & ".ncreatefolder"))
    Dim tcreatefiletype: tcreatefiletype = get_str(get_value(ngenre & ".ncreatefiletype"))
    Dim ti, tsortary: tsortary = get_sortary(ngenre, nlng)
    If IsArray(tsortary) Then
      If not tclass = 0 Then
        For ti = 0 to UBound(tsortary)
          If tsortary(ti, 0) = tclass Then
            tfid = get_sortfid(tsortary(ti, 0), tsortary(ti, 2))
            Exit For
          End If
        Next
      End If
      If not check_null(tfid) Then
        For ti = 0 to UBound(tsortary)
          If cinstr(tfid, tsortary(ti, 0), ",") Then
            toutstr = toutstr & navspstr & replace_template(tpl_href, "{$explain}" & spa & "{$value}", tsortary(ti, 1) & spa & curl(tbaseurl, iurl("list", tsortary(ti, 0), turltype, "folder=" & tcreatefolder & ";filetype=" & tcreatefiletype)))
          End If
        Next
      End If
    End If
  End If
  inavigation = toutstr
End Function

Function isort(ByVal strers)
  Dim tfsid: tfsid = get_num(get_strvalue(strers, "class"), 0)
  Dim ttpl: ttpl = get_str(get_strvalue(strers, "tpl"))
  Dim tgenre: tgenre = get_str(get_strvalue(strers, "genre"))
  Dim trnum: trnum = get_num(get_strvalue(strers, "rnum"), 0)
  If trnum = 0 Then trnum = 1
  Dim tbaseurl
  If Not check_null(tgenre) And Not tgenre = ngenre Then tbaseurl = get_actual_route(tgenre) & "/"
  If check_null(tgenre) Then tgenre = ngenre
  Dim turltype: turltype = get_num(get_value(tgenre & ".nurltype"), 0)
  Dim tcreatefolder: tcreatefolder = get_str(get_value(tgenre & ".ncreatefolder"))
  Dim tcreatefiletype: tcreatefiletype = get_str(get_value(tgenre & ".ncreatefiletype"))
  Dim ti, tsortary: tsortary = get_sortary(tgenre, nlng)
  If not IsArray(tsortary) Then Exit Function
  Dim tmpstr, tmpastr, tmprstr, tmptstr
  tmpstr = itake("global.tpl_sort." & ttpl, "tpl")
  If check_null(tmpstr) Then Exit Function
  Dim tmpstra, tmpstrb
  tmpstra = ctemplate(tmpstr, "{$}")
  tmpstrb = ctemplate(tmpstra, "{$$}")
  Dim tmpi, tmpc, tmpstrc, tmpstrd, tmpstre
  tmpc = 0
  For ti = 0 to UBound(tsortary)
    If tsortary(ti, 3) = tfsid Then
      If Not tmpc = 0 And tmpc Mod trnum = 0 Then
        tmpstrc = tmpstrc & Replace(tmpstra, jtbc_cinfo, tmpstre)
        tmpstrd = ""
        tmpstre = ""
      End If
      tmpstrd = tmpstrb
      tmpstrd = Replace(tmpstrd, "{$id}", tsortary(ti, 0))
      tmpstrd = Replace(tmpstrd, "{$sort}", tsortary(ti, 1))
      tmpstrd = Replace(tmpstrd, "{$baseurl}", tbaseurl)
      tmpstrd = Replace(tmpstrd, "{$urltype}", turltype)
      tmpstrd = Replace(tmpstrd, "{$createfolder}", tcreatefolder)
      tmpstrd = Replace(tmpstrd, "{$createfiletype}", tcreatefiletype)
      tmpstre = tmpstre & tmpstrd
      tmpc = tmpc + 1
    End If
  Next
  If Not tmpstre = "" Then tmpstrc = tmpstrc & Replace(tmpstra, jtbc_cinfo, tmpstre)
  tmpstrc = Replace(tmpstr, jtbc_cinfo, tmpstrc)
  tmpstrc = creplace(tmpstrc)
  isort = tmpstrc
End Function
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
%>
