<%
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
Class manage_forum_sort

  Private Sub Class_Initialize()
    ncontrol = "select,hidden"
    ndatabase = cndatabase(ngenre, "sort")
    nidfield = cnidfield(ngenre, "sort")
    nfpre = cnfpre(ngenre, "sort")
  End Sub

  Public Function get_forum_sortfid(ByVal mfid, ByVal msid)
    If Not (check_null(mfid) Or mfid = "0") Then
      get_forum_sortfid = mfid & "," & msid
    Else
      get_forum_sortfid = msid
    End If
  End Function

  Public Function get_forum_sortfid_count(ByVal gfid)
    Dim count_rs, count_sqlstr
    count_sqlstr = "select count(" & nidfield & ") from " & ndatabase & " where " & cfname("fid") & "='" & gfid & "' and " & cfname("lng") & "='" & slng & "'"
    Set count_rs = conn.Execute(count_sqlstr)
    get_forum_sortfid_count = count_rs(0)
    Set count_rs = Nothing
  End Function

  Public Function nav_forum_sort(ByVal sslng, ByVal sbaseurl, ByVal ssid)
    ssid = get_num(ssid, 0)
    If ssid <= 0 Then Exit Function
    If check_null(sslng) Then Exit Function
    Dim tpl_href, tmpstr, tmpfid
    tpl_href = ireplace("global.tpl_config.a_href_sort", "tpl")
    Dim nav_rs, nav_sqlstr
    Set nav_rs = server.CreateObject("adodb.recordset")
    nav_sqlstr = "select * from " & ndatabase & " where " & nidfield & "=" & ssid
    nav_rs.open nav_sqlstr, conn, 1, 1
    If Not nav_rs.EOF Then tmpfid = nav_rs(cfname("fid"))
    tmpfid = get_forum_sortfid(tmpfid, ssid)
    nav_rs.Close
    If check_null(tmpfid) Then Exit Function
    If Not cidary(tmpfid) Then Exit Function
    nav_sqlstr = "select * from " & ndatabase & " where " & nidfield & " in (" & tmpfid & ") and " & cfname("lng") & "='" & sslng & "' order by " & nidfield & " asc"
    nav_rs.open nav_sqlstr, conn, 1, 1
    Dim tmpsort, font_disabled
    font_disabled = itake("global.tpl_config.font_disabled", "tpl")
    Do While Not nav_rs.EOF
      tmpsort = nav_rs(cfname("sort"))
      If nav_rs(cfname("hidden")) = 1 Then tmpsort = Replace(font_disabled, "{$explain}", tmpsort)
      tmpstr = tmpstr & replace_template(tpl_href, "{$explain}" & spa & "{$value}", tmpsort & spa & sbaseurl & nav_rs(nidfield))
      nav_rs.movenext
    Loop
    nav_rs.Close
    Set nav_rs = Nothing
    nav_forum_sort = tmpstr
  End Function

  Public Sub manage_list()
    Dim sid, fid
    sid = get_num(request.querystring("sid"), 0)
    Dim tmpstr, tmpastr, tmprstr, tmptstr
    tmpstr = itake("manage.forum_list", "tpl")
    tmpastr = ctemplate(tmpstr, "{$recurrence_ida}")
    sqlstr = "select * from " & ndatabase & " where " & nidfield & " =" & sid
    Set rs = server.CreateObject("adodb.recordset")
    rs.open sqlstr, conn, 1, 1
    If Not rs.EOF Then
      fid = rs(cfname("fid"))
      Dim tmpsary, tmpsid
      tmpsary = Split(fid, ",")
      tmpsid = tmpsary(UBound(tmpsary))
      tmptstr = Replace(tmpastr, "{$topic}", rs(cfname("sort")))
      tmptstr = Replace(tmptstr, "{$ahref}", "?slng=" & slng & "&sid=" & tmpsid)
      tmptstr = Replace(tmptstr, "{$sclass}", "red")
      tmprstr = tmprstr & tmptstr
    End If
    rs.Close
    Set rs = Nothing
    tmpstr = Replace(tmpstr, jtbc_cinfo, tmprstr)
    tmprstr = ""
    tmpastr = ctemplate(tmpstr, "{$recurrence_idb}")
    Dim jcutpage, jcuti
    Set jcutpage = New jtbc_cutpage
    jcutpage.perpage = npagesize
    jcutpage.sqlstr = "select * from " & ndatabase & " where " & cfname("lng") & " ='" & slng & "' and " & cfname("fsid") & "=" & sid & " order by " & cfname("order") & " asc"
    jcutpage.cutpage
    Set rs = jcutpage.pagers
    Dim tmpsort, font_disabled
    font_disabled = itake("global.tpl_config.font_disabled", "tpl")
    For jcuti = 1 To npagesize
      If Not rs.EOF Then
        tmpsort = rs(cfname("sort"))
        If rs(cfname("hidden")) = 1 Then tmpsort = Replace(font_disabled, "{$explain}", tmpsort)
        tmptstr = Replace(tmpastr, "{$sort}", tmpsort)
        tmptstr = Replace(tmptstr, "{$sid}", rs(nidfield))
        rs.movenext
        tmprstr = tmprstr & tmptstr
      End If
    Next
    tmpstr = Replace(tmpstr, "{$cpagestr}", jcutpage.pagestr)
    tmpstr = Replace(tmpstr, "{$sid}", sid)
    fid = get_forum_sortfid(fid, sid)
    Set rs = Nothing
    Set jcutpage = Nothing
    tmpstr = Replace(tmpstr, jtbc_cinfo, tmprstr)
    tmprstr = ""
    tmpastr = ctemplate(tmpstr, "{$recurrence_idc}")
    Dim tempary
    tempary = Split(tmpastr, "{$$}")
    If Not sid = 0 Then
      tmprstr = tempary(0)
    Else
      tmprstr = tempary(1)
    End If
    tmpstr = Replace(tmpstr, jtbc_cinfo, tmprstr)
    tmpstr = Replace(tmpstr, "{$nav_forum_sort}", nav_forum_sort(slng, "?slng=" & slng & "&sid=", sid))
    tmpstr = creplace(tmpstr)
    response.write tmpstr
  End Sub

  Public Sub manage_edit()
    Dim sid: sid = get_num(request.querystring("sid"), 0)
    sqlstr = "select * from " & ndatabase & " where " & nidfield & "=" & sid
    Set rs = server.CreateObject("adodb.recordset")
    rs.open sqlstr, conn, 1, 1
    If Not rs.EOF Then
      Dim tmpstr, tmpastr, tmprstr, tmpi, tmpfields, tmpfieldsvalue
      tmpstr = itake("manage.forum_edit", "tpl")
      tmpastr = ctemplate(tmpstr, "{$recurrence_idc}")
      If Not rs(cfname("fsid")) = 0 Then
        tmprstr = Split(tmpastr, "{$$}")(0)
      Else
        tmprstr = Split(tmpastr, "{$$}")(1)
      End If
      tmpstr = Replace(tmpstr, jtbc_cinfo, tmprstr)
      For tmpi = 0 To rs.fields.Count - 1
        tmpfields = rs.fields(tmpi).Name
        tmpfieldsvalue = get_str(rs(tmpfields))
        If tmpfields = cfname("content") Then tcontent = tmpfieldsvalue
        tmpstr = Replace(tmpstr, "{$" & Replace(tmpfields, nfpre, "") & "}", htmlencode(tmpfieldsvalue))
      Next
      tmpstr = Replace(tmpstr, "{$id}", get_str(rs(nidfield)))
      tmpstr = Replace(tmpstr, "{$nav_forum_sort}", nav_forum_sort(slng, "?slng=" & slng & "&sid=", sid))
      tmpstr = creplace(tmpstr)
      response.write tmpstr
    Else
      Call client_alert(itake("manage_forum.editerr", "lng"), -1)
    End If
    rs.Close
    Set rs = Nothing
  End Sub

  Public Sub manage_adddisp()
    Dim sortname, sortlng
    sortname = get_safecode(request.Form("sort"))
    sortlng = get_safecode(request.Form("lng"))
    Dim sbackurl, sid, fid
    sbackurl = get_safecode(request.querystring("backurl"))
    sid = get_num(request.querystring("sid"), 0)
    If check_null(sortname) Or check_null(sortlng) Then Call jtbc_cms_admin_msg(itake("manage_forum.empty", "lng"), sbackurl, 1)
    sqlstr = "select * from " & ndatabase & " where " & cfname("lng") & "='" & sortlng & "' and " & nidfield & "=" & sid
    Set rs = server.CreateObject("adodb.recordset")
    rs.open sqlstr, conn, 1, 3
    If Not rs.EOF Then
      fid = get_forum_sortfid(rs(cfname("fid")), sid)
    Else
      fid = "0"
    End If
    If Len(fid) < 255 Then
      Dim fid_count
      fid_count = get_forum_sortfid_count(fid)
      rs.addnew
      rs(cfname("sort")) = left_intercept(sortname, 50)
      rs(cfname("fid")) = fid
      rs(cfname("fsid")) = sid
      rs(cfname("lng")) = left_intercept(sortlng, 50)
      rs(cfname("order")) = fid_count
      rs(cfname("type")) = get_num(request.Form("type"), 0)
      rs(cfname("mode")) = get_num(request.Form("mode"), 0)
      rs(cfname("popedom")) = format_checkbox(request.Form("popedom"))
      rs(cfname("images")) = left_intercept(get_str(request.Form("images")), 200)
      rs(cfname("admin")) = left_intercept(get_str(request.Form("admin")), 1000)
      rs(cfname("rule")) = left_intercept(get_str(request.Form("rule")), 500)
      rs(cfname("explain")) = left_intercept(get_str(request.Form("explain")), 500)
      rs(cfname("attestation")) = left_intercept(get_str(request.Form("attestation")), 500)
      rs(cfname("hidden")) = get_num(request.Form("hidden"), 0)
      rs.Update
      response.redirect sbackurl
    Else
      Call jtbc_cms_admin_msg(itake("manage_forum.dbaseerror", "lng"), sbackurl, 1)
    End If
    rs.Close
    Set rs = Nothing
  End Sub

  Public Sub manage_editdisp()
    Dim tmpstr, sid, sbackurl, sortname
    sid = get_num(request.querystring("sid"), 0)
    sbackurl = get_safecode(request.querystring("backurl"))
    sortname = get_safecode(request.Form("sort"))
    sqlstr = "select * from " & ndatabase & " where " & nidfield & "=" & sid
    Set rs = server.CreateObject("adodb.recordset")
    rs.open sqlstr, conn, 1, 3
    If Not rs.EOF Then
      rs(cfname("sort")) = left_intercept(sortname, 50)
      rs(cfname("type")) = get_num(request.Form("type"), 0)
      rs(cfname("mode")) = get_num(request.Form("mode"), 0)
      rs(cfname("popedom")) = format_checkbox(request.Form("popedom"))
      rs(cfname("images")) = left_intercept(get_str(request.Form("images")), 200)
      rs(cfname("admin")) = left_intercept(get_str(request.Form("admin")), 1000)
      rs(cfname("rule")) = left_intercept(get_str(request.Form("rule")), 500)
      rs(cfname("explain")) = left_intercept(get_str(request.Form("explain")), 500)
      rs(cfname("attestation")) = left_intercept(get_str(request.Form("attestation")), 500)
      rs(cfname("hidden")) = get_num(request.Form("hidden"), 0)
      rs.Update
      Call jtbc_cms_admin_msg(itake("manage_forum.editsucceed", "lng"), sbackurl, 1)
    Else
      Call jtbc_cms_admin_msg(itake("manage_forum.editerr", "lng"), sbackurl, 1)
    End If
    rs.Close
    Set rs = Nothing
  End Sub

  Public Sub manage_deletedisp()
    Dim sid, sbackurl, myfid, myfid_count
    sid = get_num(request.querystring("sid"), 0)
    sbackurl = get_safecode(request.querystring("backurl"))
    sqlstr = "select * from " & ndatabase & " where " & nidfield & "=" & sid
    Set rs = server.CreateObject("adodb.recordset")
    rs.open sqlstr, conn, 1, 3
    If Not rs.EOF Then
      Dim snotice
      snotice = itake("manage_forum.deletenotice", "lng")
      snotice = Replace(snotice, "[]", "[" & rs(cfname("sort")) & "]")
      Call manage_confirm(snotice, sbackurl)
      myfid = get_forum_sortfid(rs(cfname("fid")), sid)
      myfid_count = get_forum_sortfid_count(myfid)
      If myfid_count > 0 Then
        Call client_alert(itake("manage_forum.delete_has", "lng"), sbackurl)
      Else
        Dim osqlstr
        osqlstr = "update " & ndatabase & " set " & cfname("order") & "=" & cfname("order") & "-1 where " & cfname("fid") & "='" & rs(cfname("fid")) & "' and " & cfname("order") & ">" & rs(cfname("order"))
        If run_sqlstr(osqlstr) Then
          rs.Delete
          Call client_alert(itake("manage_forum.deletesucceed", "lng"), sbackurl)
        Else
          Call client_alert(itake("manage_forum.deletefailed", "lng"), sbackurl)
        End If
      End If
    Else
      Call client_alert(itake("manage_forum.deleteerr", "lng"), sbackurl)
    End If
  End Sub

  Public Sub manage_orderdisp()
    Call jtbc_cms_admin_orderdisp(ngenre, "sort", " and " & cfname("lng") & "='" & slng & "'")
  End Sub

  Private Sub Class_Terminate()
  End Sub
End Class
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
%>
