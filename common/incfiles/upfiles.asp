<!--#include file="upload.asp"-->
<%
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
Dim nupcof, nupmaxsize
Dim upobj, upfile, upfilesize, upfilename, upfiletype
Dim upload_tpl_href, upload_tpl_kong, upload_tpl_back
Dim upform, uptext, upfname, upftype, upbasefname, upbasefolder

Function get_upload_user()
  On Error Resume Next
  get_upload_user = nusername
  If check_null(nusername) or Err Then Err.clear: get_upload_user = admc_name
  If Err Then Err.clear: get_upload_user = "null"
End Function

Function get_upload_filename(ByVal typestr)
  Dim tfilename
  If not check_null(upbasefname) Then
    tfilename = upbasefname & format_date("", 20) & get_rndcode(2) & "." & typestr
  Else
    tfilename = format_date("", 20) & get_rndcode(2) & "." & typestr
  End If
  get_upload_filename = get_safecode(tfilename)
End Function

Function get_upload_foldername()
  Dim tfoldername
  If not check_null(upbasefolder) Then
    tfoldername = upbasefolder & "/" & Year(Now()) & "/" & Month(Now()) & "/" & Day(Now()) & "/"
  Else
    tfoldername = Year(Now()) & "/" & Month(Now()) & "/" & Day(Now()) & "/"
  End If
  get_upload_foldername = tfoldername
End Function

Sub upload_create_database_note(ByVal strgenre, ByVal strfilename, ByVal strfield)
  Dim tdatabase, tidfield, tfpre
  tdatabase = get_str(get_value("common.upload.ndatabase"))
  tidfield = get_str(get_value("common.upload.nidfield"))
  tfpre = get_str(get_value("common.upload.nfpre"))
  Dim tstrgenre, tstrfilename, tstrfield, tuser
  tstrgenre = left_intercept(get_str(strgenre), 50)
  tstrfilename = left_intercept(get_str(strfilename), 250)
  tstrfield = left_intercept(get_str(strfield), 50)
  tuser = get_upload_user
  Dim tsqlstr: tsqlstr = "insert into " & tdatabase & " (" & cfnames(tfpre, "genre") & "," & cfnames(tfpre, "upident") & "," & cfnames(tfpre, "filename") & "," & cfnames(tfpre, "field") & "," & cfnames(tfpre, "user") & "," & cfnames(tfpre, "time") & ") values ('" & tstrgenre & "','" & nupident & "','" & tstrfilename & "','" & tstrfield & "','" & tuser & "','" & Now() & "')"
  conn.Execute(tsqlstr)
End Sub

Sub upload_update_database_note(ByVal strgenre, ByVal strfilename, ByVal strfield, ByVal strid)
  Dim tdatabase, tidfield, tfpre
  tdatabase = get_str(get_value("common.upload.ndatabase"))
  tidfield = get_str(get_value("common.upload.nidfield"))
  tfpre = get_str(get_value("common.upload.nfpre"))
  Dim tstrgenre, tstrfilename, tstrid, tstrfield
  tstrgenre = get_safecode(left_intercept(get_str(strgenre), 50))
  tstrfilename = get_safecode(left_intercept(get_str(strfilename), 10000))
  tstrfield = get_safecode(left_intercept(get_str(strfield), 50))
  tstrid = get_num(strid, 0)
  Dim tsqlstr, tsqlstr2
  If check_null(tstrfield) Then Exit Sub
  tsqlstr = "update " & tdatabase & " set " & cfnames(tfpre, "valid") & "=0," & cfnames(tfpre, "voidreason") & "=2 where " & cfnames(tfpre, "fid") & "=" & tstrid & " and " & cfnames(tfpre, "genre") & "='" & tstrgenre & "' and " & cfnames(tfpre, "upident") & "='" & nupident & "' and " & cfnames(tfpre, "field") & "='" & tstrfield & "'"
  conn.Execute(tsqlstr)
  Dim ti, tstrfilenameary: tstrfilenameary = split(tstrfilename, "|")
  For ti = 0 to UBound(tstrfilenameary)
    If not check_null(tstrfilenameary(ti)) Then
      tsqlstr2 = "update " & tdatabase & " set " & cfnames(tfpre, "fid") & "=" & tstrid & "," & cfnames(tfpre, "valid") & "=1 where " & cfnames(tfpre, "genre") & "='" & tstrgenre & "' and " & cfnames(tfpre, "upident") & "='" & nupident & "' and " & cfnames(tfpre, "filename") & "='" & tstrfilenameary(ti) & "' and " & cfnames(tfpre, "field") & "='" & tstrfield & "'"
      conn.Execute(tsqlstr2)
    End If
  Next
End Sub

Sub upload_delete_database_note(ByVal strgenre, ByVal strcid)
  Dim tstrgenre: tstrgenre = get_safecode(left_intercept(get_str(strgenre), 50))
  Dim cid: cid = strcid
  If Not cidary(cid) Then Exit Sub
  Dim tdatabase, tidfield, tfpre
  tdatabase = get_str(get_value("common.upload.ndatabase"))
  tidfield = get_str(get_value("common.upload.nidfield"))
  tfpre = get_str(get_value("common.upload.nfpre"))
  Dim tsqlstr
  tsqlstr = "update " & tdatabase & " set " & cfnames(tfpre, "valid") & "=0," & cfnames(tfpre, "voidreason") & "=1 where " & cfnames(tfpre, "genre") & "='" & tstrgenre & "' and " & cfnames(tfpre, "upident") & "='" & nupident & "' and " & cfnames(tfpre, "fid") & " in (" & cid & ")"
  conn.Execute(tsqlstr)
End Sub

Sub upload_init()
  nupcof = get_num(get_value("common.nupcof"), 0)
  nupmaxsize = get_num(get_value("common.nupmaxsize"), 0)
  upload_tpl_href = itake("global.tpl_upfiles.a_href_self", "tpl")
  upload_tpl_kong = itake("global.tpl_config.html_kong", "tpl")
  upload_tpl_back = replace_template(upload_tpl_href, "{$explain}" & spa & "{$value}", itake("global.lng_config.back", "lng") & spa & "javascript:history.go(-1);")
  upform = get_safecode(request.querystring("upform"))
  uptext = get_safecode(request.querystring("uptext"))
  upfname = get_safecode(request.querystring("upfname"))
  upftype = get_safecode(request.querystring("upftype"))
  upbasefname = get_safecode(request.querystring("upbasefname"))
  upbasefolder = get_safecode(request.querystring("upbasefolder"))
End Sub

Sub upload_msg(ByVal mstr)
 Call clear_show(ireplace("global.lng_upfiles.file_" & mstr, "lng") & upload_tpl_kong & upload_tpl_back, 0)
End Sub

Sub upload_upload_class()
  On Error Resume Next
  Set upfile = upobj.file("file1")
  upfilesize = get_num(upfile.filesize, 0)
  If upfilesize <= 0 Then
    Call upload_msg("null")
    Exit Sub
  End If
  If upfilesize > nupmaxsize Then
    Call upload_msg("max")
    Exit Sub
  End If
  upfilename = upfile.FileName
  upfiletype = LCase(get_filetype(upfilename))
  If cinstr(nuptype, upfiletype, ".") Then
    upfilename = nuppath & get_upload_foldername & get_upload_filename(upfiletype)
    Call fso_create_new_folder(upfilename)
    If Err.Number = 0 Then
      upfile.saveas server.mappath(upfilename)
    End If
    If Err.Number = 0 Then
      Call upload_create_database_note(ngenre, upfilename, uptext)
      response.redirect "?type=upload&upform=" & upform & "&uptext=" & uptext & "&upftype=" & upftype & "&upfname=" & upfilename
    Else
      Call upload_msg("sudd")
    End If
  Else
    Call upload_msg("uptype")
  End If
End Sub

Sub upload_persits_upload()
  On Error Resume Next
  Dim upcount
  upobj.overwritefiles = True
  upobj.ignorenopost = True
  upobj.setmaxSize nupmaxsize, True
  upcount = upobj.save
  If Err.Number = 8 Then Call upload_msg("max")
  If Err Or upcount <> 1 Then Call upload_msg("null")
  Set upfile = upobj.Files("file1")
  upfilename = upfile.FileName
  upfiletype = LCase(get_filetype(upfilename))
  If cinstr(nuptype, upfiletype, ".") Then
    upfilename = nuppath & get_upload_foldername & get_upload_filename(upfiletype)
    Call fso_create_new_folder(upfilename)
    If Err.Number = 0 Then
      upfile.saveas server.mappath(upfilename)
    End If
    If Err.Number = 0 Then
      Call upload_create_database_note(ngenre, upfilename, uptext)
      response.redirect "?type=upload&upform=" & upform & "&uptext=" & uptext & "&upftype=" & upftype & "&upfname=" & upfilename
    Else
      Call upload_msg("sudd")
    End If
  Else
    Call upload_msg("uptype")
  End If
End Sub

Sub upload_files()
  Call upload_init
  Select Case nupcof
    Case 0
      Set upobj = New upload_class
      Call upload_upload_class
    Case 1
      Set upobj = server.CreateObject("Persits.Upload")
      Call upload_persits_upload
    Case Else
      Set upobj = New upload_class
      Call upload_upload_class
  End Select
  Set upobj = Nothing
End Sub

Sub upload_files_html(ByVal strers)
  Call upload_init
  Dim tmpstr
  tmpstr = itake("global.tpl_upfiles." & strers, "tpl")
  tmpstr = creplace(tmpstr)
  Call clear_show(tmpstr, 0)
End Sub
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
%>
