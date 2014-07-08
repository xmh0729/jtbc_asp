<%
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
ndatabase = sort_database
nidfield = sort_idfield
nfpre = sort_fpre
ncontrol = "select,hidden"
Dim sgenre, slng
sgenre = get_safecode(request.querystring("sgenre"))
slng = get_safecode(request.querystring("slng"))
If check_null(slng) Then slng = nlng
If Not (admc_popedom = "-1" or cinstr(admc_popedom, sgenre, ",")) Then Call jtbc_cms_admin_msgs(itake("global.lng_admin.popedom_error", "lng"), 1)

Sub jtbc_cms_admin_manage_list()
  Dim sid, fid
  sid = get_num(request.querystring("sid"), 0)
  Dim tmpstr, tmpastr, tmprstr, tmptstr
  tmpstr = ireplace("manage.list", "tpl")
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
    tmptstr = Replace(tmptstr, "{$ahref}", "?sgenre=" & sgenre & "&slng=" & slng & "&sid=" & tmpsid)
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
  jcutpage.sqlstr = "select * from " & ndatabase & " where " & cfname("lng") & " ='" & slng & "' and " & cfname("genre") & "='" & sgenre & "' and " & cfname("fsid") & "=" & sid & " order by " & cfname("order") & " asc"
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
  fid = get_sortfid(fid, sid)
  tmpstr = Replace(tmpstr, "{$nav_sort}", nav_sort(sgenre, slng, "?sgenre=" & sgenre & "&slng=" & slng & "&sid=", sid))
  Set rs = Nothing
  Set jcutpage = Nothing
  tmpstr = Replace(tmpstr, jtbc_cinfo, tmprstr)
  response.write tmpstr
End Sub

Sub jtbc_cms_admin_manage_edit()
  Dim tmpstr, sid
  tmpstr = ireplace("manage.edit", "tpl")
  sid = get_num(request.querystring("sid"), 0)
  sqlstr = "select * from " & ndatabase & " where " & nidfield & "=" & sid
  Set rs = server.CreateObject("adodb.recordset")
  rs.open sqlstr, conn, 1, 1
  If Not rs.EOF Then
    tmpstr = Replace(tmpstr, "{$sid}", sid)
    tmpstr = Replace(tmpstr, "{$sort}", rs(cfname("sort")))
    tmpstr = Replace(tmpstr, "{$sgenre}", sgenre)
    tmpstr = Replace(tmpstr, "{$nav_sort}", nav_sort(sgenre, slng, "?sgenre=" & sgenre & "&slng=" & slng & "&sid=", sid))
    response.write tmpstr
  Else
    Call client_alert(itake("manage.editerr", "lng"), -1)
  End If
  rs.Close
  Set rs = Nothing
End Sub

Sub jtbc_cms_admin_manage_adddisp()
  Dim sortname, sortlng
  sortname = get_safecode(request.Form("sort"))
  sortlng = get_safecode(request.Form("lng"))
  Dim sbackurl, sgenre, sid, fid
  sbackurl = get_safecode(request.querystring("backurl"))
  sgenre = get_safecode(request.querystring("sgenre"))
  sid = get_num(request.querystring("sid"), 0)
  If check_null(sortname) Or check_null(sortlng) Then Call jtbc_cms_admin_msg(itake("manage.empty", "lng"), sbackurl, 1)
  sqlstr = "select * from " & ndatabase & " where " & cfname("lng") & "='" & sortlng & "' and " & nidfield & "=" & sid
  Set rs = server.CreateObject("adodb.recordset")
  rs.open sqlstr, conn, 1, 3
  If Not rs.EOF Then
    fid = get_sortfid(rs(cfname("fid")), sid)
  Else
    fid = "0"
  End If
  If Len(fid) < 255 Then
    Dim fid_count
    fid_count = get_sortfid_count(fid, sgenre, sortlng)
    rs.addnew
    rs(cfname("sort")) = left_intercept(sortname, 50)
    rs(cfname("fid")) = fid
    rs(cfname("fsid")) = sid
    rs(cfname("genre")) = sgenre
    rs(cfname("lng")) = left_intercept(sortlng, 50)
    rs(cfname("order")) = fid_count
    rs.Update
    response.redirect sbackurl
  Else
    Call jtbc_cms_admin_msg(itake("manage.dbaseerror", "lng"), sbackurl, 1)
  End If
  rs.Close
  Set rs = Nothing
End Sub

Sub jtbc_cms_admin_manage_editdisp()
  Dim sid, sbackurl, sortname
  sid = get_num(request.querystring("sid"), 0)
  sbackurl = get_safecode(request.querystring("backurl"))
  sortname = get_safecode(request.Form("sort"))
  sqlstr = "select * from " & ndatabase & " where " & nidfield & "=" & sid
  Set rs = server.CreateObject("adodb.recordset")
  rs.open sqlstr, conn, 1, 3
  If Not rs.EOF Then
    rs(cfname("sort")) = sortname
    rs.Update
    Call jtbc_cms_admin_msg(itake("manage.editsucceed", "lng"), sbackurl, 1)
  Else
    Call jtbc_cms_admin_msg(itake("manage.editerr", "lng"), sbackurl, 1)
  End If
  rs.Close
  Set rs = Nothing
End Sub

Sub jtbc_cms_admin_manage_deletedisp()
  Dim sid, sbackurl, myfid, myfid_count
  sid = get_num(request.querystring("sid"), 0)
  sbackurl = get_safecode(request.querystring("backurl"))
  sqlstr = "select * from " & ndatabase & " where " & nidfield & "=" & sid
  Set rs = server.CreateObject("adodb.recordset")
  rs.open sqlstr, conn, 1, 3
  If Not rs.EOF Then
    Dim snotice
    snotice = itake("manage.deletenotice", "lng")
    snotice = Replace(snotice, "[]", "[" & rs(cfname("sort")) & "]")
    Call manage_confirm(snotice, sbackurl)
    myfid = get_sortfid(rs(cfname("fid")), sid)
    myfid_count = get_sortfid_count(myfid, sgenre, get_str(rs(cfname("lng"))))
    If myfid_count > 0 Then
      Call client_alert(itake("manage.delete_has", "lng"), sbackurl)
    Else
      Dim osqlstr: osqlstr = "update " & ndatabase & " set " & cfname("order") & "=" & cfname("order") & "-1 where " & cfname("genre") & "='" & get_str(rs(cfname("genre"))) & "' and " & cfname("lng") & "='" & get_str(rs(cfname("lng"))) & "' and " & cfname("fid") & "='" & rs(cfname("fid")) & "' and " & cfname("order") & ">" & rs(cfname("order"))
      If run_sqlstr(osqlstr) Then
        rs.Delete
        Call client_alert(itake("manage.deletesucceed", "lng"), sbackurl)
      Else
        Call client_alert(itake("manage.deletefailed", "lng"), sbackurl)
      End If
    End If
  Else
    Call client_alert(itake("manage.deleteerr", "lng"), sbackurl)
  End If
End Sub

Sub jtbc_cms_admin_manage_resetdisp()
  Dim ti, sid, sbackurl
  ti = 0
  sid = get_num(request.querystring("sid"), 0)
  sbackurl = get_safecode(request.querystring("backurl"))
  sqlstr = "select * from " & ndatabase & " where " & cfname("lng") & " ='" & slng & "' and " & cfname("genre") & "='" & sgenre & "' and " & cfname("fsid") & "=" & sid & " order by " & nidfield & " asc"
  Set rs = server.CreateObject("adodb.recordset")
  rs.open sqlstr, conn, 1, 3
  Do While not rs.EOF
    rs(cfname("order")) = ti
    rs.update
    ti = ti + 1
    rs.movenext
  Loop
  Set rs = Nothing
  response.redirect sbackurl
End Sub

Sub jtbc_cms_admin_manage_action()
  If Not check_null(request.querystring("action")) Then Call remove_application("")
  Select Case request.querystring("action")
    Case "add"
      Call jtbc_cms_admin_manage_adddisp
    Case "edit"
      Call jtbc_cms_admin_manage_editdisp
    Case "delete"
      Call jtbc_cms_admin_manage_deletedisp
    Case "reset"
      Call jtbc_cms_admin_manage_resetdisp
    Case "order"
      Call jtbc_cms_admin_orderdisp("common.sort", "0", " and " & cfname("genre") & "='" & sgenre & "' and " & cfname("lng") & "='" & slng & "'")
    Case "control"
      Call jtbc_cms_admin_controldisp
  End Select
End Sub

Sub jtbc_cms_admin_manage()
  Select Case request.querystring("type")
    Case "edit"
      Call jtbc_cms_admin_manage_edit
    Case Else
      Call jtbc_cms_admin_manage_list
  End Select
End Sub
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
%>
