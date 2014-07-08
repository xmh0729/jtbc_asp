<%
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
ncontrol = "select,lock,delete"
Const nsearch = "username,id"

Function pp_get_mymanage_module(ByVal strers)
  On Error Resume Next
  Dim tmpstr
  Dim tfso, tfolder
  Dim tpath: tpath = get_str(strers)
  Set tfso = server.CreateObject(fso_object)
  Set tfolder = tfso.GetFolder(server.MapPath(tpath))
  If Not Err Then
    Dim tfolders, tfoldersname, tfoldersnames, tfilename, tcfilename
    For Each tfolders In tfolder.subfolders
      tfoldersname = tfolders.Name
      tfilename = tpath & tfoldersname & "/common/config" & xmltype
      tcfilename = tpath & tfoldersname & "/common/language/manage" & xmltype
      tfoldersnames = tpath & tfoldersname
      tfoldersnames = replace(tfoldersnames, "../", "")
      tfoldersnames = replace(tfoldersnames, "./", "")
      If isfileexists(repath(tcfilename)) Then
        tmpstr = tmpstr & tfoldersnames & "|"
      End If
      If isfileexists(repath(tfilename)) Then
        If get_xrootatt(repath(tfilename), "mode") = "jtbcfgf" Then tmpstr = tmpstr & pp_get_mymanage_module(tpath & tfoldersnames & "/") & "|"
      End If
    Next
  End If
  Set tfolder = Nothing
  Set tfso = Nothing
  If Right(tmpstr, 1) = "|" Then tmpstr = get_lrstr(tmpstr, "|", "leftr")
  pp_get_mymanage_module = tmpstr
End Function

Function pp_get_manage_module(ByVal strers)
  Dim tappstr: tappstr = "sys_manage_module_" & strers
  Dim tapp: tapp = get_application(tappstr)
  If check_null(tapp) Then
    tapp = pp_get_mymanage_module(strers)
    Call set_application(tappstr, tapp)
  End If
  pp_get_manage_module = tapp
End Function

Function admin_manage_popedom(ByVal ppdstr)
  Dim option_uncheckbox, option_checkbox
  option_uncheckbox = itake("global.tpl_config.option_uncheckbox", "tpl")
  option_checkbox = itake("global.tpl_config.option_checkbox", "tpl")
  Dim font_disabled, html_kong, html_br
  font_disabled = itake("global.tpl_config.font_disabled", "tpl")
  html_kong = itake("global.tpl_config.html_kong", "tpl")
  html_br = itake("global.tpl_config.html_br", "tpl")
  Dim tmanagemdlstr: tmanagemdlstr = pp_get_manage_module(get_actual_route("./"))
  If Not check_null(tmanagemdlstr) Then
    Dim tary: tary = split(tmanagemdlstr, "|")
    If IsArray(tary) Then
      Dim ti, tmpstr, tmodule, tmodulestr, tcount
      For ti = 0 to UBound(tary)
        tmodule = tary(ti)
        If not check_null(tmodule) Then
          tmodulestr = itake("global." & tmodule & ":manage.mgtitle", "lng")
          If check_null(tmodulestr) Then tmodulestr = "?"
          If InStr(tmodule, "/") = 0 Then
            tcount = 0
            If Len(tmpstr) > Len(html_br) Then
              If Not Right(tmpstr, Len(html_br)) = html_br Then tmpstr = tmpstr & html_br
            End If
          Else
            tcount = tcount + 1
            tmodulestr = Replace(font_disabled, "{$explain}", tmodulestr)
          End If
          If cinstr(ppdstr, tmodule, ",") Then
            tmpstr = tmpstr & replace_template(option_checkbox, "{$explain}" & spa & "{$value}", "popedom" & spa & tary(ti)) & tmodulestr & html_kong
          Else
            tmpstr = tmpstr & replace_template(option_uncheckbox, "{$explain}" & spa & "{$value}", "popedom" & spa & tary(ti)) & tmodulestr & html_kong
          End If
          If tcount Mod 5 = 0 Then tmpstr = tmpstr & html_br
        End If
      Next
      admin_manage_popedom = tmpstr
    Else
      admin_manage_popedom = "Error!"
    End If
  Else
    admin_manage_popedom = "Error!"
  End If
End Function

Function admin_get_popedom(ByVal psuper, ByVal ppopedom)
  If get_num(psuper, 0) = 1 Then
    admin_get_popedom = "-1"
  Else
    admin_get_popedom = format_checkbox(ppopedom)
  End If
End Function

Function manage_navigation()
  Dim tmpstr
  tmpstr = ireplace("manage.navigation", "tpl")
  manage_navigation = tmpstr
End Function

Sub jtbc_cms_admin_manage_list()
  Dim search_field, search_keyword
  search_field = get_safecode(request.querystring("field"))
  search_keyword = get_safecode(request.querystring("keyword"))
  Dim tmpstr, tmpastr
  tmpstr = ireplace("manage.list", "tpl")
  tmpastr = ctemplate(tmpstr, "{$recurrence_ida}")
  Dim tmprstr, tmptstr
  sqlstr = "select * from " & ndatabase & " where " & nidfield & ">0"
  If search_field = "username" Then sqlstr = sqlstr & " and " & cfname("name") & " like '%" & search_keyword & "%'"
  If search_field = "id" Then sqlstr = sqlstr & " and " & nidfield & "=" & get_num(search_keyword, 0)
  sqlstr = sqlstr & " order by " & nidfield & " desc"
  Dim jcutpage, jcuti
  Set jcutpage = New jtbc_cutpage
  jcutpage.perpage = npagesize
  jcutpage.sqlstr = sqlstr
  jcutpage.cutpage
  Set rs = jcutpage.pagers
  Dim font_disabled, postfix_good
  postfix_good = ireplace("global.tpl_config.postfix_good", "tpl")
  font_disabled = itake("global.tpl_config.font_disabled", "tpl")
  Dim tmpusername
  For jcuti = 1 To npagesize
    If Not rs.EOF Then
      tmpusername = htmlencode(get_str(rs(cfname("name"))))
      If rs(cfname("lock")) = 1 Then tmpusername = Replace(font_disabled, "{$explain}", tmpusername)
      If rs(cfname("popedom")) = "-1" Then tmpusername = tmpusername & postfix_good
      tmptstr = Replace(tmpastr, "{$username}", tmpusername)
      tmptstr = Replace(tmptstr, "{$usernamestr}", urlencode(get_str(rs(cfname("name")))))
      tmptstr = Replace(tmptstr, "{$lasttime}", get_date(rs(cfname("lasttime"))))
      tmptstr = Replace(tmptstr, "{$lastip}", htmlencode(get_str(rs(cfname("lastip")))))
      tmptstr = Replace(tmptstr, "{$id}", get_num(rs(nidfield), 0))
      rs.movenext
      tmprstr = tmprstr & tmptstr
    End If
  Next
  tmpstr = Replace(tmpstr, "{$cpagestr}", jcutpage.pagestr)
  Set rs = Nothing
  Set jcutpage = Nothing
  tmpstr = Replace(tmpstr, jtbc_cinfo, tmprstr)
  response.write tmpstr
End Sub

Sub jtbc_cms_admin_manage_add()
  Dim tmpstr
  tmpstr = ireplace("manage.add", "tpl")
  response.write tmpstr
End Sub

Sub jtbc_cms_admin_manage_edit()
  Dim tid, tbackurl
  tid = get_num(request.querystring("id"), 0)
  tbackurl = get_safecode(request.querystring("backurl"))
  Set rs = server.CreateObject("adodb.recordset")
  sqlstr = "select * from " & ndatabase & " where " & nidfield & "=" & tid
  rs.open sqlstr, conn, 1, 1
  If Not rs.EOF Then
    Dim tmpstr, tmppopedom, tmpsuper
    If rs(cfname("popedom")) = "-1" Then
      tmpsuper = 1
      tmppopedom = ""
    Else
      tmpsuper = 0
      tmppopedom = htmlencode(get_str(rs(cfname("popedom"))))
    End If
    tmpstr = itake("manage.edit", "tpl")
    tmpstr = Replace(tmpstr, "{$id}", htmlencode(rs(nidfield)))
    tmpstr = Replace(tmpstr, "{$username}", htmlencode(get_str(rs(cfname("name")))))
    tmpstr = Replace(tmpstr, "{$super}", tmpsuper)
    tmpstr = Replace(tmpstr, "{$popedom}", tmppopedom)
    tmpstr = Replace(tmpstr, "{$lock}", htmlencode(get_str(rs(cfname("lock")))))
    tmpstr = creplace(tmpstr)
    response.write tmpstr
  Else
    Call jtbc_cms_admin_msg(itake("global.lng_public.not_exist", "lng"), tbackurl, 0)
  End If
  rs.Close
  Set rs = Nothing
End Sub

Sub jtbc_cms_admin_manage_adddisp()
  Dim tmpusername, tbackurl
  tmpusername = get_safecode(request.Form("username"))
  tbackurl = get_safecode(request.querystring("backurl"))
  If check_null(tmpusername) Then Call client_alert(Replace(itake("global.lng_public.insert_empty", "lng"), "[]", "[" & itake("global.lng_config.username", "lng") & "]"), -1)
  Set rs = server.CreateObject("adodb.recordset")
  sqlstr = "select * from " & ndatabase & " where " & cfname("name") & "='" & tmpusername & "'"
  rs.open sqlstr, conn, 1, 3
  If rs.EOF Then
    rs.addnew
    rs(cfname("name")) = tmpusername
    rs(cfname("pword")) = md5(request.Form("password"), 2)
    rs(cfname("popedom")) = left_intercept(admin_get_popedom(request.Form("super"), request.Form("popedom")), 250)
    rs(cfname("lock")) = get_num(request.Form("lock"), 0)
    rs(cfname("lasttime")) = Now()
    rs(cfname("lastip")) = nuserip
    rs.Update
    Call jtbc_cms_admin_msg(itake("global.lng_public.add_succeed", "lng"), tbackurl, 1)
  Else
    Call jtbc_cms_admin_msg(itake("global.lng_public.add_failed", "lng"), tbackurl, 1)
  End If
  rs.Close
  Set rs = Nothing
End Sub

Sub jtbc_cms_admin_manage_editdisp()
  Dim tbackurl, tid
  tbackurl = get_safecode(request.querystring("backurl"))
  tid = get_num(request.querystring("id"), 0)
  Set rs = server.CreateObject("adodb.recordset")
  sqlstr = "select * from " & ndatabase & " where " & nidfield & "=" & tid
  rs.open sqlstr, conn, 1, 3
  If Not rs.EOF Then
    If Not check_null(request.Form("password")) Then rs(cfname("pword")) = md5(request.Form("password"), 2)
    rs(cfname("popedom")) = left_intercept(admin_get_popedom(request.Form("super"), request.Form("popedom")), 250)
    rs(cfname("lock")) = get_num(request.Form("lock"), 0)
    rs.Update
    Call jtbc_cms_admin_msg(itake("global.lng_public.edit_succeed", "lng"), tbackurl, 1)
  Else
    Call jtbc_cms_admin_msg(itake("global.lng_public.edit_failed", "lng"), tbackurl, 1)
  End If
  rs.Close
  Set rs = Nothing
End Sub

Sub jtbc_cms_admin_manage_action()
  Select Case request.querystring("action")
    Case "add"
      Call jtbc_cms_admin_manage_adddisp
    Case "edit"
      Call jtbc_cms_admin_manage_editdisp
    Case "delete"
      Call jtbc_cms_admin_deletedisp
    Case "control"
      Call jtbc_cms_admin_controldisp
  End Select
End Sub

Sub jtbc_cms_admin_manage()
  Select Case request.querystring("type")
    Case "add"
      Call jtbc_cms_admin_manage_add
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
