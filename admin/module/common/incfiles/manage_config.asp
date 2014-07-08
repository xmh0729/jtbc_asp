<%
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
Function get_uninstall_module_select(ByVal strers)
  Dim ti, tnuninstall, tmpstr
  Dim tmodules: tmodules = get_str(get_valid_module(strers))
  Dim tmodulesary: tmodulesary = split(tmodules, "|")
  Dim option_unselected: option_unselected = itake("global.tpl_config.option_unselect", "tpl")
  For ti = 0 to UBound(tmodulesary)
    tnuninstall = get_str(get_value(cvgenre(tmodulesary(ti)) & ".nuninstall"))
    If Not check_null(tnuninstall) Then
      tmpstr = tmpstr & replace_template(option_unselected, "{$explain}" & spa & "{$value}", "(" & get_genre_description(tmodulesary(ti)) & ")" & tmodulesary(ti)  & spa & tmodulesary(ti))
    End If
  Next
  get_uninstall_module_select = tmpstr
End Function

Function get_uninstall_module(ByVal strers)
  Dim tmodule: tmodule = get_str(strers)
  Dim tmodules, ti, tmodulesary, tnuninstall
  Dim tmpstr, tstr
  tmodules = get_str(get_valid_module(get_actual_route("./")))
  tmodulesary = split(tmodules, "|")
  For ti = 0 to UBound(tmodulesary)
    tstr = tmodulesary(ti)
    If Len(tstr) >= Len(tmodule) Then
      If tstr = tmodule Or InStr(tstr, tmodule & "/") = 1 Then
        tnuninstall = get_str(get_value(cvgenre(tmodulesary(ti)) & ".nuninstall"))
        If Not check_null(tnuninstall) Then tmpstr = tmpstr & tstr & spa & tnuninstall & spb
      End If
    End If
  Next
  If Len(tmpstr) > Len(spb) Then tmpstr = Left(tmpstr, Len(tmpstr) - Len(spb))
  If not check_null(tmpstr) Then get_uninstall_module = set_newary2(tmpstr)
End Function

Function manage_navigation()
  Dim tmpstr
  tmpstr = ireplace("manage.navigation", "tpl")
  manage_navigation = tmpstr
End Function

Sub set_allow_zero_length(ByVal dbtable)
  Dim tadox, ttable
  Set tadox = Server.CreateObject("ADOX.Catalog")
  Set tadox.ActiveConnection = conn
  Set ttable = tadox.Tables(dbtable).Columns
  Dim titem
  For Each titem in ttable
    If titem.type = 202 or titem.type = 203 Then
      titem.Properties("Jet OLEDB:Allow Zero Length") = true
    End If
  Next
End Sub

Sub uninstall_module(ByVal strgenre, ByVal strset)
  On Error Resume Next
  Dim tstrgenre, tstrset, tstrsetary
  tstrgenre = get_str(strgenre)
  tstrset = strset
  tstrsetary = split(tstrset, "|")
  If UBound(tstrsetary) >= 2 Then
    Dim tsqlstr
    If CStr(tstrsetary(0)) = "1" Then
      Dim tdropstate1, tdropstate2
      tdropstate1 = 1: tdropstate2 = 1
      Dim titem, tdatabasestr
      tdatabasestr = cvgenre(tstrgenre) & ".ndatabase"
      For each titem in codic.tmpdic
        If Len(titem) >= Len(tdatabasestr) Then
          If Left(titem, Len(tdatabasestr)) = tdatabasestr Then
            tdropstate2 = 0
            tsqlstr = "DROP TABLE [" & get_value(titem) & "]"
            If run_sqlstr(tsqlstr) Then tdropstate1 = 0
          End If
        End If
      Next
    End If
    If tdropstate2 = 0 And tdropstate1 = 1 Then Call jtbc_cms_admin_msg(itake("manage.uninstall_error_0", "lng"), "?type=uninst", 1)
    If CStr(tstrsetary(1)) = "1" Then
      Call exec_delete(sort_database, " where " & cfnames(sort_fpre, "genre") & "='" & tstrgenre & "'")
    End If
    If CStr(tstrsetary(2)) = "1" Then
      Dim tdatabase, tfpre
      tdatabase = get_str(get_value("common.upload.ndatabase"))
      tfpre = get_str(get_value("common.upload.nfpre"))
      Call exec_delete(tdatabase, " where " & cfnames(tfpre, "genre") & "='" & tstrgenre & "'")
    End If
    Dim tfso, tmpfpath
    tmpfpath = server.MapPath(get_actual_route(tstrgenre))
    Set tfso = server.CreateObject(fso_object)
    If tfso.FolderExists(tmpfpath) Then tfso.DeleteFolder (tmpfpath)
    Set tfso = Nothing
    If Err Then Call jtbc_cms_admin_msg(itake("manage.uninstall_error_1", "lng"), "?type=uninst", 1)
  End If
End Sub

Sub jtbc_cms_admin_manage_install()
  Dim tmpstr
  tmpstr = ireplace("manage.install", "tpl")
  response.write tmpstr
End Sub

Sub jtbc_cms_admin_manage_uninst()
  Dim tmpstr
  tmpstr = ireplace("manage.uninst", "tpl")
  response.write tmpstr
End Sub

Sub jtbc_cms_admin_manage_uninstall()
  Dim ti, tmodule, tmoduleary
  tmodule = get_str(request.querystring("module"))
  tmoduleary = get_uninstall_module(tmodule)
  Dim tmpstr, tmpastr, tmprstr, tmptstr
  tmpstr = itake("manage.uninstall", "tpl")
  tmpastr = ctemplate(tmpstr, "{$recurrence_ida}")
  If IsArray(tmoduleary) Then
    For ti = 0 to UBound(tmoduleary)
      tmptstr = replace(tmpastr, "{$title}", "(" & get_genre_description(tmoduleary(ti, 0)) & ")" & tmoduleary(ti, 0))
      tmprstr = tmprstr & tmptstr
    Next
  End If
  tmpstr = Replace(tmpstr, jtbc_cinfo, tmprstr)
  tmpstr = Replace(tmpstr, "{$module}", tmodule)
  tmpstr = creplace(tmpstr)
  response.write tmpstr
End Sub

Sub jtbc_cms_admin_manage_uninstalldisp()
  Dim ti, tmodule, tmoduleary
  tmodule = get_str(request.form("module"))
  tmoduleary = get_uninstall_module(tmodule)
  If IsArray(tmoduleary) Then
    For ti = UBound(tmoduleary) to 0 step -1
      Call uninstall_module(tmoduleary(ti, 0), tmoduleary(ti, 1))
    Next
  End If
  Call jtbc_cms_admin_msg(itake("manage.uninstall_succeed", "lng"), "?type=uninst", 1)
End Sub

Sub jtbc_cms_admin_manage_installdisp()
  On Error Resume Next
  Dim terrnum
  Dim tpath: tpath = get_actual_route("./")
  If not check_null(tpath) Then
    Dim tupobj, tupfile, tupfilesize, tupfilename
    Set tupobj = New upload_class
    Set tupfile = tupobj.file("file1")
    tupfilesize = get_num(tupfile.filesize, 0)
    If tupfilesize > 0 Then
      tupfilename = tupfile.FileName
      tupfilename = tpath & tupfilename
      tupfile.saveas server.mappath(tupfilename)
      Dim ti, tobjXMLDoc, tobjrootsite
      Set tobjXMLDoc = server.CreateObject("microsoft.xmldom")
      tobjXMLDoc.load(server.MapPath(tupfilename))
      Dim texgenre, texfilename
      Set tobjrootsite = tobjXMLDoc.documentelement.selectsinglenode("configure/genre")
      texgenre = tobjrootsite.Text
      Dim tfso, tmpfpath
      tmpfpath = server.MapPath(get_actual_route(texgenre))
      Set tfso = server.CreateObject(fso_object)
      If tfso.FolderExists(tmpfpath) Then
        terrnum = 1
      Else
        Set tobjrootsite = tobjXMLDoc.documentelement.selectsinglenode("item_list")
        For ti = 0 To tobjrootsite.childnodes.length - 1
          texfilename = get_actual_route(tobjrootsite.childnodes.Item(ti).childnodes.Item(0).Text)
          Call fso_create_new_folder(texfilename)
          Call save_file(texfilename, tobjrootsite.childnodes.Item(ti).childnodes.Item(1).nodeTypedvalue)
        Next
        Dim tsqltext
        If dbtype = 0 Then
          tsqltext = get_file_text(get_actual_route(texgenre) & "/_install/access.sql")
        Else
          tsqltext = get_file_text(get_actual_route(texgenre) & "/_install/mssql.sql")
        End If
        If not check_null(tsqltext) Then
          Dim tsqli, tsqltextary: tsqltextary = split(tsqltext, ";")
          For tsqli = 0 to UBound(tsqltextary)
            If Not run_sqlstr(tsqltextary(tsqli)) Then terrnum = 2
          Next
          If Not terrnum = 2 Then
            If dbtype = 0 Then
              Dim tdbtable, tdbtableary
              tdbtableary = get_regexpary(tsqltext, "CREATE TABLE \[(.*)\]")
              If IsArray(tdbtableary) Then
                For ti = 0 to UBound(tdbtableary)
                  tdbtable = get_lrstr(get_lrstr(tdbtableary(ti), "[", "right"), "]", "left")
                  If not check_null(tdbtable) Then Call set_allow_zero_length(tdbtable)
                Next
              End If
            End If
          End If
        End If
        tfso.DeleteFolder(server.MapPath(get_actual_route(texgenre) & "/_install"))
        terrnum = -1
      End If
      tfso.DeleteFile(server.MapPath(tupfilename))
      Set tobjrootsite = Nothing
      Set tobjXMLDoc = Nothing
      Set tfso = Nothing
    Else
      terrnum = 0
    End If
    Set tupfile = Nothing
    Set tupobj = Nothing
  Else
    terrnum = 0
  End If
  If Err Then Call jtbc_cms_admin_msg(itake("manage.install_sudd", "lng"), "?type=install", 1)
  Select Case terrnum
    Case 0
      Call jtbc_cms_admin_msg(itake("manage.install_error_0", "lng"), "?type=install", 1)
    Case 1
      Call jtbc_cms_admin_msg(itake("manage.install_error_1", "lng"), "?type=install", 1)
    Case 2
      Call jtbc_cms_admin_msg(itake("manage.install_error_2", "lng"), "?type=install", 1)
    Case -1
      Call jtbc_cms_admin_msg(itake("manage.install_succeed", "lng"), "?type=install", 1)
  End Select
End Sub

Sub jtbc_cms_admin_manage_action()
  If not check_null(request.querystring("action")) Then Call remove_application("")
  Select Case request.querystring("action")
    Case "install"
      Call jtbc_cms_admin_manage_installdisp
    Case "uninstall"
      Call jtbc_cms_admin_manage_uninstalldisp
  End Select
End Sub

Sub jtbc_cms_admin_manage()
  Select Case request.querystring("type")
    Case "install"
      Call jtbc_cms_admin_manage_install
    Case "uninst"
      Call jtbc_cms_admin_manage_uninst
    Case "uninstall"
      Call jtbc_cms_admin_manage_uninstall
    Case Else
      Call jtbc_cms_admin_manage_install
  End Select
End Sub
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
%>
