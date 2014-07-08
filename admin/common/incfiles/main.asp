<%
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
admc_pstate = "public"

Function adm_replace_pfs(ByVal strary, ByVal strpath, ByVal strfolder)
  Dim tstrary, tstrpath, tstrfolder
  tstrary = strary
  tstrpath = strpath
  tstrfolder = get_lrstr(tstrpath, "/./", "rightr")
  If IsArray(tstrary) Then
    Dim ti, tmpstr
    For ti = 0 to UBound(tstrary)
      tmpstr = creplace(get_str(tstrary(ti, 0)))
      tmpstr = replace(tmpstr, "{$path}", tstrpath)
      tmpstr = replace(tmpstr, "{$folder}", tstrfolder)
      tstrary(ti, 0) = tmpstr
    Next
  End If
  adm_replace_pfs = tstrary
End Function

Function adm_isobj(ByVal objinfo)
  On Error Resume Next
  adm_isobj = False
  Dim testobj
  Set testobj = server.CreateObject(objinfo)
  If -2147221005 <> Err Then
    adm_isobj = True
  End If
  Set testobj = Nothing
End Function

Function adm_show_isobj(ByVal strboo)
  Select Case strboo
    Case True: adm_show_isobj = "√"
    Case False: adm_show_isobj = "×"
  End Select
End Function

Function adm_show_ckisobj()
  On Error Resume Next
  If request.Form("ckname") <> "" Then
    Dim tstr, tval
    tstr = get_safecode(request.Form("ckname"))
    tval = False
    Dim testobj, testobjver
    testobjver = ""
    Set testobj = server.CreateObject(tstr)
    If -2147221005 <> Err Then
      tval = True
      testobjver = testobj.version
      If testobjver = "" Or IsNull(testobjver) Then testobjver = testobj.about
    End If
    Set testobj = Nothing
    adm_show_ckisobj = "(" & adm_show_isobj(tval) & ")" & server.htmlencode(tstr) & " " & server.htmlencode(testobjver)
  Else
    adm_show_ckisobj = ""
  End If
End Function

Function adm_get_os()
  adm_get_os = "Unknown"
End Function

Function get_admin_menu_order(ByVal strers)
  Dim tstrers: tstrers = get_lrstr(strers, "/", "leftr")
  tstrers = get_lrstr(tstrers, "/./", "rightr")
  Select Case tstrers
    Case adminfolder
      get_admin_menu_order = get_str(get_value(adminfolder & ".norder"))
    Case Else
      get_admin_menu_order = adminfolder & "," & get_str(get_value(adminfolder & ".morder"))
  End Select
End Function

Function get_admin_menu_array(ByVal strpath, ByVal strtype)
  Dim tstrs: tstrs = "z": tstrs = tstrs & "cstr"
  If Not eval(tstrs) = "j" & "tbc" Then Exit Function
  Dim tstrtype: tstrtype = get_num(strtype, 0)
  Dim tfso, tfolder, tpath, tarys
  tpath = get_str(strpath)
  Set tfso = server.CreateObject(fso_object)
  Set tfolder = tfso.GetFolder(server.MapPath(repath(tpath)))
  If Not Err Then
    Dim tfolders, tfoldersname, tfilename, torderstr
    torderstr = get_admin_menu_order(tpath)
    For Each tfolders In tfolder.subfolders
      tfoldersname = tfolders.Name
      If Not (tstrtype = 1 And tfoldersname="common") Then
        If Not cinstr(torderstr, tfoldersname, ",") Then
          torderstr = torderstr & "," & tfoldersname
        End If
      End If
    Next
    Dim tfoldersary, tfi, tfoldersnames
    tfoldersary = Split(torderstr, ",")
    For tfi = 0 To UBound(tfoldersary)
      tfoldersnames = tfoldersary(tfi)
      If Not check_null(tfoldersnames) Then
        tfilename = tpath & tfoldersnames & "/common/guide" & xmltype
        If isfileexists(repath(tfilename)) Then
          tarys = unite_array2(tarys, adm_replace_pfs(get_xinfo(repath(tfilename), "item_list", nlng, 0), tpath & tfoldersnames, tfoldersnames))
          If get_xrootatt(repath(tfilename), "mode") = "jtbcf" Then tarys = unite_array2(tarys, get_admin_menu_array(tpath & tfoldersnames & "/", 1))
        End If
      End If
    Next
  End If
  Set tfolder = Nothing
  Set tfso = Nothing
  get_admin_menu_array = tarys
End Function

Sub jtbc_cms_login()
  If Not request.querystring("action") = "" Then
    Select Case request.querystring("action")
      Case "login"
        Call jtbc_cms_ckulogin
      Case "logout"
        Call jtbc_cms_ulogout
    End Select
    Exit Sub
  End If
  If jtbc_cms_cklogin(admc_name, admc_pword) Then
    response.redirect "admin_main.asp"
  Else
    response.write ireplace("login.login_form", "tpl")
  End If
End Sub

Sub jtbc_cms_ckulogin()
  If Not request.Form("validate") = session("rndcodes") Then
    Call client_alert(itake("admin_config.admin_urndcodes_failed", "lng"), -1)
  Else
    Dim tuname, tpassword, tislogin
    tuname = get_safecode(request.Form("uname"))
    tpassword = md5(request.Form("password"), "2")
    tislogin = 0
    If jtbc_cms_cklogin(tuname, tpassword) Then tislogin = 1
    Dim tdatabase, tidfield, tfpre
    tdatabase = get_str(get_value("common.adminlog.ndatabase"))
    tidfield = get_str(get_value("common.adminlog.nidfield"))
    tfpre = get_str(get_value("common.adminlog.nfpre"))
    sqlstr = "insert into " & tdatabase & " (" & cfnames(tfpre, "name") & "," & cfnames(tfpre, "time") & "," & cfnames(tfpre, "ip") & "," & cfnames(tfpre, "islogin") & ") values ('" & tuname& "','" & now() & "','" & nuserip & "','" & tislogin & "')"
    If run_sqlstr(sqlstr) Then
      If tislogin = 1 Then
        response.redirect "admin_main.asp"
      Else
        Call client_alert(itake("admin_config.admin_ulogin_failed", "lng"), -1)
      End If
    Else
      Call client_alert(itake("global.lng_public.sudd", "lng"), -1)
    End If
  End If
End Sub

Sub jtbc_cms_ulogout()
  response.cookies(appname & "admin")("username") = ""
  response.cookies(appname & "admin")("password") = ""
  session(appname & "admin_popedom") = ""
  session(appname & "admin_username") = ""
  response.redirect "index.asp"
End Sub

Sub jtbc_cms_admin()
  response.write ireplace("main.admin_frame", "tpl")
End Sub

Sub jtbc_cms_frame()
  response.write ireplace("main.admin_frame", "tpl")
End Sub

Sub jtbc_cms_left()
  Dim tapp: tapp = get_application(adms_appstr)
  If Not IsArray(tapp) Then
    tapp = get_admin_menu_array(get_actual_route("./"), 0)
    Call set_application(adms_appstr, tapp)
  End If
  If IsArray(tapp) Then
    Dim tplstr, ttplstr
    tplstr = ireplace("main.admin_left", "tpl")
    Dim tcrca, tcrcastr
    tcrca = Split(tplstr, "{$recurrence_ida}")
    If UBound(tcrca) = 2 Then
      tcrcastr = tcrca(1)
      Dim tcrcb, tcrcbstr
      tcrcb = Split(tcrcastr, "{$recurrence_idb}")
      If UBound(tcrcb) = 2 Then
        tcrcbstr = tcrcb(1)
      End If
      ttplstr = tcrca(0)
      Dim ti, tstr, tii, tu, tstrs
      tii = 0
      tu = UBound(tapp)
      Dim tstring, tstate
      For ti = 0 To tu
        tstring = tapp(ti, 0)
        If InStr(tstring, "description") > 0 Then
          If admc_popedom = "-1" Or tstring = "description" Or cinstr(admc_popedom, get_lrstr(tstring, ":", "left"), ",") Then
            tstate = 1
          Else
            tstate = 0
          End If
        End If
        If tstate = 1 Then
          If get_lrstr(tstring, ":", "right") = "description" Then
            ttplstr = Replace(ttplstr, jtbc_cinfo, "")
            tstr = tcrcb(0) & jtbc_cinfo & tcrcb(2)
            tstr = Replace(tstr, "{$description}", tapp(ti, 1))
            tstr = Replace(tstr, "{$id}", tii)
            ttplstr = ttplstr & tstr
            tii = tii + 1
          Else
            If InStr(tstring, ":") > 0 Then
              If admc_popedom = "-1" or cinstr(admc_popedom, get_lrstr(tstring, ":", "left"), ",") Then
                tstring = get_lrstr(tstring, ":", "right")
              End If
            End if
            If InStr(tstring, ":") = 0 Then
              tstr = Replace(tcrcbstr, "{$topic}", tapp(ti, 1))
              tstr = Replace(tstr, "{$ahref}", tstring)
              ttplstr = Replace(ttplstr, jtbc_cinfo, tstr & jtbc_cinfo)
              tstrs = tstrs & tstr
            End If
          End If
        End If
      Next
      ttplstr = ttplstr & tcrca(2)
      ttplstr = Replace(ttplstr, jtbc_cinfo, "")
      response.write ttplstr
    End If
  End If
End Sub

Sub jtbc_cms_manage()
  response.write ireplace("main.admin_manage", "tpl")
End Sub
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
%>
