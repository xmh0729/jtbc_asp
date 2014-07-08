<%
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
Function get_configure_select(ByVal strers)
  Dim ti, tmpstr
  Dim tmodules: tmodules = get_str(get_valid_module(strers))
  Dim tmodulesary: tmodulesary = split(tmodules, "|")
  Dim option_unselected: option_unselected = itake("global.tpl_config.option_unselect", "tpl")
  For ti = 0 to UBound(tmodulesary)
    tmpstr = tmpstr & replace_template(option_unselected, "{$explain}" & spa & "{$value}", "(" & get_genre_description(tmodulesary(ti)) & ")" & tmodulesary(ti)  & spa & tmodulesary(ti))
  Next
  get_configure_select = tmpstr
End Function

Function change_configure_explain(ByVal strers)
  Dim tmpstr
  If Instr(strers, ".") > 0 Then
    Dim tary: tary = split(strers, ".")
    Dim ti, tstr1, tstr2
    If ubound(tary) = 1 Then
      tstr1 = itake("global.lng_mdl." & tary(0), "lng")
      If check_null(tstr1) Then tstr1 = tary(0)
      tstr2 = itake("global.lng_cfg." & tary(1), "lng")
      If check_null(tstr2) Then tstr2 = tary(1)
      tmpstr = tstr1 & "." & tstr2
      change_configure_explain = tmpstr
    Else
      change_configure_explain = ""
    End If
  Else
    tmpstr = itake("global.lng_cfg." & strers, "lng")
    If check_null(tmpstr) Then tmpstr = strers
    change_configure_explain = tmpstr
  End If
End Function

Sub jtbc_cms_admin_manage_list()
  Dim tmpstr, tmpastr
  tmpstr = ireplace("manage.list", "tpl")
  response.write tmpstr
End Sub

Sub jtbc_cms_admin_manage_edit()
  On Error Resume Next
  Dim trootstr, torder, tmodule
  tmodule = get_safecode(request.querystring("module"))
  trootstr = get_actual_route(tmodule) & "/common/config" & xmltype
  If Not isfileexists(trootstr) Then Call client_alert(itake("manage.notexists", "lng"), -1)
  Dim tmpstr, tmpastr
  tmpstr = ireplace("manage.edit", "tpl")
  tmpastr = ctemplate(tmpstr, "{$recurrence_ida}")
  Dim strsourcefile, objxml, objrootsite, allnodesnum
  strsourcefile = server.MapPath(trootstr)
  Set objxml = server.CreateObject("microsoft.xmldom")
  objxml.Load (strsourcefile)
  Set objrootsite = objxml.documentelement.selectsinglenode("configure")
  allnodesnum = objrootsite.childnodes.length - 1
  Dim tmprstr, tmptstr
  Dim icount, tstr1, tstr2
  For icount = 0 To allnodesnum
    tstr1 = objrootsite.childnodes.Item(icount).Attributes.getNamedItem("varstr").Text
    tstr2 = objrootsite.childnodes.Item(icount).Attributes.getNamedItem("strvalue").Text
    torder = torder & tstr1 & ","
    tmptstr = tmpastr
    tmptstr = Replace(tmptstr, "{$explain}", change_configure_explain(tstr1))
    tmptstr = Replace(tmptstr, "{$varstr}", tstr1)
    tmptstr = Replace(tmptstr, "{$strvalue}", tstr2)
    tmprstr = tmprstr & tmptstr
  Next
  Set objrootsite = Nothing
  Set objxml = Nothing
  tmpstr = Replace(tmpstr, jtbc_cinfo, tmprstr)
  tmpstr = Replace(tmpstr, "{$module}", tmodule)
  tmpstr = Replace(tmpstr, "{$order}", torder)
  response.write tmpstr
End Sub

Sub jtbc_cms_admin_manage_editdisp()
  Dim tbackurl: tbackurl = get_safecode(request.querystring("backurl"))
  Dim trootstr, torder, tmodule
  tmodule = get_safecode(request.querystring("module"))
  trootstr = get_actual_route(tmodule) & "/common/config" & xmltype
  If Not isfileexists(trootstr) Then Call client_alert(itake("manage.notexists", "lng"), -1)
  Dim tmode: tmode = get_xrootatt(trootstr, "mode")
  torder = get_str(request.Form("xmlconfig_order"))
  If Right(torder, 1) = "," Then torder = Left(torder, Len(torder) - 1)
  Dim torderary, tmpstr, ti
  torderary = Split(torder, ",")
  tmpstr = "<?xml version=""1.0"" encoding=""utf-8""?>" & vbCrLf
  tmpstr = tmpstr & "<xml mode=""" & tmode & """ author=""jeti" & "ben"">" & vbCrLf
  tmpstr = tmpstr & "  <configure>" & vbCrLf
  For ti = 0 to ubound(torderary)
    tmpstr = tmpstr & "    <item varstr=""" & torderary(ti) & """ strvalue=""" & left(htmlencode(request.form(torderary(ti))), 100) & """ />" & vbCrLf
  Next
  tmpstr = tmpstr & "  </configure>" & vbCrLf
  tmpstr = tmpstr & "</xml>" & vbCrLf
  If save_file_text(trootstr, tmpstr) Then
    Call jtbc_cms_admin_msg(itake("global.lng_public.succeed", "lng"), tbackurl, 1)
  Else
    Call jtbc_cms_admin_msg(itake("global.lng_public.failed", "lng"), tbackurl, 1)
  End If
End Sub

Sub jtbc_cms_admin_manage_action()
  If not check_null(request.querystring("action")) Then Call remove_application("")
  Select Case request.querystring("action")
    Case "edit"
      Call jtbc_cms_admin_manage_editdisp
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
