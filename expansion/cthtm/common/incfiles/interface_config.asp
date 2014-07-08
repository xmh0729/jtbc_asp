<%
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
Response.Expires = 0
Response.CacheControl = "no-cache"
Response.AddHeader "Pragma", "no-cache"

Dim n_module: n_module = get_str(request.querystring("module"))
Dim n_index: n_index = get_str(get_value(n_module & ".nindex"))
Dim n_database, n_idfield, n_fpre, n_pagesize, n_listtopx
Dim n_urltype, n_clstype, n_contentcutepage, n_createfolder, n_createfiletype
If check_null(n_index) Then
  response.write "$invalid$"
  response.end
Else
  n_database = get_str(get_value(n_module & ".ndatabase"))
  n_idfield = get_str(get_value(n_module & ".nidfield"))
  n_fpre = get_str(get_value(n_module & ".nfpre"))
  n_pagesize = get_num(get_value(n_module & ".npagesize"), 0)
  n_listtopx = get_num(get_value(n_module & ".nlisttopx"), 0)
  n_urltype = get_str(get_value(n_module & ".nurltype"))
  n_clstype = get_str(get_value(n_module & ".nclstype"))
  n_contentcutepage = get_str(get_value(n_module & ".ncontentcutepage"))
  n_createfolder = get_str(get_value(n_module & ".ncreatefolder"))
  n_createfiletype = get_str(get_value(n_module & ".ncreatefiletype"))
End If

Function get_cthtm_myurl(strers)
  Dim turl: turl = nurlpre & nuri
  turl = get_lrstr(turl, ngenre, "leftr")
  get_cthtm_myurl = turl & strers
End Function

Sub jtbc_cms_interface_get_index()
  Dim tmpstr
  tmpstr = ireplace("interface.index", "tpl")
  response.write tmpstr
End Sub

Sub jtbc_cms_interface_get_list()
  Dim tmpstr
  tmpstr = ireplace("interface.list", "tpl")
  response.write tmpstr
End Sub

Sub jtbc_cms_interface_get_detail()
  Dim tmpstr
  tmpstr = ireplace("interface.detail", "tpl")
  Dim tid_min, tid_max
  Dim trs, tsqlstr
  tsqlstr = "select min(" & n_idfield & ") from " & n_database & " where " & cfnames(n_fpre, "hidden") & "=0 and " & cfnames(n_fpre, "update") & "=0"
  Set trs = conn.Execute(tsqlstr)
  tid_min = trs(0)
  Set trs = Nothing
  tsqlstr = "select max(" & n_idfield & ") from " & n_database & " where " & cfnames(n_fpre, "hidden") & "=0 and " & cfnames(n_fpre, "update") & "=0"
  Set trs = conn.Execute(tsqlstr)
  tid_max = trs(0)
  Set trs = Nothing
  tmpstr = replace(tmpstr, "{$id_min}", get_num(tid_min, 0))
  tmpstr = replace(tmpstr, "{$id_max}", get_num(tid_max, 0))
  response.write tmpstr
End Sub

Sub jtbc_cms_interface_get()
  Select Case request.querystring("mtype")
    Case "index"
      Call jtbc_cms_interface_get_index
    Case "list"
      Call jtbc_cms_interface_get_list
    Case "detail"
      Call jtbc_cms_interface_get_detail
  End Select
End Sub

Sub jtbc_cms_interface_create_index()
  Dim tindex_filename: tindex_filename = get_str(request.querystring("index_filename"))
  If not check_null(tindex_filename) Then
    Dim tfileURL: tfileURL = n_module & "/" & n_index
    tfileURL = get_cthtm_myurl(tfileURL)
    Dim tfileDATA: tfileDATA = bytestobstr(get_xmlhttp_data(tfileURL), ncharset)
    tfileDATA = encode_newline(tfileDATA)
    Dim tfileHTMLURL: tfileHTMLURL = get_actual_route(n_module) & "/" & tindex_filename & n_createfiletype
    If save_file_text(tfileHTMLURL, tfileDATA) Then
      Dim tinfo: tinfo = itake("info.create_succeed", "lng")
      Dim ta_href_blank: ta_href_blank = itake("global.tpl_config.a_href_blank", "tpl")
      Dim tinfo_tfileHTMLURL: tinfo_tfileHTMLURL = replace(ta_href_blank, "{$explain}", tfileHTMLURL)
      tinfo_tfileHTMLURL = replace(tinfo_tfileHTMLURL, "{$value}", tfileHTMLURL)
      tinfo = tinfo & tinfo_tfileHTMLURL
      response.write tinfo
    End If
  End If
End Sub

Sub jtbc_cms_interface_create_list()
  Dim tclassid: tclassid = get_num(request.querystring("classid"), 0)
  Dim tpage: tpage = get_num(request.querystring("page"), 0)
  Dim tfileURL: tfileURL = n_module & "/" & n_index & "?type=list&classid=" & tclassid & "&page=" & tpage
  tfileURL = get_cthtm_myurl(tfileURL)
  Dim tfileDATA: tfileDATA = bytestobstr(get_xmlhttp_data(tfileURL), ncharset)
  tfileDATA = encode_newline(tfileDATA)
  Dim tfileHTMLURL: tfileHTMLURL = iurl("li_page", tpage, n_urltype, "folder=" & n_createfolder & ";filetype=" & n_createfiletype)
  tfileHTMLURL = curl(get_actual_route(n_module), tfileHTMLURL)
  Call fso_create_new_folder(tfileHTMLURL)
  If save_file_text(tfileHTMLURL, tfileDATA) Then
    Dim tinfo: tinfo = itake("info.create_succeed", "lng")
    Dim ta_href_blank: ta_href_blank = itake("global.tpl_config.a_href_blank", "tpl")
    Dim tinfo_tfileHTMLURL: tinfo_tfileHTMLURL = replace(ta_href_blank, "{$explain}", tfileHTMLURL)
    tinfo_tfileHTMLURL = replace(tinfo_tfileHTMLURL, "{$value}", tfileHTMLURL)
    tinfo = tinfo & tinfo_tfileHTMLURL
    response.write tinfo
  End If
End Sub

Sub jtbc_cms_interface_create_detail()
  Dim tid: tid = get_num(request.querystring("id"), 0)
  Dim tsort: tsort = get_num(request.querystring("sort"), 0)
  Dim tsort_child: tsort_child = get_num(request.querystring("sort_child"), 0)
  Dim tisupdate: tisupdate = get_num(request.querystring("isupdate"), 0)
  Dim tpage: tpage = get_num(request.querystring("page"), 0)
  Dim trs, tsqlstr, tsqlwhere
  tsqlwhere = " where " & cfnames(n_fpre, "hidden") & "=0"
  If not (tsort = -1 or tsort = 0) Then
    If tsort_child = 1 Then
      tsqlwhere = tsqlwhere & " and " & cfnames(n_fpre, "cls") & " like '%|" & tsort & "|%'"
    Else
      tsqlwhere = tsqlwhere & " and " & cfnames(n_fpre, "class") & "=" & tsort
    End If
  End If
  If tisupdate = 1 Then tsqlwhere = tsqlwhere & " and " & cfnames(n_fpre, "update") & "=0"
  Dim tcn_create: tcn_create = 1
  Dim tcn_crpage, tcn_crpagenum, tcn_crtime
  Set trs = server.CreateObject("adodb.recordset")
  tsqlstr = "select * from " & n_database & tsqlwhere & " and " & n_idfield & "=" & tid
  trs.open tsqlstr, conn, 1, 3
  If not trs.EOF Then
    If n_contentcutepage = 1 Then
      tcn_crpagenum = cutepage_content_page(get_str(trs(cfnames(n_fpre, "content"))), get_num(trs(cfnames(n_fpre, "cp_note")), 0), get_num(trs(cfnames(n_fpre, "cp_mode")), 0), get_num(trs(cfnames(n_fpre, "cp_type")), 0), get_num(trs(cfnames(n_fpre, "cp_num")), 0))
      If tpage = 0 Then
        tcn_crpage = 2
      Else
        tcn_crpage = tpage + 1
      End If
      If tcn_crpage >= tcn_crpagenum Then trs(cfnames(n_fpre, "update")) = 1
    Else
      tcn_crpage = 0
      trs(cfnames(n_fpre, "update")) = 1
    End If
    tcn_crtime = trs(cfnames(n_fpre, "time"))
    trs.update
  End If
  If tcn_create = 1 Then
    Dim tfileURL: tfileURL = n_module & "/" & n_index & "?type=detail&id=" & tid & "&page=" & tpage
    tfileURL = get_cthtm_myurl(tfileURL)
    Dim tfileDATA: tfileDATA = bytestobstr(get_xmlhttp_data(tfileURL), ncharset)
    tfileDATA = encode_newline(tfileDATA)
    Dim tfileHTMLURL: tfileHTMLURL = iurl("ct_page", tpage, n_urltype, "folder=" & n_createfolder & ";filetype=" & n_createfiletype & ";time=" & tcn_crtime & ";")
    tfileHTMLURL = curl(get_actual_route(n_module), tfileHTMLURL)
    Call fso_create_new_folder(tfileHTMLURL)
    If save_file_text(tfileHTMLURL, tfileDATA) Then
      Dim tinfo: tinfo = itake("info.create_succeed", "lng")
      Dim ta_href_blank: ta_href_blank = itake("global.tpl_config.a_href_blank", "tpl")
      Dim tinfo_tfileHTMLURL: tinfo_tfileHTMLURL = replace(ta_href_blank, "{$explain}", tfileHTMLURL)
      tinfo_tfileHTMLURL = replace(tinfo_tfileHTMLURL, "{$value}", tfileHTMLURL)
      tinfo = tinfo & tinfo_tfileHTMLURL
      If tcn_crpage = 0 or tcn_crpage > tcn_crpagenum Then
        Dim tnextnum
        Dim trs2, tsqlstr2
        tsqlstr2 = "select top 1 " & n_idfield & " from " & n_database & tsqlwhere & " and " & n_idfield & ">" & tid & " order by " & n_idfield & " asc"
        Set trs2 = conn.Execute(tsqlstr2)
        If not trs2.EOF Then
          tnextnum = trs2(n_idfield)
        Else
          tnextnum = 0
        End If
        tinfo = tinfo & "|" & tnextnum & "|0"
      Else
        tinfo = tinfo & "|" & tid & "|" & tcn_crpage
      End If
      response.write tinfo
    End If
  End If
End Sub

Sub jtbc_cms_interface_create()
  Select Case request.querystring("mtype")
    Case "index"
      Call jtbc_cms_interface_create_index
    Case "list"
      Call jtbc_cms_interface_create_list
    Case "detail"
      Call jtbc_cms_interface_create_detail
  End Select
End Sub

Sub jtbc_cms_interface_loadsort()
  Dim tsort: tsort = get_num(request.querystring("sort"), 0)
  Dim tsort_child: tsort_child = get_num(request.querystring("sort_child"), 0)
  Dim tsortarys: tsortarys = get_sortary(n_module, nlng)
  If IsArray(tsortarys) Then
    Dim ti, tmpstr
    For ti = 0 to UBound(tsortarys)
      If (tsort = -1 or tsortarys(ti, 0) = tsort or (tsort_child = 1 and cinstr(tsortarys(ti, 2), tsort, ","))) Then
        tmpstr = tmpstr & tsortarys(ti, 0) & ","
      End If
    Next
    If Len(tmpstr) > 0 Then tmpstr = Left(tmpstr, Len(tmpstr) - 1)
    response.write tmpstr
  End If
End Sub

Sub jtbc_cms_interface_loadsortlists()
  Dim tclassid: tclassid = get_num(request.querystring("classid"), 0)
  If n_clstype = 0 Then
    sqlstr = "select count(" & n_idfield & ") from " & n_database & " where " & cfnames(n_fpre, "class") & "=" & tclassid
  Else
    sqlstr = "select count(" & n_idfield & ") from " & n_database & " where " & cfnames(n_fpre, "cls") & " like '%|" & tclassid & "|%'"
  End If
  Set rs = conn.Execute(sqlstr)
  Dim tcount: tcount = rs(0)
  If tcount > n_listtopx Then tcount = n_listtopx
  If not tcount = 0 Then tcount = CLng(tcount / n_pagesize) + 1
  response.write tcount
  Set rs = Nothing
End Sub

Sub jtbc_cms_interface_loadidminmax()
  Dim tid_min, tid_max
  Dim tsort: tsort = get_num(request.querystring("sort"), 0)
  Dim tsort_child: tsort_child = get_num(request.querystring("sort_child"), 0)
  Dim tisupdate: tisupdate = get_num(request.querystring("isupdate"), 0)
  Dim trs, tsqlstr, tsqlwhere
  tsqlwhere = " where " & cfnames(n_fpre, "hidden") & "=0"
  If not tsort = -1 Then
    If tsort_child = 1 Then
      tsqlwhere = tsqlwhere & " and " & cfnames(n_fpre, "cls") & " like '%|" & tsort & "|%'"
    Else
      tsqlwhere = tsqlwhere & " and " & cfnames(n_fpre, "class") & "=" & tsort
    End If
  End If
  If tisupdate = 1 Then tsqlwhere = tsqlwhere & " and " & cfnames(n_fpre, "update") & "=0"
  tsqlstr = "select min(" & n_idfield & ") from " & n_database & tsqlwhere
  Set trs = conn.Execute(tsqlstr)
  tid_min = trs(0)
  Set trs = Nothing
  tsqlstr = "select max(" & n_idfield & ") from " & n_database & tsqlwhere
  Set trs = conn.Execute(tsqlstr)
  tid_max = trs(0)
  Set trs = Nothing
  response.write get_num(tid_min, 0) & "," & get_num(tid_max, 0)
End Sub

Sub jtbc_cms_interface
  Select Case request.querystring("type")
    Case "get"
      Call jtbc_cms_interface_get
    Case "create"
      Call jtbc_cms_interface_create
    Case "loadsort"
      Call jtbc_cms_interface_loadsort
    Case "loadsortlists"
      Call jtbc_cms_interface_loadsortlists
    Case "loadidminmax"
      Call jtbc_cms_interface_loadidminmax
  End select
End Sub
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
%>
