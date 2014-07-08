<%
Call jtbc_cms_init("node")
ngenre = get_actual_genre(nuri, nroute)
nhead = get_str(get_value(ngenre & ".nhead"))
nfoot = get_str(get_value(ngenre & ".nfoot"))
nuppath = get_str(get_value(ngenre & ".nuppath"))
nuptype = get_str(get_value(ngenre & ".nuptype"))
npagesize = get_num(get_value(ngenre & ".npagesize"), 0)
ndatabase = get_str(get_value(ngenre & ".ndatabase"))
nidfield = get_str(get_value(ngenre & ".nidfield"))
nfpre = get_str(get_value(ngenre & ".nfpre"))
ntitle = itake("module.channel_title","lng")
If check_null(nhead) Then nhead = default_head
If check_null(nfoot) Then nfoot = default_foot
Dim npagesize_reply: npagesize_reply = get_num(get_value(ngenre & ".npagesize_reply"), 0)
Dim nint_topic: nint_topic = get_num(get_value(ngenre & ".nint_topic"), 0)
Dim nint_reply: nint_reply = get_num(get_value(ngenre & ".nint_reply"), 0)
Dim max_vote_option: max_vote_option = get_num(get_value(ngenre & ".max_vote_option"), 0)
Dim user_upload: user_upload = get_num(get_value(ngenre & ".user_upload"), 0)
Dim new_user_release_timeout: new_user_release_timeout = get_num(get_value(ngenre & ".new_user_release_timeout"), 0)

Function check_forum_isnew(ByVal strdate)
  If IsDate(strdate) Then
    If DateDiff("d", strdate, format_date(Now(), 1)) = 0 Then
      check_forum_isnew = True
    Else
      check_forum_isnew = False
    End If
  Else
    check_forum_isnew = False
  End If
End Function

Function check_forum_islock(ByVal strids, ByVal strmyid, ByVal strisuname, ByVal strunames, ByVal strmyuname)
  Dim tbool1, tbool2
  If check_null(strids) Then
    tbool1 = True
  Else
    If cinstr(strids, strmyid, ",") Then
      tbool1 = True
    Else
      tbool1 = False
    End If
  End If
  If get_num(strisuname, 0) = 2 Then
    If cinstr(strunames, strmyuname, ",") Then
      tbool2 = True
    Else
      tbool2 = False
    End If
  Else
    tbool2 = True
  End If
  If (tbool1 and tbool2) Then
    check_forum_islock = False
  Else
    check_forum_islock = True
  End If
End Function

Function check_forum_isadmin(ByVal strsid)
  Dim tstrsid: tstrsid = get_num(strsid, 0)
  If tstrsid = 0 Then
    check_forum_isadmin = 0
  Else
    Dim tisadmin
    tisadmin = get_userinfo("forum_admin", nusername)
    If tisadmin = 1 Then
      check_forum_isadmin = 1
    Else
      Dim tdatabase, tidfield, tfpre
      tdatabase = cndatabase(ngenre, "sort")
      tidfield = cnidfield(ngenre, "sort")
      tfpre = cnfpre(ngenre, "sort")
      Dim trs, tsqlstr
      tsqlstr = "select * from " & tdatabase & " where " & tidfield & "=" & tstrsid
      Set trs = conn.Execute(tsqlstr)
      If not trs.EOF Then
      	Dim tisadmins
      	tisadmins = trs(cfnames(tfpre, "admin"))
      	If cinstr(tisadmins, nusername, ",") Then
          check_forum_isadmin = 2
      	Else
          check_forum_isadmin = 0
        End If
      Else
      	check_forum_isadmin = 0
      End If
      Set trs = Nothing
    End If
  End If
End Function

Function check_forum_popedom(ByVal strsid, ByVal strtype)
  Dim tsid: tsid = get_num(strsid, 0)
  Dim tutype: tutype = get_userinfo("utype", nusername)
  Dim tdatabase, tidfield, tfpre
  tdatabase = cndatabase(ngenre, "sort")
  tidfield = cnidfield(ngenre, "sort")
  tfpre = cnfpre(ngenre, "sort")
  Dim trs, tsqlstr
  tsqlstr = "select * from " & tdatabase & " where " & cfnames(tfpre, "hidden") & "=0 and not " & cfnames(tfpre, "fsid") & "=0 and " & tidfield & "=" & tsid
  Set trs = conn.Execute(tsqlstr)
  If not trs.EOF Then
    check_forum_popedom = 0
    If strtype = 1 Then
      If trs(cfnames(tfpre, "type")) = 1 Then
        If check_forum_isadmin(tsid) = 0 Then
          check_forum_popedom = 1
          Exit Function
        End If
      End If
      If trs(cfnames(tfpre, "mode")) = 1 Then
        check_forum_popedom = 2
        Exit Function
      ElseIf trs(cfnames(tfpre, "mode")) = 2 Then
        check_forum_popedom = 2.5
        Exit Function
      End If
    End If
    If check_forum_islock(trs(cfnames(tfpre, "popedom")), tutype, trs(cfnames(tfpre, "type")), trs(cfnames(tfpre, "attestation")), nusername) Then
      check_forum_popedom = 3
      Exit Function
    End If
  Else
    check_forum_popedom = 0
  End If
  Set trs = nothing
End Function

Function check_forum_blacklist(ByVal strsid)
  Dim tsid: tsid = get_num(strsid, 0)
  Dim tdatabase, tidfield, tfpre
  tdatabase = cndatabase(ngenre, "blacklist")
  tidfield = cnidfield(ngenre, "blacklist")
  tfpre = cnfpre(ngenre, "blacklist")
  Dim trs, tsqlstr
  tsqlstr = "select * from " & tdatabase & " where " & cfnames(tfpre, "username") & "='" & nusername & "' and " & cfnames(tfpre, "sid") & "=" & tsid
  Set trs = conn.Execute(tsqlstr)
  If not trs.EOF Then
    check_forum_blacklist = True
  Else
    check_forum_blacklist = False
  End If
  Set trs = Nothing
End Function

Function change_forum_topic(ByVal strtopic, ByVal strcolor, ByVal strb)
  Dim tstrtopic: tstrtopic = get_str(strtopic)
  If not check_null(strcolor) Then tstrtopic = "<font color=""" & htmlencode(strcolor) & """>" & tstrtopic & "</font>"
  If get_num(strb, 0) = 1 Then tstrtopic = "<b>" & tstrtopic & "</b>"
  change_forum_topic = tstrtopic
End Function

Function change_forum_vote_type(strers)
  If strers = 0 Then
    change_forum_vote_type = "radio"
  Else
    change_forum_vote_type = "checkbox"
  End If
End Function

Function encode_forum_content(ByVal strers, ByVal strtype)
  Dim tmpstr
  If strtype = 0 then
    tmpstr = encode_article(htmlencode(strers))
  Else
    tmpstr = encode_article(ubbcode(htmlencode(strers), 0))
  End If
  encode_forum_content = creplace(tmpstr)
End Function

Function get_forum_pic(ByVal strislock, ByVal strdate)
  If strislock Then
    get_forum_pic = "forum_lock"
  Else
    If check_forum_isnew(strdate) Then
      get_forum_pic = "forum_new"
    Else
      get_forum_pic = "forum"
    End If
  End If
End Function

Function get_forum_topic_pic(ByVal strhtop, ByVal strtop, ByVal strlock, ByVal strelite, ByVal strcount)
  Dim tstr
  If strhtop = 1 Then
    tstr = "htop"
  ElseIf strtop = 1 Then
    tstr = "top"
  ElseIf strlock = 1 Then
    tstr = "lock"
  ElseIf strelite = 1 Then
    tstr = "elite"
  ElseIf strcount > 200 Then
    tstr = "hot"
  Else
    tstr = "normal"
  End If
  get_forum_topic_pic = tstr
End Function

Function get_forum_files_list(ByVal strers)
  Dim option_unselected: option_unselected = itake("global.tpl_config.option_unselect", "tpl")
  Dim tstrers: tstrers = get_str(strers)
  If check_null(tstrers) Then Exit Function
  Dim tstrary: tstrary = split(tstrers, "|")
  Dim ti, tmpstr
  For ti = 0 to UBound(tstrary)
    tmpstr = tmpstr & replace_template(option_unselected, "{$explain}" & spa & "{$value}", tstrary(ti) & spa & tstrary(ti))
  Next
  get_forum_files_list = tmpstr
End Function

Function get_forum_admin(ByVal strers)
  If check_null(strers) Then Exit Function
  Dim tmpstr, tmprstr
  tmpstr = ireplace("global.tpl_config.a_href_blank", "tpl")
  Dim tmpary: tmpary = split(strers, ",")
  Dim ti
  For ti = 0 to Ubound(tmpary)
    tmprstr = tmprstr & " " & replace_template(tmpstr, "{$explain}" & spa & "{$value}", htmlencode(tmpary(ti)) & spa & get_actual_route(userfolder) & "/?type=user_detail&username=" & urlencode(tmpary(ti)))
  Next
  get_forum_admin = tmprstr
End Function

Function get_forum_info(ByVal strsid, ByVal strislock, ByVal strid, ByVal strtopic, ByVal strtime, ByVal strnum_new, ByVal strnum_new_date, ByVal strnum_topic, ByVal strnum_note)
  Dim tmpstr, tmpastr, tmprstr, tmptstr
  tmpstr = itake("module.forum" , "tpl")
  If check_null(tmpstr) Then tmpstr = itake("global.tpl_user.login" , "tpl")
  tmpastr = ctemplate(tmpstr, "{$recurrence_ida}")
  Dim tmpary: tmpary = split(tmpastr, "{$$}")
  If Not ubound(tmpary) = 1 Then Exit Function
  If Not strislock Then
    Dim tsid, tid, ttopic, ttime, tnum_new, tnum_topic, tnum_note
    tsid = get_num(strsid, 0)
    tid = get_num(strid, 0)
    ttopic = get_str(strtopic)
    If check_null(strtime) Then
      ttime = ""
    Else
      ttime = get_date(strtime)
    End If
    tnum_new = get_str(strnum_new)
    If not IsDate(strnum_new_date) Then
      tnum_new = 0
    Else
      If not DateDiff("d", strnum_new_date, format_date(Now(), 1)) = 0 Then tnum_new = 0
    End If
    tnum_topic = get_str(strnum_topic)
    tnum_note = get_str(strnum_note)
    tmprstr = tmpary(0)
    tmprstr = replace(tmprstr, "{$sid}", htmlencode(tsid))
    tmprstr = replace(tmprstr, "{$tid}", htmlencode(tid))
    tmprstr = replace(tmprstr, "{$topic}", htmlencode(ttopic))
    tmprstr = replace(tmprstr, "{$time}", htmlencode(ttime))
    tmprstr = replace(tmprstr, "{$num_new}", htmlencode(tnum_new))
    tmprstr = replace(tmprstr, "{$num_topic}", htmlencode(tnum_topic))
    tmprstr = replace(tmprstr, "{$num_note}", htmlencode(tnum_note))
  Else
    tmprstr = tmpary(1)
  End If
  tmpstr = Replace(tmpstr, jtbc_cinfo, tmprstr)
  tmpstr = creplace(tmpstr)
  get_forum_info = tmpstr
End Function

Function get_forum_mysortary(ByVal strlng, ByVal strfsid)
  Dim tary, tarys, tarysi
  Dim trs, tsqlstr
  Dim tstrlng: tstrlng = get_safecode(strlng)
  Dim tstrfsid: tstrfsid = get_num(strfsid, 0)
  Dim tdatabase, tidfield, tfpre
  tdatabase = cndatabase(ngenre, "sort")
  tidfield = cnidfield(ngenre, "sort")
  tfpre = cnfpre(ngenre, "sort")
  tsqlstr = "select * from " & tdatabase & " where " & cfnames(tfpre, "fsid") & "=" & tstrfsid & " and " & cfnames(tfpre, "lng") & "='" & tstrlng & "' and " & cfnames(tfpre, "hidden") & "=0 order by " & cfnames(tfpre, "order") & " asc"
  Set trs = conn.Execute(tsqlstr)
  ReDim tary(0, 4)
  Do While Not trs.EOF
    tary(0, 0) = trs(tidfield)
    tary(0, 1) = trs(cfnames(tfpre, "sort"))
    tary(0, 2) = trs(cfnames(tfpre, "fid"))
    tary(0, 3) = trs(cfnames(tfpre, "fsid"))
    tary(0, 4) = trs(cfnames(tfpre, "order"))
    tarysi = unite_array2(tarysi, tary)
    tarysi = unite_array2(tarysi, get_forum_mysortary(tstrlng, trs(tidfield)))
    trs.movenext
  Loop
  Set trs = Nothing
  get_forum_mysortary = tarysi
End Function

Function get_forum_sortary(ByVal strlng)
  Dim tappstr: tappstr = ngenre & "_sort_" & strlng
  Dim tapp: tapp = get_application(tappstr)
  If Not IsArray(tapp) Then
    tapp = get_forum_mysortary(strlng, 0)
    Call set_application(tappstr, tapp)
  End If
  get_forum_sortary = tapp
End Function

Function get_forum_content(ByVal strdatabase, ByVal strtid)
  Dim tdatabase, tidfield, tfpre
  tdatabase = get_safecode(strdatabase)
  tidfield = cnidfield(ngenre, "data")
  tfpre = cnfpre(ngenre, "data")
  Dim tstrtid: tstrtid = get_num(strtid, 0)
  Dim trs, tsqlstr
  tsqlstr = "select " & cfnames(tfpre, "content") & " from " & tdatabase & " where " & cfnames(tfpre, "tid") & "=" & tstrtid
  Set trs = conn.Execute(tsqlstr)
  If Not trs.EOF Then
    get_forum_content = trs(0)
  End If
End Function

Function nav_forum()
  Dim toutstr, tpl_href
  tpl_href = itake("global.tpl_config.a_href_self","tpl")
  Dim tsid: tsid = get_num(request.querystring("sid"), 0)
  If tsid = 0 Then Exit Function
  Dim tary: tary = get_forum_sortary(nlng)
  If IsArray(tary) Then
    Dim ti, tfid
    For ti = 0 to UBound(tary)
      If tary(ti, 0) = tsid Then
        tfid = get_sortfid(tary(ti, 0), tary(ti, 2))
        Exit For
      End If
    Next
    If not check_null(tfid) Then
      For ti = 0 to UBound(tary)
        If cinstr(tfid, tary(ti, 0), ",") and tary(ti, 3) <> 0 Then
          toutstr = toutstr & navspstr & replace_template(tpl_href, "{$explain}" & spa & "{$value}", tary(ti, 1) & spa & get_actual_route(ngenre) & "/?type=list&sid=" & tary(ti, 0))
        End If
      Next
      nav_forum = toutstr
    End If
  End If
End Function

Function sel_forum_sort(ByVal sfsid, ByVal ssid, ByVal slng)
  Dim tary: tary = get_forum_sortary(slng)
  If IsArray(tary) Then
    Dim tsfsid: tsfsid = get_num(sfsid, 0)
    Dim tssid: tssid = get_num(ssid, 0)
    Dim ti, tmpstr, trestr
    trestr = "├"
    Dim option_unselected: option_unselected = itake("global.tpl_config.option_unselect", "tpl")
    Dim option_selected: option_selected = itake("global.tpl_config.option_select", "tpl")
    For ti = 0 to UBound(tary)
      If not tary(ti, 2) = 0 Then
        If tsfsid = 0 Then
          If tary(ti, 0) = tssid Then
            tmpstr = tmpstr & replace_template(option_selected, "{$explain}" & spa & "{$value}", get_repeatstr(trestr, get_incount(tary(ti, 2), ",") + 1) & tary(ti, 1) & spa & tary(ti, 0))
          Else
            tmpstr = tmpstr & replace_template(option_unselected, "{$explain}" & spa & "{$value}", get_repeatstr(trestr, get_incount(tary(ti, 2), ",") + 1) & tary(ti, 1) & spa & tary(ti, 0))
          End If
        End If
      End If
    Next
    sel_forum_sort = tmpstr
  End If
End Function

Sub set_forum_ndatabase(ByVal strers)
  ndatabase = get_str(get_value(ngenre & ".ndatabase_" & strers))
  nidfield = get_str(get_value(ngenre & ".nidfield_" & strers))
  nfpre = get_str(get_value(ngenre & ".nfpre_" & strers))
End Sub
%>
