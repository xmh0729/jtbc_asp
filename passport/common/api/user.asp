<%
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
Function check_isuser(ByVal struname)
  Dim tdatabase, tidfield, tfpre
  tdatabase = cndatabase(userfolder, "0")
  tidfield = cnidfield(userfolder, "0")
  tfpre = cnfpre(userfolder, "0")
  Dim tstruname: tstruname = get_safecode(struname)
  Dim trs, tsqlstr
  tsqlstr = "select * from " & tdatabase & " where " & cfnames(tfpre, "username") & "='" & tstruname & "'"
  Set trs = server.CreateObject("adodb.recordset")
  trs.open tsqlstr, conn, 1, 3
  If not trs.EOF Then
    If trs(cfnames(tfpre, "lock")) = 1 Then
      check_isuser = 2
    Else
      check_isuser = 1
    End If
  Else
    check_isuser = 0
  End If
  Set trs = nothing
End Function

Function check_userlogin()
  If Not check_null(session(appname & "uname")) Then
    check_userlogin = True
  Else
    Dim tusername, tpassword
    tusername = get_safecode(request.cookies(appname & "user")("uname"))
    tpassword = get_safecode(request.cookies(appname & "user")("pword"))
    If Not check_null(tusername) Then
      If check_uname(tusername, tpassword) Then
        session(appname & "uname") = tusername
        check_userlogin = True
      Else
        check_userlogin = False
      End If
    Else
      check_userlogin = False
    End If
  End If
End Function

Function check_uname(ByVal tuname, ByVal tpword)
  Dim tdatabase, tidfield, tfpre
  tdatabase = cndatabase(userfolder, "0")
  tidfield = cnidfield(userfolder, "0")
  tfpre = cnfpre(userfolder, "0")
  Dim trs, tsqlstr
  tsqlstr = "select * from " & tdatabase & " where " & cfnames(tfpre, "username") & "='" & tuname & "' and " & cfnames(tfpre, "password") & "='" & tpword & "' and " & cfnames(tfpre, "lock") & "=0"
  Set trs = server.CreateObject("adodb.recordset")
  trs.open tsqlstr, conn, 1, 3
  If not trs.EOF Then
    check_uname = True
    trs(cfnames(tfpre, "pretime")) = trs(cfnames(tfpre, "lasttime"))
    trs(cfnames(tfpre, "lasttime")) = Now()
    trs.update
  Else
    check_uname = False
  End If
  Set trs = nothing
End Function

Function count_user_message(ByVal strusername)
  Dim tdatabase, tidfield, tfpre
  tdatabase = cndatabase(userfolder & ".message", "0")
  tidfield = cnidfield(userfolder & ".message", "0")
  tfpre = cnfpre(userfolder & ".message", "0")
  Dim trs, tsqlstr
  tsqlstr = "select count(" & tidfield & ") from " & tdatabase & " where " & cfnames(tfpre, "recipients") & "='" & get_safecode(strusername) & "' and " & cfnames(tfpre, "read") & "=0"
  Set trs = conn.Execute(tsqlstr)
  count_user_message = trs(0)
  Set trs = Nothing
End Function

Function get_userinfo(ByVal strers, ByVal struname)
  Dim tstrers, tstruname
  tstrers = get_safecode(strers)
  tstruname = get_safecode(struname)
  If check_null(tstrers) Or check_null(tstruname) Then Exit Function
  Dim tdatabase, tidfield, tfpre
  tdatabase = cndatabase(userfolder, "0")
  tidfield = cnidfield(userfolder, "0")
  tfpre = cnfpre(userfolder, "0")
  Dim trs, tsqlstr
  tsqlstr = "select " & cfnames(tfpre, strers) & " from " & tdatabase & " where " & cfnames(tfpre, "username") & "='" & tstruname & "'"
  Set trs = conn.Execute(tsqlstr)
  If not trs.EOF Then get_userinfo = trs(0)
  Set trs = nothing
End Function

Function get_userface(ByVal strface, ByVal strface_u, ByVal strface_url)
  Dim tstrface, tstrface_u, tstrface_url
  tstrface = get_num(strface, 0)
  tstrface_u = get_num(strface_u, 0)
  tstrface_url = get_str(strface_url)
  If tstrface_u = 1 Then
    tstrface_url = LCase(htmlencode(tstrface_url))
    If Left(tstrface_url, 4) = "http" Then
      get_userface = htmlencode(tstrface_url)
    Else
      get_userface = ""
    End If
  Else
    get_userface = global_images_route & "face/" & tstrface & ".gif"
  End If
End Function

Function sel_usergroup(ByVal strname, ByVal strtype, ByVal strvalue)
  sel_usergroup = show_xmlinfo_select("global." & userfolder & ":sel_group.all", strvalue, strname & ":" & strtype)
End Function

Function user_login(ByVal strtpl)
  Dim tmpstr, tmpastr, tmprstr, tmptstr
  If not strtpl = "default" Then tmpstr = itake(strtpl , "tpl")
  If check_null(tmpstr) Then tmpstr = itake("global." & userfolder & ":api.login" , "tpl")
  tmpastr = ctemplate(tmpstr, "{$recurrence_ida}")
  Dim tmpary: tmpary = split(tmpastr, "{$$}")
  If Not ubound(tmpary) = 1 Then Exit Function
  If Not check_userlogin Then
    tmprstr = tmpary(0)
  Else
    tmprstr = tmpary(1)
    Dim tmessage: tmessage = itake("global." & userfolder & ":api.message", "lng")
    Dim font_red: font_red = itake("global.tpl_config.font_red", "tpl")
    font_red = Replace(font_red, "{$explain}", count_user_message(nusername))
    tmessage = replace(tmessage, "[]", "[" & font_red & "]")
    tmessage = replace(tmessage, "[]", "[" & count_user_message(nusername) & "]")
    tmprstr = replace(tmprstr, "{$message}", tmessage)
  End If
  tmpstr = Replace(tmpstr, jtbc_cinfo, tmprstr)
  tmpstr = creplace(tmpstr)
  tmpstr = cvalhtml(tmpstr, nvalidate, "{$recurrence_valcode}")
  user_login = tmpstr
End Function

Function user_data_member_side()
  Dim tmpstr, tmpastr, tmptstr
  tmpstr = itake("global." & userfolder & ":module.data_member_side", "tpl")
  tmpastr = ctemplate(tmpstr, "{$recurrence_ida}")
  Dim tmpary, tmprstr
  tmpary = get_xinfo_ary("global." & userfolder & ":member_menu.all", "lng")
  If IsArray(tmpary) Then
    Dim tmpi, tstr0, tstr1
    For tmpi = 0 To UBound(tmpary)
      tstr0 = tmpary(tmpi, 0)
      tstr1 = tmpary(tmpi, 1)
      tmptstr = Replace(tmpastr, "{$href}", tstr0)
      tmptstr = Replace(tmptstr, "{$explain}", tstr1)
      tmprstr = tmprstr & tmptstr
    Next
  End If
  tmpstr = Replace(tmpstr, jtbc_cinfo, tmprstr)
  tmpstr = creplace(tmpstr)
  user_data_member_side = tmpstr
End Function

Function update_userpropertys(ByVal strers, ByVal strvalue, ByVal struname)
  Dim tstrers, tstrvalue, tstruname
  tstrers = get_safecode(strers)
  tstrvalue = get_num(strvalue, 0)
  tstruname = get_safecode(struname)
  Dim tdatabase, tidfield, tfpre
  tdatabase = cndatabase(userfolder, "0")
  tidfield = cnidfield(userfolder, "0")
  tfpre = cnfpre(userfolder, "0")
  Dim trs, tsqlstr
  tsqlstr = "select * from " & tdatabase & " where " & cfnames(tfpre, "username") & "='" & tstruname & "'"
  Set trs = server.CreateObject("adodb.recordset")
  trs.open tsqlstr, conn, 1, 3
  If not trs.EOF Then
    Dim tnum
    tnum = get_num(trs(cfnames(tfpre, tstrers)), 0) + tstrvalue
    If tnum > 0 Then
      trs(cfnames(tfpre, tstrers)) = tnum
      trs.update
    End If
    update_userpropertys = tnum
  End If
  Set trs = Nothing
End Function

Sub isuserlogin(ByVal strurls)
  Dim turls
  If strurls = "0" Then
    turls = get_actual_route(userfolder) & "/?type=login&backurl=" & urlencode(nurl)
  Else
    turls = get_actual_route(userfolder) & "/?type=login&backurl=" & urlencode(strurls)
  End If
  If not check_userlogin Then
    Call imessage(itake("global." & userfolder & ":api.nologin", "lng"), turls)
  End If
End Sub

Sub update_userproperty(ByVal strers, ByVal strvalue, ByVal strtype, ByVal struname)
  Dim tstrers, tstrvalue, tstrtype, tstruname
  tstrers = get_safecode(strers)
  tstruname = get_safecode(struname)
  Dim tdatabase, tidfield, tfpre
  tdatabase = cndatabase(userfolder, "0")
  tidfield = cnidfield(userfolder, "0")
  tfpre = cnfpre(userfolder, "0")
  Dim tsqlstr
  Select Case strtype
    Case 0
      tstrvalue = get_num(strvalue, 0)
      tsqlstr = "update " & tdatabase & " set " & cfnames(tfpre, tstrers) & "=" & cfnames(tfpre, tstrers) & "+" & tstrvalue & " where " & cfnames(tfpre, "username") & "='" & tstruname & "'"
    Case 1
      tstrvalue = get_num(strvalue, 0)
      tsqlstr = "update " & tdatabase & " set " & cfnames(tfpre, tstrers) & "=" & tstrvalue & " where " & cfnames(tfpre, "username") & "='" & tstruname & "'"
    Case 2
      tstrvalue = get_safecode(strvalue)
      tsqlstr = "update " & tdatabase & " set " & cfnames(tfpre, tstrers) & "='" & tstrvalue & "' where " & cfnames(tfpre, "username") & "='" & tstruname & "'"
  End Select
  If not check_null(tsqlstr) Then conn.Execute(tsqlstr)
End Sub

Sub send_user_message(ByVal strtopic, ByVal strcontent, ByVal struname, ByVal strsuname)
  Dim tdatabase, tidfield, tfpre
  tdatabase = cndatabase(userfolder & ".message", "0")
  tidfield = cnidfield(userfolder & ".message", "0")
  tfpre = cnfpre(userfolder & ".message", "0")
  Dim trs, tsqlstr
  tsqlstr = "select * from " & tdatabase
  Set trs = server.CreateObject("adodb.recordset")
  trs.open tsqlstr, conn, 1, 3
  trs.addnew
  trs(cfnames(tfpre, "topic")) = left_intercept(get_str(strtopic), 50)
  trs(cfnames(tfpre, "content")) = left_intercept(get_str(strcontent), 1000)
  trs(cfnames(tfpre, "len")) = Len(strcontent)
  trs(cfnames(tfpre, "time")) = Now()
  trs(cfnames(tfpre, "addresser")) = left_intercept(get_str(strsuname), 50)
  trs(cfnames(tfpre, "recipients")) = left_intercept(get_str(struname), 50)
  trs.update
  Set trs = Nothing
End Sub

Sub user_init()
  If check_userlogin Then nusername = get_str(session(appname & "uname"))
End Sub
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
%>
