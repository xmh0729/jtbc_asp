<%
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
Const admin_head = "admin_head"
Const admin_foot = "admin_foot"

Dim admc_name, admc_pword, admc_popedom, admc_pstate
admc_name = get_safecode(request.cookies(appname & "admin")("username"))
admc_pword = get_safecode(request.cookies(appname & "admin")("password"))
admc_popedom = session(appname & "admin_popedom")

Function get_admin_search()
  If check_null(nsearch) Then Exit Function
  Dim sfield: sfield = get_safecode(request.querystring("field"))
  get_admin_search = show_xmlinfo_select("global.sel_search.all|" & nsearch, sfield, "select")
End Function

Function get_admin_keyword()
  If check_null(nsearch) Then Exit Function
  Dim sfield: sfield = get_safecode(request.querystring("field"))
  If cinstr(nsearch, sfield, ",") Then get_admin_keyword = htmlencode(request.querystring("keyword"))
End Function

Function get_admin_images_list(ByVal strers)
  Dim option_unselected: option_unselected = itake("global.tpl_config.option_unselect", "tpl")
  Dim tstrers: tstrers = get_str(strers)
  If check_null(tstrers) Then Exit Function
  Dim tstrary: tstrary = split(tstrers, "|")
  Dim ti, tmpstr
  For ti = 0 to UBound(tstrary)
    tmpstr = tmpstr & replace_template(option_unselected, "{$explain}" & spa & "{$value}", tstrary(ti) & spa & tstrary(ti))
  Next
  get_admin_images_list = tmpstr
End Function

Function jtbc_cms_cklogin(ByVal ausername, ByVal apassword)
  If check_null(session(appname & "admin_popedom")) Or check_null(session(appname & "admin_username")) Then
    Dim tdatabase, tidfield, tfpre
    tdatabase = get_str(get_value("common.admin.ndatabase"))
    tidfield = get_str(get_value("common.admin.nidfield"))
    tfpre = get_str(get_value("common.admin.nfpre"))
    Dim adm_name, adm_pword
    adm_name = get_safecode(ausername)
    adm_pword = get_safecode(apassword)
    Dim tsqlstr, trs
    tsqlstr = "select * from " & tdatabase & " where " & cfnames(tfpre, "name") & "= '" & adm_name & "' and " & cfnames(tfpre, "pword") & "='" & adm_pword & "' and " & cfnames(tfpre, "lock") & "=0"
    Set trs = server.CreateObject("adodb.recordset")
    trs.open tsqlstr, conn, 1, 3
    If Not trs.EOF Then
      response.cookies(appname & "admin")("username") = trs(cfnames(tfpre, "name"))
      response.cookies(appname & "admin")("password") = trs(cfnames(tfpre, "pword"))
      session(appname & "admin_popedom") = trs(cfnames(tfpre, "popedom"))
      session(appname & "admin_username") = trs(cfnames(tfpre, "name"))
      admc_popedom = trs(cfnames(tfpre, "popedom"))
      trs(cfnames(tfpre, "lasttime")) = Now()
      trs(cfnames(tfpre, "lastip")) = nuserip
      trs.Update
      jtbc_cms_cklogin = True
    Else
      jtbc_cms_cklogin = False
    End If
    trs.Close
    Set trs = Nothing
  Else
    jtbc_cms_cklogin = True
  End If
End Function

Function get_admin_sellng()
  Dim font_red: font_red = itake("global.tpl_config.font_red", "tpl")
  Dim tslng: tslng = get_safecode(request.querystring("slng"))
  If check_null(tslng) Then tslng = nlng
  Dim tmpstr, tmpastr
  tmpstr = ireplace("global.tpl_admin.admin_lng", "tpl")
  tmpastr = ctemplate(tmpstr, "{$recurrence_idc}")
  Dim tmpary, tmprstr
  tmpary = get_xinfo_ary("global.sel_lng.all", "sel")
  If IsArray(tmpary) Then
    Dim tmpi, tmptstr
    Dim tstra, tstrb
    For tmpi = 0 To UBound(tmpary)
      tstra = tmpary(tmpi, 0)
      tstrb = tmpary(tmpi, 1)
      If Not tstra = "" Then
        If tslng = tstra Then tstrb = Replace(font_red, "{$explain}", tstrb)
        tmptstr = Replace(tmpastr, "{$topic}", tstrb)
        tmptstr = Replace(tmptstr, "{$ahref}", replace_querystring("slng", tstra))
      End If
      tmprstr = tmprstr & tmptstr
    Next
  End If
  tmpstr = Replace(tmpstr, jtbc_cinfo, tmprstr)
  get_admin_sellng = tmpstr
End Function

Function get_genre_description(strers)
  On Error Resume Next
  Dim tstrers, tmpstr
  tstrers = strers
  If not check_null(tstrers) Then
    tmpstr = itake("global." & tstrers & ":manage.mgtitle", "lng")
    If check_null(tmpstr) Then tmpstr = itake("global." & tstrers & ":module.channel_title", "lng")
    If check_null(tmpstr) Then tmpstr = "?"
    get_genre_description = tmpstr
  End If
End Function

Function get_html_content()
  Dim tmpstr, tmprstr
  tmpstr = ireplace("global.tpl_config.a_href_sort", "tpl")
  tmprstr = replace_template(tmpstr, "{$explain}" & spa & "{$value}", itake("global.lng_admin.content_htmledit", "lng") & spa & replace_querystring("htype", "0"))
  tmprstr = tmprstr & "&nbsp;" & replace_template(tmpstr, "{$explain}" & spa & "{$value}", itake("global.lng_admin.content_ubbcode", "lng") & spa & replace_querystring("htype", "1"))
  tmprstr = tmprstr & "&nbsp;" & replace_template(tmpstr, "{$explain}" & spa & "{$value}", itake("global.lng_admin.content_text", "lng") & spa & replace_querystring("htype", "2"))
  get_html_content = tmprstr
End Function

Function nav_sort(ByVal ssgenre, ByVal sslng, ByVal sbaseurl, ByVal ssid)
  ssid = get_num(ssid, 0)
  If ssid <= 0 Then Exit Function
  If check_null(sslng) Then Exit Function
  Dim tpl_href, tmpstr, tmpfid
  tpl_href = ireplace("global.tpl_config.a_href_sort", "tpl")
  Dim nav_rs, nav_sqlstr
  Set nav_rs = server.CreateObject("adodb.recordset")
  nav_sqlstr = "select * from " & sort_database & " where " & sort_idfield & "=" & ssid
  nav_rs.open nav_sqlstr, conn, 1, 1
  If Not nav_rs.EOF Then tmpfid = nav_rs(cfnames(sort_fpre, "fid"))
  tmpfid = get_sortfid(tmpfid, ssid)
  nav_rs.Close
  If check_null(tmpfid) Then Exit Function
  If Not cidary(tmpfid) Then Exit Function
  nav_sqlstr = "select * from " & sort_database & " where " & sort_idfield & " in (" & tmpfid & ") and " & cfnames(sort_fpre, "genre") & "='" & ssgenre & "' and " & cfnames(sort_fpre, "lng") & "='" & sslng & "' order by " & sort_idfield & " asc"
  nav_rs.open nav_sqlstr, conn, 1, 1
  Dim tmpsort, font_disabled
  font_disabled = itake("global.tpl_config.font_disabled", "tpl")
  Do While Not nav_rs.EOF
    tmpsort = nav_rs(cfnames(sort_fpre, "sort"))
    If nav_rs(cfnames(sort_fpre, "hidden")) = 1 Then tmpsort = Replace(font_disabled, "{$explain}", tmpsort)
    tmpstr = tmpstr & replace_template(tpl_href, "{$explain}" & spa & "{$value}", tmpsort & spa & sbaseurl & nav_rs(sort_idfield))
    nav_rs.movenext
  Loop
  nav_rs.Close
  Set nav_rs = Nothing
  nav_sort = tmpstr
End Function

Function nav_sort_child(ByVal ssgenre, ByVal sslng, ByVal sbaseurl, ByVal fid, ByVal rnum)
  rnum = get_num(rnum, 0)
  fid = get_num(fid, 0)
  If rnum <= 0 Or fid < 0 Then Exit Function
  If check_null(sslng) Then Exit Function
  Dim tpl_href, tpl_html
  tpl_href = ireplace("global.tpl_config.a_href_sort", "tpl")
  tpl_html = ireplace("global.tpl_config.table_html", "tpl")
  Dim tmpstra, tmpstrb
  tmpstra = ctemplate(tpl_html, "{$}")
  tmpstrb = ctemplate(tmpstra, "{$$}")
  Dim nav_rs, nav_sqlstr
  nav_sqlstr = "select * from " & sort_database & " where " & cfnames(sort_fpre, "fsid") & "=" & fid & " and " & cfnames(sort_fpre, "hidden") & "= 0 and " & cfnames(sort_fpre, "genre") & "='" & ssgenre & "' and " & cfnames(sort_fpre, "lng") & "='" & sslng & "' order by " & cfnames(sort_fpre, "order") & " asc"
  Set nav_rs = server.CreateObject("adodb.recordset")
  nav_rs.open nav_sqlstr, conn, 1, 1
  Dim tmpi, tmpstrc, tmpstrd, tmpstre, tmpsort
  tmpi = 0
  Do While Not nav_rs.EOF
    If Not tmpi = 0 And tmpi Mod rnum = 0 Then
      tmpstrc = tmpstrc & Replace(tmpstra, jtbc_cinfo, tmpstre)
      tmpstrd = ""
      tmpstre = ""
    End If
    tmpsort = nav_rs(cfnames(sort_fpre, "sort"))
    tmpstrd = replace_template(tpl_href, "{$explain}" & spa & "{$value}", tmpsort & spa & sbaseurl & nav_rs(sort_idfield))
    tmpstre = tmpstre & Replace(tmpstrb, "{$value}", tmpstrd)
    nav_rs.movenext
    tmpi = tmpi + 1
  Loop
  If Not tmpstre = "" Then tmpstrc = tmpstrc & Replace(tmpstra, jtbc_cinfo, tmpstre)
  tmpstrc = Replace(tpl_html, jtbc_cinfo, tmpstrc)
  nav_sort_child = tmpstrc
End Function

Sub jtbc_cms_islogin()
  If check_null(npopedom) Then npopedom = ngenre
  If Not jtbc_cms_cklogin(admc_name, admc_pword) Then response.redirect get_actual_route(adminfolder)
  If Not (cinstr(admc_popedom, npopedom, ",") Or admc_pstate = "public" Or admc_popedom = "-1") Then Call jtbc_cms_admin_msgs(itake("global.lng_admin.popedom_error", "lng"), 1)
End Sub

Sub jtbc_cms_admin_controldisp()
  Dim csid, cbackurl
  cbackurl = get_safecode(request.querystring("backurl"))
  csid = get_safecode(request.Form("sel_id"))
  Select Case request.Form("control")
    Case "hidden"
      If cinstr(ncontrol, "hidden", ",") Then Call dbase_switch(ndatabase, nfpre & "hidden", nidfield, csid, "0")
    Case "lock"
      If cinstr(ncontrol, "lock", ",") Then Call dbase_switch(ndatabase, nfpre & "lock", nidfield, csid, "0")
    Case "good"
      If cinstr(ncontrol, "good", ",") Then Call dbase_switch(ndatabase, nfpre & "good", nidfield, csid, "0")
    Case "top"
      If cinstr(ncontrol, "top", ",") Then Call dbase_switch(ndatabase, nfpre & "top", nidfield, csid, "0")
    Case "spprice"
      If cinstr(ncontrol, "spprice", ",") Then Call dbase_switch(ndatabase, nfpre & "spprice", nidfield, csid, "0")
    Case "delete"
      If cinstr(ncontrol, "delete", ",") Then Call dbase_delete(ndatabase, nidfield, csid, "0")
      If not check_null(nuppath) Then Call upload_delete_database_note(ngenre, csid)
  End Select
  response.redirect cbackurl
End Sub

Sub jtbc_cms_admin_batch_controldisp(ByVal strsqlstr, ByVal strtype, ByVal strvars, ByVal strbackurl)
  If not (check_null(strsqlstr) or check_null(strbackurl)) Then
    Dim trs, tsqlstr
    tsqlstr = strsqlstr
    Set trs = server.CreateObject("adodb.recordset")
    trs.open tsqlstr, conn, 1, 3
    Do While Not trs.EOF
      Select Case strtype
        Case "select","hidden","lock","good","spprice"
          If not check_null(strvars) Then
            Dim ti, tary, tary2
            tary = split(strvars, ";")
            For ti = 0 to UBound(tary)
              If not check_null(tary(ti)) Then
                tary2 = split(strvars, "=")
                If UBound(tary2) = 1 Then
                  If tary2(0) = "class" Then
                    If Not get_num(tary2(1), 0) = 0 Then
                      trs(cfname("class")) = get_num(tary2(1), 0)
                      trs(cfname("cls")) = get_sort_cls(get_num(tary2(1), 0))
                    End If
                  Else
                    trs(cfname(tary2(0))) = tary2(1)
                  End If
                End If
              End If
            Next
          End If
          If Not strtype = "select" Then
            If trs(cfname(strtype)) = 0 Then
              trs(cfname(strtype)) = 1
            Else
              trs(cfname(strtype)) = 0
            End If
          End If
          trs.Update
        Case "delete"
          If not check_null(nuppath) Then Call upload_delete_database_note(ngenre, trs(nidfield))
          Call dbase_delete(ndatabase, nidfield, trs(nidfield), "0")
      End Select
      trs.movenext
    Loop
    Set trs = Nothing
    response.redirect strbackurl
  Else
    Call jtbc_cms_admin_msgs(itake("global.lng_public.sudd", "lng"), 1)
  End If
End Sub

Sub jtbc_cms_admin_deletedisp()
  Dim tsid, tbackurl, tnotice, tnoticestr
  tnotice = itake("global.lng_public.delete_notice", "lng")
  tnoticestr = get_safecode(request.querystring("noticestr"))
  tnotice = Replace(tnotice, "[]", "[" & htmlencode(tnoticestr) & "]")
  tbackurl = get_safecode(request.querystring("backurl"))
  Call manage_confirm(tnotice, tbackurl)
  tsid = get_num(request.querystring("id"), 0)
  Call dbase_delete(ndatabase, nidfield, tsid, "0")
  If not check_null(nuppath) Then Call upload_delete_database_note(ngenre, tsid)
  response.redirect tbackurl
End Sub

Sub jtbc_cms_admin_batch_shiftdisp()
  Dim tsort1, tsort2, tchild, tbackurl
  tsort1 = get_num(request.Form("sort1"), 0)
  tsort2 = get_num(request.Form("sort2"), 0)
  tchild = get_num(request.Form("child"), 0)
  tbackurl = get_safecode(request.querystring("backurl"))
  Dim tsqlstr: tsqlstr = "update " & ndatabase & " set " & cfname("class") & "=" & tsort2 & "," & cfname("cls") & "='" & get_sort_cls(tsort2) & "'"
  If tchild = 0 Then
    tsqlstr = tsqlstr & " where " & cfname("class") & "=" & tsort1
  Else
    tsqlstr = tsqlstr & " where " & cfname("cls") & " like '%|" & tsort1 & "|%'"
  End If
  If run_sqlstr(tsqlstr) Then
    Call jtbc_cms_admin_msg(itake("global.lng_public.succeed", "lng"), tbackurl, 1)
  Else
    Call jtbc_cms_admin_msg(itake("global.lng_public.failed", "lng"), tbackurl, 1)
  End If
End Sub

Sub jtbc_cms_admin_batch_deletedisp()
  Dim tsort1, tchild, tbackurl
  tsort1 = get_num(request.Form("sort1"), 0)
  tchild = get_num(request.Form("child"), 0)
  tbackurl = get_safecode(request.querystring("backurl"))
  Dim trs, tsqlstr
  tsqlstr = "select * from " & ndatabase
  If Not tsort1 = -1 Then
    If tchild = 0 Then
      tsqlstr = tsqlstr & " where " & cfname("class") & "=" & tsort1
    Else
      tsqlstr = tsqlstr & " where " & cfname("cls") & " like '%|" & tsort1 & "|%'"
    End If
  End If
  Set trs = server.CreateObject("adodb.recordset")
  trs.open tsqlstr, conn, 1, 3
  Do While not trs.EOF
    If not check_null(nuppath) Then Call upload_delete_database_note(ngenre, trs(nidfield))
    trs.delete
  trs.movenext
  loop
  Set trs = Nothing
  Call jtbc_cms_admin_msg(itake("global.lng_public.succeed", "lng"), tbackurl, 1)
End Sub

Sub jtbc_cms_admin_orderdisp(ByVal strgenre, ByVal strers, ByVal strcntsqlstr)
  Dim tat, tsid, tnum, tbackurl
  tat = get_safecode(request.querystring("at"))
  tbackurl = get_safecode(request.querystring("backurl"))
  tsid = get_num(request.querystring("sid"), 0)
  Dim tdatabase, tidfield, tfpre
  tdatabase = cndatabase(strgenre, strers)
  tidfield = cnidfield(strgenre, strers)
  tfpre = cnfpre(strgenre, strers)
  If not check_null(tdatabase) Then
    Dim trs, tsqlstr
    tsqlstr = "select * from " & tdatabase & " where " & tidfield & "=" & tsid
    Set trs = server.CreateObject("adodb.recordset")
    trs.open tsqlstr, conn, 1, 3
    If Not trs.EOF Then
      Dim tsrs, tssqlstr
      tssqlstr = "select count(" & tidfield & ") from " & tdatabase & " where " & cfnames(tfpre, "fid") & "='" & trs(cfnames(tfpre, "fid")) & "'" & strcntsqlstr
      Set tsrs = conn.Execute(tssqlstr)
      Dim tfid_count: tfid_count = tsrs(0)
      Set tsrs = Nothing
      If tat = "down" Then
        tnum = trs(cfname("order")) + 1
        tsqlstr = "update " & tdatabase & " set " & cfnames(tfpre, "order") & "=" & cfnames(tfpre, "order") & "-1 where " & cfnames(tfpre, "fsid") & "=" & trs(cfnames(tfpre, "fsid")) & " and " & cfnames(tfpre, "order") & "=" & tnum & strcntsqlstr
        If tnum <= (tfid_count - 1) Then
          If run_sqlstr(tsqlstr) Then
            trs(cfname("order")) = tnum
            trs.Update
          End If
        End If
      Else
        tnum = trs(cfnames(tfpre, "order")) - 1
        tsqlstr = "update " & tdatabase & " set " & cfnames(tfpre, "order") & "=" & cfnames(tfpre, "order") & "+1 where " & cfnames(tfpre, "fsid") & "=" & trs(cfnames(tfpre, "fsid")) & " and " & cfnames(tfpre, "order") & "=" & tnum & strcntsqlstr
        If tnum >= 0 Then
          If run_sqlstr(tsqlstr) Then
            trs(cfname("order")) = tnum
            trs.Update
          End If
        End If
      End If
    End If
    trs.Close
    Set trs = Nothing
  End If
  response.redirect tbackurl
End Sub

Sub jtbc_cms_admin_showmsg(ByVal smsg, ByVal sbackurl)
  Dim tmpstr
  tmpstr = ireplace("global.tpl_admin.admin_info", "tpl")
  tmpstr = Replace(tmpstr, "{$backurl}", sbackurl)
  tmpstr = Replace(tmpstr, "{$msginfo}", smsg)
  response.write tmpstr
End Sub

Sub jtbc_cms_admin_showmsgs(ByVal smsg)
  Dim tmpstr
  tmpstr = ireplace("global.tpl_admin.admin_infos", "tpl")
  tmpstr = Replace(tmpstr, "{$msginfo}", smsg)
  response.write tmpstr
End Sub

Sub jtbc_cms_admin_msg(ByVal mmsg, ByVal mbackurl, ByVal mtype)
  If mtype = 0 Then
    Call jtbc_cms_admin_showmsg(mmsg, mbackurl)
  Else
    Call jtbc_cms_web_head(admin_head)
    Call jtbc_cms_admin_showmsg(mmsg, mbackurl)
    Call jtbc_cms_web_foot(admin_foot)
    Call jtbc_cms_close
    response.End
  End If
End Sub

Sub jtbc_cms_admin_msgs(ByVal mmsg, ByVal mtype)
  If mtype = 0 Then
    Call jtbc_cms_admin_showmsg(mmsg)
  Else
    Call jtbc_cms_web_head(admin_head)
    Call jtbc_cms_admin_showmsgs(mmsg)
    Call jtbc_cms_web_foot(admin_foot)
    Call jtbc_cms_close
    response.End
  End If
End Sub
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
%>
