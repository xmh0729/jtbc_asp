<%
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
Function cndatabase(ByVal strgenre, ByVal strers)
  If strers = "0" Then
    cndatabase = get_str(get_value(strgenre & ".ndatabase"))
  Else
    cndatabase = get_str(get_value(strgenre & ".ndatabase_" & strers))
  End If
End Function

Function cnidfield(ByVal strgenre, ByVal strers)
  If strers = "0" Then
    cnidfield = get_str(get_value(strgenre & ".nidfield"))
  Else
    cnidfield = get_str(get_value(strgenre & ".nidfield_" & strers))
  End If
End Function

Function cnfpre(ByVal strgenre, ByVal strers)
  If strers = "0" Then
    cnfpre = get_str(get_value(strgenre & ".nfpre"))
  Else
    cnfpre = get_str(get_value(strgenre & ".nfpre_" & strers))
  End If
End Function

Function cutepage_content(ByVal strers, ByVal cp_note, ByVal cp_mode, ByVal cp_type, ByVal cp_num)
  Dim tstrers, tstrary: tstrers = strers
  Dim ti, tmpstr
  Dim tcp_note: tcp_note = get_num(cp_note, 0)
  Dim tcp_mode: tcp_mode = get_num(cp_mode, 0)
  Dim tcp_type: tcp_type = get_num(cp_type, 0)
  Dim tcp_num: tcp_num = get_num(cp_num, 0)
  Dim tcp_page: tcp_page = get_num(request.querystring("page"), 1)
  If tcp_page < 1 Then tcp_page = 1
  If tcp_note = 0 Then
    cutepage_content = tstrers
  Else
    If tcp_mode = 0 Then
      tstrary = split(tstrers, "[NextPage]")
      tcp_page = tcp_page - 1
      If tcp_page < 0 Then tcp_page = 1
      If tcp_page > UBound(tstrary) Then tcp_page = UBound(tstrary)
      cutepage_content = tstrary(tcp_page)
    Else
      If tcp_page < 1 Then tcp_page = 1
      If cp_type = 0 Then
        tstrary = split(tstrers, vbcrlf)
        tcp_page = tcp_page * tcp_num
        If tcp_page > UBound(tstrary) Then
          tcp_page = UBound(tstrary)
          ti = Int(tcp_page/tcp_num) * tcp_num
        Else
          ti = tcp_page - tcp_num
          tcp_page = tcp_page - 1
        End If
        For ti = ti to tcp_page
          tmpstr = tmpstr & tstrary(ti) & vbcrlf
        Next
        cutepage_content = tmpstr
      Else
        Dim tstrlen: tstrlen = Len(tstrers)
        tcp_page = tcp_page * tcp_num
        If tcp_page > tstrlen Then
          tcp_page = tstrlen
          ti = Int(tcp_page/tcp_num) * tcp_num
          tcp_page = tcp_page - ti
        Else
          ti = tcp_page - tcp_num
          tcp_page = tcp_num
        End If
        ti = ti + 1
        If ti <= tstrlen Then cutepage_content = Mid(tstrers, ti, tcp_num)
      End If
    End If
  End If
End Function

Function cutepage_content_page(ByVal strers, ByVal cp_note, ByVal cp_mode, ByVal cp_type, ByVal cp_num)
  Dim tstrers, tstrary: tstrers = strers
  Dim tcp_note: tcp_note = get_num(cp_note, 0)
  Dim tcp_mode: tcp_mode = get_num(cp_mode, 0)
  Dim tcp_type: tcp_type = get_num(cp_type, 0)
  Dim tcp_num: tcp_num = get_num(cp_num, 0)
  If tcp_note = 0 Then
    cutepage_content_page = 0
  Else
    If tcp_mode = 0 Then
      tstrary = split(tstrers, "[NextPage]")
      cutepage_content_page = UBound(tstrary) + 1
    Else
      If cp_type = 0 Then
        tstrary = split(tstrers, vbcrlf)
        If (UBound(tstrary) + 1) Mod tcp_num = 0 Then
          cutepage_content_page = Int((UBound(tstrary) + 1)/tcp_num)
        Else
          cutepage_content_page = Int((UBound(tstrary) + 1)/tcp_num) + 1
        End If
      Else
        Dim tstrlen: tstrlen = Len(tstrers)
        If tstrlen Mod tcp_num = 0 Then
          cutepage_content_page = Int(tstrlen/tcp_num)
        Else
          cutepage_content_page = Int(tstrlen/tcp_num) + 1
        End If
      End If
    End If
  End If
End Function

Function cutepage_content_page_sel(ByVal strers, ByVal cp_note, ByVal cp_mode, ByVal cp_type, ByVal cp_num, ByVal cp_otr)
  Dim ti, tmpstr
  Dim tpagenum: tpagenum = cutepage_content_page(strers, cp_note, cp_mode, cp_type, cp_num)
  If not tpagenum = 0 Then
    Dim tpagelng: tpagelng = itake("global.lng_cutepage.npage", "lng")
    Dim tpl_a_href_self: tpl_a_href_self = itake("global.tpl_config.a_href_self", "tpl")
    If tpagenum < 1 Then tpagenum = 1
    For ti = 1 to tpagenum
      tmpstr = tmpstr & replace_template(tpl_a_href_self, "{$explain}" & spa & "{$value}", replace(tpagelng, "[]", ti) & spa & iurl("ct_page", ti, nurltype, cp_otr & "burls=" & nurl))
      If not ti = tpagenum Then tmpstr = tmpstr & " "
    Next
    cutepage_content_page_sel = tmpstr
  End If
End Function

Function cvalhtml(ByVal strtemplate, ByVal strval, ByVal strrecurrence)
  Dim tstrtemplate: tstrtemplate = get_str(strtemplate)
  Dim tmpstr: tmpstr = ctemplate(tstrtemplate, strrecurrence)
  If get_num(strval, 0) = 0 Then tmpstr = ""
  cvalhtml = Replace(tstrtemplate, jtbc_cinfo, tmpstr)
End Function

Function ck_valcode()
  Dim tbool: tbool = false
  If Not nvalidate = 0 Then
    If request.Form("valcode") = session("rndcodes") Then tbool = true
    If request.QueryString("valcode") = session("rndcodes") Then tbool = true
  Else
    tbool = true
  End If
  ck_valcode = tbool
End Function

Function em_bar(ByVal strers)
  Dim tmpstr
  tmpstr = ireplace("global.tpl_common.em", "tpl")
  tmpstr = replace(tmpstr, "{$content}", strers)
  em_bar = tmpstr
End Function

Function echo_error()
  If Not check_null(ErrStr) Then
    Dim ti, tary, tstr, tmpstr
    tary = split(ErrStr, spa)
    For ti = 0 to UBound(tary)
      If Not check_null(tary(ti)) Then tstr = tstr & tary(ti) & "\n"
    Next
    tmpstr = itake("global.tpl_common.echo_error", "tpl")
    tmpstr = replace(tmpstr, "{$message}", tstr)
    echo_error = tmpstr
  End If
End Function

Function get_sortfid(ByVal mfid, ByVal msid)
  If Not (check_null(mfid) Or mfid = "0") Then
    get_sortfid = mfid & "," & msid
  Else
    get_sortfid = msid
  End If
End Function

Function get_sortfid_count(ByVal gfid, ByVal ggenre, ByVal glng)
  Dim trs, tsqlstr
  tsqlstr = "select count(" & sort_idfield & ") from " & sort_database & " where " & cfnames(sort_fpre, "fid") & "='" & gfid & "' and " & cfnames(sort_fpre, "genre") & "='" & ggenre & "' and " & cfnames(sort_fpre, "lng") & "='" & glng & "'"
  Set trs = conn.Execute(tsqlstr)
  get_sortfid_count = trs(0)
  Set trs = Nothing
End Function

Function get_mysortary(ByVal strgenre, ByVal strlng, ByVal strfsid)
  Dim tary, tarys, tarysi
  Dim trs, tsqlstr
  Dim tstrgenre: tstrgenre = get_safecode(strgenre)
  Dim tstrlng: tstrlng = get_safecode(strlng)
  Dim tstrfsid: tstrfsid = get_num(strfsid, 0)
  tsqlstr = "select * from " & sort_database & " where " & cfnames(sort_fpre, "fsid") & "=" & tstrfsid & " and " & cfnames(sort_fpre, "genre") & "='" & tstrgenre & "' and " & cfnames(sort_fpre, "lng") & "='" & tstrlng & "' and " & cfnames(sort_fpre, "hidden") & "=0 order by " & cfnames(sort_fpre, "order") & " asc"
  Set trs = conn.Execute(tsqlstr)
  ReDim tary(0, 4)
  Do While Not trs.EOF
    tary(0, 0) = trs(sort_idfield)
    tary(0, 1) = trs(cfnames(sort_fpre, "sort"))
    tary(0, 2) = trs(cfnames(sort_fpre, "fid"))
    tary(0, 3) = trs(cfnames(sort_fpre, "fsid"))
    tary(0, 4) = trs(cfnames(sort_fpre, "order"))
    tarysi = unite_array2(tarysi, tary)
    tarysi = unite_array2(tarysi, get_mysortary(tstrgenre, tstrlng, trs(sort_idfield)))
    trs.movenext
  Loop
  Set trs = Nothing
  get_mysortary = tarysi
End Function

Function get_sortary(ByVal strgenre, ByVal strlng)
  Dim tappstr: tappstr = "sys_sort_" & strgenre & "_" & strlng
  Dim tapp: tapp = get_application(tappstr)
  If Not IsArray(tapp) Then
    tapp = get_mysortary(strgenre, strlng, 0)
    Call set_application(tappstr, tapp)
  End If
  get_sortary = tapp
End Function

Function get_sorttext(ByVal strgenre, ByVal strlng, ByVal strsid)
  Dim tsortary: tsortary = get_sortary(strgenre, strlng)
  If IsArray(tsortary) Then
    Dim ti, tstrsid
    tstrsid = get_num(strsid, 0)
    If tstrsid = 0 Then Exit Function
    For ti = 0 to UBound(tsortary)
      If tsortary(ti, 0) = tstrsid Then
        get_sorttext = tsortary(ti, 1)
        Exit Function
      End If
    Next
  End If
End Function

Function get_sortids(ByVal strgenre, ByVal strlng)
  Dim tsortary: tsortary = get_sortary(strgenre, strlng)
  If IsArray(tsortary) Then
    Dim ti, tstrids
    For ti = 0 to UBound(tsortary)
      tstrids = tstrids & tsortary(ti, 0) & ","
    Next
    If Not check_null(tstrids) Then
      If Right(tstrids, 1) = "," Then tstrids = Left(tstrids, Len(tstrids) - 1)
    End If
    get_sortids = tstrids
  End If
End Function

Function get_sort_cls(ByVal strers)
  Dim tstrers: tstrers = get_num(strers, 0)
  If not tstrers = 0 Then
    Dim trs, tsqlstr
    tsqlstr = "select * from " & sort_database & " where " & sort_idfield & "=" & tstrers
    Set trs = conn.Execute(tsqlstr)
    If not trs.EOF Then
      Dim tmpstr
      Dim ti, tfidary
      tfidary = split(get_str(trs(cfnames(sort_fpre, "fid"))), ",")
      For ti = 0 to UBound(tfidary)
        tmpstr = tmpstr & "|" & tfidary(ti) & "|,"
      Next
      tmpstr = tmpstr & "|" & strers & "|"
      get_sort_cls = tmpstr
    End If
    Set trs = Nothing
  End If
End Function

Function get_topid(ByVal strdatabase, ByVal stridfield)
  Dim tstrdatabase: tstrdatabase = get_safecode(strdatabase)
  Dim tstridfield: tstridfield = get_safecode(stridfield)
  Dim trs, tsqlstr
  tsqlstr = "select max(" & tstridfield & ") from " & tstrdatabase
  Set trs = conn.Execute(tsqlstr)
  get_topid = trs(0)
  Set trs = Nothing
End Function

Function get_myvalid_module(ByVal strers)
  On Error Resume Next
  Dim tmpstr
  Dim tfso, tfolder
  Dim tpath: tpath = get_str(strers)
  Set tfso = server.CreateObject(fso_object)
  Set tfolder = tfso.GetFolder(server.MapPath(tpath))
  If Not Err Then
    Dim tfolders, tfoldersname, tfoldersnames, tfilename
    For Each tfolders In tfolder.subfolders
      tfoldersname = tfolders.Name
      tfilename = tpath & tfoldersname & "/common/config" & xmltype
      tfoldersnames = tpath & tfoldersname
      tfoldersnames = replace(tfoldersnames, "../", "")
      tfoldersnames = replace(tfoldersnames, "./", "")
      If isfileexists(repath(tfilename)) Then
        tmpstr = tmpstr & tfoldersnames & "|"
        If get_xrootatt(repath(tfilename), "mode") = "jtbcfgf" Then tmpstr = tmpstr & get_myvalid_module(tpath & tfoldersnames & "/") & "|"
      End If
    Next
  End If
  Set tfolder = Nothing
  Set tfso = Nothing
  If Right(tmpstr, 1) = "|" Then tmpstr = get_lrstr(tmpstr, "|", "leftr")
  get_myvalid_module = tmpstr
End Function

Function get_valid_module(ByVal strers)
  Dim tstrers: tstrers = strers
  tstrers = replace(tstrers, "../", "")
  tstrers = replace(tstrers, "./", "")
  Dim tappstr: tappstr = "sys_valid_module"
  If Not check_null(tstrers) Then tappstr = tappstr & "_" & tstrers
  Dim tapp: tapp = get_application(tappstr)
  If check_null(tapp) Then
    tapp = get_myvalid_module(strers)
    Call set_application(tappstr, tapp)
  End If
  get_valid_module = tapp
End Function

Function html_content(ByVal hname, ByVal hvalue, ByVal htype)
  Dim tmphtype, tmpstr
  tmphtype = request.querystring("htype")
  If check_null(tmphtype) Then
    tmphtype = htype
    If check_null(tmphtype) then tmphtype = ncttype
  End If
  tmphtype = get_num(tmphtype, 0)
  If tmphtype = -1 Then tmphtype = htype
  Select Case tmphtype
    Case 0
      tmpstr = itake("global.tpl_admin.content_htmledit", "tpl")
    Case 1
      tmpstr = itake("global.tpl_admin.content_ubbcode", "tpl")
    Case 2
      tmpstr = itake("global.tpl_admin.content_text", "tpl")
    Case Else
      tmpstr = itake("global.tpl_admin.content_htmledit", "tpl")
  End Select
  tmpstr = Replace(tmpstr, "{$name}", hname)
  tmpstr = Replace(tmpstr, "{$value}", htmlencode(hvalue))
  html_content = creplace(tmpstr)
End Function

Function icoloration(ByVal strers, ByVal strvars)
  Dim tstrers: tstrers = strers
  If not check_null(strers) Then
    Dim tb, tcolor
    tb = get_num(get_strvalue(strvars, "b"), 0)
    tcolor = htmlencode(get_strvalue(strvars, "color"))
    If not check_null(tcolor) Then
      Dim tfont_color: tfont_color = itake("global.tpl_config.font_color", "tpl")
      tstrers = replace_template(tfont_color, "{$explain}" & spa & "{$value}", tstrers & spa & tcolor)
    End If
    If tb = 1 Then
      Dim thtml_b: thtml_b = itake("global.tpl_config.html_b", "tpl")
      tstrers = replace(thtml_b, "{$explain}", tstrers)
    End If
    icoloration = tstrers
  End If
End Function

Function sel_sort(ByVal sfsid, ByVal ssid, ByVal sgenre, ByVal slng)
  Dim tary: tary = get_sortary(sgenre, slng)
  If IsArray(tary) Then
    Dim tsfsid: tsfsid = get_num(sfsid, 0)
    Dim tssid: tssid = get_num(ssid, 0)
    Dim ti, tmpstr, trestr
    trestr = itake("global.lng_common.re-class", "lng")
    Dim option_unselected: option_unselected = itake("global.tpl_config.option_unselect", "tpl")
    Dim option_selected: option_selected = itake("global.tpl_config.option_select", "tpl")
    For ti = 0 to UBound(tary)
      If tsfsid = 0 Then
        If tary(ti, 0) = tssid Then
          tmpstr = tmpstr & replace_template(option_selected, "{$explain}" & spa & "{$value}", get_repeatstr(trestr, get_incount(tary(ti, 2), ",") + 1) & tary(ti, 1) & spa & tary(ti, 0))
        Else
          tmpstr = tmpstr & replace_template(option_unselected, "{$explain}" & spa & "{$value}", get_repeatstr(trestr, get_incount(tary(ti, 2), ",") + 1) & tary(ti, 1) & spa & tary(ti, 0))
        End If
      End If
    Next
    sel_sort = tmpstr
  End If
End Function

Function sel_control()
  Dim tmpstr: tmpstr = ireplace("global.tpl_admin.admin_control", "tpl")
  tmpstr = Replace(tmpstr, "{$control}", show_xmlinfo_select("global.sel_control.all|" & ncontrol, "", "select"))
  sel_control = tmpstr
End Function

Function sel_yesno(ByVal rname, ByVal rvalue)
  Dim tmpstr, option_radio, option_unradio
  option_radio = ireplace("global.tpl_config.option_radio", "tpl")
  option_unradio = ireplace("global.tpl_config.option_unradio", "tpl")
  Dim html_kong: html_kong = itake("global.tpl_config.html_kong", "tpl")
  Dim tlngyes: tlngyes = itake("global.lng_config.yes", "lng")
  Dim tlngno: tlngno = itake("global.lng_config.no", "lng")
  If rvalue = 1 Then
    tmpstr = tmpstr & replace_template(option_radio, "{$explain}" & spa & "{$value}", rname & spa & "1") & tlngyes & html_kong
  Else
    tmpstr = tmpstr & replace_template(option_unradio, "{$explain}" & spa & "{$value}", rname & spa & "1") & tlngyes & html_kong
  End If
  If rvalue = 0 Then
    tmpstr = tmpstr & replace_template(option_radio, "{$explain}" & spa & "{$value}", rname & spa & "0") & tlngno
  Else
    tmpstr = tmpstr & replace_template(option_unradio, "{$explain}" & spa & "{$value}", rname & spa & "0") & tlngno
  End If
  sel_yesno = tmpstr
End Function

Function sel_genre(ByVal strers, ByVal strsel)
  Dim tstrers: tstrers = get_str(strers)
  Dim tstrsel: tstrsel = get_str(strsel)
  Dim option_unselected: option_unselected = itake("global.tpl_config.option_unselect", "tpl")
  Dim option_selected: option_selected = itake("global.tpl_config.option_select", "tpl")
  Dim tmodules: tmodules = get_str(get_valid_module(get_actual_route("./")))
  Dim ti, tarys, tmpstr
  tarys = split(tstrers, ",")
  For ti = 0 to UBound(tarys)
    If cinstr(tmodules, tarys(ti), "|") Then
      If tarys(ti) = tstrsel Then
        tmpstr = tmpstr & replace_template(option_selected, "{$explain}" & spa & "{$value}", itake("global." & tarys(ti) & ":module.channel_title", "lng") & spa & tarys(ti))
      Else
        tmpstr = tmpstr & replace_template(option_unselected, "{$explain}" & spa & "{$value}", itake("global." & tarys(ti) & ":module.channel_title", "lng") & spa & tarys(ti))
      End If
    End If
  Next
  sel_genre = tmpstr
End Function

Function ubb_bar(ByVal strers)
  Dim tmpstr
  tmpstr = ireplace("global.tpl_common.ubb", "tpl")
  tmpstr = replace(tmpstr, "{$content}", strers)
  ubb_bar = tmpstr
End Function

Function valcode()
  Dim tmpstr
  tmpstr = ireplace("global.tpl_common.valcode", "tpl")
  valcode = tmpstr
End Function

Sub cntitle(ByVal strers)
  If check_null(ntitle) Then
    ntitle = htmlencode(get_str(strers))
  Else
    ntitle = htmlencode(get_str(strers)) & spstr & ntitle
  End If
End Sub

Sub check_valcode(ByVal strbk)
  If Not ck_valcode() Then Call client_alert(itake("global.lng_error.valcode", "lng"), strbk)
End Sub

Sub dbase_delete(ByVal dbtable, ByVal dbid, ByVal idary, ByVal otsql)
  If Not (check_null(dbtable) Or check_null(dbid) Or check_null(idary)) Then
    Dim tmpstr: tmpstr = format_checkbox(idary)
    If Not cidary(tmpstr) Then Exit Sub
    Dim tsqlstr
    Select Case dbtype
      Case 0
        tsqlstr = "delete from " & dbtable & " where " & dbid & " in (" & tmpstr & ") "
      Case 1
        tsqlstr = "delete " & dbtable & " where " & dbid & " in (" & tmpstr & ") "
      Case Else
        tsqlstr = "delete " & dbtable & " where " & dbid & " in (" & tmpstr & ") "
    End Select
    If not otsql = "0" Then tsqlstr = tsqlstr & otsql
    If run_sqlstr(tsqlstr) Then Exit Sub
  End If
End Sub

Sub dbase_switch(ByVal dbtable, ByVal dbfield, ByVal dbid, ByVal idary, ByVal otsql)
  If Not (check_null(dbtable) Or check_null(dbfield) Or check_null(dbid) Or check_null(idary)) Then
    Dim tmpstr: tmpstr = format_checkbox(idary)
    If Not cidary(tmpstr) Then Exit Sub
    Dim trs, tsqlstr
    tsqlstr = "select * from " & dbtable & " where " & dbid & " in (" & tmpstr & ")"
    If not otsql = "0" Then tsqlstr = tsqlstr & otsql
    Set trs = server.CreateObject("adodb.recordset")
    trs.open tsqlstr, conn, 1, 3
    Do While Not trs.EOF
      If trs(dbfield) = 0 Then
        trs(dbfield) = 1
      Else
        trs(dbfield) = 0
      End If
      trs.Update
      trs.movenext
    Loop
    Set trs = Nothing
  End If
End Sub

Sub dbase_update(ByVal dbtable, ByVal dbfield, ByVal dbfieldvalue, ByVal dbid, ByVal idary, ByVal otsql)
  If Not (check_null(dbtable) Or check_null(dbfield) Or check_null(dbid) Or check_null(idary)) Then
    Dim tmpstr: tmpstr = format_checkbox(idary)
    If Not cidary(tmpstr) Then Exit Sub
    Dim trs, tsqlstr
    tsqlstr = "select * from " & dbtable & " where " & dbid & " in (" & tmpstr & ")"
    If not otsql = "0" Then tsqlstr = tsqlstr & otsql
    Set trs = server.CreateObject("adodb.recordset")
    trs.open tsqlstr, conn, 1, 3
    Do While Not trs.EOF
      trs(dbfield) = dbfieldvalue
      trs.Update
      trs.movenext
    Loop
    Set trs = Nothing
  End If
End Sub

Sub exec_delete(ByVal dbtable, ByVal otsql)
  If Not (check_null(dbtable) Or check_null(otsql)) Then
    Dim tsqlstr
    Select Case dbtype
      Case 0
        tsqlstr = "delete from " & dbtable & otsql
      Case 1
        tsqlstr = "delete " & dbtable & otsql
      Case Else
        tsqlstr = "delete " & dbtable & otsql
    End Select
    If run_sqlstr(tsqlstr) Then Exit Sub
  End If
End Sub

Sub fso_create_new_folder(ByVal strfname)
  Dim tstrfname, tstrary
  tstrfname = strfname
  If instr(tstrfname, "/") = 0 Then Exit Sub
  tstrary = split(tstrfname, "/")
  Dim ti, tubound, tfso, tfolder, tfolderstr
  tubound = ubound(tstrary)
  Set tfso = Server.CreateObject(fso_object)
  For ti = 0 to tubound - 1
    tfolderstr = tfolderstr & tstrary(ti) & "/"
    tfolder = server.mappath(tfolderstr)
    If not (tfso.FolderExists(tfolder)) then
      tfso.CreateFolder(tfolder)
    End If
  Next
  Set tfso = Nothing
End Sub
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
%>
