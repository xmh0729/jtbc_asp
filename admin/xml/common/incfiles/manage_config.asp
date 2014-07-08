<%
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
Function check_xml_node(ByVal fname, ByVal fdimen)
  On Error Resume Next
  Dim tmpstr
  tmpstr = request.Form(fname)(fdimen)
  If Err Then
    check_xml_node = False
  Else
    check_xml_node = True
  End If
End Function

Function get_xml_root(ByVal rootstr)
  If InStr(rootstr, ".") = 0 Then Exit Function
  Dim tmpary, tmpstr, tmproot
  tmpary = Split(rootstr, ".")
  If Not UBound(tmpary) = 2 Then Exit Function
  tmpstr = get_actual_route(tmpary(0))
  Select Case tmpary(1)
    Case "tpl"
      tmproot = "/common/template/"
    Case "lng"
      tmproot = "/common/language/"
    Case Else
      tmproot = "/common/"
  End Select
  get_xml_root = repath(tmpstr & tmproot & tmpary(2))
End Function

Sub jtbc_cms_admin_manage_edit(ByVal etpl)
  On Error Resume Next
  Dim trootstr, torder
  trootstr = request.querystring("xml")
  trootstr = get_xml_root(trootstr) & xmltype
  If Not isfileexists(trootstr) Then Call client_alert(itake("manage.notexists", "lng"), -1)
  Dim tmpstr, tmpastr
  tmpstr = ireplace("manage." & etpl, "tpl")
  tmpastr = ctemplate(tmpstr, "{$recurrence_ida}")
  Dim strsourcefile, objxml, objrootsite, allnodesnum
  strsourcefile = server.MapPath(trootstr)
  Set objxml = server.CreateObject("microsoft.xmldom")
  objxml.Load (strsourcefile)
  Set objrootsite = objxml.documentelement.selectSingleNode("configure")
  If Not get_num(objrootsite.childnodes.length, 0) = 3 Then Call client_alert(itake("manage.no", "lng"), -1)
  Dim tnode: tnode = objrootsite.childnodes.Item(0).Text
  Dim tfield: tfield = objrootsite.childnodes.Item(1).Text
  Dim tbase: tbase = objrootsite.childnodes.Item(2).Text
  Set objrootsite = Nothing
  Dim tfiledary: tfiledary = Split(tfield, ",")
  Set objrootsite = objxml.documentelement.selectSingleNode(tbase)
  allnodesnum = objrootsite.childnodes.length - 1
  Dim tmprstr, tmptstr
  Dim trows, tdisplay
  Dim icount, icountb, itmpstr
  Dim delete_notice: delete_notice = itake("global.lng_public.delete_notice", "lng")
  For icount = 0 To allnodesnum
    For icountb = 0 To UBound(tfiledary)
      trows = 5
      tdisplay = "none"
      If icountb = 0 Then trows = 1: tdisplay = "block": torder = torder & objrootsite.childnodes.Item(icount).childnodes.Item(0).Text & ","
      tmptstr = tmpastr
      tmptstr = Replace(tmptstr, "{$rows}", trows)
      tmptstr = Replace(tmptstr, "{$disinfo}", tfiledary(icountb))
      tmptstr = Replace(tmptstr, "{$name}", objrootsite.childnodes.Item(icount).childnodes.Item(0).Text)
      tmptstr = Replace(tmptstr, "{$namestr}", urlencode(objrootsite.childnodes.Item(icount).childnodes.Item(0).Text))
      tmptstr = Replace(tmptstr, "{$value}", htmlencode(objrootsite.childnodes.Item(icount).childnodes.Item(icountb).Text))
      tmptstr = Replace(tmptstr, "{$delete_notice}", Replace(delete_notice, "[]", "[" & objrootsite.childnodes.Item(icount).childnodes.Item(0).Text & "]"))
      tmptstr = Replace(tmptstr, "{$display}", tdisplay)
      tmprstr = tmprstr & tmptstr
    Next
  Next
  tmpstr = Replace(tmpstr, jtbc_cinfo, tmprstr)
  tmpastr = ctemplate(tmpstr, "{$recurrence_idb}")
  tmprstr = ""
  For icountb = 0 To UBound(tfiledary)
    trows = 5
    If icountb = 0 Then trows = 1
    tmptstr = tmpastr
    tmptstr = Replace(tmptstr, "{$rows}", trows)
    tmptstr = Replace(tmptstr, "{$disinfo}", tfiledary(icountb))
    tmprstr = tmprstr & tmptstr
  Next
  Set objrootsite = Nothing
  Set objxml = Nothing
  tmpstr = Replace(tmpstr, jtbc_cinfo, tmprstr)
  tmpstr = Replace(tmpstr, "{$node}", tnode)
  tmpstr = Replace(tmpstr, "{$field}", tfield)
  tmpstr = Replace(tmpstr, "{$base}", tbase)
  tmpstr = Replace(tmpstr, "{$burl}", trootstr)
  tmpstr = Replace(tmpstr, "{$order}", torder)
  response.write tmpstr
End Sub

Sub jtbc_cms_admin_manage_editdisp()
  Dim tbackurl
  tbackurl = get_safecode(request.querystring("backurl"))
  Dim tburl, tnode, tfield, tbase, torder
  tburl = get_str(request.Form("xmlconfig_burl"))
  tnode = get_str(request.Form("xmlconfig_node"))
  tfield = get_str(request.Form("xmlconfig_field"))
  tbase = get_str(request.Form("xmlconfig_base"))
  torder = get_str(request.Form("xmlconfig_order"))
  If Right(torder, 1) = "," Then torder = Left(torder, Len(torder) - 1)
  If Not isfileexists(tburl) Or check_null(tnode) Or check_null(tfield) Or check_null(tbase) Then Exit Sub
  Dim tmode: tmode = get_xrootatt(tburl, "mode")
  Dim tfieldary, torderary, tmpstr, taryub
  tfieldary = Split(tfield, ",")
  torderary = Split(torder, ",")
  taryub = UBound(tfieldary)
  tmpstr = "<?xml version=""1.0"" encoding=""utf-8""?>" & vbCrLf
  tmpstr = tmpstr & "<xml mode=""" & tmode & """ author=""jet" & "iben"">" & vbCrLf
  tmpstr = tmpstr & "  <configure>" & vbCrLf
  tmpstr = tmpstr & "    <node>" & tnode & "</node>" & vbCrLf
  tmpstr = tmpstr & "    <field>" & tfield & "</field>" & vbCrLf
  tmpstr = tmpstr & "    <base>" & tbase & "</base>" & vbCrLf
  tmpstr = tmpstr & "  </configure>" & vbCrLf
  tmpstr = tmpstr & "  <" & tbase & ">" & vbCrLf
  Dim tico, icount
  For tico = 0 To UBound(torderary)
    If check_xml_node(torderary(tico), taryub + 1) Then
      tmpstr = tmpstr & "    <" & tnode & ">" & vbCrLf
      For icount = 0 To taryub
        tmpstr = tmpstr & "      <" & tfieldary(icount) & "><![CDATA[" & get_str(request.Form(torderary(tico))(icount + 1)) & "]]></" & tfieldary(icount) & ">" & vbCrLf
      Next
      tmpstr = tmpstr & "    </" & tnode & ">" & vbCrLf
    End If
  Next
  Dim tnew_node: tnew_node = get_str(request.Form("xmlconfig_new_node_" & tfieldary(0)))
  If not check_null(tnew_node) Then
    tmpstr = tmpstr & "    <" & tnode & ">" & vbCrLf
    For icount = 0 To taryub
      tmpstr = tmpstr & "      <" & tfieldary(icount) & "><![CDATA[" & get_str(request.Form("xmlconfig_new_node_" & tfieldary(icount))) & "]]></" & tfieldary(icount) & ">" & vbCrLf
    Next
    tmpstr = tmpstr & "    </" & tnode & ">" & vbCrLf
  End If
  tmpstr = tmpstr & "  </" & tbase & ">" & vbCrLf
  tmpstr = tmpstr & "</xml>" & vbCrLf
  If save_file_text(tburl, tmpstr) Then
    Call jtbc_cms_admin_msg(itake("global.lng_public.succeed", "lng"), tbackurl, 1)
  Else
    Call jtbc_cms_admin_msg(itake("global.lng_public.failed", "lng"), tbackurl, 1)
  End If
End Sub

Sub jtbc_cms_admin_manage_deletedisp()
  On Error Resume Next
  Dim tbackurl, tdelnode
  tbackurl = get_safecode(request.querystring("backurl"))
  tdelnode = get_str(request.querystring("node"))
  Dim trootstr, torder
  trootstr = get_str(request.querystring("xml"))
  trootstr = get_xml_root(trootstr) & xmltype
  If Not isfileexists(trootstr) Then Call client_alert(itake("manage.notexists", "lng"), -1)
  Dim strsourcefile, objxml, objnode, objrootsite, allnodesnum
  strsourcefile = server.MapPath(trootstr)
  Set objxml = server.CreateObject("microsoft.xmldom")
  objxml.Load (strsourcefile)
  Set objrootsite = objxml.documentelement.selectSingleNode("configure")
  If Not get_num(objrootsite.childnodes.length, 0) = 3 Then Call client_alert(itake("manage.no", "lng"), -1)
  Dim tnode: tnode = objrootsite.childnodes.Item(0).Text
  Dim tfield: tfield = objrootsite.childnodes.Item(1).Text
  Dim tbase: tbase = objrootsite.childnodes.Item(2).Text
  Set objrootsite = Nothing
  Set objnode = objxml.selectSingleNode("xml/" & tbase & "/" & tnode & "[" & Split(tfield, ",")(0) & " ='" & tdelnode & "']")
  If Not IsNull(objnode) Then
    objnode.parentNode.removeChild (objnode)
    objxml.save (strsourcefile)
    If Err Then
      Call jtbc_cms_admin_msg(itake("global.lng_public.sudd", "lng"), tbackurl, 1)
    Else
      Call jtbc_cms_admin_msg(itake("global.lng_public.succeed", "lng"), tbackurl, 1)
    End If
  Else
    Call jtbc_cms_admin_msg(itake("global.lng_public.failed", "lng"), tbackurl, 1)
  End If
  Set objnode = Nothing
  Set objxml = Nothing
End Sub

Sub jtbc_cms_admin_manage_action()
  Select Case request.querystring("action")
    Case "edit"
      Call jtbc_cms_admin_manage_editdisp
    Case "delete"
      Call jtbc_cms_admin_manage_deletedisp
  End Select
End Sub

Sub jtbc_cms_admin_manage()
  Select Case request.querystring("type")
    Case "template"
      Call jtbc_cms_admin_manage_edit("template")
    Case "language"
      Call jtbc_cms_admin_manage_edit("language")
    Case Else
      Call jtbc_cms_admin_manage_edit("language")
  End Select
End Sub
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
%>
