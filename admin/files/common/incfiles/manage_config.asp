<%
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
Dim show_path, nshow_path
nshow_path = get_safecode(request.querystring("show_path"))
If check_null(nshow_path) Then nshow_path = get_actual_route("./")
show_path = server.MapPath(nshow_path)

Function manage_navigation()
  Dim tmpstr
  tmpstr = ireplace("manage.navigation", "tpl")
  manage_navigation = tmpstr
End Function

Sub jtbc_cms_admin_manage_list()
  On Error Resume Next
  Dim showfso, showfolder
  Set showfso = server.CreateObject(fso_object)
  Set showfolder = showfso.GetFolder(show_path)
  If Err Then Call jtbc_cms_admin_msgs(itake("manage.folderfailed", "lng"), 1)
  Dim delete_notice: delete_notice = itake("global.lng_public.delete_notice", "lng")
  Dim tengross: tengross = itake("manage.engross", "lng")
  Dim tshowfolderSize: tshowfolderSize = showfolder.Size
  Dim tmpstr, tmpastr
  tmpstr = ireplace("manage.list", "tpl")
  tmpastr = ctemplate(tmpstr, "{$recurrence_ida}")
  tmpstr = Replace(tmpstr, "{$path}", htmlencode(show_path))
  tmpstr = Replace(tmpstr, "{$foldersize}", csize(tshowfolderSize))
  tmpstr = Replace(tmpstr, "{$lasttime}", showfolder.DateLastModified)
  tmpstr = Replace(tmpstr, "{$foldercount}", showfolder.subfolders.Count)
  tmpstr = Replace(tmpstr, "{$filescount}", showfolder.Files.Count)
  Dim tmprstr, tmptstr
  Dim showfolders, showfoldersSize, showfoldersName
  For Each showfolders In showfolder.subfolders
    showfoldersName = showfolders.Name
    showfoldersSize = showfolders.Size
    tmptstr = Replace(tmpastr, "{$nfoldername}", showfoldersName)
    tmptstr = Replace(tmptstr, "{$nlasttime}", showfolders.DateLastModified)
    tmptstr = Replace(tmptstr, "{$nfoldersize}", csize(showfoldersSize))
    tmptstr = Replace(tmptstr, "{$nfolderpath}", urlencode(repath(nshow_path & "/" & showfoldersName)))
    tmptstr = Replace(tmptstr, "{$nfolderpaths}", repath(nshow_path & "/" & showfoldersName))
    tmptstr = Replace(tmptstr, "{$delete_notice}", Replace(delete_notice, "[]", "[" & showfoldersName & "]"))
    tmptstr = Replace(tmptstr, "{$width}", cper(showfoldersSize, tshowfolderSize))
    tmptstr = Replace(tmptstr, "{$engross}", tengross)
    tmprstr = tmprstr & tmptstr
  Next
  tmpstr = Replace(tmpstr, jtbc_cinfo, tmprstr)
  tmpastr = ctemplate(tmpstr, "{$recurrence_idb}")
  tmprstr = ""
  Dim showfiles, showfilesSize, showfilesName
  For Each showfiles In showfolder.Files
    showfilesName = showfiles.Name
    showfilesSize = showfiles.Size
    tmptstr = Replace(tmpastr, "{$nfilename}", showfilesName)
    tmptstr = Replace(tmptstr, "{$nftype}", fileico(showfilesName))
    tmptstr = Replace(tmptstr, "{$nlasttime}", showfiles.DateLastModified)
    tmptstr = Replace(tmptstr, "{$nfilesize}", csize(showfilesSize))
    tmptstr = Replace(tmptstr, "{$nfilepath}", urlencode(repath(nshow_path & "/" & showfilesName)))
    tmptstr = Replace(tmptstr, "{$nfilepaths}", repath(nshow_path & "/" & showfilesName))
    tmptstr = Replace(tmptstr, "{$delete_notice}", Replace(delete_notice, "[]", "[" & showfilesName & "]"))
    tmptstr = Replace(tmptstr, "{$width}", cper(showfilesSize, tshowfolderSize))
    tmptstr = Replace(tmptstr, "{$engross}", tengross)
    tmprstr = tmprstr & tmptstr
  Next
  tmpstr = Replace(tmpstr, jtbc_cinfo, tmprstr)
  response.write tmpstr
  Set showfolder = nothing
  Set showfso = nothing
End Sub

Sub jtbc_cms_admin_manage_add_folder()
  Dim tmpstr
  tmpstr = ireplace("manage.add_folder", "tpl")
  response.write tmpstr
End Sub

Sub jtbc_cms_admin_manage_edit_folder()
  Dim tmpstr
  tmpstr = ireplace("manage.edit_folder", "tpl")
  response.write tmpstr
End Sub

Sub jtbc_cms_admin_manage_add_file()
  Dim tmpstr
  tmpstr = ireplace("manage.add_file", "tpl")
  response.write tmpstr
End Sub

Sub jtbc_cms_admin_manage_edit_file()
  Dim tmpstr, tmpedittype, tmptypestr
  tmpedittype = ".asp.aspx.css.cfm.htm.html.ini.inc.jtbc.jsp.jspa.js.jtml.php.phtml.shtml.txt.vbs.xml.xsl.xslt"
  tmptypestr = get_safecode(request.querystring("file_path"))
  tmptypestr = get_lrstr(tmptypestr, ".", "right")
  If Not cinstr(tmpedittype, tmptypestr, ".") Then Call client_alert(itake("manage.cannot", "lng"), -1)
  tmpstr = ireplace("manage.edit_file", "tpl")
  response.write tmpstr
End Sub

Sub jtbc_cms_admin_manage_add_folderdisp()
  Dim tmpfpath, tfso, tbackurl
  tmpfpath = get_safecode(request.Form("folder_path"))
  tbackurl = Replace(get_safecode(request.querystring("backurl")), "type=add_folder&", "")
  If check_null(tmpfpath) Then Exit Sub
  tmpfpath = server.MapPath(tmpfpath)
  Set tfso = server.CreateObject(fso_object)
  If Not tfso.FolderExists(tmpfpath) Then tfso.CreateFolder (tmpfpath)
  Set tfso = Nothing
  response.redirect tbackurl
End Sub

Sub jtbc_cms_admin_manage_edit_folderdisp()
  Dim tmpfpatha, tmpfpathb, tfso
  tmpfpatha = get_safecode(request.Form("folder_patha"))
  tmpfpathb = get_safecode(request.Form("folder_pathb"))
  If check_null(tmpfpatha) Or check_null(tmpfpathb) Then Exit Sub
  tmpfpatha = server.MapPath(tmpfpatha)
  tmpfpathb = server.MapPath(tmpfpathb)
  Set tfso = server.CreateObject(fso_object)
  If Not tfso.FolderExists(tmpfpatha) Or tfso.FolderExists(tmpfpathb) Then Exit Sub
  tfso.MoveFolder tmpfpatha, tmpfpathb
  Set tfso = Nothing
  response.redirect "?"
End Sub

Sub jtbc_cms_admin_manage_delete_floderdisp()
  Dim tmpfpath, tfso, tbackurl
  tmpfpath = get_safecode(request.querystring("folder_path"))
  tbackurl = get_safecode(request.querystring("backurl"))
  If check_null(tmpfpath) Then Exit Sub
  tmpfpath = server.MapPath(tmpfpath)
  Set tfso = server.CreateObject(fso_object)
  If tfso.FolderExists(tmpfpath) Then tfso.DeleteFolder (tmpfpath)
  Set tfso = Nothing
  response.redirect tbackurl
End Sub

Sub jtbc_cms_admin_manage_add_filedisp()
  Dim tbackurl
  tbackurl = get_safecode(request.querystring("backurl"))
  If save_file_text(request.Form("file_path"), request.Form("filetext")) Then
    Call jtbc_cms_admin_msg(itake("global.lng_public.succeed", "lng"), tbackurl, 1)
  Else
    Call jtbc_cms_admin_msg(itake("global.lng_public.failed", "lng"), tbackurl, 1)
  End If
End Sub

Sub jtbc_cms_admin_manage_edit_filedisp()
  Dim tbackurl
  tbackurl = get_safecode(request.querystring("backurl"))
  If save_file_text(request.Form("file_path"), request.Form("filetext")) Then
    Call jtbc_cms_admin_msg(itake("global.lng_public.succeed", "lng"), tbackurl, 1)
  Else
    Call jtbc_cms_admin_msg(itake("global.lng_public.failed", "lng"), tbackurl, 1)
  End If
End Sub

Sub jtbc_cms_admin_manage_delete_filedisp()
  Dim tmpfpath, tfso, tbackurl
  tmpfpath = get_safecode(request.querystring("file_path"))
  tbackurl = get_safecode(request.querystring("backurl"))
  If check_null(tmpfpath) Then Exit Sub
  tmpfpath = server.MapPath(tmpfpath)
  Set tfso = server.CreateObject(fso_object)
  If tfso.FileExists(tmpfpath) Then tfso.DeleteFile (tmpfpath)
  Set tfso = Nothing
  response.redirect tbackurl
End Sub

Sub jtbc_cms_admin_manage_uploaddisp()
  Dim tpath: tpath = get_safecode(request.querystring("path"))
  If not check_null(tpath) Then
    If not Right(tpath, 1) = "/" Then tpath = tpath & "/"
    Dim tupobj, tupfile, tupfilesize, tupfilename
    Set tupobj = New upload_class
    Set tupfile = tupobj.file("file1")
    tupfilesize = get_num(tupfile.filesize, 0)
    If tupfilesize > 0 Then
      tupfilename = tupfile.FileName
      tupfilename = tpath & tupfilename
      tupfile.saveas server.mappath(tupfilename)
    End If
    Set tupfile = Nothing
    Set tupobj = Nothing
  End If
  response.redirect "?show_path=" & urlencode(tpath)
End Sub

Sub jtbc_cms_admin_manage_action()
  Select Case request.querystring("action")
    Case "add_folder"
      Call jtbc_cms_admin_manage_add_folderdisp
    Case "edit_folder"
      Call jtbc_cms_admin_manage_edit_folderdisp
    Case "delete_folder"
      Call jtbc_cms_admin_manage_delete_floderdisp
    Case "add_file"
      Call jtbc_cms_admin_manage_add_filedisp
    Case "edit_file"
      Call jtbc_cms_admin_manage_edit_filedisp
    Case "delete_file"
      Call jtbc_cms_admin_manage_delete_filedisp
    Case "upload"
      Call jtbc_cms_admin_manage_uploaddisp
  End Select
End Sub

Sub jtbc_cms_admin_manage()
  Select Case request.querystring("type")
    Case "add_folder"
      Call jtbc_cms_admin_manage_add_folder
    Case "edit_folder"
      Call jtbc_cms_admin_manage_edit_folder
    Case "add_file"
      Call jtbc_cms_admin_manage_add_file
    Case "edit_file"
      Call jtbc_cms_admin_manage_edit_file
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
